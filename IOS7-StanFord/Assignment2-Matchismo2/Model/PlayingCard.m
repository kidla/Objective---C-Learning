//
//  PlayingCard.m
//  Matchismo
//
//  Created by Ｋ on 2015/2/5.
//  Copyright (c) 2015年 Wayi. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard
@synthesize  suit = _suit;

+ (NSUInteger)maxRank {
    return [[self rankStrings] count] -1 ;
}

+ (NSArray *)validSuits {
    return @[@"♥︎",@"♦︎",@"♠︎",@"♣︎"];
}

+ (NSArray *)rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"
             ,@"10",@"J",@"Q",@"K"];
}

#pragma mark - override Super class method

- (int)match:(NSArray *)otherCards {
    int score = 0;
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        if (otherCard.rank == self.rank) {
            score = 4;
        } else if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        }
    }
    
    return score;
}

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (void)setRank:(NSUInteger)rank {
    if (_rank < [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit ]) {
         _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

@end
