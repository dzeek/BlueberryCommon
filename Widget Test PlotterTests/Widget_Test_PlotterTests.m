//
//  Widget_Test_PlotterTests.m
//  Widget Test PlotterTests
//
//  Created by CP120 on 10/31/12.
//  Copyright (c) 2012 Hal Mueller. All rights reserved.
//

#import "Widget_Test_PlotterTests.h"
#import "WidgetTester.h"
#import "WidgetTestObservationPoint.h"

@implementation Widget_Test_PlotterTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testProduction
{
    WidgetTester *oscilloscope = [[[WidgetTester alloc] init] autorelease];
    NSLog(@"%@", oscilloscope);
    STAssertTrue((oscilloscope.sampleSize > 0), @"WidgetTester has no points");
}

- (void)testVoltageBounds
{
    WidgetTester *oscilloscope = [[[WidgetTester alloc] init] autorelease];
    
    STAssertTrue((oscilloscope.sensorMaximum >= oscilloscope.sensorMinimum),
                 @"reported sensor minimum %f greater than reported sensor maximum %f",
                 oscilloscope.sensorMaximum, oscilloscope.sensorMinimum);
}

- (void)testTimeBounds
{
    WidgetTester *oscilloscope = [[[WidgetTester alloc] init] autorelease];
    
    STAssertTrue((oscilloscope.timeMaximum >= oscilloscope.timeMinimum),
                 @"reported time minimum %f greater than reported time maximum %f",
                 oscilloscope.timeMaximum, oscilloscope.timeMinimum);
}

- (void)testVoltageIsInRange
{
    WidgetTester *oscilloscope = [[[WidgetTester alloc] init] autorelease];
    for (WidgetTestObservationPoint *point in oscilloscope.testData) {
        STAssertTrue((point.voltage <= oscilloscope.sensorMaximum),
                     @"found point with sensor value exceeding reported maximum");
        STAssertTrue((point.voltage >= oscilloscope.sensorMinimum),
                     @"found point with sensor value below reported minimum");
    }
}

- (void)testTimesAreInRange
{
    WidgetTester *oscilloscope = [[[WidgetTester alloc] init] autorelease];
    [oscilloscope.testData enumerateObjectsUsingBlock:^(WidgetTestObservationPoint *point, NSUInteger idx, BOOL *stop) {
        STAssertTrue((point.observationTime <= oscilloscope.timeMaximum),
                     @"found point with time value exceeding reported maximum");
        STAssertTrue((point.observationTime >= oscilloscope.timeMinimum),
                     @"found point with time value below reported minimum");
    }];
}


@end
