//
//  PlayingCard.m
//  Cards
//
//  Created by Sanjib Ahmad on 11/3/13.
//  Copyright (c) 2013 <>< ObjectCoder. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (PlayingCard *otherCard in otherCards) {
        if (otherCard.rank == self.rank) {
            score += 4;
        } else if ([otherCard.suit isEqualToString:self.suit]) {
            score += 1;
        }
    }
    
    /*
     * Used for comparing the contents of otherCards to match against each other
     * For Example: in 3 card match, let's assume
     *      self.rank = J♠
     *      otherCards = [4♦, 8♦]
     * In the match test block above J♠ doesn't match either 4♦ or 8♦
     * But 4♦ matches the suit of 8♦ - the following code block address that
     */
    NSMutableArray *otherCardsCollectionForComparison = [otherCards mutableCopy];
    for (PlayingCard *otherCard in otherCards) {
        [otherCardsCollectionForComparison removeObject:otherCard];
        for (PlayingCard *otherCardInOtherCardsColleciton in otherCardsCollectionForComparison) {
            if (otherCard.rank == otherCardInOtherCardsColleciton.rank) {
                score += 4;
            } else if ([otherCard.suit isEqualToString:otherCardInOtherCardsColleciton.suit]) {
                score += 1;
            }
        }
    }
    
    return score;
}

#pragma mark - suits
@synthesize suit = _suit;
+ (NSArray *)validSuits
{
    
    return @[@"♥", @"♦", @"♣", @"♠"];
}
- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}
- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

#pragma mark - ranks

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6",
             @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
