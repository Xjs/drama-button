//
//  Drama_ButtonAppDelegate.m
//  Drama Button
//
//  Created by Martin Schend on 06.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Drama_ButtonAppDelegate.h"
#import <QuartzCore/QuartzCore.h>


#define MFCFAutorelease(x) (__typeof(x))[NSMakeCollectable(x) autorelease]
#define WINDOW_PADDING (50)


@interface Drama_ButtonAppDelegate ()
- (void)_swapViews;
- (void)_prepareViewIsFront:(BOOL)isFront;
- (void)_hideShadow:(BOOL)hidden;
- (CAAnimationGroup *)_flipAnimationWithDuration:(CGFloat)duration isFront:(BOOL)isFront;
@end

@implementation Drama_ButtonAppDelegate

@synthesize scale,distortion;

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
	
	[[window contentView] addSubview:frontView];


    // In order to simulate a floating panel, we create an over-large, borderless, invisible window.
    window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, NSWidth(frontView.frame) + 2 * WINDOW_PADDING, NSHeight(frontView.frame) + 2 * WINDOW_PADDING) styleMask:NSBorderlessWindowMask backing:NSBackingStoreRetained defer:NO];
    [window setMovableByWindowBackground:YES];
    [window setOpaque:NO];
    [window.contentView setWantsLayer:YES];
    window.backgroundColor = [NSColor clearColor];
    [window.contentView layer].backgroundColor = CGColorGetConstantColor(kCGColorClear);
    
    self.distortion = 0;
    self.scale = 1.0;
    
    // Helper functions because I hate writing the same code twice.
    [self _prepareViewIsFront:YES];
    [self _prepareViewIsFront:NO];
    [self _hideShadow:NO];
	
//    [window center];
    [window makeKeyAndOrderFront:nil];
		
	// Create a default CATransform3D
	CATransform3D perspective_transform = CATransform3DIdentity;
	// This is some cryptic edit to the default CATransform3D that I will understand in the not-so-near future
	perspective_transform.m34 = -1.0/800.0;
	// Set perspective_transform as the transform matrix for all sublayer
	[[window contentView] layer].sublayerTransform = perspective_transform;
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


/* FLIPPING!!! */

#pragma mark Actions

- (IBAction)flip:(id)sender;
{
#define ANIMATION_DURATION_IN_SECONDS (1.0)
    // Hold the shift key to flip the window in slo-mo. It's really cool!
    CGFloat flipDuration = ANIMATION_DURATION_IN_SECONDS * (window.currentEvent.modifierFlags & NSShiftKeyMask ? 10.0 : 1.0);
	
    // The hidden layer is "in the back" and will be rotating forward. The visible layer is "in the front" and will be rotating backward
    CALayer *hiddenLayer = [frontView.isHidden ? frontView : notFrontView layer];
    CALayer *visibleLayer = [frontView.isHidden ? notFrontView : frontView layer];
    
    // Before we can "rotate" the window, we need to make the hidden view look like it's facing backward by rotating it pi radians (180 degrees). We make this its own transaction and supress animation, because this is already the assumed state
    [CATransaction begin];
	{
        [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
        [hiddenLayer setValue:[NSNumber numberWithDouble:M_PI] forKeyPath:@"transform.rotation.y"];
//        if (self.isDebugging) // Shadows screw up corner finding
//            [self _hideShadow:YES];
    }
	[CATransaction commit];
    
    // There's no way to know when we are halfway through the animation, so we have to use a timer. 
	// On a sufficiently fast machine (like a Mac) this is close enough.
	// On something like an iPhone, this can cause minor drawing glitches
    [self performSelector:@selector(_swapViews) withObject:nil afterDelay:flipDuration / 2.0];
        
    // Both layers animate the same way, but in opposite directions (front to back versus back to front)
    [CATransaction begin]; {
        [hiddenLayer addAnimation:[self _flipAnimationWithDuration:flipDuration isFront:NO] forKey:@"flipGroup"];
        [visibleLayer addAnimation:[self _flipAnimationWithDuration:flipDuration isFront:YES] forKey:@"flipGroup"];
    } [CATransaction commit];
	NSLog(@"foo");
}


#pragma mark Private

- (void)_swapViews;
{
    // At the point the window flips, change which view is visible, thus bringing it "to the front"
    [frontView setHidden:![frontView isHidden]];
    [notFrontView setHidden:![notFrontView isHidden]];
}

- (void)_prepareViewIsFront:(BOOL)isFront;
{
    NSRect frame = NSMakeRect(WINDOW_PADDING, WINDOW_PADDING, NSWidth(frontView.frame), NSHeight(frontView.frame));
    NSView *view = isFront ? frontView : notFrontView;
    [view setHidden:!isFront];
    
    [window.contentView addSubview:view];
    [view setFrameOrigin:NSMakePoint(WINDOW_PADDING, WINDOW_PADDING)];
    view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    view.layer.frame = NSRectToCGRect(frame);
   
}

- (void)_hideShadow:(BOOL)hidden;
{
#define SHADOW_OPACITY (0.25)
#define SHADOW_RADIUS (10.0)
#define SHADOW_OFFSET CGSizeMake(0.0, -10)
    
	/*
	 Here's an oddity. This throws a compiler error:
	 frontView.layer.shadowOffset = debugging ? CGSizeZero : SHADOW_OFFSET;
	 
	 But these both work:
	 [frontView.layer setShadowOffset:debugging ? CGSizeZero : SHADOW_OFFSET];
	 frontView.layer.shadowOffset = debugging ? CGMakeSize(0.0, 0.0) : SHADOW_OFFSET;
	 */
    
    frontView.layer.shadowOpacity = hidden ? 0.0 : SHADOW_OPACITY;
    frontView.layer.shadowRadius = hidden ? 0.0 : SHADOW_RADIUS;
    frontView.layer.shadowOffset = hidden ? CGSizeMake(0.0, 0.0) : SHADOW_OFFSET;
	
    notFrontView.layer.shadowOpacity = hidden ? 0.0 : SHADOW_OPACITY;
    notFrontView.layer.shadowRadius = hidden ? 0.0 : SHADOW_RADIUS;
    notFrontView.layer.shadowOffset = hidden ? CGSizeMake(0.0, 0.0) : SHADOW_OFFSET;
}

- (CAAnimationGroup *)_flipAnimationWithDuration:(CGFloat)duration isFront:(BOOL)isFront;
{
    // Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	
    // The hidden view rotates from negative to make it look like it's in the back
#define LEFT_TO_RIGHT (isFront ? -M_PI : M_PI)
#define RIGHT_TO_LEFT (isFront ? M_PI : -M_PI)
    flipAnimation.toValue = [NSNumber numberWithDouble:[notFrontView isHidden] ? LEFT_TO_RIGHT : RIGHT_TO_LEFT];
    
    // Shrinking the view makes it seem to move away from us, for a more natural effect
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	
    shrinkAnimation.toValue = [NSNumber numberWithDouble:self.scale];
	
    // We only have to animate the shrink in one direction, then use autoreverse to "grow"
    shrinkAnimation.duration = duration / 2.0;
    shrinkAnimation.autoreverses = YES;
    
    // Combine the flipping and shrinking into one smooth animation
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:flipAnimation, shrinkAnimation, nil];
	
    // As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
    // Set ourselves as the delegate so we can clean up when the animation is finished
    animationGroup.delegate = self;
    animationGroup.duration = duration;
	
    // Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
	
    return animationGroup;
}


@end
