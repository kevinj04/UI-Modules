//
//  button.m
//  Classroom Demo
//
//  Created by Nick Pannuto on 2/10/10.
//  Copyright 2010 Sneakyness, llc.. All rights reserved.
//

#import "SneakyButton.h"

@implementation SneakyButton

@synthesize status, value, active, isHoldable, isToggleable, rateLimit, radius;
@synthesize buttonName;
@synthesize boundingBox;
@synthesize isOn;
@synthesize isRateLimited;

- (void) onEnterTransitionDidFinish
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:10 swallowsTouches:YES];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

-(id)initWithRect:(CGRect)rect{
	self = [super init];
	if(self){
		
        buttonName = [[NSString stringWithFormat:@"defaultButton"] retain];
        
		bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
        boundingBox = rect;
		center = CGPointMake(rect.size.width/2, rect.size.height/2);
		status = 1; //defaults to enabled
		active = NO;
		value = 0;
		isHoldable = NO;
		isToggleable = 0;
        [self setRadius:32.0f];
		rateLimit = 1.0f/120.0f;
		isRateLimited = YES;
        
        isOn = YES;
        
		position_ = rect.origin;
        [self setPosition:rect.origin];
	}
	return self;
}

-(void)limiter:(ccTime)delta{
    
    if (value == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@Up", [self buttonName]] object:self userInfo:nil];
    }
    
    value = 0;
	[self unschedule: @selector(limiter:)];
	active = NO;
}

- (void) setRadius:(float)r
{
	radius = r;
	radiusSq = r*r;
}

#pragma mark Touch Delegate
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{      
    
    if (!isOn) return NO;
	if (active) return NO;
    
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	//location = [self convertToNodeSpace:location];
    
    
    //Do a fast rect check before doing a circle hit check:
    // Modified Sneaky Button for rectangles
	if (!CGRectContainsPoint(boundingBox, location)){
		return NO;
	}else{
        active = YES;
        if (!isHoldable && !isToggleable){
            value = 1;
            
            if (isRateLimited)
                [self schedule: @selector(limiter:) interval:rateLimit];
            //[[CCScheduler sharedScheduler] scheduleSelector:@selector(limiter:) forTarget:self interval:rateLimit paused:NO];
            // tap event?
            //untested!
            //NSLog(@"Fire event %@", [NSString stringWithFormat:@"%@Down", [self buttonName]]);
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@Down", [self buttonName]] object:self userInfo:nil];
            
        }
        if (isHoldable) {
            value = 1;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@Down", [self buttonName]] object:self userInfo:nil];
            // hold event start?
        }
        if (isToggleable) {
            // Untested
            //NSLog(@"Fire event %@", [NSString stringWithFormat:@"%@Down", [self buttonName]]);
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@Down", [self buttonName]] object:self userInfo:nil];
            value = !value;
            // toggleEvent
        }
        return YES;
		
	}
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	//if (!active) return;
	
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
	//location = [self convertToNodeSpace:location];
    //Do a fast rect check before doing a circle hit check:
	if (!CGRectContainsPoint(boundingBox, location)){
        
        if (isHoldable) {
            
            // we are no longer holding the button down
            
            value = 0; 
            active = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@Off", [self buttonName]] object:self userInfo:nil];            
            // fire touch again?
            [[CCTouchDispatcher sharedDispatcher] touchesCancelled:[NSSet setWithObject:touch] withEvent:event];
            [[CCTouchDispatcher sharedDispatcher] touchesBegan:[NSSet setWithObject:touch] withEvent:event];
            //[self ccTouchEnded:touch withEvent:event];
            //NSLog(@"  >> Hold Ended with drag out");
            // should count as tap?
            // hold event ended
        }
        
		return;
	}else{
        
        if (value == 0) {
            // We have reentered the button region
            active = YES;
            value = 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@Down", [self buttonName]] object:self userInfo:nil];
        }    
        
        if (isHoldable) {
            value = 1;
            //NSLog(@"  >> Hold Moved");
            // hold event maintained?
        }
        
	}
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (!active) {
        // tap ended? hold ended? toggle ended?
        return;
    }
	if (isHoldable) {
        value = 0;
        
    }
	if (isHoldable||isToggleable) {
        active = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@Up", [self buttonName]] object:self userInfo:nil];
        //NSLog(@"  >> Hold Ended");
        // hold ended?
        // toggle ended?
    } else {
        
        if (value == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@Up", [self buttonName]] object:self userInfo:nil];
        }
        
    }
    
    
    
    // tap ended?
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self ccTouchEnded:touch withEvent:event];
}

- (void) dealloc {
    
    [buttonName release];
    
    [super dealloc];
}


- (void) update:(ccTime) dt {
    if (value == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@Down", [self buttonName]] object:self];
    }
}

@end
