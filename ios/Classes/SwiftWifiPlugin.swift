import Flutter
import UIKit
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import CoreLocation

public class SwiftWifiPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {

  fileprivate var locationManager: CLLocationManager!
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
         /* if #available(iOS 13.0, *) {
              setLocationData();
          }else{
          getSSID {(sSSID) in
                              result(sSSID)
                          }
          }*/
//          DispatchQueue.main.async {
//                     locationManager = CLLocationManager()
//                     locationManager.delegate = self
//                     locationManager.desiredAccuracy = kCLLocationAccuracyKilometer//kCLLocationAccuracyNearestTenMeters
//                 }
          setLocationData();
          break;
      default:
          //result(FlutterMethodNotImplemented);
          break;
      }
  }

    private func setLocationData(){
        
        self.locationManager = CLLocationManager();
        self.locationManager.delegate = self;
        
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
               print("ssid !")
               result(nil)
           }
       }
    
    /*public func locationManager(_ manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
         if (status == CLAuthorizationStatus.denied) {
             print("callback denied")
         } else if (status == CLAuthorizationStatus.authorizedAlways) {
             print("callback authorizedAlways")
         }else if(status ==  CLAuthorizationStatus.authorizedWhenInUse){
             print("callback authorizedWhenInUse")
         }else if(status == CLAuthorizationStatus.notDetermined){
             print("callback notDetermined")
         }else if(status == CLAuthorizationStatus.restricted){
             print("callback restricted")
         }
     }*/
    
    
    /**
        Method is called after the locationManager requests location and the locationManager was successful at getting the user's location. It will return the user's location by calling the getUsersCurrentLocationCallback
        - parameter manager:   CLLocationManager
        - parameter locations: [CLLocation]
        */
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        print("didUpdateLocations")
       }

       /**
        Method is called after the locationManager requests location and the locationManager failed at getting the user's location. It will return that there was an error by calling the getUsersCurrentLocationCallback
        - parameter manager: CLLocationManager
        - parameter error:   Error
        */
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print("didFailWithError")
       }

       /**
        Method is called after the user has either authorized or denied location services. It will return the result of this authorization change by calling the isLocationServicedEnabledAndIfNotHandleItCallback.
        - parameter manager: CLLocationManager
        - parameter status:  CLAuthorizationStatus
        */
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        if (status == CLAuthorizationStatus.denied) {
            print("callback denied")
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            print("callback authorizedAlways")
        }else if(status ==  CLAuthorizationStatus.authorizedWhenInUse){
            print("callback authorizedWhenInUse")
        }else if(status == CLAuthorizationStatus.notDetermined){
            print("callback notDetermined")
        }else if(status == CLAuthorizationStatus.restricted){
            print("callback restricted")
        }
       }
    
}
