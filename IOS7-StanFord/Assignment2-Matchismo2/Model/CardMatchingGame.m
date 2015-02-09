//
//  CardMatchingGame.m
//  Matchismo2
//
//  Created by Ｋ on 2015/2/6.
//  Copyright (c) 2015年 Wayi. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@end
static const int MISMATCH_PENALTY = 2;
static const int Match_BONUS = 4;
static const int Cost_To_Choose = 1;
@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *drawCard = [deck drawRandomCard];
            if (drawCard) {
                [self.cards addObject:drawCard];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card =[self cardAtIndex:index];
    if (!card.matched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    int matchScore = [card match:@[otherCard]
                                      ];
                    if (matchScore) {
                        self.score += matchScore * Match_BONUS;
                        otherCard.matched = YES;
                        card.matched = YES;
                    } else {
                        otherCard.chosen = NO;
                        self.score -= MISMATCH_PENALTY;
                    }
                    break;
                }
            }
            self.score -= Cost_To_Choose;
            card.chosen = YES;
        }
    }
}

- (Card *)cardAtIndex:(NSInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
