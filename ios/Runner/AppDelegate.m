#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "WatchSessionBridge.h"
#import "Runner-Swift.h"
@import FirebaseMessaging;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  NSObject<FlutterPluginRegistrar> *watchRegistrar = [self registrarForPlugin:@"WatchSessionBridge"];
  if (watchRegistrar != nil) {
    [[WatchSessionBridge shared] registerWithMessenger:watchRegistrar.messenger];
  }
  NSObject<FlutterPluginRegistrar> *liveActivityRegistrar = [self registrarForPlugin:@"LiveActivityBridge"];
  if (liveActivityRegistrar != nil) {
    [[LiveActivityBridge shared] registerWithMessenger:liveActivityRegistrar.messenger];
  }
  NSObject<FlutterPluginRegistrar> *significantLocationRegistrar = [self registrarForPlugin:@"SignificantLocationBridge"];
  if (significantLocationRegistrar != nil) {
    [[SignificantLocationBridge shared] registerWithMessenger:significantLocationRegistrar.messenger];
  }
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

// Belt-and-suspenders APNs token forwarding. The Firebase iOS SDK already
// swizzles this method to set Messaging.apnsToken, but we override it too so
// that (a) failures surface in the device console instead of silently, and
// (b) the app keeps working if a future plugin disables Firebase's swizzling
// (FirebaseAppDelegateProxyEnabled = NO).
- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [FIRMessaging messaging].APNSToken = deviceToken;
  NSMutableString *hex = [NSMutableString stringWithCapacity:deviceToken.length * 2];
  const unsigned char *bytes = deviceToken.bytes;
  for (NSUInteger i = 0; i < deviceToken.length; i++) {
    [hex appendFormat:@"%02x", bytes[i]];
  }
  NSLog(@"[Fogos] APNs token registered (%lu bytes): %@", (unsigned long)deviceToken.length, hex);
  if ([FlutterAppDelegate.class instancesRespondToSelector:_cmd]) {
    [super application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
  }
}

- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"[Fogos] APNs registration FAILED: %@", error);
  if ([FlutterAppDelegate.class instancesRespondToSelector:_cmd]) {
    [super application:application didFailToRegisterForRemoteNotificationsWithError:error];
  }
}

@end
