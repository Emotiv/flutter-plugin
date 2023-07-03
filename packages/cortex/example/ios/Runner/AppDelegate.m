#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <EmotivCortexLib/CortexLib.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void) applicationWillTerminate:(UIApplication *)application
{
    [CortexLib stop];
}

@end
