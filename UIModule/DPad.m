//
//  DPad.m
//  physics
//
//  Created by Kevin Jenkins on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DPad.h"

NSString *const dPadUL = @"dPadUL";
NSString *const dPadU = @"dPadU";
NSString *const dPadUR = @"dPadUR";
NSString *const dPadL = @"dPadL";
NSString *const dPadMenu = @"dPadMenu";
NSString *const dPadR = @"dPadR";
NSString *const dPadDL = @"dPadDL";
NSString *const dPadD = @"dPadD";
NSString *const dPadDR = @"dPadDR";

@interface DPad (hidden)
- (void) setupButtons;
- (void) registerNotifications;

- (void) leftButtonDown:(NSNotification *) notification;
- (void) rightButtonDown:(NSNotification *) notification;
- (void) leftUpButtonDown:(NSNotification *) notification;
- (void) rightUpButtonDown:(NSNotification *) notification;
- (void) leftDownButtonDown:(NSNotification *) notification;
- (void) rightDownButtonDown:(NSNotification *) notification;
- (void) upButtonDown:(NSNotification *) notification;
- (void) downButtonDown:(NSNotification *) notification;
- (void) menuButtonDown:(NSNotification *) notification;
@end

@implementation DPad (hidden)
- (void) setupButtons {
    buttons = [[NSMutableSet alloc] initWithCapacity:10];
    
    SneakyButton *leftUpButton = [[SneakyButton alloc] initWithRect:CGRectMake(0, 2.0*boundary.size.height/3.0, boundary.size.width/3.0, 
                                                                               boundary.size.height/3.0)];
    [leftUpButton setButtonName:@"leftUpButton"];
    
    SneakyButton *leftDownButton = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, boundary.size.width/3.0, 
                                                                                 boundary.size.height/3.0)];
    [leftDownButton setButtonName:@"leftDownButton"];
    
    SneakyButton *leftButton = [[SneakyButton alloc] initWithRect:CGRectMake(0, boundary.size.height/3.0, boundary.size.width/3.0, 
                                                                             boundary.size.height/3.0)];
    [leftButton setButtonName:@"leftButton"];
    
    SneakyButton *rightUpButton = [[SneakyButton alloc] initWithRect:CGRectMake(2.0*boundary.size.width/3.0, 2.0*boundary.size.height/3.0, 
                                                                                boundary.size.width/3.0, boundary.size.height/3.0)];
    [rightUpButton setButtonName:@"rightUpButton"];
    SneakyButton *rightDownButton = [[SneakyButton alloc] initWithRect:CGRectMake(2.0*boundary.size.width/3.0, 0, 
                                                                                  boundary.size.width/3.0, boundary.size.height/3.0)];
    [rightDownButton setButtonName:@"rightDownButton"];
    SneakyButton *rightButton = [[SneakyButton alloc] initWithRect:CGRectMake(2.0*boundary.size.width/3.0, boundary.size.height/3.0, 
                                                                              boundary.size.width/3.0, boundary.size.height/3.0)];
    [rightButton setButtonName:@"rightButton"];
    
    SneakyButton *upButton = [[SneakyButton alloc] initWithRect:CGRectMake(boundary.size.width/3.0, 2.0*boundary.size.height/3.0, 
                                                                           boundary.size.width/3.0, boundary.size.height/3.0)];
    [upButton setButtonName:@"upButton"];
    SneakyButton *menuButton = [[SneakyButton alloc] initWithRect:CGRectMake(boundary.size.width/3.0, boundary.size.height/3.0, 
                                                                             boundary.size.width/3.0, boundary.size.height/3.0)];
    [menuButton setButtonName:@"menuButton"];
    SneakyButton *downButton = [[SneakyButton alloc] initWithRect:CGRectMake(boundary.size.width/3.0, 0.0, 
                                                                             boundary.size.width/3.0, boundary.size.height/3.0)];
    [downButton setButtonName:@"downButton"];
    
    [buttons addObject:leftUpButton];
    [buttons addObject:leftButton];
    [buttons addObject:leftDownButton];
    [buttons addObject:upButton];
    [buttons addObject:menuButton];
    [buttons addObject:downButton];
    [buttons addObject:rightUpButton];
    [buttons addObject:rightButton];
    [buttons addObject:rightDownButton];
    
    [self addChild:leftUpButton];
    [self addChild:leftButton];
    [self addChild:leftDownButton];
    [self addChild:upButton];
    [self addChild:menuButton];
    [self addChild:downButton];
    [self addChild:rightUpButton];
    [self addChild:rightButton];
    [self addChild:rightDownButton];
    
    [leftButton release];
    [leftUpButton release];
    [leftDownButton release];
    [upButton release];
    [menuButton release];
    [downButton release];
    [rightUpButton release];
    [rightButton release];
    [rightDownButton release];
}
- (void) registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftUpButtonDown:) name:@"leftUpButtonDown" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightUpButtonDown:) name:@"rightUpButtonDown" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftButtonDown:) name:@"leftButtonDown" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightButtonDown:) name:@"rightButtonDown" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftDownButtonDown:) name:@"leftDownButtonDown" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightDownButtonDown:) name:@"rightDownButtonDown" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upButtonDown:) name:@"upButtonDown" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downButtonDown:) name:@"downButtonDown" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuButtonDown:) name:@"menuButtonDown" object:nil];
    
}
- (void) leftButtonDown:(NSNotification *) notification {
    NSLog(@"Left Button Down");
    [[NSNotificationCenter defaultCenter] postNotificationName:dPadL object:self];
}
- (void) rightButtonDown:(NSNotification *) notification {
    NSLog(@"Right Button Down");
    [[NSNotificationCenter defaultCenter] postNotificationName:dPadR object:self];
}
- (void) leftUpButtonDown:(NSNotification *) notification {
    NSLog(@"Left Up Button Down");
    [[NSNotificationCenter defaultCenter] postNotificationName:dPadUL object:self];
}
- (void) rightUpButtonDown:(NSNotification *) notification {
    NSLog(@"Right Up Button Down");
    [[NSNotificationCenter defaultCenter] postNotificationName:dPadUR object:self];
}
- (void) leftDownButtonDown:(NSNotification *) notification {
    NSLog(@"Left Down Button Down");
    [[NSNotificationCenter defaultCenter] postNotificationName:dPadDL object:self];
}
- (void) rightDownButtonDown:(NSNotification *) notification {
    NSLog(@"Right Down Button Down");
    [[NSNotificationCenter defaultCenter] postNotificationName:dPadDR object:self];
}
- (void) upButtonDown:(NSNotification *) notification {
    NSLog(@"Up Button Down");
    [[NSNotificationCenter defaultCenter] postNotificationName:dPadU object:self];
}
- (void) downButtonDown:(NSNotification *) notification {
    NSLog(@"Down Button Down");
    [[NSNotificationCenter defaultCenter] postNotificationName:dPadD object:self];
}
- (void) menuButtonDown:(NSNotification *) notification {
    NSLog(@"Menu Button Down");
    [[NSNotificationCenter defaultCenter] postNotificationName:dPadMenu object:self];
}

@end

@implementation DPad

@synthesize shouldDraw;

- (id) initWithRect:(CGRect)rect {
    
    if ((self = [super init])) {
        
        [self setupWithRect:rect];
        
        return self;
    } else {
        return nil;
    }
    
}
+ (id) layerWithRect:(CGRect) rect {
    return [[[DPad alloc] initWithRect:rect] autorelease];
}
- (void) setupWithRect:(CGRect) rect {
    shouldDraw = NO;
    boundary = rect;
    [self setupButtons];
    [self registerNotifications];
}
- (void) dealloc {
    [super dealloc];
}

- (void) draw {
    
    if (shouldDraw) {
        // setup buttons to draw themselves and turn that on... 
    }
    [super draw];
}
- (void) update:(ccTime) dt {
    for (SneakyButton *sb in buttons) {
        [sb update:dt];
    }
}

- (void) setActive:(bool) b {
    for (SneakyButton *sb in buttons) {
        [sb setIsOn:b];
    }
}

@end
