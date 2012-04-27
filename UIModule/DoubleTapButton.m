//
//  DoubleTapButton.m
//  physics
//
//  Created by Kevin Jenkins on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DoubleTapButton.h"

NSString *const doubleTap = @"doubleTap";

@implementation DoubleTapButton

-(id)initWithRect:(CGRect)rect {
    
    if (( self = [super initWithRect:rect] )) {
        
        rateLimit = 1.0/2.0;
        isHoldable = NO;
        isToggleable = NO;
        taps = 0;
        
        return self;
    } else {
        return nil;
    }
    
}

#pragma mark Touch Delegate
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    if (!isOn) return NO;        
    
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	//location = [self convertToNodeSpace:location];
    
    
    //Do a fast rect check before doing a circle hit check:
    // Modified Sneaky Button for rectangles
	if (!CGRectContainsPoint(boundingBox, location)){
		return NO;
	}else{
        //NSLog(@"Value: %i    isActive: %i", value, active);
        
        if (!isHoldable && !isToggleable){
            
            
            if (taps == 0) {
                active = YES;
                //[self performSelector:@selector(limiter:) withObject:nil afterDelay:rateLimit];
                [self schedule:@selector(limiter:) interval:rateLimit];
            }
                
            if (taps == 1 && active) {
                [[NSNotificationCenter defaultCenter] postNotificationName:doubleTap object:self];
                taps = 0;
                active = NO;
            }
            
            taps += 1;
            
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
            NSLog(@"Fire event %@", [NSString stringWithFormat:@"%@Down", [self buttonName]]);
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
	if (!active) return;
	
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	location = [self convertToNodeSpace:location];
    //Do a fast rect check before doing a circle hit check:
	if(location.x < -radius || location.x > radius || location.y < -radius || location.y > radius){
		return;
	}else{
		float dSq = location.x*location.x + location.y*location.y;
		if(radiusSq > dSq){
			if (isHoldable) {
                value = 1;
                //NSLog(@"  >> Hold Moved");
                // hold event maintained?
            }
		}
		else {
			if (isHoldable) {
                value = 0; 
                active = NO;
                //NSLog(@"  >> Hold Ended with drag out");
                // should count as tap?
                // hold event ended
            }
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
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@Up", [self buttonName]] object:self userInfo:nil];
    
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


- (void) limiter:(ccTime) dt {
    taps = 0;
    active = NO;    
    [self unschedule:@selector(limiter:)];
}


@end
