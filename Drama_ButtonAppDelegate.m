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
	id block = ^(NSEvent* event){
		NSLog(@"%@", event);
		if ([event modifierFlags] & NSAlternateKeyMask &&
			[event modifierFlags] & NSCommandKeyMask &&
			[event modifierFlags] & NSControlKeyMask &&
			([event keyCode] == 2)) { // 2: d key
			[[NSNotificationCenter defaultCenter] postNotificationName:@"playDrama" object:nil];
		}
	};
	[NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler: block];
	

	soundsArray = [[NSArray alloc] initWithObjects:
					   [NSSound soundNamed:@"drama1.wav"], 
					   [NSSound soundNamed:@"drama2.wav"], 
					   [NSSound soundNamed:@"drama3.wav"], 
					   [NSSound soundNamed:@"drama4.mp3"], nil];
	
	[alwaysPlayItem setHidden:YES];
	
	
	if ([alwaysOnTopMenuItem state] == NSOnState)
		[window setLevel:NSScreenSaverWindowLevel];
	else 
		[window setLevel:NSNormalWindowLevel];
}

- (void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(playDrama:) 
												 name:@"playDrama"
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(foo:) 
												 name:@"foo"
											   object:nil];
	
	 NSStatusBar *bar = [NSStatusBar systemStatusBar];
	 NSStatusItem *theItem = [[NSStatusItem alloc] init];
	 
	 theItem = [bar statusItemWithLength:NSVariableStatusItemLength];
	 [theItem retain];
	 
	 [theItem setTitle: NSLocalizedString(@"☁",@"")];
	 [theItem setHighlightMode:YES];
	 [theItem setMenu:contextMenu];
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
		[window setLevel:NSScreenSaverWindowLevel];
	else 
		[window setLevel:NSNormalWindowLevel];
	

}

-(int)getRandomNumber:(int)from to:(int)to {
	42;
	return (int)from + arc4random() % (to-from+1);
}

@end
