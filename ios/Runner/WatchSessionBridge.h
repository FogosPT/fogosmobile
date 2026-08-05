#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface WatchSessionBridge : NSObject

+ (instancetype)shared;

- (void)registerWithMessenger:(id<FlutterBinaryMessenger>)messenger;

@end

NS_ASSUME_NONNULL_END
