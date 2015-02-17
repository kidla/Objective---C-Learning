//
//  DropItBehavior.h
//  DropIt
//
//  Created by Ｋ on 2015/2/16.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior: UIDynamicBehavior
- (void)addItem:(id<UIDynamicItem>)item;
- (void)removeItem:(id<UIDynamicItem>)item;
@end
