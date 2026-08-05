#import "WatchSessionBridge.h"
@import WatchConnectivity;

// Bridges Flutter → watchOS via WCSession application context.
// Flutter calls "sendContext" with a dictionary; the payload is merged
// into a persistent context and forwarded to the paired watch (if any)
// via updateApplicationContext (latest-wins delivery).

@interface WatchSessionBridge () <WCSessionDelegate>
@property (nonatomic, strong, nullable) FlutterMethodChannel *channel;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *pendingContext;
@end

@implementation WatchSessionBridge

+ (instancetype)shared {
    static WatchSessionBridge *inst;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [WatchSessionBridge new];
        inst.pendingContext = [NSMutableDictionary new];
    });
    return inst;
}

- (void)registerWithMessenger:(id<FlutterBinaryMessenger>)messenger {
    self.channel = [FlutterMethodChannel methodChannelWithName:@"pt.fogos/watch_bridge"
                                                 binaryMessenger:messenger];
    __weak typeof(self) weakSelf = self;
    [self.channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
        [weakSelf handleCall:call result:result];
    }];

    if ([WCSession isSupported]) {
        [WCSession defaultSession].delegate = self;
        [[WCSession defaultSession] activateSession];
    }
}

- (void)handleCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"sendContext"]) {
        if (![call.arguments isKindOfClass:[NSDictionary class]]) {
            result([FlutterError errorWithCode:@"bad_args" message:@"Expected a dictionary" details:nil]);
            return;
        }
        [self mergeContext:call.arguments];
        [self flushContext];
        result(nil);
    } else if ([call.method isEqualToString:@"isPaired"]) {
        BOOL paired = [WCSession isSupported] && [WCSession defaultSession].isPaired;
        result(@(paired));
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)mergeContext:(NSDictionary<NSString *, id> *)context {
    for (NSString *key in context) {
        id value = context[key];
        if ([value isKindOfClass:[NSNull class]]) {
            [self.pendingContext removeObjectForKey:key];
        } else {
            self.pendingContext[key] = value;
        }
    }
}

- (void)flushContext {
    if (![WCSession isSupported]) return;
    WCSession *session = [WCSession defaultSession];
    if (session.activationState != WCSessionActivationStateActivated) return;
    if (!session.isPaired || !session.isWatchAppInstalled) return;
    if (self.pendingContext.count == 0) return;

    NSError *error = nil;
    [session updateApplicationContext:self.pendingContext error:&error];
    if (error) {
        NSLog(@"[WatchSessionBridge] updateApplicationContext failed: %@", error);
    }
}

#pragma mark - WCSessionDelegate

- (void)session:(WCSession *)session
    activationDidCompleteWithState:(WCSessionActivationState)activationState
                             error:(nullable NSError *)error {
    if (activationState == WCSessionActivationStateActivated) {
        [self flushContext];
    }
}

- (void)sessionDidBecomeInactive:(WCSession *)session {}

- (void)sessionDidDeactivate:(WCSession *)session {
    [[WCSession defaultSession] activateSession];
}

@end
