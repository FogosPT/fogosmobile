#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "WatchSessionBridge.h"
#import "Runner-Swift.h"

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
  NSObject<FlutterPluginRegistrar> *orientationRegistrar = [self registrarForPlugin:@"OrientationBridge"];
  if (orientationRegistrar != nil) {
    [[OrientationBridge shared] registerWithMessenger:orientationRegistrar.messenger];
  }
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

// NOTE: we intentionally do NOT override
// didRegisterForRemoteNotificationsWithDeviceToken:. Firebase iOS SDK
// swizzles that method via its FIRAppDelegateProxy (enabled by default —
// FirebaseAppDelegateProxyEnabled absent from Info.plist) to set
// Messaging.apnsToken and derive the FCM registration token. An earlier
// override that set apnsToken manually raced with Firebase's own path
// and left iOS clients without an FCM token (see 722a028 → this commit).

@end
