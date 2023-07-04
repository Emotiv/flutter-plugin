#import "CortexPlugin.h"
#import "CortexManager.h"

@implementation CortexPlugin

NSString * const CORTEX_METHOD_CHANNEL_NAME = @"dev.emotiv.cortex/methods";
NSString * const RESPONSE_EVENT_CHANNEL_NAME = @"dev.emotiv.cortex/response";
NSString * const WARNING_EVENT_CHANNEL_NAME = @"dev.emotiv.cortex/warning";
NSString * const DATA_STREAM_EVENT_CHANNEL_NAME = @"dev.emotiv.cortex/dataStream";

CortexManager *manager = nil;
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:CORTEX_METHOD_CHANNEL_NAME
            binaryMessenger:[registrar messenger]];
  CortexPlugin* instance = [[CortexPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  if(!manager)
  {
      manager = [[CortexManager alloc]init];
      
      StreamHandler *responseHandler = [[StreamHandler alloc] initWithEventType:ResponseEvent];
      FlutterEventChannel *responseChannel =
            [FlutterEventChannel eventChannelWithName:RESPONSE_EVENT_CHANNEL_NAME
                                      binaryMessenger:[registrar messenger]];
      [responseChannel setStreamHandler:responseHandler];
      [manager registerHandler:responseHandler forEvent:responseChannel];
      
      StreamHandler *warningHandler = [[StreamHandler alloc] initWithEventType:WarningEvent];
      FlutterEventChannel *warningChannel =
            [FlutterEventChannel eventChannelWithName:WARNING_EVENT_CHANNEL_NAME
                                      binaryMessenger:[registrar messenger]];
      [warningChannel setStreamHandler:warningHandler];
      [manager registerHandler:warningHandler forEvent:warningChannel];
      
      StreamHandler *dataStreamHandler = [[StreamHandler alloc] initWithEventType:DataStreamEvent];
      FlutterEventChannel *dataStreamChannel =
            [FlutterEventChannel eventChannelWithName:DATA_STREAM_EVENT_CHANNEL_NAME
                                      binaryMessenger:[registrar messenger]];
      [dataStreamChannel setStreamHandler:dataStreamHandler];
      [manager registerHandler:dataStreamHandler forEvent:dataStreamChannel];
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

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    [manager unregisterListener];
}

@end
