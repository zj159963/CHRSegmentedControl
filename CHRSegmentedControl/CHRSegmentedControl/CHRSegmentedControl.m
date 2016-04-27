//
//  CHRSegmentedControl.m
//  CHRSegmentedControl
//
//  Created by JianZhang on 16/4/24.
//  Copyright © 2016年 JianZhang. All rights reserved.
//

#import "CHRSegmentedControl.h"
#import "CHRSegmentedLayer.h"

#define CHRSegmentedControlRangeAssert(range, description) \
if ((range).length + (range).location > self.innerSelectedTitles.count) {\
NSString *assertInfo = [NSString stringWithFormat:@"%s at line: %d\n %@", __PRETTY_FUNCTION__, __LINE__, (description)];\
NSAssert(NO, assertInfo);\
};

#define CHRSegmentedControlArrayAssert(array, description)\
if ((array).count > self.innerSelectedTitles.count) {\
NSString *assertInfo = [NSString stringWithFormat:@"%s at line: %d\n %@", __PRETTY_FUNCTION__, __LINE__, (description)];\
NSAssert(NO, assertInfo);\
};

#define CHRSegmentedControlArrayRangeAssert(array, range, description) \
if (range.length != selectedTitles.count) {\
NSString *assertInfo = [NSString stringWithFormat:@"%s at line: %d\n %@", __PRETTY_FUNCTION__, __LINE__, (description)];\
NSAssert(NO, assertInfo);\
};

#define CHRSegmentedControlArrayRangeArgumentAssert(array, range, description) \
if (array) {\
CHRSegmentedControlArrayRangeAssert(array, range, description)\
CHRSegmentedControlRangeAssert(range, description)\
CHRSegmentedControlArrayAssert(array, description)\
} else {\
CHRSegmentedControlRangeAssert(range, description) \
};\


@interface CHRSegmentedControl ()

@property (nonatomic, readwrite, strong) NSMutableArray *innerTitles;
@property (nonatomic, readwrite, strong) NSMutableArray *innerSelectedTitles;
@property (nonatomic, readwrite, strong) NSMutableArray <CHRSegmentedLayer *> *titleLayers;
@property (nonatomic, readwrite, strong) NSMutableArray <CALayer *> *seperatorLayers;
@property (nonatomic, readwrite, strong) NSMutableArray <UIColor *> *innerTitleColors;
@property (nonatomic, readwrite, strong) NSMutableArray <UIColor *> *innerSelectedTitleColors;
@property (nonatomic, readwrite, strong) NSMutableArray <NSDictionary *> *innerTitleAttributes;
@property (nonatomic, readwrite, strong) NSMutableArray <NSDictionary *> *innerSelectedTitleAttributes;
@property (nonatomic, readwrite, strong) NSMutableArray <UIFont *> *innerTitleFonts;
@property (nonatomic, readwrite, strong) NSMutableArray <UIFont *> *innerSelectedTitleFonts;
@property (nonatomic, readwrite, strong) NSMutableArray <UIColor *> *innerItemBackgroundColors;
@property (nonatomic, readwrite, strong) NSMutableArray <UIColor *> *innerSelectedBackgroundColors;
@property (nonatomic, readwrite, assign) CGSize itemSize;
@property (nonatomic, readwrite, strong) NSMutableArray <NSString *> *itemSizes;
@property (nonatomic, readwrite, strong, nonnull) UIGestureRecognizer *selectGestureRecgnizer;
@property (nonatomic, readwrite, strong) CALayer *indicatorLayer;

@end

@implementation CHRSegmentedControl

@dynamic titles;
@dynamic selectedTitles;

#pragma mark - Initializers
- (instancetype)initWithTitles:(NSArray *)titles
{
  self = [super init];
  if (self) {
    [self p_initializeWithTitles:titles];
  }
  return self;
}

#pragma mark - 初始化设置
- (void)p_initializeWithTitles:(NSArray *)titles
{
  self.clipsToBounds = YES;
  _innerTitles = titles == nil ? [NSMutableArray array] : [titles mutableCopy];
  _innerSelectedTitles = [_innerTitles mutableCopy];
  _titleColor = [UIColor blueColor];
  _selectedTitleColor = [UIColor whiteColor];
  _titleFont = [UIFont systemFontOfSize:16.0];
  _selectedTitleFont = [UIFont boldSystemFontOfSize:16.0];
  _itemBackgroundColor = _selectedTitleColor;
  _selectedBackgroundColor = _titleColor;
  _indicatorColor = _titleColor;
  _indicatorWidthFactor = 0.8;
  _indicatorHeight = 1.0;
  _seperatorColor = _titleColor;
  _seperatorHeightFactor = 0.8;
  _seperatorWidth = 1.0;
  _itemWidthEqually = YES;
  _itemSize = CGSizeZero;
  _itemSizeIncrease = CGSizeMake(8.0, 8.0);
  _titleLayers = [NSMutableArray array];
  _seperatorLayers = [NSMutableArray array];
  _selectedIndex = 0;
  
  /// 构造 title Layers 和 seperatorLayers
  [_innerTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    /// 构造 titleLayer
    CHRSegmentedLayer *titleLayer = [CHRSegmentedLayer layer];
    [_titleLayers addObject:titleLayer];
    /// 构造 seperator
    if (idx > 0) {
      CALayer *seperatorLayer = [CALayer layer];
      [_seperatorLayers addObject:seperatorLayer];
    }
  }];
  
  /// 构造底部指示条
  _indicatorLayer = [CALayer layer];
  
  /// 点击选中手势
  _selectGestureRecgnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tap:)];
  [self addGestureRecognizer:_selectGestureRecgnizer];
}

#pragma mark - Getters and Setters
- (NSArray *)titles
{
  return [self.innerTitles copy];
}

- (NSArray *)selectedTitles
{
  return [self.innerSelectedTitles copy];
}

- (NSMutableArray *)innerTitleColors
{
  if (!_innerTitleColors) {
    NSUInteger titleCount = self.innerTitles.count;
    _innerTitleColors = [NSMutableArray array];
    for (NSUInteger index = 0; index < titleCount; index++) {
      [_innerTitleColors addObject:self.titleColor];
    }
  }
  return _innerTitleColors;
}

- (NSMutableArray<UIColor *> *)innerSelectedTitleColors
{
  if (!_innerSelectedTitleColors) {
    NSUInteger titleCount = self.innerTitles.count;
    _innerSelectedTitleColors = [NSMutableArray array];
    for (NSUInteger index = 0; index < titleCount; index++) {
      [_innerSelectedTitleColors addObject:self.selectedTitleColor];
    }
  }
  return _innerSelectedTitleColors;
}

- (NSMutableArray<NSDictionary *> *)innerTitleAttributes
{
  if (!_innerTitleAttributes) {
    NSUInteger titleCount = self.innerTitles.count;
    _innerTitleAttributes = [NSMutableArray array];
    for (NSUInteger index = 0; index < titleCount; index++) {
      [_innerTitleAttributes addObject:@{}];
    }
  }
  return _innerTitleAttributes;
}

- (NSMutableArray<NSDictionary *> *)innerSelectedTitleAttributes
{
  if (!_innerSelectedTitleAttributes) {
    NSUInteger titleCount = self.innerTitles.count;
    _innerSelectedTitleAttributes = [NSMutableArray array];
    for (NSUInteger index = 0; index < titleCount; index++) {
      [_innerSelectedTitleAttributes addObject:@{}];
    }
  }
  return _innerSelectedTitleAttributes;
}

- (NSMutableArray<UIFont *> *)innerTitleFonts
{
  if (!_innerTitleFonts) {
    NSUInteger titleCount = self.innerTitles.count;
    _innerTitleFonts = [NSMutableArray array];
    for (NSUInteger index = 0; index < titleCount; index++) {
      [_innerTitleFonts addObject:self.titleFont];
    }
  }
  return _innerTitleFonts;
}

- (NSMutableArray<UIFont *> *)innerSelectedTitleFonts
{
  if (!_innerSelectedTitleFonts) {
    NSUInteger titleCount = self.innerTitles.count;
    _innerSelectedTitleFonts = [NSMutableArray array];
    for (NSUInteger index = 0; index < titleCount; index++) {
      [_innerSelectedTitleFonts addObject:self.selectedTitleFont];
    }
  }
  return _innerTitleFonts;
}

- (NSMutableArray<UIColor *> *)innerItemBackgroundColors
{
  if (!_innerItemBackgroundColors) {
    NSUInteger titleCount = self.innerTitles.count;
    _innerItemBackgroundColors = [NSMutableArray array];
    for (NSUInteger index = 0; index < titleCount; index++) {
      [_innerItemBackgroundColors addObject:self.itemBackgroundColor];
    }
  }
  return _innerItemBackgroundColors;
}

- (NSMutableArray<UIColor *> *)innerSelectedBackgroundColors
{
  if (!_innerSelectedBackgroundColors) {
    NSUInteger titleCount = self.innerTitles.count;
    _innerSelectedBackgroundColors = [NSMutableArray array];
    for (NSUInteger index = 0; index < titleCount; index++) {
      [_innerSelectedBackgroundColors addObject:self.selectedBackgroundColor];
    }
  }
  return _innerSelectedBackgroundColors;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
  [self setNeedsLayout];
  if (_selectedIndex == selectedIndex) {
    if (self.selectRepeatable) {
      if (self.selectedCallback) {
        self.selectedCallback(self, selectedIndex);
      }
    }
    return;
  }
  if (self.selectedCallback) {
    self.selectedCallback(self, selectedIndex);
  }
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  _selectedIndex = selectedIndex;
}

- (NSMutableArray<NSString *> *)itemSizes
{
  if (!_itemSizes) {
    _itemSizes = [NSMutableArray array];
  }
  return _itemSizes;
}

- (void)setItemWidthEqually:(BOOL)itemWidthEqually
{
  _itemWidthEqually = itemWidthEqually;
  
}

#pragma mark - Instance Method
- (void)setSelectedTitles:(NSArray *)selectedTitles forRange:(NSRange)range
{
  CHRSegmentedControlArrayRangeArgumentAssert(selectedTitles, range, @"选中标题 || range 不匹配");
  
  if (selectedTitles.count == 0) return;
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerSelectedTitles[index] = selectedTitles[index - range.location];
  }
}

- (void)setTitleColor:(UIColor *)titleColor forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置标题颜色失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerTitleColors[index] = titleColor;
  }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置选中标题颜色失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerSelectedTitleColors[index] = selectedTitleColor;
  }
}

- (void)setTitleAttributes:(nullable NSDictionary *)attributes forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置标题属性失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerTitleAttributes[index] = attributes;
  }
}

- (void)setSelectedTitleAttributes:(nullable NSDictionary *)attributes forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置选中标题属性失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerSelectedTitleAttributes[index] = attributes;
  }
}

- (void)setTitleFont:(nullable UIFont *)titleFont forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置标题字体失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerTitleFonts[index] = titleFont;
  }
}

- (void)setSelectedTitleFont:(nullable UIFont *)selectedTitleFont forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置选中标题字体失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerSelectedTitleFonts[index] = selectedTitleFont;
  }
}

- (void)setItemBackgroundColor:(nullable UIColor *)itemBackgroundColor forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置背景颜色失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerItemBackgroundColors[index] = itemBackgroundColor;
  }
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置选中背景颜色失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerSelectedBackgroundColors[index] = selectedBackgroundColor;
  }
}

- (void)insertItem:(id)title atIndex:(NSUInteger)index
{
  [self.innerTitles addObject:[title copy]];
  [self.innerSelectedTitles addObject:[title copy]];
  CHRSegmentedLayer *layer = [CHRSegmentedLayer layer];
  [self.titleLayers insertObject:layer atIndex:index];
  CALayer *seperatorLayer = [CALayer layer];
  [self.seperatorLayers addObject:seperatorLayer];
  [self sizeToFit];
}

- (void)deleteItemAtIndex:(NSUInteger)index
{
  if (self.innerTitles.count == 0 || index > self.innerTitles.count - 1) return;
  
  /// 删除多余的分割线
  if (index == self.innerTitles.count - 1) {
    [self.seperatorLayers.lastObject removeFromSuperlayer];
    [self.seperatorLayers removeLastObject];
  } else if (index == 0) {
    [self.seperatorLayers.firstObject removeFromSuperlayer];
    [self.seperatorLayers removeObjectAtIndex:0];
  } else if (self.seperatorLayers.count > 0) {
    [self.seperatorLayers[index] removeFromSuperlayer];
    [self.seperatorLayers removeObjectAtIndex:index];
  }
  
  /// 删除标题和 标题层
  [self.innerTitles removeObjectAtIndex:index];
  [self.innerSelectedTitles removeObjectAtIndex:index];
  [self.titleLayers[index] removeFromSuperlayer];
  [self.titleLayers removeObjectAtIndex:index];
  
  /// 处理删除后的选中索引
  if (index < self.selectedIndex) {
    self.selectedIndex = self.selectedIndex - 1;
  } else if (index == self.selectedIndex) {
    self.selectedIndex = index == 0 ? 0 : index - 1;
  }
  
  /// 更新大小
  [self sizeToFit];
}

- (void)beginUpdate
{
  self.userInteractionEnabled = NO;
}

- (void)commit
{
  self.userInteractionEnabled = YES;
  CGFloat minimumOffset = CGFLOAT_MAX;
  NSUInteger selectedIndexForUpdating = 0;
  for (CHRSegmentedLayer *titleLayer in self.titleLayers) {
    CGFloat offset = fabs(CGRectGetMidX(self.indicatorLayer.frame) - CGRectGetMidX(titleLayer.frame));
    if (offset < minimumOffset) {
      minimumOffset = offset;
      selectedIndexForUpdating = [self.titleLayers indexOfObject:titleLayer];
    }
  }
  
  self.selectedIndex = selectedIndexForUpdating;
  
  
}

- (void)setOffset:(CGFloat)offset
{
  _offset = offset;
  [CATransaction begin];
  [CATransaction setAnimationDuration:0.0];
  self.indicatorLayer.position = CGPointMake((self.bounds.size.width - self.indicatorLayer.bounds.size.width)* offset + self.indicatorLayer.bounds.size.width / 2.0,
                                             self.indicatorLayer.position.y);
  [CATransaction commit];
}

#pragma mark - Override
- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [self p_reload];
}

- (CGSize)sizeThatFits:(CGSize)size
{
  if (self.innerTitles.count == 0) return CGSizeZero;
  
  if (self.itemWidthEqually) {
    __block CGFloat maxWidth = 0.0;
    __block CGFloat maxHeight = 0.0;
    
    [self.innerTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([obj isKindOfClass:[NSString class]]) {
        NSString *string = obj;
        CGSize contentSize = [string boundingRectWithSize:size
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName : self.titleFont}
                                                  context:nil].size;
        maxWidth = maxWidth > contentSize.width ? maxWidth : contentSize.width;
        maxHeight = maxHeight > contentSize.height ? maxHeight : contentSize.height;
      } else {
        NSAttributedString *attributedString = obj;
        CGSize contentSize = [attributedString boundingRectWithSize:size
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                            context:nil].size;
        maxWidth = maxWidth > contentSize.width ? maxWidth : contentSize.width;
        maxHeight = maxHeight > contentSize.height ? maxHeight : contentSize.height;
      }
    }];
    self.itemSize = CGSizeMake(maxWidth + self.itemSizeIncrease.width,
                               maxHeight + self.itemSizeIncrease.height);
    return CGSizeMake(self.itemSize.width * self.innerTitles.count + (self.innerTitles.count - 1) * self.seperatorWidth,
                      self.itemSize.height);
  }
  
  [self.itemSizes removeAllObjects];
  __block CGFloat totalWidth = 0.0;
  __block CGFloat maxHeight = 0.0;
  [self.itemSizes removeAllObjects];
  [self.innerTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj isKindOfClass:[NSString class]]) {
      NSString *string = obj;
      CGSize contentSize = [string boundingRectWithSize:size
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName : self.titleFont}
                                                context:nil].size;
      
      /// 存储根据 itemSizeIncreasing 计算过的 size
      CGSize realSize = CGSizeMake(contentSize.width + self.itemSizeIncrease.width,
                                   contentSize.height + self.itemSizeIncrease.height);
      totalWidth += realSize.width;
      maxHeight = maxHeight > contentSize.height ? maxHeight : contentSize.height;
      [self.itemSizes addObject:NSStringFromCGSize(realSize)];
    } else {
      NSAttributedString *attributedString = obj;
      CGSize contentSize = [attributedString boundingRectWithSize:size
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                          context:nil].size;
      /// 存储根据 itemSizeIncreasing 计算过的 size
      CGSize realSize = CGSizeMake(contentSize.width + self.itemSizeIncrease.width,
                                   contentSize.height + self.itemSizeIncrease.height);
      totalWidth += realSize.width;
      maxHeight = maxHeight > contentSize.height ? maxHeight : contentSize.height;
      [self.itemSizes addObject:NSStringFromCGSize(realSize)];
    }
  }];
  return CGSizeMake(totalWidth + (self.innerTitles.count - 1) * self.seperatorWidth, maxHeight);
}

#pragma mark - UserInterface Actions
- (void)p_tap:(UITapGestureRecognizer *)gestureRecognizer
{
  CGPoint tapPoint = [gestureRecognizer locationInView:self];
  for (NSUInteger index = 0; index < self.titleLayers.count; index++) {
    CHRSegmentedLayer *layer = self.titleLayers[index];
    if (CGRectContainsPoint(layer.frame, tapPoint)) {
      self.selectedIndex = index;
      return;
    }
  }
}

#pragma mark - Private Methods
- (void)p_reload
{ 
  if (self.innerTitles.count == 0) {
    [self.indicatorLayer removeFromSuperlayer];
  }
  
  /// 为了计算底部指示条
  CGFloat selectedTitleLayerFrameOriginX= 0.0;
  CGSize selectedTitleLayerSize = CGSizeZero;
  
  for (NSUInteger index = 0; index < self.titleLayers.count; index++) {
    
    /// 配置 标题层
    CHRSegmentedLayer *titleLayer = self.titleLayers[index];
    [titleLayer removeFromSuperlayer];
    
    CGFloat titleLayerFrameOriginX = 0.0;
    CGRect titleLayerFrame = CGRectZero;
    CGSize titleLayerSize = CGSizeZero;
    if (self.itemWidthEqually) {
      titleLayerFrameOriginX = index * (self.itemSize.width + self.seperatorWidth);
      titleLayerSize = self.itemSize;
      titleLayerFrame= (CGRect){titleLayerFrameOriginX, 0, titleLayerSize};
    } else {
      for (NSUInteger jndex = 0; jndex <= index; jndex++) {
        CGSize storedSize = CGSizeFromString(self.itemSizes[jndex]);
        titleLayerFrameOriginX += jndex > 0 ? CGSizeFromString(self.itemSizes[jndex - 1]).width : 0.0;
        if (jndex == index) {
          titleLayerSize = storedSize;
        }
      }
      if (index > 0) {
        titleLayerFrameOriginX += self.seperatorWidth;
      }
      titleLayerFrame = (CGRect) {titleLayerFrameOriginX + self.seperatorWidth, 0, titleLayerSize};
    }
    titleLayer.frame = CGRectIntegral(titleLayerFrame);
    
    titleLayer.title = self.innerTitles[index];
    titleLayer.selectedTitle = self.innerSelectedTitles[index];
    titleLayer.titleColor = self.innerTitleColors[index].CGColor;
    titleLayer.selectedTitleColor = self.innerSelectedTitleColors[index].CGColor;
    titleLayer.normalBackgroundColor = self.innerItemBackgroundColors[index].CGColor;
    titleLayer.selectedBackgroundColor = self.innerSelectedBackgroundColors[index].CGColor;
    titleLayer.font = (__bridge CFTypeRef _Nullable)(self.innerTitleFonts[index].fontName);
    titleLayer.fontSize = self.innerTitleFonts[index].pointSize;
    titleLayer.selectedFont = (__bridge CFTypeRef _Nullable)self.innerSelectedTitleFonts[index];
    titleLayer.selectedFontSize = self.innerSelectedTitleFonts[index].pointSize;
    [titleLayer setNeedsLayout];
    [self.layer addSublayer:titleLayer];
    
    /// 配置分割线层
    if (index > 0) {
      CALayer *seperatorLayer = self.seperatorLayers[index - 1];
      [seperatorLayer removeFromSuperlayer];
      
      seperatorLayer.backgroundColor = self.seperatorColor.CGColor;
      CHRSegmentedLayer *previousLayer = self.titleLayers[index - 1];
      CGFloat seperatorLayerFrameOriginX = CGRectGetMaxX(previousLayer.frame);
      CGFloat seperatorLayerHeight = self.bounds.size.height * self.seperatorHeightFactor;
      CGFloat seperatorLayerFrameOriginY = (self.bounds.size.height - seperatorLayerHeight) / 2.0;
      CGRect seperatorLayerFrame = (CGRect){seperatorLayerFrameOriginX, seperatorLayerFrameOriginY, self.seperatorWidth, seperatorLayerHeight};
      seperatorLayer.frame = CGRectIntegral(seperatorLayerFrame);
      [self.layer addSublayer:seperatorLayer];
    }
    
    if (index == self.selectedIndex) {
      selectedTitleLayerFrameOriginX = titleLayerFrameOriginX;
      selectedTitleLayerSize = titleLayerSize;
    }
  }
  
  /// 配置 底部指示条
  self.indicatorLayer.backgroundColor = self.indicatorColor.CGColor;
  CGFloat indicatorLayerFrameOriginX = selectedTitleLayerFrameOriginX + selectedTitleLayerSize.width * (1.0 - self.indicatorWidthFactor) / 2.0;
  CGFloat indicatorLayerWidth = selectedTitleLayerSize.width * self.indicatorWidthFactor;
  CGFloat indicatorLayerFrameOriginY = self.bounds.size.height - self.indicatorHeight;
  self.indicatorLayer.frame = (CGRect){indicatorLayerFrameOriginX, indicatorLayerFrameOriginY, indicatorLayerWidth, self.indicatorHeight};
  [self.layer addSublayer:self.indicatorLayer];
  
  /// 更新选中图层和底部指示条
  [self.titleLayers enumerateObjectsUsingBlock:^(CHRSegmentedLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [obj setSelected:idx == self.selectedIndex];
  }];
}

@end