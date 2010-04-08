//
//  Drama_ButtonAppDelegate.m
//  Drama Button
//
//  Created by Martin Schend on 06.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Drama_ButtonAppDelegate.h"


@implementation Drama_ButtonAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Listen to command-option-control-D
	/* COCOA id block = ^(NSEvent* event){
		if ([event modifierFlags] & NSAlternateKeyMask &&
			[event modifierFlags] & NSCommandKeyMask &&
			[event modifierFlags] & NSControlKeyMask &&
			([event keyCode] == 2)) { // 2: d key
			[[NSNotificationCenter defaultCenter] postNotificationName:@"playDrama" object:nil];
		}
	};
	[NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler: block];*/
	

	soundsArray = [[NSArray alloc] initWithObjects:
					   [NSSound soundNamed:@"drama1.wav"], 
					   [NSSound soundNamed:@"drama2.wav"], 
					   [NSSound soundNamed:@"drama3.wav"], 
					   [NSSound soundNamed:@"drama4.mp3"], nil];
	
	[alwaysPlayItem setHidden:YES];
	
	
	if ([alwaysOnTopMenuItem state] == NSOnState)
		[window setLevel:NSFloatingWindowLevel];
	else 
		[window setLevel:NSNormalWindowLevel];
}

- (void)awakeFromNib
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self 
		   selector:@selector(playDrama:) 
			   name:@"playDrama"
			 object:nil];
	[nc addObserver:self 
		   selector:@selector(mouseEntered:) 
			   name:@"mouseEntered"
			 object:nil];
	[nc addObserver:self 
		   selector:@selector(mouseExited:) 
			   name:@"mouseExited"
			 object:nil];
	
	 NSStatusBar *bar = [NSStatusBar systemStatusBar];
	 NSStatusItem *theItem = [[NSStatusItem alloc] init];
	 
	 theItem = [bar statusItemWithLength:NSVariableStatusItemLength];
	 [theItem retain];
	 
	 [theItem setTitle: NSLocalizedString(@"☁",@"")];
	 [theItem setHighlightMode:YES];
	 [theItem setMenu:contextMenu];
	
	
	/* CARBON */
	
	EventTypeSpec eventType;
	eventType.eventClass = kEventClassKeyboard;
	eventType.eventKind  = kEventHotKeyPressed;
	
	InstallApplicationEventHandler(&handler, 1, &eventType, NULL, NULL);
	
	EventHotKeyID g_HotKeyID;
	g_HotKeyID.id = 1;
	
	EventHotKeyRef g_HotKeyRef;
	
	RegisterEventHotKey(2, controlKey + cmdKey + optionKey, g_HotKeyID, GetApplicationEventTarget(), 0, &g_HotKeyRef);
	
}

- (IBAction)randomSettingChanged:(id)sender {
	[alwaysPlayItem setEnabled:[randomMenuItem state]];
}




 
 
- (IBAction)playDrama:(id)sender {	
	if ([randomMenuItem state] == 1)
		[[soundsArray objectAtIndex:[self getRandomNumber:0 to:[soundsArray count]-1]] play];
	else 
		[[soundsArray objectAtIndex:0] play];
	
}

- (IBAction)alwaysOnTopSettingChanged:(id)sender {
	if (![alwaysOnTopMenuItem state] == NSOnState)
		[window setLevel:NSFloatingWindowLevel];
	else 
		[window setLevel:NSNormalWindowLevel];
}

- (int) getRandomNumber:(int)from to:(int)to {
	42;
	return (int)from + arc4random() % (to-from+1);
}

- (void) mouseEntered:(id)object {
	[[contextInfoLabel animator] setAlphaValue:1.0];
}

- (void) mouseExited:(id)object {
	[[contextInfoLabel animator] setAlphaValue:0.0];
}


/* CARBON */

OSStatus handler(EventHandlerCallRef nextHandler, EventRef theEvent, void* userData)
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"playDrama" object:nil];
	return noErr;
}

@end
