//
//  SneakyButtonSkinnedBase.h
//  SneakyInput
//
//  Created by Nick Pannuto on 2/19/10.
//  Copyright 2010 Sneakyness, llc.. All rights reserved.
//

// Adapted from above by Kevin Jenkins 6/3/11

#import "cocos2d.h"

@class SneakyButton;

@interface SneakyButtonSkin : CCSprite {
	CCSprite *defaultSprite;
	CCSprite *activatedSprite;
	CCSprite *disabledSprite;
	CCSprite *pressSprite;
	SneakyButton *button;
}

@property (nonatomic, retain) CCSprite *defaultSprite;
@property (nonatomic, retain) CCSprite *activatedSprite;
@property (nonatomic, retain) CCSprite *disabledSprite;
@property (nonatomic, retain) CCSprite *pressSprite;

@property (nonatomic, retain) SneakyButton *button;

@end
