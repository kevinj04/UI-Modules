// Adaped from Nick Pannuto's sneakyButton



//
//  button.h
//  Classroom Demo
//
//  Created by Nick Pannuto on 2/10/10.
//  Copyright 2010 Sneakyness, llc.. All rights reserved.
//

#import "cocos2d.h"

@interface SneakyButton : CCNode <CCTargetedTouchDelegate> {
	
    NSString *buttonName;
    
    CGPoint center;
	
	float radius;
	float radiusSq;
	
	CGRect bounds;
	BOOL active;
	BOOL status;
	BOOL value;
	BOOL isHoldable;
	BOOL isToggleable;
    
    bool isRateLimited;
	ccTime rateLimit;
    
    CGRect boundingBox;
    bool isOn;
}

@property (nonatomic, retain) NSString *buttonName;

@property (nonatomic, assign) BOOL status;
@property (nonatomic, readonly) BOOL value;
@property (nonatomic, readonly) BOOL active;
@property (nonatomic, assign) BOOL isHoldable;
@property (nonatomic, assign) BOOL isToggleable;
@property (nonatomic, assign) bool isRateLimited;
@property (nonatomic, assign) ccTime rateLimit;
@property (nonatomic, assign) CGRect boundingBox;
@property (nonatomic, assign) bool isOn;

//Optimizations (keep Squared values of all radii for faster calculations) (updated internally when changing radii)
@property (nonatomic, assign) float radius;

-(id)initWithRect:(CGRect)rect;

- (void) limiter:(ccTime) dt;


@end

