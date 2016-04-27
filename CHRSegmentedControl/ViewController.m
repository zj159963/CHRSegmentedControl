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
  
  CHRSegmentedControl *seg = [[CHRSegmentedControl alloc] initWithTitles:@[@"A", @"B", @"C", @"D", @"E", @"F"]];
  seg.titleColor = [UIColor greenColor];
  seg.itemBackgroundColor = [UIColor whiteColor];
  seg.selectedTitleColor = [UIColor blackColor];
  seg.selectedBackgroundColor = [UIColor yellowColor];
  seg.seperatorColor = [UIColor clearColor];
  seg.indicatorColor = [UIColor greenColor];
  seg.itemSizeIncrease = CGSizeMake(50, 20);
  seg.itemWidthEqually = YES;
  seg.seperatorWidth = 1.0;
  seg.indicatorHeight = 4.0;
  seg.selectedCallback = ^(CHRSegmentedControl *control, NSUInteger selectedIndex){
    NSLog(@"%@, %lu", control, selectedIndex);
    [control setItemBackgroundColor:[UIColor blueColor] forRange:NSMakeRange(2, 2)];
  };
  [seg setSelectedBackgroundColor:[UIColor redColor] forRange:NSMakeRange(0, 2)];
  [seg setItemBackgroundColor:[UIColor cyanColor] forRange:NSMakeRange(2, 2)];
  [seg setSelectedTitles:@[@"1", @"2", @"3", @"4", @"5", @"6"] forRange:NSMakeRange(0, 6)];
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
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self.seg beginUpdate];
  CGFloat offset = scrollView.contentOffset.x / scrollView.bounds.size.width;
  self.seg.offset = offset;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  if (!decelerate) {
    [self.seg commit];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  [self.seg commit];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [self.seg removeFromSuperview];
  
  self.seg = nil;
}

@end