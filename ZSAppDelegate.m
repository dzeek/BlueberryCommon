//
//  ZSAppDelegate.m
//  StreamReader
//
//  Created by Don Zeek on 11/11/12.
//  Copyright (c) 2012 net.dzeek.cp210. All rights reserved.
//

#import "ZSAppDelegate.h"

@implementation ZSAppDelegate
{
    NSInputStream   *iStream;
    NSOutputStream  *oStream;
    NSMutableData   *_data;
    NSNumber        *bytesRead;
    NSNumber        *readBytes;
    int        byteIndex;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)initiate_read:(id)sender {
    NSLog(@"Hello stream");
    
    [self setUpStreamForFile:@"/Users/donzeek/Documents/cp210/incoming/week7/music_notation.svg"];
 }

-  (void)setUpStreamForFile:(NSString *)path {
    // iStream is NSInputStream instance variable
    
    NSLog(@"Open stream with file at path: %@", path);
    iStream = [[NSInputStream alloc] initWithFileAtPath:path];
    [iStream setDelegate:self];
    [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSDefaultRunLoopMode];
    [iStream open];
}

- (void)createOutputStream {
    NSLog(@"Creating and opening NSOutputStream...");
    // oStream is an instance variable
    oStream = [[NSOutputStream alloc] initToMemory];
    [oStream setDelegate:self];
    [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSDefaultRunLoopMode];
    [oStream open];
}


- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    switch(eventCode) {
        case NSStreamEventNone:
            NSLog(@"stream-event-none");
            break;
        case NSStreamEventHasSpaceAvailable:
        {
            NSLog(@"stream-event-has-space-available");
            uint8_t *readBytes = (uint8_t *)[_data mutableBytes];
            readBytes += byteIndex; // instance variable to move pointer
            int data_len = [_data length];
            unsigned int len = ((data_len - byteIndex >= 1024) ?
                                1024 : (data_len-byteIndex));
            uint8_t buf[len];
            (void)memcpy(buf, readBytes, len);
            len = [stream write:(const uint8_t *)buf maxLength:len];
            byteIndex += len;
            
            break;
        }
        case NSStreamEventOpenCompleted:
            NSLog(@"stream-event-open-completed: str-status: %lu", [stream streamStatus] );
            break;
        case NSStreamEventHasBytesAvailable:
        {
            NSLog(@"stream-event-has-bytes-available");
            if(!_data) {
                _data = [[NSMutableData data] retain];
            }
            uint8_t buf[1024];
            unsigned int len = 0;
            len = [(NSInputStream *)stream read:buf maxLength:1024];
            if(len) {
                [_data appendBytes:(const void *)buf length:len];
                // bytesRead is an instance variable of type NSNumber.
                [bytesRead setIntValue:[bytesRead intValue]+len];
            } else {
                NSLog(@"no buffer!");
            }
            break;
        }
        case NSStreamEventEndEncountered:
        {
            NSLog(@"stream-event-end-encountered");
            [stream close];
            [stream removeFromRunLoop:[NSRunLoop currentRunLoop]
                              forMode:NSDefaultRunLoopMode];
            [stream release];
            stream = nil; // stream is ivar, so reinit it
            
            
            NSLog(@"_data.description: %@", _data.description);
            

            break;
        }
        case NSStreamEventErrorOccurred:
        {
            NSLog(@"stream-event-error-occurred");
            NSError *theError = [stream streamError];
            NSAlert *theAlert = [[NSAlert alloc] init];
            NSLog(@"error reading stream");
            [theAlert setMessageText:@"Error reading stream!"];
            [theAlert setInformativeText:[NSString stringWithFormat:@"Error %li: %@", [theError code],
                                          [theError localizedDescription]]];
            [theAlert addButtonWithTitle:@"OK"];
            [theAlert beginSheetModalForWindow:[NSApp mainWindow]
                                 modalDelegate:self
                                didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                                   contextInfo:nil];
            [stream close];
            [stream release];
            
            break;
        }
    
    }
}
    // Listing 1 Creating and initializing an NSOutputStream object for memory
        

@end
