//
//  PhotosCDTVCViewController.m
//  Photomania
//
//  Created by Ｋ on 2015/3/4.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "PhotosCDTVCViewController.h"
#import "ImageViewController.h"
#import "Photo.h"

@implementation PhotosCDTVCViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Photo Cell"];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue.identifier
                  fromIndexPath:indexPath];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id detailvc = [self.splitViewController.viewControllers lastObject];
    if ([detailvc isKindOfClass:[UINavigationController class]]) {
        detailvc = [((UINavigationController *)detailvc).viewControllers firstObject];
        [self prepareViewController:detailvc
                           forSegue:nil
                      fromIndexPath:indexPath];
        
    }
}


- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath {
   Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([vc isKindOfClass:[ImageViewController class]]) {
        ImageViewController *imgVC = (ImageViewController *)vc;
        imgVC.imageURL = [NSURL URLWithString:photo.imageURL];
        imgVC.title = photo.title;
    }
}

@end