//
//  CortexManager.m
//  cortex
//
//  Created by Cuong Trinh on 7/3/23.
//

#import "CortexManager.h"
#import <EmotivCortexLib/CortexLib.h>

@implementation CortexManager

-(id) init
{
    self = [super init];
    return self;
}

-(BOOL) startCortex
{
    [CortexLib setCortexLogHandler:kInfo handler:nil];
    return [CortexLib start:^(void){
        [self onCortexStarted];
    }];;
}

-(BOOL) sendRequest:(NSString *)command
{
    if(!cortexClient)
        return FALSE;
    [cortexClient sendRequest:command];
    return TRUE;
}

-(void) startAuthentication:(NSString *)clientId
{
    
}

-(void) setDisplayContex:(id<ASWebAuthenticationPresentationContextProviding>)contex
{
    
}

-(void) onCortexStarted
{
    NSLog(@"onCortexStarted");
    if(!cortexClient)
    {
        cortexClient = [[CortexClient alloc] init];
        cortexClient.delegate = self;
    }
}

#pragma mark CortexClientDelegate

- (void) processResponse:(NSString *)responseMessage
{
    NSLog(@"response for the request: %@", responseMessage);
}

- (void)authenticationFinished:(NSString *)authenticationCode withError:(NSError *)error {
    if(!error)
    {
        NSLog(@"authentication code: %@",authenticationCode);
    }
    else
        NSLog(@"error: %@", error.description);
}

@end
