//
//  CortexManager.m
//  cortex
//
//  Created by Cuong Trinh on 7/3/23.
//

#import "CortexManager.h"
#import <EmotivCortexLib/CortexLib.h>

@implementation CortexManager

- (id)init
{
    self = [super init];
    if(self)
    {
        eventChannels = [NSMutableDictionary dictionary];
        streamHandlers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)startCortex
{
    [CortexLib setCortexLogHandler:kInfo handler:nil];
    return [CortexLib start:^(void){
        [self onCortexStarted];
    }];;
}

- (BOOL)sendRequest:(NSString *)command
{
    if(!cortexClient)
        return FALSE;
    [cortexClient sendRequest:command];
    return TRUE;
}

- (BOOL)startAuthentication:(NSString *)clientId
{
    if(!cortexClient)
        return FALSE;
    
    [cortexClient authenticate:clientId];
    return TRUE;
}

- (void)setDisplayContex:(id<ASWebAuthenticationPresentationContextProviding>)contex
{
    if(cortexClient)
        [cortexClient setDisplayContext:contex];
}

- (void)onCortexStarted
{
    NSLog(@"onCortexStarted");
    if(!cortexClient)
    {
        cortexClient = [[CortexClient alloc] init];
        cortexClient.delegate = self;
    }
}

- (void)registerHandler:(StreamHandler *)handler forEvent:(FlutterEventChannel *)event
{
    NSNumber *key = [NSNumber numberWithInt:handler.eventType];
    [eventChannels setObject:event forKey:key];
    [streamHandlers setObject:handler forKey:key];
}

- (void)unregisterListener
{
    for (FlutterEventChannel *channel in eventChannels.allValues)
    {
        [channel setStreamHandler:nil];
    }
    [eventChannels removeAllObjects];
    
    for (NSObject<FlutterStreamHandler> *handler in streamHandlers.allValues)
    {
        [handler onCancelWithArguments:nil];
    }
    [streamHandlers removeAllObjects];
    
    [cortexClient close];
}

#pragma mark CortexClientDelegate

- (void)processResponse:(NSString *)responseMessage
{
    //NSLog(@"response for the request: %@", responseMessage);
    NSError *error;
    NSDictionary * response = [NSJSONSerialization JSONObjectWithData:[responseMessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    if(!error)
    {
        NSDictionary *warning = [response objectForKey:@"warning"];
        NSString *sid = [response objectForKey:@"sid"];
        if(warning != nil)
        {
            StreamHandler *handler = [streamHandlers objectForKey:[NSNumber numberWithInt:WarningEvent]];
            if(handler.onEventUpdated)
                handler.onEventUpdated(responseMessage);
        }
        else if (sid != nil)
        {
            StreamHandler *handler = [streamHandlers objectForKey:[NSNumber numberWithInt:DataStreamEvent]];
            if(handler.onEventUpdated)
                handler.onEventUpdated(responseMessage);
        }
        else
        {
            StreamHandler *handler = [streamHandlers objectForKey:[NSNumber numberWithInt:ResponseEvent]];
            if(handler.onEventUpdated)
                handler.onEventUpdated(responseMessage);
        }
    }
}

- (void)authenticationFinished:(NSString *)authenticationCode withError:(NSError *)error {
    if(!error)
        NSLog(@"authentication code: %@",authenticationCode);
    else
        NSLog(@"error: %@", error.description);
    
    if(self.onReceivedAuthenCode)
        self.onReceivedAuthenCode(authenticationCode, error);
}

@end
