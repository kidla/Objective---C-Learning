//
//  Deck.h
//  Matchismo
//
//  Created by Ｋ on 2015/2/4.
//  Copyright (c) 2015年 Wayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
