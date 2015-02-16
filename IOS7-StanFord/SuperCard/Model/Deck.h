//
//  Deck.h
//  Cards
//
//  Created by Sanjib Ahmad on 11/3/13.
//  Copyright (c) 2013 <>< ObjectCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;
- (Card *)drawRandomCard;

@end
