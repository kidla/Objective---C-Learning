//
//  CardMatchingGame.h
//  Matchismo2
//
//  Created by Ｋ on 2015/2/6.
//  Copyright (c) 2015年 Wayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) NSInteger score;

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSInteger)index;

@end
