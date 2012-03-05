//
//  FlickScroller.h
//  UIModule
//
//  Created by Kevin Jenkins on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FlickScrollerDelegate.h"

extern NSString *const nScrollChange;
extern NSString *const nLocation;

typedef enum flickerType {
	vertical, horizontal, both
} flickerType;


/**
 @brief Enables custom defined flick/drag/swipe gestures.
 
 FlickScroller is a CCTargetedTouchDelegate that catches all touches on the screen and processes the user's interactions into flicks, swipes, and drags. These events are propagated to the FlickScrollerDelegate. 
 
 @ingroup controls
 
 */

@interface FlickScroller : CCNode <CCTargetedTouchDelegate> {
    
    NSObject<FlickScrollerDelegate> *delegate;
    CGRect touchRect;
    bool active;
    
@private 
    flickerType fType;
    bool isDragging;
    bool wasFlicked;
    double flickTime;
    CGPoint touchOrigin;
    CGPoint lastDragPoint;
    
}

/** Determines whether or not this FlickScroller will recieve input. If set to NO, touches will be ignored by this FlickScroller. */
@property bool active;

/** An object that implements the FlickScrollerDelegate protocol.  */
@property (nonatomic, retain) NSObject<FlickScrollerDelegate> *delegate;

/** The area inside which touches will be processed by this FlickScroller.*/
@property CGRect touchRect;

#pragma mark Initialization/Dealloc
/** @name Constructors/Setup/Destructors 
 
 These methods control the creation, initialization, setup, and destruction of all objects of this class.
 */
//@{

/** Creates a FlickScroller 
 
 @param touchRect
 A rectangle that describes the region inside which this FlickScroller will respond to touch events.
 
 @param type
 An enum that defines what sort of motion this scroller will have. 
 - vertical: (0) A vertical only scroller.
 - horizontal: (1) A horizontal only scroller.
 - both: (2) A scroller that responds to displacement along both x and y axes.
 
 */
- (id) initWithRect:(CGRect) rect andType:(flickerType) type;

/** Sets up the FlickScroller with default values. */
- (void) setup;

/** Resets the state of this object to it's default values. */
- (void) reset;

/** Frees this object and all retained objects */
- (void) dealloc;

//@}
#pragma mark -

#pragma mark Touch Delegate
/** @name Touch delegate methods.
 
 These methods control the creation, initialization, setup, and destruction of all objects of this class.
 */
//@{

/** Fired when a touch even begins.
 
 @param touch
 The UITouch that triggered this event.
 @param event
 The UIEvent object that represents this event.
 
 @return 
 YES if this touch was handled by this object.
 NO if this touch was ignored by this object.
 */
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

/** Fired when a touch is moved
 
 @param touch
 The UITouch that triggered this event.
 @param event
 The UIEvent object that represents this event.
 
 */
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;

/** Fired when a touch event has concluded.
 
 @param touch
 The UITouch that triggered this event.
 @param event
 The UIEvent object that represents this event.
 
 */
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;

/** Fired when a touch is cancelled
 
 @param touch
 The UITouch that triggered this event.
 @param event
 The UIEvent object that represents this event.
 
 */
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event;

//@}
#pragma mark -

@end
