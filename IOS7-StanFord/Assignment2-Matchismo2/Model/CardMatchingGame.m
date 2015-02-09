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
@property (nonatomic, readwrite)  NSInteger *valueMatchedPoint;
@end
static const NSInteger MISMATCH_PENALTY = 2;
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
    NSLog(@"%lu",self.gameCardMode);
    if (!card.matched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            NSMutableArray *myCardArray = [[NSMutableArray alloc]init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    
                    [myCardArray addObject:otherCard];
                    
                    if ([myCardArray count] == self.gameCardMode) {
                        NSLog(@"mycard count%lu",[myCardArray count]);
                        int matchScore = [card match:myCardArray
                                          ];
                        if (matchScore) {
                            self.score += matchScore * Match_BONUS;
                            otherCard.matched = YES;
                            for (Card *gameModeCard  in myCardArray ) {
                                gameModeCard.matched = YES;
                            }
                            self.valueMatchedPoint = matchScore * Match_BONUS;
                            card.matched = YES;
                        } else {
                            for (Card *gameModeCard  in myCardArray ) {
                                gameModeCard.chosen = NO;
                            }
                            self.score -= MISMATCH_PENALTY;
                            self.valueMatchedPoint = - MISMATCH_PENALTY;
                        }
                        break;
                        
                    }
                    
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
