//
//  ViewController.m
//  xypieTest
//
//  Created by Ｋ on 2015/1/7.
//  Copyright (c) 2015年 Wayi. All rights reserved.
//

#import "ViewController.h"
#import "XYPieChart.h"

#import <QuartzCore/QuartzCore.h>
@interface ViewController () <XYPieChartDelegate, XYPieChartDataSource>

@property (strong,nonatomic) NSMutableArray *slices;
@property (strong, nonatomic) IBOutlet XYPieChart *pieChart;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slices = [[NSMutableArray alloc] init];
    for (int i =1 ; i<= 10; i++) {
       NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
        [self.slices addObject:one];
    }
    //[self.dlpieChart renderInLayer:self.dlpieChart dataArray:self.slices];
     NSLog(@"%lu",self.slices.count);
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
     [self.pieChart setPieCenter:CGPointMake(160, 240)];
    [self.pieChart setShowPercentage:YES];
    [self.pieChart setLabelColor:[UIColor blackColor]];
    [self.pieChart reloadData];
    self.pieChart.pieRadius = 150;
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    NSLog(@"%lu",self.slices.count);
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [UIColor colorWithRed:45*index/255.0 green:3*index/255.0 blue:0/255.0 alpha:1];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %d",index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
   // self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
