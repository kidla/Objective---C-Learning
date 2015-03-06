//
//  Photo+Flicker.m
//  Photomania
//
//  Created by Ｋ on 2015/3/3.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "Photo+Flicker.h"
#import "FlickrFetcher.h"
#import "Photographer+Create.h"

@implementation Photo (Flicker)
+ (Photo *)photoWithFlickerInfo:(NSDictionary *)photoDictionary
         inManagedObjectContext:(NSManagedObjectContext *)context {
    Photo *photo = nil;
    NSString *unique = photoDictionary[FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || error || [matches count] > 1 ) {
        //handle error
    } else if ([matches count]) {
        photo = [matches lastObject];
    } else {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = unique;
        photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
        NSLog(@"%@",photo.title);
        photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        NSString *photographerName = [photoDictionary valueForKey:FLICKR_PHOTO_OWNER];
        photo.latitude = @([photoDictionary[FLICKR_LATITUDE] doubleValue]);
        photo.longitude = @([photoDictionary[FLICKR_LONGITUDE] doubleValue]);
        photo.thumbnailURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];
        photo.whoTook = [Photographer photographerWithName:photographerName inManagedObjectContext:context];
        
    }
    
    
    return photo;
}

+ (void)loadPhotosFromFlickrArray:(NSArray *)photos intoManagedObjectContext:(NSManagedObjectContext *)context {
    
    for (NSDictionary *photo in photos) {
        [self photoWithFlickerInfo:photo inManagedObjectContext:context];
    }

}
@end
