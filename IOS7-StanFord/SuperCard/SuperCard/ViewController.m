//
//  ViewController.m
//  SuperCard
//
//  Created by Ｋ on 2015/2/13.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.playingCardView.suit = @"♥️";
    self.playingCardView.rank = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
