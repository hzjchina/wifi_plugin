
import 'dart:async';

import 'package:flutter/services.dart';

class WifiPlugin {
  static const MethodChannel _channel =
      const MethodChannel('wifi_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get wifiName async{

    final String wifiName = await _channel.invokeMethod("wifiName");

    return wifiName;
  }

  static Future<bool> get wifi5G async{

    final bool isWifi5G = await _channel.invokeMethod("wifi5G");

    return isWifi5G;
  }
}
