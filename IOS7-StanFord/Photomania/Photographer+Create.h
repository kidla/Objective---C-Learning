//
//  Photographer+Create.h
//  Photomania
//
//  Created by Ｋ on 2015/3/3.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "Photographer.h"

@interface Photographer (Create)
+ (Photographer *) photographerWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
@end
