package com.bmwenet.bmw_app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.net.wifi.WifiManager
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat

class VehicleSessionService : Service() {
    companion object {
        private const val CHANNEL_ID = "vehicle_session"
        private const val NOTIFICATION_ID = 1701
        private const val WAKE_LOCK_TAG = "BimmerScope:VehicleSession"
        private const val WIFI_LOCK_TAG = "BimmerScope:VehicleNetwork"
    }

    private var cpuWakeLock: PowerManager.WakeLock? = null
    private var wifiLock: WifiManager.WifiLock? = null

    override fun onCreate() {
        super.onCreate()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Vehicle session",
                NotificationManager.IMPORTANCE_LOW,
            )
            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.stat_sys_data_bluetooth)
            .setContentTitle("BimmerScope vehicle session")
            .setContentText("Vehicle connection is active")
            .setOngoing(true)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .build()
        startForeground(NOTIFICATION_ID, notification)
        acquireSessionLocks()
        return START_NOT_STICKY
    }

    private fun acquireSessionLocks() {
        try {
            val powerManager = getSystemService(PowerManager::class.java)
            val lock = cpuWakeLock ?: powerManager.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                WAKE_LOCK_TAG,
            ).also { cpuWakeLock = it }
            if (!lock.isHeld) lock.acquire()
        } catch (error: RuntimeException) {
            android.util.Log.e("VehicleSessionService", "Could not hold CPU awake", error)
        }

        try {
            val wifiManager = applicationContext.getSystemService(WIFI_SERVICE) as WifiManager
            val lock = wifiLock ?: wifiManager.createWifiLock(
                WifiManager.WIFI_MODE_FULL,
                WIFI_LOCK_TAG,
            ).also { wifiLock = it }
            if (!lock.isHeld) lock.acquire()
        } catch (error: RuntimeException) {
            android.util.Log.e("VehicleSessionService", "Could not hold Wi-Fi awake", error)
        }
    }

    private fun releaseSessionLocks() {
        cpuWakeLock?.let { lock ->
            if (lock.isHeld) lock.release()
        }
        cpuWakeLock = null

        wifiLock?.let { lock ->
            if (lock.isHeld) lock.release()
        }
        wifiLock = null
    }

    override fun onDestroy() {
        releaseSessionLocks()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
