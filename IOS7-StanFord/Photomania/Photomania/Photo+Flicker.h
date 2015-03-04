//
//  Photo+Flicker.h
//  Photomania
//
//  Created by Ｋ on 2015/3/3.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flicker)
+ (Photo *)photoWithFlickerInfo:(NSDictionary *)photoDictionary
          inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)loadPhotosFromFlickrArray:(NSArray *)photos intoManagedObjectContext:(NSManagedObjectContext *)context;

@end
