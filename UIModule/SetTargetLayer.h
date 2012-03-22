//
//  SetTargetLayer.h
//  physics
//
//  Created by Kevin Jenkins on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SetTargetLayerReferenceProtocol.h"
/*#import "PhysicsForceObject.h"
#import "PhysicsObject.h"
 */

extern NSString *const referencePointUpdate;
extern NSString *const referenceObjectUpdate;
extern NSString *const targetLayerUpdate;
extern NSString *const location;
extern NSString *const forceApplied;

@interface SetTargetLayer : CCLayer {
    
    BOOL active;
    
    @private
    bool pointExists;
    
    //CGPoint targetPoint;  // may be faster to just use this if we are doing single touch.
    NSObject<SetTargetLayerReferenceProtocol> *referenceObject;
    CGPoint referencePoint;
    CGRect boundary;
    
    NSMutableSet *touches;
    
}

@property BOOL active;

- (id) initWithRect:(CGRect) rect;
+ (id) layerWithRect:(CGRect) rect;
- (void) setupWithRect:(CGRect) rect;
- (void) dealloc;

- (void) update:(ccTime) dt;
- (void) setBoundary:(CGRect) r;

@end
