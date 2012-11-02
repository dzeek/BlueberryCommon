//
//  WidgetTester.h
//  WidgetTestPlotter
//
//  Created by CP120 on 11/8/11.
//  Copyright (c) 2011 Hal Mueller. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class WidgetTestObservationPoint;
@interface WidgetTester : NSObject 

#pragma mark -
#pragma mark properties

@property(nonatomic,assign)NSUInteger sampleSize;
@property(nonatomic,retain)NSMutableArray *testData;
@property(nonatomic,assign)double sensorMinimum;
@property(nonatomic,assign)double sensorMaximum;

- (void)performTest;

- (WidgetTestObservationPoint *)startingPoint;
- (WidgetTestObservationPoint *)endingPoint;
- (double)sensorMinimum;
- (double)sensorMaximum;
- (double)timeMinimum;
- (double)timeMaximum;

- (NSString *)summary;

@end
