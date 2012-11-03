//
//  MdSeer.m
//  painter
//
//  Created by Don Zeek on 10/29/12.
//  Copyright (c) 2012 net.dzeek.cp210. All rights reserved.
//

#import "MdSeer.h"

@implementation MdSeer
{
    int _drawCount;
    NSBezierPath *_pointsPath;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _drawCount = 0;
    }
    
    return self;
}

- (NSBezierPath *)pointsPath
{
    if (!_pointsPath) {
        _pointsPath = [[NSBezierPath bezierPath] retain];
        NSPoint pointA = NSMakePoint(12., 22.);
        
        NSPoint pointB = {
            .x = 30., .y = 150.
        };
        
        NSPoint pointC;
        pointC.x = 80.;
        pointC.y = 30.;
        
        [_pointsPath moveToPoint:pointA];
        [_pointsPath lineToPoint:pointB];
        [_pointsPath lineToPoint:pointC];
        
        _pointsPath.lineWidth = 5.0;
    }
    return _pointsPath;
}
- (void)drawRect:(NSRect)dirtyRect
{
    NSLog(@"drawRect(%d) %@", _drawCount, NSStringFromRect(dirtyRect));// Drawing code here.
    _drawCount++;
    
    NSRect bounds = [self bounds];
    
    [[NSColor greenColor] set];
    [NSBezierPath fillRect:bounds];
    
    [[NSColor blackColor] set];
    [NSBezierPath strokeRect:bounds];
    
    [[NSColor whiteColor] set];
    NSRect smallBounds = NSMakeRect(50., 100., 300., 30.);
    [NSBezierPath fillRect:smallBounds];
    
    [[NSColor grayColor] set];
    [self.pointsPath fill];
    [[NSColor blackColor] set];
    [self.pointsPath stroke];
    
    NSMutableAttributedString *sampleString =
    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"drawn %d times", _drawCount]];
    
    NSPoint center;
    center.x = NSMidX(smallBounds);
    center.y = NSMidY(smallBounds) - 8;
    
    [sampleString drawAtPoint:center];
    [sampleString release];
}

@end
