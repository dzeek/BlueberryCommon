//
//  WidgetTestObservationPoint.m
//  WidgetTestPlotter
//
//  Created by Hal Mueller on 2/16/12.
//  Copyright (c) 2012 Hal Mueller. All rights reserved.
//

#import "WidgetTestObservationPoint.h"

@implementation WidgetTestObservationPoint

+ (WidgetTestObservationPoint *)pointWithVoltage:(double)aVolt
                                            time:(double)aSeconds
{
    WidgetTestObservationPoint *result = [[[WidgetTestObservationPoint alloc] init] autorelease];
    result.voltage = aVolt;
    result.observationTime = aSeconds;
    return result;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ T %f V %f", self.className, self.observationTime, self.voltage];
}
@end
