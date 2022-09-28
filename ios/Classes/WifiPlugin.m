#import "WifiPlugin.h"
#if __has_include(<wifi_plugin/wifi_plugin-Swift.h>)
#import <wifi_plugin/wifi_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "wifi_plugin-Swift.h"
#endif

@implementation WifiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWifiPlugin registerWithRegistrar:registrar];
}
@end
