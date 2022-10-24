import Flutter
import UIKit
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import CoreLocation

public class SwiftWifiPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {

  private var locationManager: CLLocationManager!
  private var resultCallBack: FlutterResult!
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "wifi_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftWifiPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      self.resultCallBack = result;
      
      switch(call.method){
      case "getPlatformVersion":
          result("" + UIDevice.current.systemVersion);
          break;
      case "wifiName":
          if #available(iOS 13.0, *) {
                      //  DispatchQueue.main.async {
              setLocationPermission();
                       // }
          }else{
              getWifiName()
          }
          break;
      default:
          result(FlutterMethodNotImplemented);
          break;
      }
  }

    private func setLocationPermission(){
        
        self.locationManager = CLLocationManager();
        self.locationManager.delegate = self;
        
        let status: CLAuthorizationStatus?
                if #available(iOS 14.0, *) {
                    status = locationManager.authorizationStatus
                } else {
                    status = CLLocationManager.authorizationStatus()
                }
                
                if status == .notDetermined
                    || status == .denied
                    || status == .restricted{
                    if #available(iOS 13.0, *) {
                        locationManager.requestWhenInUseAuthorization()
                    }
                    
                } else {
                    print("other");
                    
                   // getWifiName()
                }
        
    }

    private func getWifiName(){
        if #available(iOS 14.0, *) {
            NEHotspotNetwork.fetchCurrent(completionHandler: { currentNetwork in
                self.resultCallBack(currentNetwork?.ssid);
            })
        } else {
            if let interfaces = CNCopySupportedInterfaces() as NSArray? {
                for interface in interfaces {
                    if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                        self.resultCallBack(interfaceInfo[kCNNetworkInfoKeySSID as String] as? String)
                        return
                    }
                }
            }
            print("ssid !")
            self.resultCallBack(nil)
        }
    }
    
   
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
        if status == CLAuthorizationStatus.authorizedAlways
            || status ==  CLAuthorizationStatus.authorizedWhenInUse {
            
            getWifiName()
        }else if status ==  CLAuthorizationStatus.denied
                 //  || status == CLAuthorizationStatus.restricted
        {
            
                    self.resultCallBack("Permission.denied")
        }else{
            //self.resultCallBack("");
        }

       }
}
