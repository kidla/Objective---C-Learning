//
//  ImageViewController.m
//  Imaginarium
//
//  Created by Ｋ on 2015/2/25.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ImageViewController
- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.bounces = YES;
    _scrollView.delegate = self;
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
     }

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
   //self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
    [self startDownloadingImage];
}

- (void)startDownloadingImage {
    self.image = nil;
    if (self.imageURL) {
        [self.activityIndicator startAnimating];
        NSURLRequest  *request = [[NSURLRequest alloc] initWithURL:self.imageURL];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession  *session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
            if (!error) {
                if ([self.imageURL isEqual:request.URL]) {
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
                   dispatch_async(dispatch_get_main_queue(), ^{
                        self.image = image;
                   });
                }
            }
        }];
        [task resume];
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    
    return  _imageView;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    [self.activityIndicator stopAnimating];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}


@end
