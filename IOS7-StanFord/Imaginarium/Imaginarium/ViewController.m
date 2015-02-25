//
//  ViewController.m
//  Imaginarium
//
//  Created by Ｋ on 2015/2/25.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
        ImageViewController *vc = (ImageViewController *)segue.destinationViewController;
        vc.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://images.apple.com/v/iphone-5s/gallery/a/images/download/%@.jpg", segue.identifier]];
        vc.title = segue.identifier;
    }
}
@end
