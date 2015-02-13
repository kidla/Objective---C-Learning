//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Ｋ on 2015/2/13.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) BOOL faceUp;
@end
