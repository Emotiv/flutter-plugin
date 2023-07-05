//
//  ViewController.h
//  cortex
//
//  Created by Cuong Trinh on 7/5/23.
//

#import <UIKit/UIKit.h>
#import <AuthenticationServices/ASWebAuthenticationSession.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : UIViewController<ASWebAuthenticationPresentationContextProviding>

@end

NS_ASSUME_NONNULL_END
