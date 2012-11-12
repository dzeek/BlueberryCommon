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

// FIXME - Need to keep event (down/drag) location global as is to allow draw cursor

@implementation WidgetTestRunView
{
    int mouse_moved_count;
    int local_cursor_ladder;
    NSPoint cursor_info_origin;

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
    //  [[self window] setAcceptsMouseMovedEvents:YES];
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

	// change to be entire background instead of above line 
	NSBezierPath *areaAboveObservedVoltsPath = [NSBezierPath bezierPath];
	NSPoint upperLeftPoint = NSMakePoint(0.0, bounds.size.height);
	[areaAboveObservedVoltsPath moveToPoint:upperLeftPoint];
	NSPoint lowerLeftPoint = NSMakePoint(0.0, 0.0);
	[areaAboveObservedVoltsPath lineToPoint:lowerLeftPoint];
	NSPoint lowerRightPoint = NSMakePoint(bounds.size.width, 0.0);
	[areaAboveObservedVoltsPath lineToPoint:lowerRightPoint];
	NSPoint upperRightPoint = NSMakePoint(bounds.size.width, bounds.size.height);
	[areaAboveObservedVoltsPath lineToPoint:upperRightPoint];
	[areaAboveObservedVoltsPath closePath];
	// END - change to be entire background 
	
	NSBezierPath *areaBelowObservedVoltsPath = [NSBezierPath bezierPath];
	// NSPoint lowerLeftPoint = NSMakePoint(0.0, 0.0);
	[areaBelowObservedVoltsPath moveToPoint:lowerLeftPoint];
	
	// NSUInteger drawingStyleNumber = [[NSUserDefaults standardUserDefaults] integerForKey:drawingStyleKey];
	
	// go through data, add points to each path
	Boolean first_flag = YES;
    NSPoint lastProjectedPoint = {0.0, 0.0};
	for (WidgetTestObservationPoint *observation in self.widgetTester.testData) {
		// NSPoint projectedPoint = NSMakePoint(observation.observationTime, observation.voltage);
		NSPoint projectedPoint = NSMakePoint([self getScreenAbsicca:observation], [self getScreenOrdinate:observation]);
        lastProjectedPoint = projectedPoint;
		// fill in here to map time/voltage to X/Y graphic coordinates
		if (first_flag) {
			[voltsObservedPath moveToPoint:projectedPoint];
			first_flag = NO;
		} else {
			[voltsObservedPath lineToPoint:projectedPoint];
		}
		[areaBelowObservedVoltsPath lineToPoint:projectedPoint];
		// [areaAboveObservedVoltsPath lineToPoint:projectedPoint];

		// MyLog(@"raw %@; projected %@", observation, NSStringFromPoint(projectedPoint));
		
	}

	// NSPoint lowerRightPoint = NSMakePoint(bounds.size.width, 0.0);
    NSPoint lowEdgeLastReading = NSMakePoint(lastProjectedPoint.x, 0.0);
	// [areaBelowObservedVoltsPath lineToPoint:lowerRightPoint];
    [areaBelowObservedVoltsPath lineToPoint:lowEdgeLastReading];
	[areaBelowObservedVoltsPath closePath];
	// NSPoint upperRightPoint = NSMakePoint(bounds.size.width, bounds.size.height);
	// [areaAboveObservedVoltsPath lineToPoint:upperRightPoint];
	// [areaAboveObservedVoltsPath closePath];
	
	NSUInteger drawingStyleNumber = [[NSUserDefaults standardUserDefaults] integerForKey:drawingStyleKey];
    // MyLog(@"WidgetTestRunView.drawRect: drawingStyleNumber: %ld", drawingStyleNumber);
    
	switch (drawingStyleNumber) {
		case 0:
			// NSColor *paleGold = [NSColor colorWithDeviceRed:1.0 green:1.0 blue:0.8 alpha:0.98];
			// NSColor *paleGold = [NSColor colorWithDeviceRed:1.0 green:1.0 blue:0.8];
            // [paleGold set];
            [[NSColor lightGrayColor] set];
			[areaAboveObservedVoltsPath fill];
			[voltsObservedPath setLineWidth:2.0];
			[[NSColor grayColor] set];
			[voltsObservedPath stroke];
			NSColor *paleGreen = [NSColor colorWithDeviceRed:0.8 green:1.0 blue:0.8 alpha:0.98]; // alpha gives ghosty cursor
			// NSColor *paleGreen = [NSColor colorWithDeviceRed:0.8 green:1.0 blue:0.8];
            [paleGreen set];
			[areaBelowObservedVoltsPath fill];
			break;
		case 1:
			[[NSColor whiteColor] set];
			[areaAboveObservedVoltsPath fill];
			[voltsObservedPath setLineWidth:2.8];
			[[NSColor blackColor] set];
			[voltsObservedPath stroke];
			[[NSColor yellowColor] set];
			[areaBelowObservedVoltsPath fill];
			break;
		case 2:
//			[voltsObservedPath setLineWidth:6.3];
//			[[NSColor redColor] set];
//			[voltsObservedPath stroke];
			[[NSColor greenColor] set];
			[areaBelowObservedVoltsPath fill];
            
            CGFloat dashingArray[2];
            dashingArray[0] = 2.0;
//          [voltsObservedPath setLineDash:(const CGFloat *) count:<#(NSInteger)#> phase:<#(CGFloat)#>]
			[[NSColor blueColor] set];
			[areaAboveObservedVoltsPath fill];
			[voltsObservedPath setLineWidth:6.3];
			[[NSColor redColor] set];
			[voltsObservedPath stroke];
			break;
	}


	// no need for this?: NSBezierPath *panelBezelPath = [NSBezierPath bezierPath];
	// [[NSColor brownColor] set];
	// [NSBezierPath strokeRect:bounds];


	if (self.shouldDrawMouseInfo) {
        
        // float xVar = _mousePositionViewCoordinates.x;
        // float yVar = _mousePositionViewCoordinates.y;
        float volts = [self getVoltsFromScreen:_mousePositionViewCoordinates];
        float time = [self getTimeFromScreen:_mousePositionViewCoordinates];
        
        if (0 == (local_cursor_ladder % 2)){
            [self drawCursorPathAtEvent];
        }

        
        NSFont *font = [NSFont fontWithName:@"Palatino-Roman" size:14.0];
        NSDictionary *attributes_dictiontary =
        [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        NSMutableAttributedString *sampleString =
        [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"volts %f - time %f", volts, time] attributes:attributes_dictiontary];
        
        NSSize  stringSizeOnScreen = [sampleString size];
        
        // NSLog(@"Cursor xpos %f, Bounds edge %f, str-len: %f", _mousePositionViewCoordinates.x, bounds.size.width, stringSizeOnScreen.width);
        cursor_info_origin = _mousePositionViewCoordinates;
        if (bounds.size.width < (cursor_info_origin.x + stringSizeOnScreen.width)) {
            // NSLog(@" ... switch location");
            cursor_info_origin.x -= stringSizeOnScreen.width;
            cursor_info_origin.x -= 5;
        } else {
            cursor_info_origin.x += 5;
        }
        
    
        [sampleString drawAtPoint:cursor_info_origin];
        
        
        
        [sampleString release];
        
        
        
        
        //        NSMutableAttributedString *sampleString =
        //        [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"drawn %d times", 2]];
        //        NSPoint center;
        //        center.x = NSMidX(bounds);
        //        center.y = NSMidY(bounds) - 8;
        
        //        [sampleString drawAtPoint:center];

	}
}

-(void)drawCursorPathAtEvent
{
    // NSLog(@"cursor at point: %@", _mousePositionViewCoordinates);
    [[NSColor blackColor] set];
    NSBezierPath *cursorPath = [NSBezierPath bezierPath];
    NSPoint cursorLeftPoint = NSMakePoint(_mousePositionViewCoordinates.x - 30, _mousePositionViewCoordinates.y);
    [cursorPath moveToPoint:cursorLeftPoint];
    NSPoint cursorRightPoint = NSMakePoint(_mousePositionViewCoordinates.x + 30, _mousePositionViewCoordinates.y);
    [cursorPath lineToPoint:cursorRightPoint];
    
    NSPoint cursorTopPoint = NSMakePoint(_mousePositionViewCoordinates.x, _mousePositionViewCoordinates.y + 30);
    [cursorPath moveToPoint:cursorTopPoint];
    NSPoint cursorBottomPoint = NSMakePoint(_mousePositionViewCoordinates.x, _mousePositionViewCoordinates.y - 30);
    [cursorPath lineToPoint:cursorBottomPoint];
    [cursorPath setLineWidth:1.0];
    [[NSColor blackColor] set];
    [cursorPath stroke];

}
-(void)viewDidMoveToWindow
{
    int options = NSTrackingMouseEnteredAndExited |
                    NSTrackingActiveAlways |
                    NSTrackingInVisibleRect;
    NSTrackingArea *ta;
    ta = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:ta];
    [ta release];
}
-(void)flagsChanged:(NSEvent *)theEvent
{
    // NSLog(@"WidgTestRunView.flagsChanged: theEvent: %@", theEvent);
    if (0 != (NSControlKeyMask & [theEvent modifierFlags])) {
        NSLog(@"Hello control key");
    } else if (0 != (NSFunctionKeyMask & [theEvent modifierFlags])) {
        // NSLog(@"FUNCTION KEY");
        
        local_cursor_ladder++;
        _shouldDrawMouseInfo = YES;
        [self setNeedsDisplay:YES];
    } else if (0 != (NSAlternateKeyMask & [theEvent modifierFlags])) {
        NSLog(@"alternate key");
    } else if (0 != (NSCommandKeyMask & [theEvent modifierFlags])) {
        NSLog(@"Command Key");
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
    if (theEvent.modifierFlags == NSShiftKeyMask) {
        
        // draw extra stuff
    }
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
    [[self widgetTester] setWidgetSignalSourceOn:YES];
}
- (void)mouseExited:(NSEvent *)theEvent
{
	NSLog(@"mouseExited: %@", NSStringFromPoint(theEvent.locationInWindow));
    [[self widgetTester] setWidgetSignalSourceOn:NO];
}

@end
