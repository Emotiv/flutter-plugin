//
//  StreamHandler.m
//  cortex
//
//  Created by Cuong Trinh on 7/4/23.
//

#import "StreamHandler.h"

@implementation StreamHandler

@synthesize eventType;

- (id)initWithEventType:(EventType)type
{
    self = [super init];
    if(self)
    {
        eventType = type;
    }
    return self;
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink
{
    //NSLog(@"onListenWithArguments");
    self.onEventUpdated = ^(NSString* data)
    {
        eventSink(data);
        //NSLog(@"Sending event to flutter: %@", data);
    };
        
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments
{
    return nil;
}

@end
