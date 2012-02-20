//
//  FlickScrollerDelegate.h
//  testBed
//
//  Created by Kevin Jenkins on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/** @enum swipeDirection Directionality enumeration for swipe gestures. */
typedef enum swipeDirection {
	sdLeft, sdUp, sdRight, sdDown
} swipeDirection;

/**
 @brief An object must implement this protocol to respond to a FlickScroller.
 
 FlickScrollerDelegate presents an object with an interface to process flicks, swipes, and drags from a FlickScroller.
 
 @ingroup controls
 */

@protocol FlickScrollerDelegate <NSObject>

#pragma mark Flick Delegate Methods
/**
 Updates this objects position based on a user input 'flick'. Utilizes a CCAction with EaseExponentialOut.
 
 @param p
 The point at which this object should come to rest.
 */
- (void) flickToLocation:(CGPoint) p;

/**
 Updates the objects position when the user drags a finger around the screen but does not cross the 'flick' motion threshold.
 
 @param p
 A point which represents a vector of how far to move this object. 
 */
- (void) scrollByDistance:(CGPoint) p;

/**
 Stops the motion of this object when the user puts their finger down.
 
 @param d
 A swipe direction indicated by the enumeration swipeDirection:
 - sdLeft: (0) A swipe to the left.
 - sdUp: (1) An upward swipe.
 - sdRight: (2) A swipe to the right.
 - sdDown: (3) A downward swipe.
 */
- (void) swipe:(swipeDirection) d;

/** Stops the motion of this object. */
- (void) stopFlick;

/** @brief Returns the bounding box for this scrollable object. */
- (CGRect) boundingBox;
/** @brief Returns the location of this object (BoundingBox origin). */
- (CGPoint) location;

- (bool) visible;
- (NSString *) objectId;
#pragma mark -

@end
