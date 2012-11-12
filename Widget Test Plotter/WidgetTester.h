//
//  WidgetTester.h
//  WidgetTestPlotter
//
//  Created by CP120 on 11/8/11.
//  Copyright (c) 2011 Hal Mueller. All rights reserved.
//

// #import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@class WidgetTestObservationPoint;
@interface WidgetTester : NSObject
{
    // Time
	NSTimeInterval startTime;
	NSTimeInterval elapsedTime;
	// NSTimeInterval timeLimit;
	NSTimer *timer;

}

#pragma mark -
#pragma mark properties

@property(nonatomic,assign)NSUInteger sampleSize;
@property(nonatomic,retain)NSMutableArray *totalRunData;
@property(nonatomic,retain)NSMutableArray *testData;
@property(nonatomic,assign)double sensorMinimum;
@property(nonatomic,assign)double sensorMaximum;

- (void) performTest;
- (void) fillTotalRunDataWithRandom;
// - (void)initiateSignalTimer;
// - (void) inputSignal:(NSTimer *)aTimer;
- (void) setWidgetSignalSourceOn:(BOOL)flag;
- (void) masterView:(NSView *) master_view;

- (WidgetTestObservationPoint *)startingPoint;
- (WidgetTestObservationPoint *)endingPoint;
- (double)sensorMinimum;
- (double)sensorMaximum;
- (double)timeMinimum;
- (double)timeMaximum;

- (NSString *)summary;

@end
