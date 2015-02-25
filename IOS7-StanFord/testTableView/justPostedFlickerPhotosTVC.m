//
//  justPostedFlickerPhotosTVC.m
//  testTableView
//
//  Created by Ｋ on 2015/2/25.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "justPostedFlickerPhotosTVC.h"
#import "FlickrFetcher.h"

@interface justPostedFlickerPhotosTVC ()

@end

@implementation justPostedFlickerPhotosTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPhotosData];
}

- (void)fetchPhotosData {
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
    NSLog(@"%@",jsonDict);
    self.photos = nil;
}

@end
