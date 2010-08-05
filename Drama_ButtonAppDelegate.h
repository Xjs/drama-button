//
//  Drama_ButtonAppDelegate.h
//  Drama Button
//
//  Created by Martin Schend on 06.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface Drama_ButtonAppDelegate : NSObject {
    NSWindow *window;
	NSArray *soundsArray;
	
	CGFloat scale;
    NSInteger distortion;
    
	IBOutlet NSTextField *contextInfoLabel;
	
	IBOutlet NSMenu *contextMenu;
	
	IBOutlet NSMenuItem *randomMenuItem;
	IBOutlet NSMenuItem *alwaysPlayItem;
	
	IBOutlet NSMenuItem *alwaysOnTopMenuItem;
	
	IBOutlet NSView *frontView;
	IBOutlet NSView *notFrontView;
}

@property CGFloat scale;
@property NSInteger distortion;


- (IBAction)playDrama:(id)sender;
- (int)getRandomNumber:(int)from to:(int)to;
- (IBAction)randomSettingChanged:(id)sender;

- (IBAction)alwaysOnTopSettingChanged:(id)sender;

- (void) mouseEntered: (id) object;
- (void) mouseExited: (id) object;

- (IBAction) flip: (id) sender;

OSStatus handler(EventHandlerCallRef nextHandler, EventRef theEvent, void* userData);

@end

