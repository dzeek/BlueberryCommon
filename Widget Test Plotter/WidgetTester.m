//
//  WidgetTester.m
//  WidgetTestPlotter
//
//  Created by CP120 on 11/8/11.
//  Copyright (c) 2011 Hal Mueller. All rights reserved.
//

#import "WidgetTester.h"
#import "WidgetTestObservationPoint.h"

@implementation WidgetTester
{
    int local_signal_ladder;
    NSView *m_master_view;
}

#pragma mark -
#pragma mark properties

#pragma mark -
#pragma mark initializers / destructors

// init
- (id)init
{
    if (self = [super init]) {
        _sampleSize = 50 + ((int)random() % 20);
		[self fillTotalRunDataWithRandom];
    }
    return self;
}


//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    self.totalRunData = nil;
    self.testData = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark data simulation
- (void)inputSignal:(NSTimer *)aTimer
{
    
	// [self updateElapsedTime];
    local_signal_ladder++;
    // NSLog(@"WidgetTester.inputSignal: ladder: %d master_view: %@", local_signal_ladder, self->m_master_view);
    if (50 < local_signal_ladder) {
        [self fillTotalRunDataWithRandom ];  // also reset signal count
    }
    [self scanDataToCurrent];
    [self->m_master_view setNeedsDisplay:YES];
}

- (void) setWidgetSignalSourceOn:(BOOL)flag
{
    // [self resetElapsedTime];
    if (flag) {
        NSLog(@"WidgTest.setWidgetSignalSourceOn ... Signal on please");
        if (timer == nil) {
            NSLog(@"WidgTest.setWidgetSignalSourceOn ... scheduling input signal");
            // Create a timer
	        timer = [NSTimer scheduledTimerWithTimeInterval:0.5
    			target:self
    			selector:@selector(inputSignal:)
                     userInfo:nil repeats:YES ];
        } else {
            NSLog(@"WidgTest.setWidgetSignalSourceOn ... no action necessary (timer avail)");
        }
    } else {
        NSLog(@"Stop Signal");
        if (timer == nil) {
            NSLog(@"WidgTest.setWidgetSignalSourceOn ... no action necessary (timer already gone?)");
        } else {
            NSLog(@"WidgTest.setWidgetSignalSourceOn ... stopping timer");
	        // Invalidate and release the timer
            local_signal_ladder = 0;
	        [timer invalidate];
	        timer = nil;
        }
        
    }
}
- (void)performTest
{
    // [self initiateSignalTimer];
    [self scanDataToCurrent];
}
-(void)scanDataToCurrent
{
 	[self willChangeValueForKey:@"testData"];
    
    // change scan from sample-size to 'ladder' incremented by input_signal
    //    NSUInteger testDataLength = self.sampleSize;
    NSUInteger totalDataLength = self.sampleSize;
    NSUInteger testDataLength = local_signal_ladder;
    if (testDataLength > totalDataLength) testDataLength = totalDataLength;
    if (testDataLength < 1) testDataLength = 1;
    self.testData = [NSMutableArray arrayWithCapacity:testDataLength];
	for (int i = 0; i < testDataLength; i++) {
		WidgetTestObservationPoint *point = [[self totalRunData] objectAtIndex:i];
		[self.testData addObject:point];
	}
	[self didChangeValueForKey:@"testData"];
   ;
}
-(void) fillTotalRunDataWithRandom
{
    local_signal_ladder = 0;
    
    // fill totalRunData with random value volt readings, variable time span
	NSUInteger i;
	double timeIncrement = 0.3;
	double startingTime = 10.0 + (random()/(double)RAND_MAX) * 20.;
	double sensorValueMean = 13.2;
	int sensorValueRange = 8;
	
	self.sensorMinimum = sensorValueMean + sensorValueRange;
	self.sensorMaximum = sensorValueMean - sensorValueRange;
    
	// [self willChangeValueForKey:@"totalRunData"];
    
    NSUInteger totalRunDataLength = self.sampleSize;
    self.totalRunData = [NSMutableArray arrayWithCapacity:totalRunDataLength];
	for (i = 0; i < totalRunDataLength; i++) {
		float random_sensor_value = sensorValueMean - sensorValueRange/2. + ((double)random()/(double)RAND_MAX * sensorValueRange);
		float marching_time = startingTime + timeIncrement * i;
        WidgetTestObservationPoint *point = [WidgetTestObservationPoint pointWithVoltage:random_sensor_value
                                                                        time:marching_time];
		self.sensorMinimum = MIN(point.voltage, self.sensorMinimum);
		self.sensorMaximum = MAX(point.voltage, self.sensorMaximum);
		[self.totalRunData addObject:point];
	}
	[self didChangeValueForKey:@"totalRunData"];
}

- (WidgetTestObservationPoint *)startingPoint
{
	return [self.testData objectAtIndex:0];
}

- (WidgetTestObservationPoint *)endingPoint
{
	// return [self.testData lastObject];
	return [self.totalRunData lastObject];
}

- (double)timeMinimum
{
	return self.startingPoint.observationTime;
}
- (double)timeMaximum 
{
	return self.endingPoint.observationTime;	
}

- (NSString *)summary {
    return [NSString stringWithFormat:@"%ld points. Voltage range %f to %f, time range %f to %f",
            self.testData.count, self.sensorMinimum, self.sensorMaximum,
            self.timeMinimum, self.timeMaximum];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %@>", self.className, self.summary];
}

- (void)resetElapsedTime
{
	startTime = [NSDate timeIntervalSinceReferenceDate];
    [self updateElapsedTime];
}
- (void)updateElapsedTime
{
    [self willChangeValueForKey:@"elapsedTime"];
    elapsedTime = [NSDate timeIntervalSinceReferenceDate] - startTime;
    [self didChangeValueForKey:@"elapsedTime"];
}
-(void)masterView:(NSView *)master_view
{
    m_master_view = master_view;
    NSLog(@"WidgetTester.masterView: %@", m_master_view);
}


@end
