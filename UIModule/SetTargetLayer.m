//
//  SetTargetLayer.m
//  physics
//
//  Created by Kevin Jenkins on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SetTargetLayer.h"

NSString *const referencePointUpdate = @"referencePointUpdate";
NSString *const referenceObjectUpdate = @"referenceObjectUpdate";
NSString *const targetLayerUpdate = @"targetLayerUpdate";
NSString *const location = @"location";
NSString *const forceApplied = @"forceApplied";

@interface SetTargetLayer (hidden)
- (void) registerNotifications;

- (void) updateReferencePoint:(NSNotification *) notification;
- (void) updateReferenceObject:(NSNotification *) notification;
- (CGPoint) currentReferencePoint;
@end
@implementation SetTargetLayer (hidden)

- (void) registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateReferencePoint:) name:referencePointUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateReferenceObject:) name:referenceObjectUpdate object:nil];
}

- (void) updateReferencePoint:(NSNotification *) notification {
    referencePoint = CGPointFromString([[notification userInfo] objectForKey:referencePointUpdate]);
}
- (void) updateReferenceObject:(NSNotification *)notification {
    if ([[notification object] respondsToSelector:@selector(position)]) {
        referenceObject = [[notification object] retain];
    } else {
        if (referenceObject != nil) {
            [referenceObject release];
        }
        referenceObject = nil;
    }
}
- (CGPoint) currentReferencePoint {
    if (referenceObject == nil) { return referencePoint; }
    else { return [referenceObject position]; }
}
@end

@implementation SetTargetLayer

@synthesize active;

- (id) initWithRect:(CGRect) rect {
    
    if (( self = [super init])) {
        
        [self setupWithRect:rect];
        
        return self;
    } else {
        return nil;
    }
    
}
+ (id) layerWithRect:(CGRect) rect {
    return [[[SetTargetLayer alloc] initWithRect:rect] autorelease];
}
- (void) setupWithRect:(CGRect) rect {
    
    boundary = rect;
    active = YES;
    referencePoint = CGPointMake(0.0, 0.0);
    //targetPoint = ccp(0.0,0.0);
    pointExists = NO;
    
    touches = [[NSMutableSet setWithCapacity:10] retain];
    
    [self registerNotifications];
    
}
- (void) dealloc {
    [super dealloc];
}

- (void) setBoundary:(CGRect) r {
    boundary = r;
}

- (void) update:(ccTime) dt {
    if (pointExists) {
        
        //float angleForce = ccpAngle(referencePoint, targetPoint);
        //float distance = ccpDistance(referencePoint, targetPoint);
        //CGPoint force = ccpNormalize(ccpSub(targetPoint, referencePoint));
        //CGPoint force = ccpSub(targetPoint, referencePoint);
        //CGPoint force = ccpMult(ccpSub(targetPoint, referencePoint), .05);
        
        //PhysicsForceObject *pfo = [PhysicsForceObject objectWithForce:force];
        //[[NSNotificationCenter defaultCenter] postNotificationName:targetLayerUpdate object:pfo];
        
        
        for (UITouch *touch in touches) {
            CGPoint touchPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
            CGPoint force = ccpMult(ccpSub(touchPoint, [self currentReferencePoint]), 1.0);
           
            /*
            PhysicsForceObject *pfo = [PhysicsForceObject objectWithForce:force];*/
            NSDictionary *pfo = [NSDictionary dictionaryWithObject:NSStringFromCGPoint(force) forKey:forceApplied];
            [[NSNotificationCenter defaultCenter] postNotificationName:targetLayerUpdate object:self userInfo:pfo];
             
        }
        
        
    }
}

- (void) onEnterTransitionDidFinish {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:100 swallowsTouches:NO];
    
}

- (void) onExit {
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

#pragma mark Touch Delegate
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    
    if (!active) { return NO; }
    
    CGPoint locationOrig = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];    
    
    if (CGRectContainsPoint(boundary, locationOrig)) {
        
        pointExists = YES;
        //targetPoint = locationOrig;
        [touches addObject:touch];
        
        return YES;
    }
    
    return  NO;
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (!active) { return; }
    
    CGPoint locationOrig = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    
    if (CGRectContainsPoint(boundary, locationOrig)) {
        
        pointExists = YES;
        //targetPoint = locationOrig;
    }
    
    
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {    
    
    [touches removeObject:touch];
    
    if ([touches count] == 0) {
        pointExists = NO;
        //targetPoint = ccp(0.0,0.0);
    }

}
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self ccTouchEnded:touch withEvent:event];
}
#pragma mark -

@end
