//
//  CortexManager.h
//  cortex
//
//  Created by Cuong Trinh on 7/3/23.
//

#import <Foundation/Foundation.h>
#import <EmotivCortexLib/CortexClient.h>
#import <AuthenticationServices/ASWebAuthenticationSession.h>

NS_ASSUME_NONNULL_BEGIN

@interface CortexManager : NSObject<CortexClientDelegate>
{
@private
    CortexClient *cortexClient;
}

-(void) setDisplayContex:(id<ASWebAuthenticationPresentationContextProviding>)contex API_AVAILABLE(ios(13.0));
-(void) startAuthentication:(NSString*)clientId;
-(BOOL) sendRequest: (NSString *) command;
-(BOOL) startCortex;
-(void) onCortexStarted;

@end

NS_ASSUME_NONNULL_END
