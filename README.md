# wifi_plugin

A Flutter project to get current Wifi SSID.

a specialized package that includes platform-specific implementation code for
Android and/or iOS.
## Getting Started
### android
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />

### ios
<key>NSLocationWhenInUseUsageDescription</key>
<string>iOS13+ needs to obtain phone location permission to obtain wifi ssid</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>iOS13+ needs to obtain phone location permission to obtain wifi ssid</string>

Xcode -> [Project Name] -> Targets -> [Target Name] -> Signing/Capabilities -> Access WiFi Information -> ON
	