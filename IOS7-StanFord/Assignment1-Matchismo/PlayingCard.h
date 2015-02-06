//
//  PlayingCard.h
//  Matchismo
//
//  Created by Ｋ on 2015/2/5.
//  Copyright (c) 2015年 Wayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
