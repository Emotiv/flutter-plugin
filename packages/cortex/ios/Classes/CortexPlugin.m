#import "CortexPlugin.h"
#import "CortexManager.h"

@implementation CortexPlugin

CortexManager *manager = nil;
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"dev.emotiv.cortex/methods"
            binaryMessenger:[registrar messenger]];
  CortexPlugin* instance = [[CortexPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  if(!manager)
  {
      manager = [[CortexManager alloc]init];
  }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"startCortex" isEqualToString:call.method]) {
      BOOL callResult = [manager startCortex];
      result(@(callResult));
  } else if ([@"sendRequest" isEqualToString:call.method]){
      NSString* command = call.arguments[@"command"];
      BOOL callResult = [manager sendRequest:command];
      if(callResult)
          result(@(callResult));
      else
          result([FlutterError errorWithCode:@"UNAVAILABLE"
                                           message:@"CortexClient is null"
                                           details:nil]);
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

@end
