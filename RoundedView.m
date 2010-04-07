//
//  RoundedView.m
//  Drama Button
//
//  Created by Martin Schend on 06.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RoundedView.h"


@implementation RoundedView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        NSTrackingArea *trackingArea = [[NSTrackingArea alloc]
						   initWithRect:frame
								options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect)
								  owner:self userInfo:nil];
        [self addTrackingArea:trackingArea];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	// Drawing code here.
	
	
	[super drawRect:dirtyRect];
	
	NSRect rect = [self bounds];
	NSRect newRect = NSMakeRect(rect.origin.x+2, rect.origin.y+2, rect.size.width-3, rect.size.height-3);
	
	NSBezierPath *textViewSurround = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:10 yRadius:10];
	[textViewSurround setLineWidth:2.0];
	[[NSColor colorWithCalibratedWhite:0.1 alpha:0.7] set];
	[textViewSurround fill];
	
	[[NSColor whiteColor] set];
	[textViewSurround stroke];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"mouseEntered" object:nil];
}

- (void)mouseExited:(NSEvent *)theEvent {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"mouseExited" object:nil];
}

@end
