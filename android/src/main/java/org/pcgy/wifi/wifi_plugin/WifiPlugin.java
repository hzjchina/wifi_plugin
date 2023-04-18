package org.pcgy.wifi.wifi_plugin;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.net.wifi.WifiConfiguration;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * WifiPlugin
 */
public class WifiPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.RequestPermissionsResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context applicationContext;
    private Activity mActivity;
    private boolean is5G = false;
    private static final int PERMISSIONS_REQUEST_CODE_ACCESS_FINE_LOCATION = 87654333;
    private Result resultCallBack = null;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "wifi_plugin");
        channel.setMethodCallHandler(this);
        applicationContext = flutterPluginBinding.getApplicationContext();

    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        resultCallBack = result;
        if (call.method.equals("getPlatformVersion")) {
            result.success("" + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("wifiName")) {

            if ((Build.VERSION.SDK_INT >= Build.VERSION_CODES.P)) {
                if (applicationContext.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                    setLocationPermission();
                } else {
                    result.success(getWifiName());
                }
            } else {
                result.success(getWifiName());
            }
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        applicationContext = null;
        channel.setMethodCallHandler(null);
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    private void setLocationPermission() {
        LocationManager lm = (LocationManager) applicationContext.getSystemService(Context.LOCATION_SERVICE);
        if (lm != null) {
            mActivity.requestPermissions(new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, PERMISSIONS_REQUEST_CODE_ACCESS_FINE_LOCATION);
        }

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
                    is5G = true;
                } else {
                    is5G = false;
                }
            }
        }
        return mSsid;
    }

    // initialize members of this class with Activity
    private void initActivity(Activity activity) {
        mActivity = activity;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        // binding.addActivityResultListener(this);
        initActivity(binding.getActivity());
        binding.addRequestPermissionsResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        mActivity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        initActivity(binding.getActivity());
        binding.addRequestPermissionsResultListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        mActivity = null;
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        final boolean wasPermissionGranted = grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED;
        switch (requestCode) {
            case PERMISSIONS_REQUEST_CODE_ACCESS_FINE_LOCATION:
                if (wasPermissionGranted) {
                    resultCallBack.success(getWifiName());
                } else {
//          resultCallBack.error( "Permission", "denied", null);
                    resultCallBack.success("Permission.denied");
                }
                return true;
        }
        return false;
    }
}
