//
//  ViewController.m
//  Matchismo
//
//  Created by Ｋ on 2015/2/3.
//  Copyright (c) 2015年 Wayi. All rights reserved.
//

#import "ViewController.h"

#import "PlayingCardDeck.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic,assign) int flipCount;
@property (strong, nonatomic) Deck *deck;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (Deck *)deck {
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    
    return _deck;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.countLabel.text = [NSString stringWithFormat:@"Count: %d",flipCount];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    if ([sender.currentTitle length]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"cardback"] forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
        
        self.flipCount++ ;
    } else {
        Card *drawCard = [self.deck drawRandomCard];
        if (drawCard) {
            NSString *drawCardContent = drawCard.contents;
            [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"] forState:UIControlStateNormal];
            [sender setTitle:drawCardContent forState:UIControlStateNormal];
            if ([drawCardContent containsString:@"♥︎"]||[drawCardContent containsString:@"♦︎"]) {
                [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }else {
                [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            self.flipCount++ ;
        }
        
    }
}

@end
