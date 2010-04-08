//
//  BorderlessWindow.m
//  Drama Button
//
//  Created by Martin Schend on 06.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BorderlessWindow.h"


@implementation BorderlessWindow
- (id)initWithContentRect:(NSRect)contentRect
				styleMask:(NSUInteger)windowStyle
				  backing:(NSBackingStoreType)bufferingType
					defer:(BOOL)deferCreation
{
    self = [super
			initWithContentRect:contentRect
			styleMask:NSBorderlessWindowMask
			backing:bufferingType
			defer:deferCreation];
    if (self)
    {
		[self setMovableByWindowBackground:YES];
        //[self setOpaque:NO];
		[self setBackgroundColor:[NSColor clearColor]];
		
		[self setOpaque:NO];
		[[self windowController] setShouldCascadeWindows:NO];      // Tell the controller to not cascade its windows.
		[self setFrameAutosaveName:[self representedFilename]];  // Specify the autosave name for the window.

    }
    return self;
}

/*
 Custom windows that use the NSBorderlessWindowMask can't become key by default. Override this method so that controls in this window will be enabled.
 */
- (BOOL)canBecomeKeyWindow {
    return YES;
}

@end
