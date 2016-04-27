//
//  ViewController.m
//  CHRSegmentedControl
//
//  Created by JianZhang on 16/4/24.
//  Copyright © 2016年 JianZhang. All rights reserved.
//

#import "ViewController.h"
#import "CHRTableViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CHRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(CHRTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//  [cell.segmentedControl insertItem:@"A" atIndex:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  for (CHRTableViewCell *cell in self.tableView.visibleCells) {
    [cell.segmentedControl beginUpdate];
    CGFloat offset = scrollView.contentOffset.y / scrollView.contentSize.height;
    cell.segmentedControl.offset = offset;
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  for (CHRTableViewCell *cell in self.tableView.visibleCells) {
    if (!decelerate) {
      [cell.segmentedControl commit];
    }
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  for (CHRTableViewCell *cell in self.tableView.visibleCells) {
    [cell.segmentedControl commit];
  }
}

@end