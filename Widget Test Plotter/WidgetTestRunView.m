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
{
    int mouse_moved_count;
}

- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        // self.shouldDrawMouseInfo = YES;
    }
    return self;
}
- (void) awakeFromNib
{
    // initially failed, now logging call
    // began working when became first responder
    NSLog(@"WidgTestRunView.awakeFromNib");
    [[self window] setAcceptsMouseMovedEvents:YES];
}

- (BOOL)isOpaque
{
    return YES;
}
-(BOOL)acceptsFirstResponder
{
    NSLog(@"WidgTestRunView.acceptsFirstResponder");
    return YES;
}
-(BOOL)resignFirstResponder
{
    NSLog(@"WidgTestRunView.resignFirstResponder");
    [self setNeedsDisplay:YES];
    return YES;
}
-(BOOL)becomeFirstResponder
{
    NSLog(@"WidgTestRunView.becomeFirstResponder");
    [self setNeedsDisplay:YES];
    return YES;
}
-(void)keyDown:(NSEvent *)event
{
    // this one will tunnel throught to insertText, ...
    // [self interpretKeyEvents:[NSArray arrayWithObject:event]];
    NSLog(@"WidgTestRunView.keyDown: event: %@", event);
}
// plotted on the vertical axis
//  FIXME I know this is peculiar out-of-pattern naming, have not decided on how to hold absicca/ordinate
- (double) getScreenOrdinate:(WidgetTestObservationPoint*) pt
{
    NSRect bounds = [self bounds];

    double ret = (  ([pt voltage] - [self.widgetTester sensorMinimum])
               / ([self.widgetTester sensorMaximum] - [self.widgetTester sensorMinimum]) )
    * bounds.size.height;

    return ret;
}
- (double) getVoltsFromScreen:(NSPoint) in_pt
{
    NSRect bounds = [self bounds];

    float full_scale = ([self.widgetTester sensorMaximum] - [self.widgetTester sensorMinimum]);
    float ret = ((in_pt.y / bounds.size.height) * full_scale)
                + [self.widgetTester sensorMinimum];
    return ret;
}
// plotted on the horizontal axis
//  FIXME I know this is peculiar out-of-pattern naming, have not decided on how to hold absicca/ordinate
- (double) getScreenAbsicca:(WidgetTestObservationPoint*) pt
{
    NSRect bounds = [self bounds];
    
    double ret = (  ([pt observationTime] - [self.widgetTester timeMinimum])
                  / ([self.widgetTester timeMaximum] - [self.widgetTester timeMinimum]) )
    * bounds.size.width;
    
    return ret;
}
- (double) getTimeFromScreen:(NSPoint) in_time
{
    NSRect bounds = [self bounds];
    
    float full_scale = ([self.widgetTester timeMaximum] - [self.widgetTester timeMinimum]);
    float ret = ((in_time.x / bounds.size.width) * full_scale)
    + [self.widgetTester timeMinimum];
    return ret;
}


- (void)drawRect:(NSRect)dirtyRect {
	NSRect bounds = [self bounds];
	// MyLog(@"WidgetTestRunView.drawRect: bounds %@", NSStringFromRect(bounds));
	
	[NSBezierPath setDefaultLineWidth:6.0];  // used by "ugly" style
    
    // points of voltage vs time
	NSBezierPath *voltsObservedPath = [NSBezierPath bezierPath];

	NSBezierPath *areaAboveObservedVoltsPath = [NSBezierPath bezierPath];
	NSPoint upperLeftPoint = NSMakePoint(0.0, bounds.size.height);
	[areaAboveObservedVoltsPath moveToPoint:upperLeftPoint];
	
	NSBezierPath *areaBelowObservedVoltsPath = [NSBezierPath bezierPath];
	NSPoint lowerLeftPoint = NSMakePoint(0.0, 0.0);
	[areaBelowObservedVoltsPath moveToPoint:lowerLeftPoint];
	
	// NSUInteger drawingStyleNumber = [[NSUserDefaults standardUserDefaults] integerForKey:drawingStyleKey];

	
	// go through data, add points to each path
	Boolean first_flag = YES;
	for (WidgetTestObservationPoint *observation in self.widgetTester.testData) {
		// NSPoint projectedPoint = NSMakePoint(observation.observationTime, observation.voltage);
		NSPoint projectedPoint = NSMakePoint([self getScreenAbsicca:observation], [self getScreenOrdinate:observation]);
		// fill in here to map time/voltage to X/Y graphic coordinates
		if (first_flag) {
			[voltsObservedPath moveToPoint:projectedPoint];
			first_flag = NO;
		} else {
			[voltsObservedPath lineToPoint:projectedPoint];
		}
		[areaBelowObservedVoltsPath lineToPoint:projectedPoint];
		[areaAboveObservedVoltsPath lineToPoint:projectedPoint];

		// MyLog(@"raw %@; projected %@", observation, NSStringFromPoint(projectedPoint));
		
	}

	NSPoint lowerRightPoint = NSMakePoint(bounds.size.width, 0.0);
	[areaBelowObservedVoltsPath lineToPoint:lowerRightPoint];
	[areaBelowObservedVoltsPath closePath];
	NSPoint upperRightPoint = NSMakePoint(bounds.size.width, bounds.size.height);
	[areaAboveObservedVoltsPath lineToPoint:upperRightPoint];
	[areaAboveObservedVoltsPath closePath];
	
	NSUInteger drawingStyleNumber = [[NSUserDefaults standardUserDefaults] integerForKey:drawingStyleKey];
    // MyLog(@"WidgetTestRunView.drawRect: drawingStyleNumber: %ld", drawingStyleNumber);
    
	switch (drawingStyleNumber) {
		case 0:
			[voltsObservedPath setLineWidth:2.0];
			[[NSColor grayColor] set];
			[voltsObservedPath stroke];
			NSColor *paleGreen = [NSColor colorWithDeviceRed:0.8 green:1.0 blue:0.8 alpha:0.77];
            [paleGreen set];
			[areaBelowObservedVoltsPath fill];
			NSColor *paleGold = [NSColor colorWithDeviceRed:1.0 green:1.0 blue:0.8 alpha:0.50];
            [paleGold set];
			[areaAboveObservedVoltsPath fill];
			break;
		case 1:
			[voltsObservedPath setLineWidth:2.8];
			[[NSColor blackColor] set];
			[voltsObservedPath stroke];
			[[NSColor yellowColor] set];
			[areaBelowObservedVoltsPath fill];
			[[NSColor whiteColor] set];
			[areaAboveObservedVoltsPath fill];
			break;
		case 2:
//			[voltsObservedPath setLineWidth:6.3];
//			[[NSColor redColor] set];
//			[voltsObservedPath stroke];
			[[NSColor greenColor] set];
			[areaBelowObservedVoltsPath fill];
			[[NSColor blueColor] set];
			[areaAboveObservedVoltsPath fill];
			[voltsObservedPath setLineWidth:6.3];
			[[NSColor redColor] set];
			[voltsObservedPath stroke];
			break;
	}


	// no need for this?: NSBezierPath *panelBezelPath = [NSBezierPath bezierPath];
	[[NSColor brownColor] set];
	[NSBezierPath strokeRect:bounds];


	if (self.shouldDrawMouseInfo) {
        
        // float xVar = _mousePositionViewCoordinates.x;
        // float yVar = _mousePositionViewCoordinates.y;
        float volts = [self getVoltsFromScreen:_mousePositionViewCoordinates];
        float time = [self getTimeFromScreen:_mousePositionViewCoordinates];
        
        NSFont *font = [NSFont fontWithName:@"Palatino-Roman" size:14.0];
        NSDictionary *attributes_dictiontary =
        [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        NSMutableAttributedString *sampleString =
        [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"volts %f - time %f", volts, time] attributes:attributes_dictiontary];
    
        [sampleString drawAtPoint:_mousePositionViewCoordinates];
        [sampleString release];
        
        
        
        
        //        NSMutableAttributedString *sampleString =
        //        [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"drawn %d times", 2]];
        //        NSPoint center;
        //        center.x = NSMidX(bounds);
        //        center.y = NSMidY(bounds) - 8;
        
        //        [sampleString drawAtPoint:center];

	}
}

#pragma mark -
#pragma mark mouse events
- (void)mouseDown:(NSEvent *)theEvent
{
    // NSLog(@"WidgetTestRunView.mouseDown: %@", NSStringFromPoint(theEvent.locationInWindow));
    // do this with accessors
    _shouldDrawMouseInfo = YES;
    NSPoint event_location = [theEvent locationInWindow];
    // _mousePositionViewCoordinates = [theEvent locationInWindow];
    _mousePositionViewCoordinates = [self convertPoint:event_location fromView:nil];
    [self setNeedsDisplay:YES];
}
- (void)mouseDragged:(NSEvent *)theEvent
{
    // NSLog(@"WindowTestRunView.mouseDragged: %@", NSStringFromPoint(theEvent.locationInWindow));
    // do this with accessors
    NSPoint event_location = [theEvent locationInWindow];
    // _mousePositionViewCoordinates = [theEvent locationInWindow];
    _mousePositionViewCoordinates = [self convertPoint:event_location fromView:nil];
    [self setNeedsDisplay:YES];
}
- (void)mouseUp:(NSEvent *)theEvent
{
    // NSLog(@"WindowTestRunView.mouseUp: %@", NSStringFromPoint(theEvent.locationInWindow));
    _shouldDrawMouseInfo = NO;
    // [self setNeedsDisplay:YES];
}
- (void)mouseMoved:(NSEvent *)theEvent
{
    mouse_moved_count++;
    if (0 == (mouse_moved_count % 100)) {
	   NSLog(@"mouseMoved: %@", NSStringFromPoint(theEvent.locationInWindow));
    }
    //   cannot see this string on the screen,
    //   and the new location wipes out the data string left by 'mouse-up'
    // _mousePositionViewCoordinates = NSMakePoint(30.0, 30.0);
    // [self setNeedsDisplay:YES];
    
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
