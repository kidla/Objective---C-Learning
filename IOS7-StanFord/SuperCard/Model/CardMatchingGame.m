//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Sanjib Ahmad on 11/4/13.
//  Copyright (c) 2013 <>< ObjectCoder. All rights reserved.
//

#import "CardMatchingGame.h"

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (nonatomic) NSInteger currentMatchCardFlipCount;
@property (nonatomic) NSInteger numberOfCardsToPlayWith;
@end

@implementation CardMatchingGame

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
          numberOfCardsToPlayWith:(NSInteger)numberOfCardsToPlayWith
{
    self = [super init]; // super's designated initializer
    
    if (self) {
        self.numberOfCardsToPlayWith = numberOfCardsToPlayWith;
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            self.status = @"";
        } else {
            // match against other cards
            
            // First we store the cards that are chosen and not matched in currentChosenCards
            NSMutableArray *currentChosenCards = [[NSMutableArray alloc] init];
            NSMutableString *statusCurrentChosenCards = [[NSMutableString alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [currentChosenCards addObject:otherCard];
                    [statusCurrentChosenCards appendFormat:@"%@ ", otherCard.contents];
                }
            }
            if ([currentChosenCards count]) {
                self.status = [[NSString stringWithFormat:@"Chose %@ to match with: ", card.contents] stringByAppendingString:statusCurrentChosenCards];
            } else {
                self.status = [NSString stringWithFormat:@"Chose %@", card.contents];
            }

            
            // The model is already tracking how many cards are currently chosen and not matched
            // So all we need to do is match that count with the number of cards we are playing with
            // We do a -1 because currentChosenCards doesn't include the card that was just clicked
            if ([currentChosenCards count] == self.numberOfCardsToPlayWith-1) {
                int matchScore = [card match:currentChosenCards];
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    for (Card *otherCard in currentChosenCards) {
                        otherCard.matched = YES;
                    }
                    card.matched = YES;
                    self.status = [[NSString stringWithFormat:@"Scored: %d. Match found for: %@ ", matchScore * MATCH_BONUS, card.contents] stringByAppendingString:statusCurrentChosenCards];
                } else {
                    self.score -= MISMATCH_PENALTY;
                    for (Card *otherCard in currentChosenCards) {
                        otherCard.chosen = NO;
                    }
                    self.status = [[NSString stringWithFormat:@"Penalty: %d. No match found for: %@ ", MISMATCH_PENALTY, card.contents] stringByAppendingString:statusCurrentChosenCards];
                }
            }
        
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
    
    // This is not part of the assignment. It's just a nice way to end the game.
    // If the last remaning cards do not match, the game should freeze those cards
    // from being clicked and end the game.
    [self shouldDisableGame];
}

- (void)shouldDisableGame
{
    NSMutableArray *cardsRemaining = [[NSMutableArray alloc] init];
    for (Card *otherCard in self.cards) {
        if (!otherCard.isMatched) {
            [cardsRemaining addObject:otherCard];
        }
    }
    if ([cardsRemaining count] && ([cardsRemaining count] <= self.numberOfCardsToPlayWith)) {
        Card *firstCard = [cardsRemaining firstObject];
        NSMutableArray *cardsToMatch = [[NSMutableArray alloc] initWithArray:cardsRemaining];
        [cardsToMatch removeObjectAtIndex:0];
        int possibleMatchScore = [firstCard match:cardsToMatch];
        
        if (!possibleMatchScore) {
            for (Card *card in cardsRemaining) {
                NSLog(@"Remaining cards: %@", card.contents);
                card.matched = YES;
            }
        }
    }    
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil ;
}

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

@end
