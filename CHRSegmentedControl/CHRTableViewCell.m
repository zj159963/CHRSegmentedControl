//
//  CHRTableViewCell.m
//  CHRSegmentedControl
//
//  Created by yicha on 16/4/27.
//  Copyright © 2016年 JianZhang. All rights reserved.
//

#import "CHRTableViewCell.h"

@interface CHRTableViewCell ()
@end

@implementation CHRTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    NSAttributedString *attributedStringA = [[NSAttributedString alloc] initWithString:@"A"];
    NSAttributedString *attributedStringB = [[NSAttributedString alloc] initWithString:@"B"];
    NSAttributedString *attributedStringC = [[NSAttributedString alloc] initWithString:@"C"];
    NSAttributedString *attributedStringD = [[NSAttributedString alloc] initWithString:@"D"];
    NSAttributedString *attributedStringE = [[NSAttributedString alloc] initWithString:@"E"];
    NSAttributedString *attributedStringF = [[NSAttributedString alloc] initWithString:@"F"];
    NSAttributedString *attributedStringG = [[NSAttributedString alloc] initWithString:@"G"];
    
    NSAttributedString *attributedString0 = [[NSAttributedString alloc] initWithString:@"0"];
    NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithString:@"1"];
    NSAttributedString *attributedString2 = [[NSAttributedString alloc] initWithString:@"2"];
    NSAttributedString *attributedString3 = [[NSAttributedString alloc] initWithString:@"3"];
    NSAttributedString *attributedString4 = [[NSAttributedString alloc] initWithString:@"4"];
    NSAttributedString *attributedString5 = [[NSAttributedString alloc] initWithString:@"5"];
    NSAttributedString *attributedString6 = [[NSAttributedString alloc] initWithString:@"6"];
    
    _segmentedControl = [[CHRSegmentedControl alloc] initWithTitles:@[attributedStringA,
                                                                      attributedStringB,
                                                                      attributedStringC,
                                                                      attributedStringD,
                                                                      attributedStringE,
                                                                      attributedStringF,
                                                                      attributedStringG]];
    [_segmentedControl setSelectedTitles:@[attributedString0,
                                           attributedString1,
                                           attributedString2,
                                           attributedString3,
                                           attributedString4,
                                           attributedString5,
                                           attributedString6,] forRange:NSMakeRange(0, 7)];
    
    [_segmentedControl setTitleAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17],
                                            NSForegroundColorAttributeName: [UIColor redColor]}
                                 forRange:NSMakeRange(0, 7)];
    
    [_segmentedControl setSelectedTitleAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:25],
                                                    NSForegroundColorAttributeName: [UIColor whiteColor]}
                                 forRange:NSMakeRange(0, 7)];
    
    _segmentedControl.titleFont = [UIFont systemFontOfSize:17];
    _segmentedControl.selectedTitleFont = [UIFont boldSystemFontOfSize:20];
    _segmentedControl.itemSizeIncrease = CGSizeMake(20, 10);
    _segmentedControl.itemBackgroundColor = [UIColor brownColor];
    _segmentedControl.selectedBackgroundColor = [UIColor grayColor];
    _segmentedControl.titleColor = [UIColor redColor];
    _segmentedControl.selectedTitleColor = [UIColor whiteColor];
    _segmentedControl.selectedCallback = ^(CHRSegmentedControl *segmentedControl, NSUInteger selectedIndex) {
      NSLog(@"%@, %lu", segmentedControl, selectedIndex);
    };
    [_segmentedControl sizeToFit];
    _segmentedControl.frame = CGRectIntegral((CGRect){10, 10, _segmentedControl.frame.size});
    [self.contentView addSubview:_segmentedControl];
  }
  return self;
}

@end