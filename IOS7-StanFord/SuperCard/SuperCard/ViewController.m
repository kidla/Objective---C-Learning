//
//  ViewController.m
//  SuperCard
//
//  Created by Ｋ on 2015/2/13.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@property (strong, nonatomic) Deck *deck;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.playingCardView.suit = @"♠";
    self.playingCardView.rank = 13;
    [self.playingCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self.playingCardView action:@selector(pinch:) ]];
}

- (Deck *)deck {
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc]init];
    }
    
    return _deck;
}

- (void)drawRandomPlayingCard {
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playcard = (PlayingCard *)card;
        self.playingCardView.suit = playcard.suit;
        self.playingCardView.rank = playcard.rank;
    }
}
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    if(!self.playingCardView.faceUp) {
        [self drawRandomPlayingCard];
    }
    
    self.playingCardView.faceUp =! self.playingCardView.faceUp;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
