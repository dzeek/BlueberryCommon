//
//  ZSAppDelegate.h
//  StreamReader
//
//  Created by Don Zeek on 11/11/12.
//  Copyright (c) 2012 net.dzeek.cp210. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ZSAppDelegate : NSObject <NSStreamDelegate, NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *initStream;
@property (assign) IBOutlet NSTextField *obsStreamStatus;
- (IBAction)initiate_read:(id)sender;

@end
