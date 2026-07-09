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
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
