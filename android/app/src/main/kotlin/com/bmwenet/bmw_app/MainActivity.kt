package com.bmwenet.bmw_app

import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.os.Build
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import com.chaquo.python.Python
import com.chaquo.python.android.AndroidPlatform
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "bimmerscope/android_network"
    private val securityChannelName = "bimmerscope/security_response"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, securityChannelName)
            .setMethodCallHandler { call, result ->
                if (call.method != "calculate") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val btld = call.argument<String>("btld")
                val seed = call.argument<String>("seed")
                if (btld == null || seed == null) {
                    result.error("invalid_input", "BTLD and seed are required", null)
                    return@setMethodCallHandler
                }
                try {
                    if (!Python.isStarted()) {
                        Python.start(AndroidPlatform(applicationContext))
                    }
                    val module = Python.getInstance().getModule("seed_response")
                    val response = module.callAttr("calculate_default_response", btld, seed).toString()
                    result.success(response)
                } catch (error: Exception) {
                    result.error("calculation_failed", error.message ?: "Python calculation failed", null)
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method != "bindEthernet") {
                    when (call.method) {
                        "openHotspotSettings" -> {
                            val intents = listOf(
                                Intent("android.settings.TETHER_SETTINGS"),
                                Intent(Settings.ACTION_WIRELESS_SETTINGS),
                                Intent(Settings.ACTION_SETTINGS),
                            )
                            val settingsIntent = intents.firstOrNull { intent ->
                                intent.resolveActivity(packageManager) != null
                            }
                            if (settingsIntent == null) {
                                result.success(false)
                            } else {
                                try {
                                    startActivity(settingsIntent)
                                    result.success(true)
                                } catch (_: Exception) {
                                    result.success(false)
                                }
                            }
                        }
                        "startVehicleSessionService" -> {
                            val intent = Intent(this, VehicleSessionService::class.java)
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                startForegroundService(intent)
                            } else {
                                startService(intent)
                            }
                            result.success(true)
                        }
                        "stopVehicleSessionService" -> {
                            stopService(Intent(this, VehicleSessionService::class.java))
                            result.success(true)
                        }
                        else -> result.notImplemented()
                    }
                    return@setMethodCallHandler
                }
                val connectivity = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                val request = NetworkRequest.Builder()
                    .addTransportType(NetworkCapabilities.TRANSPORT_ETHERNET)
                    .build()
                var completed = false
                val callback = object : ConnectivityManager.NetworkCallback() {
                    override fun onAvailable(network: Network) {
                        if (completed) return
                        completed = true
                        connectivity.bindProcessToNetwork(network)
                        connectivity.unregisterNetworkCallback(this)
                        result.success(true)
                    }
                    override fun onUnavailable() {
                        if (completed) return
                        completed = true
                        result.success(false)
                    }
                }
                connectivity.requestNetwork(request, callback, 2500)
            }
    }
}
