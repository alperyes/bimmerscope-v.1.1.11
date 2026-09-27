import 'package:flutter/services.dart';

const _androidNetworkChannel = MethodChannel('bimmerscope/android_network');

Future<bool> openPortableHotspotSettings() async {
  try {
    return await _androidNetworkChannel.invokeMethod<bool>(
          'openHotspotSettings',
        ) ??
        false;
  } on PlatformException {
    return false;
  } on MissingPluginException {
    return false;
  }
}
