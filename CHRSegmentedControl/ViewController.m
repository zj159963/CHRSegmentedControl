//
//  ViewController.m
//  CHRSegmentedControl
//
//  Created by JianZhang on 16/4/24.
//  Copyright © 2016年 JianZhang. All rights reserved.
//

#import "ViewController.h"
#import "CHRSegmentedControl.h"

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) CHRSegmentedControl *seg;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  CHRSegmentedControl *seg = [[CHRSegmentedControl alloc] initWithTitles:nil];
  seg.titleColor = [UIColor greenColor];
  seg.itemBackgroundColor = [UIColor whiteColor];
  seg.selectedTitleColor = [UIColor blackColor];
  seg.selectedBackgroundColor = [UIColor whiteColor];
  seg.seperatorColor = [UIColor clearColor];
  seg.indicatorColor = [UIColor greenColor];
  seg.itemSizeIncrease = CGSizeMake(50, 20);
  seg.itemWidthEqually = YES;
  seg.seperatorWidth = 1.0;
  seg.indicatorHeight = 4.0;
  seg.selectedCallback = ^(CHRSegmentedControl *control, NSUInteger selectedIndex){
    NSLog(@"%@, %lu", control, selectedIndex);
  };
  [seg sizeToFit];
  CGRect frame = CGRectIntegral(seg.frame);
  seg.frame = (CGRect) {0, 100, frame.size};
  [self.view addSubview:seg];
  self.seg = seg;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  self.seg.center = self.view.center;
  [self.seg insertItem:@"A" atIndex:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGFloat offset = scrollView.contentOffset.x / scrollView.bounds.size.width;
  NSLog(@"%f", offset);
  self.seg.offset = offset;
}

@end