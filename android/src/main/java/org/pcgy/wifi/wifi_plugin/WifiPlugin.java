package org.pcgy.wifi.wifi_plugin;

import android.content.Context;
import android.net.wifi.WifiConfiguration;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;

import androidx.annotation.NonNull;

import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** WifiPlugin */
public class WifiPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context applicationContext;

  private boolean is5G = false;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "wifi_plugin");
    channel.setMethodCallHandler(this);
    applicationContext = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }else if(call.method.equals("wifiName")){

      String wifiName = getWifiName();
      result.success(wifiName);

    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    applicationContext = null;
    channel.setMethodCallHandler(null);
  }


  private String getWifiName() {
    String mSsid = "";
    WifiInfo info = null;
    WifiManager mWifiManager = (WifiManager) applicationContext.getSystemService(Context.WIFI_SERVICE);
    if (mWifiManager != null) info = mWifiManager.getConnectionInfo();
    if (info != null && mWifiManager != null) {

      int networkId = info.getNetworkId();
      List<WifiConfiguration> netConfigList = mWifiManager.getConfiguredNetworks();
      if (netConfigList.size() == 0) {
        mSsid = info.getSSID();
      } else {
        for (WifiConfiguration wifiConf : netConfigList) {
          if (wifiConf.networkId == networkId) {
            mSsid = wifiConf.SSID;
            break;
          }
        }
      }

      if (mSsid.startsWith("\"") && mSsid.endsWith("\"")) {
        mSsid = mSsid.substring(1, mSsid.length() - 1);
      }

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        int frequence = info.getFrequency();
        if (frequence > 4900 && frequence < 5900) {
          // Connected 5G wifi. Device does not support 5G
          //  mConfirmBtn.setTag(Boolean.TRUE);
          //判断WiFi
          //判断WiFi 不支持5G  选择另外的WiFi
          is5G = true;

        } else {
          is5G = false;
        }
      }
    }
    return mSsid;
  }
}
