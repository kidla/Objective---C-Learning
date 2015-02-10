//
//  ViewController.m
//  Matchismo2
//
//  Created by Ｋ on 2015/2/6.
//  Copyright (c) 2015年 Wayi. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface ViewController ()
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame *game;

@property (weak, nonatomic) IBOutlet UIButton *rePlayButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation ViewController

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
        _game.gameCardMode = self.segmentedControl.selectedSegmentIndex + 1;
    }
    
    return _game;
}

- (Deck *)deck {
    if (!_deck) {
        _deck = [self createDeck];
    }
    return _deck;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc]init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (void)updateUI {
    
    self.segmentedControl.enabled = NO;
    
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setBackgroundImage:[self backgroundForCard:card] forState:UIControlStateNormal];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        
        if ([cardButton.titleLabel.text containsString:@"♥︎"]||[cardButton.titleLabel.text containsString:@"♦︎"]) {
            [cardButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else {
            [cardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }

        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
        if (_game.valueMatchedPoint) {
            self.resultLabel.text = [NSString stringWithFormat:@"result:%@",_game.valueMatchedPoint];
        } else {
            self.resultLabel.text = @"Ready!";
        }
    }
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (IBAction)switchCardGameMode:(UISegmentedControl *)sender {

    _game.gameCardMode = self.segmentedControl.selectedSegmentIndex + 1;
}

- (IBAction)touchRePlayButton:(UIButton *)sender {
    _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    _game.gameCardMode =  self.segmentedControl.selectedSegmentIndex + 1;
    [self updateUI];
     self.segmentedControl.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *s =@[@"AAA"];
    id objtest = s;
    NSArray *a = objtest;
    NSLog(@"%@",a);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSLog(@"segment%lu",self.segmentedControl.selectedSegmentIndex);
}
@end
