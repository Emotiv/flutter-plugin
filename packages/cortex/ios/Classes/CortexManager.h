//
//  CortexManager.h
//  cortex
//
//  Created by Cuong Trinh on 7/3/23.
//

#import <Foundation/Foundation.h>
#import <EmotivCortexLib/CortexClient.h>
#import <AuthenticationServices/ASWebAuthenticationSession.h>

#import "StreamHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface CortexManager : NSObject<CortexClientDelegate>
{
@private
    CortexClient *cortexClient;
    NSMutableDictionary<NSNumber *, FlutterEventChannel *> *eventChannels;
    NSMutableDictionary<NSNumber *, StreamHandler *> *streamHandlers;
}

- (void)setDisplayContex:(id<ASWebAuthenticationPresentationContextProviding>)contex API_AVAILABLE(ios(13.0));
- (void)startAuthentication:(NSString*)clientId;
- (BOOL)sendRequest: (NSString *) command;
- (BOOL)startCortex;
- (void)onCortexStarted;

- (void)registerHandler:(StreamHandler *)handler forEvent:(FlutterEventChannel *)event;
- (void)unregisterListener;

@end

NS_ASSUME_NONNULL_END
