//
//  DropItBehavior.m
//  DropIt
//
//  Created by Ｋ on 2015/2/16.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "DropitBehavior.h"

@interface DropitBehavior()
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UIDynamicItemBehavior *animatorOptions;
@end
@implementation DropitBehavior

- (UICollisionBehavior *)collision {
    if (!_collision) {
        _collision = [[UICollisionBehavior alloc]init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
            }
    
    return _collision;
}

- (UIDynamicItemBehavior *)animatorOptions {
    if (!_animatorOptions) {
        _animatorOptions = [[UIDynamicItemBehavior alloc]init];
        _animatorOptions.allowsRotation = NO;
    }
    
    return _animatorOptions;
}
- (UIGravityBehavior *)gravity {
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc]init];
        _gravity.magnitude = 0.9;
}
    
    return _gravity;
}

- (void)addItem:(id<UIDynamicItem>)item {
    [self.gravity addItem:item];
    [self.collision addItem:item];
    [self.animatorOptions addItem:item];
}

- (void)removeItem:(id<UIDynamicItem>)item {
    [self.gravity removeItem:item];
    [self.collision removeItem:item];
    [self.animatorOptions removeItem:item];
}


- (instancetype)init {
    self = [super init];
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collision];
    [self addChildBehavior:self.animatorOptions];
    return self;
}

@end
