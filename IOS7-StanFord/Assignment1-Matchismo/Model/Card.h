//
//  Card.h
//  Matchismo
//
//  Created by Ｋ on 2015/2/3.
//  Copyright (c) 2015年 Wayi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;


@end
