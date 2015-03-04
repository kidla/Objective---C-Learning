//
//  PhotosByPhotographerCDTVCViewController.m
//  Photomania
//
//  Created by Ｋ on 2015/3/4.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "PhotosByPhotographerCDTVCViewController.h"

@implementation PhotosByPhotographerCDTVCViewController

- (void)setPhotographer:(Photographer *)photographer {
    _photographer = photographer;
    self.title = photographer.name;
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController {
    NSManagedObjectContext *context = self.photographer.managedObjectContext;
    if (context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@",self.photographer];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedStandardCompare:)]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        
    } else {
        self.fetchedResultsController = nil;
    }
    
}

@end
