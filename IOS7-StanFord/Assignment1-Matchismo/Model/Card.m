//
//  Card.m
//  Matchismo
//
//  Created by Ｋ on 2015/2/3.
//  Copyright (c) 2015年 Wayi. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards {
    
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score ++;
        }
    }
    
    return score;
}
 
@end
