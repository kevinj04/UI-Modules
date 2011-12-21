//
//  DPad.h
//  physics
//
//  Created by Kevin Jenkins on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyButton.h"

extern NSString *const dPadUL;
extern NSString *const dPadU;
extern NSString *const dPadUR;
extern NSString *const dPadL;
extern NSString *const dPadMenu;
extern NSString *const dPadR;
extern NSString *const dPadDL;
extern NSString *const dPadD;
extern NSString *const dPadDR;

@interface DPad : CCLayer {
    
    bool shouldDraw;
    
    @private 
    CGRect boundary;
    NSMutableSet *buttons;
    bool active;
        
}

@property bool shouldDraw;

- (id) initWithRect:(CGRect) rect;
+ (id) layerWithRect:(CGRect) rect;
- (void) setupWithRect:(CGRect) rect;
- (void) dealloc;

- (void) draw;
- (void) update:(ccTime) dt;

- (void) setActive:(bool) b;

@end
