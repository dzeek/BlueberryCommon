//
//  AppDelegate.m
//  Widget Test Plotter
//
//  Created by CP120 on 10/31/12.
//  Copyright (c) 2012 Hal Mueller. All rights reserved.
//

#import "AppDelegate.h"
#import "KeyStrings.h"
#import "WidgetTester.h"
#import "WidgetTestRunView.h"

@implementation AppDelegate

NSString *drawingStyleKey = @"drawingStyle";

- (void)dealloc
{
    [super dealloc];
}

+ (void)initialize
{
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject:[NSNumber numberWithInt:0] forKey:drawingStyleKey];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    LogMethod();
    [self.stylePicker setSelectedSegment:[[NSUserDefaults standardUserDefaults] integerForKey:drawingStyleKey]];
    
    self.widgetTester = [[[WidgetTester alloc] init] autorelease];
    self.testView.widgetTester = self.widgetTester;
    [self.testView setNeedsDisplay:YES];
}


- (IBAction)changeDrawingStyle:(NSSegmentedControl *)sender
{
    LogMethod();
    [[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegment
                                               forKey:drawingStyleKey];
    [self.testView setNeedsDisplay:YES];
}

- (IBAction)performNewTest:(id)sender
{
    LogMethod();
    [self.widgetTester performTest];
    [self.testView setNeedsDisplay:YES];
}

- (IBAction)summarizeToCopyBuffer:(id)sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [pb clearContents];
    
    ;
    // [pb writeObjects:[NSArray arrayWithObject:@"hello pasteboard"]];
    [pb writeObjects:[NSArray arrayWithObject:[[self widgetTester] summary]]];
}

@end
