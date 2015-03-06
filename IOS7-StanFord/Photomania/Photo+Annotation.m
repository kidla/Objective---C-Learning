//
//  Photo+Annotation.m
//  Photomania
//
//  Created by Ｋ on 2015/3/6.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "Photo+Annotation.h"

@implementation Photo (Annotation)

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coordinate ;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    
    return coordinate;
}


@end
