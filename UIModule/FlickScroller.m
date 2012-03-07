//
//  FlickScroller.m
//  UIModule
//
//  Created by Kevin Jenkins on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "FlickScroller.h"

#define kOffsetIPadX 0.0 // 64?
#define kOffsetIPadY 0.0 // 32?

NSString *const nScrollChange = @"scrollChange";
NSString *const nLocation = @"location";

#define SPEED_BUFFER 5.0
#define FLICK_POWER 5.0
#define FLICK_FRICTION 1.0
#define SWIPE_LENGTH 75.0

@interface FlickScroller (hidden)

- (void) updateTimer:(double) dt;
- (CGPoint) scalePointForIPad:(CGPoint) p;
- (CGPoint) scalePointFromIPad:(CGPoint) p;
- (CGRect) scaleRectFromIPad:(CGRect) r;
- (CGRect) scaleRectForIPad:(CGRect) r;
@end

@implementation FlickScroller (hidden)

- (void) updateTimer:(double) dt {
    flickTime += dt;
    NSLog(@"Flick time update to: %2.2f", flickTime);
}
- (CGPoint) scalePointForIPad:(CGPoint) p {
    // ipad actions need to be twice as large, maybe old iphone too?
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGPointMake(p.x*2.0+kOffsetIPadX, p.y*2.0+kOffsetIPadY);
    } else {
        return p;
    }
}
- (CGPoint) scalePointFromIPad:(CGPoint) p {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGPointMake((p.x - kOffsetIPadX) *0.5, (p.y - kOffsetIPadY)*0.5);
    } else {
        return p;
    }
}
- (CGRect) scaleRectFromIPad:(CGRect) r {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGRectMake((r.origin.x - kOffsetIPadX)*0.5, (r.origin.y-kOffsetIPadY)*0.5, r.size.width*0.5, r.size.height*0.5);
    } else {
        return r;
    }
}
- (CGRect) scaleRectForIPad:(CGRect) r {
    // ipad actions need to be twice as large, maybe old iphone too?
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGRectMake(r.origin.x*2.0+kOffsetIPadX, r.origin.y*2.0+kOffsetIPadY, r.size.width*2.0, r.size.height*2.0);
    } else {
        return r;
    }
}

@end


@implementation FlickScroller

@synthesize delegate, touchRect, active;

#pragma mark Initialization/Dealloc
- (id) initWithRect:(CGRect) rect andType:(flickerType) type {
    
    if ((self = [super init])) {
        
        touchRect = rect;
        
        fType = type;
        
        [self setup];
        
        [self reset];
        
        return self;
    } else {
        return nil;
    }
    
}
- (void) setup {
    return;
}
- (void) reset {
    
    active = YES;
    
    flickTime = 0.0;
    isDragging = NO;
    wasFlicked = NO;
    
    return;
}
- (void) dealloc {
    [delegate release];
    
    [super dealloc];
}
- (void) onEnterTransitionDidFinish
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}
#pragma mark -

#pragma mark Touch Delegate
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    
    
    if (!active) { return NO; }
    
    CGPoint locationOrig = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    locationOrig = [self scalePointFromIPad:locationOrig];
    
    CGRect hitBox = [self scaleRectFromIPad:[delegate boundingBox]];
    
    if (CGRectContainsPoint(hitBox, locationOrig) /*&& [delegate visible]*/) {
        
        if (wasFlicked) {
            //if (delegate != nil) {[delegate stopFlick];}        
        }
        
        touchOrigin = locationOrig;
        lastDragPoint = locationOrig;
        isDragging = YES;
        wasFlicked = NO;
        
        // start flickTimer
        flickTime = 0.0;
        [self schedule:@selector(updateTimer:)];
        
        return YES;
    }
    
    return  NO;
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (!active) {return;}
    
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    location = [self scalePointFromIPad:location];
    
    if (isDragging) {
        
        
        float dx = 0.0;
        float dy = 0.0;
        switch (fType) {
            case vertical:                
                dy = location.y - lastDragPoint.y;                
                break;
            case horizontal:
                dx = location.x - lastDragPoint.x;
                break;
            case both:
                dx = location.x - lastDragPoint.x;
                dy = location.y - lastDragPoint.y;
                break;        
        }
        
        if (delegate != nil) {
            CGPoint change = CGPointMake(dx,dy);
            
            [[NSNotificationCenter defaultCenter] 
             postNotificationName:[NSString stringWithFormat:@"%@ScrollBy", [delegate objectId]] 
             object:self 
             userInfo:[NSDictionary dictionaryWithObject:NSStringFromCGPoint(change) 
                                                  forKey:nScrollChange]];
            
            //[delegate scrollByDistance:change];
        }
        
        lastDragPoint = location;
        
    }
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    [self unschedule:@selector(updateTimer:)];
    
    if (!active) {return;}
    
    isDragging = NO;
    
    CGPoint locationOrig = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    locationOrig = [self scalePointFromIPad:locationOrig];
	//location = [self convertToNodeSpace:locationOrig];
    
    float dx = 0.0;
    float dy = 0.0;
    float dist = 0.0;
    
    switch (fType) {
        case vertical:                
            dy = locationOrig.y - touchOrigin.y;                
            dist = fabs(dy);
            break;
        case horizontal:
            dx = locationOrig.x - touchOrigin.x;            
            dist = fabs(dx);
            break;
        case both:
            dx = locationOrig.x - touchOrigin.x;
            dy = locationOrig.y - touchOrigin.y;
            dist = sqrtf(dx*dx+dy*dy);
            break;        
    }
    
    
    
    if (fabsf(dx) > SWIPE_LENGTH) {
        if (dx > 0.0) {
            if (delegate!=nil) {[[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@SwipeLeft", [delegate objectId]]  object:self userInfo:nil];}    //[delegate swipe:sdRight];}
        } else if (dx < 0.0){
            if (delegate!=nil) {[[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@SwipeRight", [delegate objectId]]  object:self userInfo:nil];}//[delegate swipe:sdLeft];}
        }
    }
    
    if (fabsf(dy) > SWIPE_LENGTH) {
        if (dy > 0.0) {
            if (delegate!=nil) {[[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@SwipeUp", [delegate objectId]]  object:self userInfo:nil];}//[delegate swipe:sdUp];}
        } else if (dy < 0.0){
            if (delegate!=nil) {[[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@SwipeDown", [delegate objectId]]  object:self userInfo:nil];}//[delegate swipe:sdDown];}
        }
    }
    
    flickTime = fmaxf(flickTime, .01);
    
    float speed = dist / (flickTime * 100.0);    
    
    if (speed > SPEED_BUFFER) {
        // flick event
        
        dx *= FLICK_POWER;
        dy *= FLICK_POWER;
        
        if (delegate != nil) {
            CGPoint flickLocation = ccp(dx/FLICK_FRICTION,dy/FLICK_FRICTION);
            NSLog(@"Flick Location EP: %@", NSStringFromCGPoint(flickLocation));
            [[NSNotificationCenter defaultCenter] 
             postNotificationName:[NSString stringWithFormat:@"flickTo"]  
             object:self userInfo:[NSDictionary dictionaryWithObject:NSStringFromCGPoint(flickLocation) 
                                                              forKey:nLocation]];
            //[delegate flickToLocation:flickLocation];
        }
        wasFlicked = YES;
    } 
    
    
}
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self ccTouchEnded:touch withEvent:event];
}
#pragma mark -

- (void) setDelegate:(NSObject<FlickScrollerDelegate> *)d {
    delegate = [d retain];
    touchRect = [d boundingBox];
}


@end

