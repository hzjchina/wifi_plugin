import Flutter
import UIKit
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import CoreLocation

public class SwiftWifiPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "wifi_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftWifiPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

      switch(call.method){
      case "getPlatformVersion":
          result("iOS " + UIDevice.current.systemVersion);
          break;
      case "wifiName":
          if #available(iOS 13.0, *) {
          setLocationData();
          }
          getSSID {(sSSID) in
                              result(sSSID)
                          }
          break;
      default:
          //result(FlutterMethodNotImplemented);
          break;
      }
  }

    private func setLocationData(){
        
        let locationManager = CLLocationManager();
        let status: CLAuthorizationStatus?
                if #available(iOS 14.0, *) {
                    status = locationManager.authorizationStatus
                } else {
                    status = CLLocationManager.authorizationStatus()
                }
                
                if status == .notDetermined {
                    print("notDetermined");
                    if #available(iOS 13.0, *) {
                        locationManager.requestWhenInUseAuthorization()
                    }
                    
                } else if status == .denied  {
                    print("denied");
                    if #available(iOS 13.0, *) {
                        locationManager.requestWhenInUseAuthorization()
                    }
                    
                }else if status == .restricted {
                    print("restricted");
                    if #available(iOS 13.0, *) {
                        locationManager.requestWhenInUseAuthorization()
                    }
                } else {
                    print("other");
                }
        
    }

    
    private func getSSID(result: @escaping (String?) -> ()) {
           if #available(iOS 14.0, *) {
               NEHotspotNetwork.fetchCurrent(completionHandler: { currentNetwork in
                   result(currentNetwork?.ssid);
               })
           } else {
               if let interfaces = CNCopySupportedInterfaces() as NSArray? {
                   for interface in interfaces {
                       if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                           result(interfaceInfo[kCNNetworkInfoKeySSID as String] as? String)
                           return
                       }
                   }
               }
               result(nil)
           }
       }
    
}
