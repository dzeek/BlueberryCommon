//
//  WidgetTestRunView.m
//  Widget Test Plotter
//
//  Created by CP120 on 10/31/12.
//  Copyright (c) 2012 Hal Mueller. All rights reserved.
//

#import "WidgetTestRunView.h"
#import "WidgetTester.h"
#import "WidgetTestObservationPoint.h"
#import "KeyStrings.h"

@implementation WidgetTestRunView

- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	NSRect bounds = [self bounds];
	MyLog(@"drawRect: bounds %@", NSStringFromRect(bounds));
	
	NSBezierPath *pointsPath = [NSBezierPath bezierPath];
	
	NSUInteger drawingStyleNumber = [[NSUserDefaults standardUserDefaults] integerForKey:drawingStyleKey];
	
	for (WidgetTestObservationPoint *observation in self.widgetTester.testData) {
		NSPoint projectedPoint;
        // fill in here to map time/voltage to X/Y graphic coordinates
        
        //		MyLog(@"raw %@; projected %@", observation, NSStringFromPoint(projectedPoint));
		
	}
	
	switch (drawingStyleNumber) {
		case 0:

			break;
		case 1:

			break;
		case 2:

			break;
	}
	if (self.shouldDrawMouseInfo) {
	}
}

#pragma mark -
#pragma mark mouse events
- (void)mouseMoved:(NSEvent *)theEvent
{
	NSLog(@"mouseMoved: %@", NSStringFromPoint(theEvent.locationInWindow));
}
- (void)mouseEntered:(NSEvent *)theEvent
{
	NSLog(@"mouseEntered: %@", NSStringFromPoint(theEvent.locationInWindow));
}
- (void)mouseExited:(NSEvent *)theEvent
{
	NSLog(@"mouseExited: %@", NSStringFromPoint(theEvent.locationInWindow));
}

@end
