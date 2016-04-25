//
//  CHRSegmentedTitleLayer.m
//  CHRSegmentedControl
//
//  Created by yicha on 16/4/25.
//  Copyright © 2016年 JianZhang. All rights reserved.
//

#import "CHRSegmentedLayer.h"
#import <UIKit/UIKit.h>

@implementation CHRSegmentedLayer

#pragma mark - Convenience and Initializers
+ (instancetype)layer
{
  CHRSegmentedLayer *layer = [[self  alloc] init];
  return layer;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _titleLayer = [CATextLayer layer];
    _titleLayer.alignmentMode = kCAAlignmentCenter;
    _titleLayer.contentsScale = [UIScreen mainScreen].scale;
    [self addSublayer:_titleLayer];
  }
  return self;
}

#pragma mark - Setters and Getters
- (void)setTitleColor:(CGColorRef)titleColor
{
  _titleColor = titleColor;
  self.titleLayer.foregroundColor = titleColor;
}

- (void)setTitle:(id)title
{
  _title = [title copy];
  self.titleLayer.string = [title copy];
}

- (void)setSelected:(BOOL)selected
{
  _selected = selected;
  [self p_reload];
}

/// 布局子图层
- (void)layoutSublayers
{
  [super layoutSublayers];
  
  [self p_reload];
}

#pragma mark - Private Method
- (void)p_reload
{
  NSTimeInterval animationDuration = self.selected ? 1.0 : 0.0;
  CAMediaTimingFunction *timingFunction = self.selected ? [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut] : nil;
  
  [CATransaction begin];
  [CATransaction setAnimationDuration: animationDuration];
  [CATransaction setAnimationTimingFunction:timingFunction];
  self.titleLayer.foregroundColor = self.selected ? self.selectedTitleColor : self.titleColor;
  self.backgroundColor = self.selected ? self.selectedBackgroundColor : self.normalBackgroundColor;
  self.titleLayer.string = self.selected ? self.selectedTitle : self.title;
  self.titleLayer.font = self.selected ? self.selectedFont : self.font;
  self.titleLayer.fontSize = self.selected ? self.selectedFontSize : self.fontSize;
  [CATransaction commit];
  
  [CATransaction begin];
  [CATransaction setAnimationDuration: 0];
  self.titleLayer.frame = (CGRect){0, 0, self.titleLayer.preferredFrameSize};
  self.titleLayer.position = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
  [CATransaction commit];
}

@end