//
//  ViewController.m
//  CHRSegmentedControl
//
//  Created by JianZhang on 16/4/24.
//  Copyright © 2016年 JianZhang. All rights reserved.
//

#import "ViewController.h"
#import "CHRSegmentedControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  CHRSegmentedControl *seg = [[CHRSegmentedControl alloc] initWithTitles:@[@"116646", @"2222", @"13"]];
  seg.itemBackgroundColor = [UIColor yellowColor];
  seg.selectedBackgroundColor = [UIColor lightGrayColor];
  seg.itemSizeIncrease = CGSizeMake(80, 20);
  seg.itemWidthEqually = YES;
  [seg setSelectedTitles:@[@"First", @"Second", @"Third"] forRange:NSMakeRange(0, 3)];
  seg.selectedCallback = ^(CHRSegmentedControl *control, NSUInteger selectedIndex){
    NSLog(@"%@, %lu", control, selectedIndex);
  };
  [seg sizeToFit];
  seg.frame = CGRectIntegral(seg.frame);
  [self.view addSubview:seg];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  CHRSegmentedControl *seg = ((CHRSegmentedControl *)self.view.subviews.lastObject);
  seg.center = self.view.center;
}

@end