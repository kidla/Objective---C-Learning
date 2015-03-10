//
//  AddPhotoViewController.h
//  Photomania
//
//  Created by Ｋ on 2015/3/9.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "Photographer.h"
@interface AddPhotoViewController : UIViewController

//in
@property (strong, nonatomic) Photographer *photographerTakingPhoto;

//out
@property (readonly, nonatomic) Photo *addPhoto;

@end
