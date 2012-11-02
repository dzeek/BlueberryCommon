//
//  AppDelegate.h
//  Widget Test Plotter
//
//  Created by CP120 on 10/31/12.
//  Copyright (c) 2012 Hal Mueller. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WidgetTestRunView;
@class WidgetTester;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSSegmentedControl *stylePicker;
@property (assign) IBOutlet NSWindow *window;
@property(nonatomic,retain) WidgetTester *widgetTester;
@property(retain)	IBOutlet WidgetTestRunView *testView;

- (IBAction)changeDrawingStyle:(NSSegmentedControl *)sender;
- (IBAction)performNewTest:(id)sender;
- (IBAction)summarizeToCopyBuffer:(id)sender;

@end
