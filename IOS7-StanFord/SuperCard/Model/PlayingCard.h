//
//  PlayingCard.h
//  Cards
//
//  Created by Sanjib Ahmad on 11/3/13.
//  Copyright (c) 2013 <>< ObjectCoder. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
