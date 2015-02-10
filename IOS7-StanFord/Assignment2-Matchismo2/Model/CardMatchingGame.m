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
@property (nonatomic, readwrite) NSString *valueMatchedPoint;
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
    if (!card.matched) {
        if (card.isChosen) {
            card.chosen = NO;
            self.valueMatchedPoint = @"";
        } else {
            NSMutableArray *currentCardArray = [[NSMutableArray alloc] init];
            NSMutableString *statusCurrentChosenCards = [[NSMutableString alloc] init];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    
                    [currentCardArray addObject:otherCard];
                    [statusCurrentChosenCards appendFormat:@"%@ ",otherCard.contents];
                }
            }
            
            if ([currentCardArray count]) {
                self.valueMatchedPoint = [[NSString stringWithFormat:@"Chose %@ to match with: ",card.contents] stringByAppendingString:statusCurrentChosenCards];
            } else {
                self.valueMatchedPoint = [NSString stringWithFormat:@"Chose %@" , card.contents];
            }
            
            
            
            if ([currentCardArray count] == self.gameCardMode) {
                int matchScore = [card match:currentCardArray];
                
                if (matchScore) {
                    self.valueMatchedPoint = card.contents;
                    self.score += matchScore * Match_BONUS;
//                    otherCard.matched = YES;
                    for (Card *gameModeCard  in currentCardArray ) {
                        gameModeCard.matched = YES;
                    }
                    self.valueMatchedPoint = [self.valueMatchedPoint stringByAppendingString:[NSString stringWithFormat:@" get:%d",matchScore * Match_BONUS]];
                    
                    card.matched = YES;
                } else {
                    self.valueMatchedPoint = card.contents;
                    for (Card *gameModeCard  in currentCardArray ) {
                        gameModeCard.chosen = NO;
                        self.valueMatchedPoint = [self.valueMatchedPoint stringByAppendingString:gameModeCard.contents];
                    }
                    self.score -= MISMATCH_PENALTY;
                    self.valueMatchedPoint = [self.valueMatchedPoint stringByAppendingString:[NSString stringWithFormat:@" penalty:%d",  -MISMATCH_PENALTY]];
                    // self.valueMatchedPoint = - MISMATCH_PENALTY;
                }
                
                
                  
                
            }
            
        }
    }
    
    self.score -= Cost_To_Choose;
    card.chosen = YES;
}



- (Card *)cardAtIndex:(NSInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
