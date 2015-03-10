//
//  AddPhotoViewController.m
//  Photomania
//
//  Created by Ｋ on 2015/3/9.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "AddPhotoViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Photo.h"
#import "UIImage+CS193p.h"


@interface AddPhotoViewController () <UITextFieldDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *subTitleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSURL *thumbnailURL;
@property (strong, nonatomic, readwrite) Photo *addPhoto;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSInteger locationErrorCode;
@end

@implementation AddPhotoViewController

+ (BOOL)canAddPhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusRestricted) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(![[self class] canAddPhoto]) {
        [self fatalAlert:@"Sorry ,device can't add a photo, please check control center"];
    }else {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)viewDidLoad {
    self.image = [UIImage imageNamed:@"disclosure"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    [[NSFileManager defaultManager] removeItemAtURL:_imageURL error:NULL];
    [[NSFileManager defaultManager] removeItemAtURL:_thumbnailURL error:NULL];
    self.thumbnailURL = nil;
    self.imageURL = nil;
}

- (NSURL *)imageURL {
    if (!_imageURL && self.image) {
        NSURL *url = [self uniqueDocumentURL];
        if (url) {
            NSData *imageData = UIImageJPEGRepresentation(self.image, 1.0f);
            if (imageData) {
                [imageData writeToURL:url atomically:YES];
                 _imageURL = url;
            }
        }
        
    }
    
    return _imageURL;
}

- (NSURL *)thumbnailURL {
    NSURL *url = [self.imageURL URLByAppendingPathExtension:@"thumbnail"];
    if (![_thumbnailURL isEqual:url ]) {
        _thumbnailURL = nil;
        if (url) {
            UIImage *thumbnailImage = [self.image imageByScalingToSize:CGSizeMake(75, 75)];
            NSData *imageData = UIImageJPEGRepresentation(thumbnailImage, 0.5);
            if(imageData) {
                [imageData writeToURL:url atomically:YES];
                  _thumbnailURL = url;
            }
        }
    }
    
    return _thumbnailURL;
}

- (NSURL *)uniqueDocumentURL {
    NSArray *documentDirectories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSString *unique = [NSString stringWithFormat:@"%.0f",floor([NSDate timeIntervalSinceReferenceDate])];
    return [[documentDirectories firstObject] URLByAppendingPathComponent:unique];
}

- (UIImage *)image {
    return self.imageView.image;
}
#define UNWIND_SEGUE_IDENTIFIER @"DO Add Photo"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER]) {
        NSManagedObjectContext *context = self.photographerTakingPhoto.managedObjectContext;
        if (context) {
            Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
            photo.title = self.titleTextField.text;
            photo.subtitle = self.subTitleTextField.text;
            photo.thumbnailURL = [self.thumbnailURL absoluteString];
            photo.imageURL = [self.imageURL absoluteString];
            photo.whoTook = self.photographerTakingPhoto;
            photo.latitude = @(self.location.coordinate.latitude);
            photo.longitude = @(self.location.coordinate.longitude);
            
            self.addPhoto = photo;
            self.imageURL = nil;
            self.thumbnailURL = nil;
            
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER]) {
        if (!self.image) {
            [self alert:@"No photo taken!"];
            return NO;
        } else if (![self.titleTextField.text length]) {
            [self alert:@"Title required!"];
            return NO;
        } else if (!self.location) {
            switch (self.locationErrorCode) {
                case kCLErrorLocationUnknown:
                    NSLog(@"%ld",(long)self.locationErrorCode);
                    [self alert:@"Couldn't figure out where this photo was taken (yet)."]; break;
                case kCLErrorDenied:
                    [self alert:@"Location Services disabled under Privacy in Settings application."]; break;
                case kCLErrorNetwork:
                    [self alert:@"Can't figure out where this photo is being taken.  Verify your connection to the network."]; break;
                default:
                    [self alert:@"Cant figure out where this photo is being taken, sorry."]; break;
            }
            return NO;
        } else { // should check imageURL too to be sure we could write the file
            return YES;
        }
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager = locationManager;
        [locationManager requestWhenInUseAuthorization];
    }
    
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = [locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.locationErrorCode = error.code;
}

- (void)alert:(NSString *)msg {
    [[[UIAlertView alloc] initWithTitle:@"Add Photo" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

- (void)fatalAlert:(NSString *)msg {
    [[[UIAlertView alloc] initWithTitle:@"Add Photo" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

- (IBAction)cancel {
    self.image = nil;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self cancel];
}

- (IBAction)done:(id)sender {
}

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if(!image)  {
       image = info[UIImagePickerControllerOriginalImage];
    }
    self.image = image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
