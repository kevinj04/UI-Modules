//
//  SetTargetLayer.h
//  physics
//
//  Created by Kevin Jenkins on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
/*#import "PhysicsForceObject.h"
#import "PhysicsObject.h"
 */

extern NSString *const referencePointUpdate;
extern NSString *const targetLayerUpdate;
extern NSString *const location;

@interface SetTargetLayer : CCLayer {
    
    bool active;
    
    @private
    bool pointExists;
    
    //CGPoint targetPoint;  // may be faster to just use this if we are doing single touch.
    CGPoint referencePoint;
    CGRect boundary;
    
    NSMutableSet *touches;
    
}

@property bool active;

- (id) initWithRect:(CGRect) rect;
+ (id) layerWithRect:(CGRect) rect;
- (void) setupWithRect:(CGRect) rect;
- (void) dealloc;

- (void) update:(ccTime) dt;

@end
