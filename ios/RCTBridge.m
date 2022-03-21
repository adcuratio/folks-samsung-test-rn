#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(NativeControllerModule, NSObject)
  RCT_EXTERN_METHOD(localDevices:(NSString*)message callback:(RCTResponseSenderBlock))
  RCT_EXTERN_METHOD(socketConnect:(NSString*)ipaddress callback:(RCTResponseSenderBlock))
  RCT_EXTERN_METHOD(makesslcall:(NSString*)ipaddress callback:(RCTResponseSenderBlock))

@end
