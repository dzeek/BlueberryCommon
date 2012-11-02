//
//  WidgetTestObservationPoint.h
//  WidgetTestPlotter
//
//  Created by Hal Mueller on 2/16/12.
//  Copyright (c) 2012 Hal Mueller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WidgetTestObservationPoint : NSObject
@property(assign, nonatomic) double voltage;
@property(assign, nonatomic) double observationTime;

+ (WidgetTestObservationPoint *)pointWithVoltage:(double)aVolt
                                            time:(double)aSeconds;
@end
