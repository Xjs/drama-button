//
//  Drama_ButtonAppDelegate.h
//  Drama Button
//
//  Created by Martin Schend on 06.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Drama_ButtonAppDelegate : NSObject {
    NSWindow *window;
	NSArray *soundsArray;
	
	IBOutlet NSMenu *contextMenu;
	
	IBOutlet NSMenuItem *randomMenuItem;
	IBOutlet NSMenuItem *alwaysPlayItem;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)playDrama:(id)sender;
- (int)getRandomNumber:(int)from to:(int)to;
- (IBAction)randomSettingChanged:(id)sender;
@end
