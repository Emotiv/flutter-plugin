//
//  StreamHandler.h
//  cortex
//
//  Created by Cuong Trinh on 7/4/23.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum EventType : int {
    ResponseEvent = 1,
    WarningEvent = 2,
    DataStreamEvent = 3
} EventType;

@interface StreamHandler : NSObject<FlutterStreamHandler>

@property (copy) void (^onEventUpdated)(NSString*);
@property (readonly) EventType eventType;

- (id)initWithEventType:(EventType)type;

@end

NS_ASSUME_NONNULL_END
