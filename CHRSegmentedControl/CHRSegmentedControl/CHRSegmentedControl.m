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
if ((range).length > self.innerSelectedTitles.count) {\
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
  if (titles.count == 0 || [titles isEqual:[NSNull null]]) return;
  
  NSUInteger titleCount = titles.count;
  
  _innerTitles = [titles mutableCopy];
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
  _selectedIndex = 0;
  _titleLayers = [NSMutableArray arrayWithCapacity:titleCount];
  _seperatorLayers = [NSMutableArray arrayWithCapacity:titleCount - 1];
  
  /// 构造 title Layers 和 seperatorLayers
  [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    /// 构造 titleLayer
    CHRSegmentedLayer *titleLayer = [CHRSegmentedLayer layer];
    [_titleLayers addObject:titleLayer];
    
    /// 构造 seperator
    if (idx != titleCount - 2) {
      CALayer *seperatorLayer = [CALayer layer];
      [_seperatorLayers addObject:seperatorLayer];
    }
  }];
  
  /// 构造底部指示条
  _indicatorLayer = [CALayer layer];
  
  _selectGestureRecgnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
  [self addGestureRecognizer:_selectGestureRecgnizer];
  self.selectedIndex = 0;
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
    _innerTitleColors = [NSMutableArray arrayWithCapacity: titleCount];
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
    _innerSelectedTitleColors = [NSMutableArray arrayWithCapacity:titleCount];
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
    _innerTitleAttributes = [NSMutableArray arrayWithCapacity:titleCount];
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
    _innerSelectedTitleAttributes = [NSMutableArray arrayWithCapacity:titleCount];
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
    _innerTitleFonts = [NSMutableArray arrayWithCapacity:titleCount];
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
    _innerSelectedTitleFonts = [NSMutableArray arrayWithCapacity:titleCount];
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
    _innerItemBackgroundColors = [NSMutableArray arrayWithCapacity:titleCount];
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
    _innerSelectedBackgroundColors = [NSMutableArray arrayWithCapacity:titleCount];
    for (NSUInteger index = 0; index < titleCount; index++) {
      [_innerSelectedBackgroundColors addObject:self.selectedBackgroundColor];
    }
  }
  return _innerSelectedBackgroundColors;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
  _selectedIndex = selectedIndex;
  [self.titleLayers enumerateObjectsUsingBlock:^(CHRSegmentedLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [obj setSelected:idx == selectedIndex];
  }];
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
    self.innerTitleColors[index - range.location] = titleColor;
  }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置选中标题颜色失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerSelectedTitleColors[index - range.location] = selectedTitleColor;
  }
}

- (void)setTitleAttributes:(nullable NSDictionary *)attributes forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置标题属性失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerTitleAttributes[index - range.location] = attributes;
  }
}

- (void)setSelectedTitleAttributes:(nullable NSDictionary *)attributes forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置选中标题属性失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerSelectedTitleAttributes[index - range.location] = attributes;
  }
}

- (void)setTitleFont:(nullable UIFont *)titleFont forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置标题字体失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerTitleFonts[index - range.location] = titleFont;
  }
}

- (void)setSelectedTitleFont:(nullable UIFont *)selectedTitleFont forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置选中标题字体失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerSelectedTitleFonts[index - range.location] = selectedTitleFont;
  }
}

- (void)setItemBackgroundColor:(nullable UIColor *)itemBackgroundColor forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置背景颜色失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerItemBackgroundColors[index - range.location] = itemBackgroundColor;
  }
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor forRange:(NSRange)range
{
  CHRSegmentedControlRangeAssert(range, @"批量设置选中背景颜色失败， range 超出 titles 范围");
  
  for (NSUInteger index = range.location; index < range.location + range.length; index++) {
    self.innerSelectedBackgroundColors[index - range.location] = selectedBackgroundColor;
  }
}

- (CGSize)sizeThatFits:(CGSize)size
{
  if (self.itemWidthEqually) {
    __block CGFloat maxWidth = 0.0;
    __block CGFloat maxHeight = 0.0;
    
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    self.itemSize = CGSizeMake(maxWidth + self.itemSizeIncrease.width, maxHeight + self.itemSizeIncrease.height);
    return CGSizeMake((maxWidth + self.itemSizeIncrease.width) * self.titles.count, maxHeight + self.itemSizeIncrease.height);
  }
  
  __block CGFloat totalWidth = 0.0;
  __block CGFloat maxHeight = 0.0;
  [self.itemSizes removeAllObjects];
  [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj isKindOfClass:[NSString class]]) {
      NSString *string = obj;
      CGSize contentSize = [string boundingRectWithSize:size
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName : self.titleFont}
                                                context:nil].size;
      
      /// 存储根据 itemSizeIncreasing 计算过的 size
      CGSize realSize = CGSizeMake(contentSize.width + self.itemSizeIncrease.width, contentSize.height + self.itemSizeIncrease.height);
      totalWidth += contentSize.width + self.itemSizeIncrease.width;
      maxHeight = maxHeight > contentSize.height ? maxHeight : contentSize.height;
      [self.itemSizes addObject:NSStringFromCGSize(realSize)];
    } else {
      NSAttributedString *attributedString = obj;
      CGSize contentSize = [attributedString boundingRectWithSize:size
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                          context:nil].size;
      /// 存储根据 itemSizeIncreasing 计算过的 size
      CGSize realSize = CGSizeMake(contentSize.width + self.itemSizeIncrease.width, contentSize.height + self.itemSizeIncrease.height);
      totalWidth += contentSize.width + self.itemSizeIncrease.width;
      maxHeight = maxHeight > contentSize.height ? maxHeight : contentSize.height;
      [self.itemSizes addObject:NSStringFromCGSize(realSize)];
    }
  }];
  return CGSizeMake(totalWidth, maxHeight);
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [self p_reload];
}

#pragma mark - Gesture Actions
- (void)tap:(UITapGestureRecognizer *)gesture
{
  CGPoint tapPoint = [gesture locationInView:self];
  for (NSUInteger index = 0; index < self.titleLayers.count; index++) {
    CHRSegmentedLayer *layer = self.titleLayers[index];
    if (CGRectContainsPoint(layer.frame, tapPoint)) {
      
      if (self.selectedIndex == index && !self.isSelectRepeatable) return;
      
      self.selectedIndex = index;
      if (self.selectedCallback) {
        self.selectedCallback(self, index);
      }
      
      [self sendActionsForControlEvents:UIControlEventValueChanged];
      return;
    }
  }
}

#pragma mark - Private Methods
- (void)p_reload
{
  for (NSUInteger index = 0; index < self.titleLayers.count; index++) {
    CHRSegmentedLayer *layer = self.titleLayers[index];
    if (self.itemWidthEqually) {
      CGRect layerFrame = {index * self.itemSize.width, 0, self.itemSize};
      layer.frame = CGRectIntegral(layerFrame);
    } else {
      CGSize layerSize = CGSizeZero;
      CGFloat layerX = 0.0;
      for (NSUInteger jndex = 0; jndex <= index; jndex++) {
        CGSize storedSize = CGSizeFromString(self.itemSizes[jndex]);
        layerX += jndex > 0 ? CGSizeFromString(self.itemSizes[jndex - 1]).width : 0.0;
        if (jndex == index) {
          layerSize = storedSize;
        }
      }
      CGRect layerFrame = (CGRect) {layerX, 0, layerSize};
      layer.frame = CGRectIntegral(layerFrame);
    }
    [self.layer addSublayer:layer];
    /// 构造 titleLayer
    layer.title = self.titles[index];
    layer.selectedTitle = self.innerSelectedTitles[index];
    layer.titleColor = self.titleColor.CGColor;
    layer.selectedTitleColor = self.selectedTitleColor.CGColor;
    layer.normalBackgroundColor = self.itemBackgroundColor.CGColor;
    layer.selectedBackgroundColor = self.selectedBackgroundColor.CGColor;
    layer.font = (__bridge CFTypeRef _Nullable)(self.titleFont.fontName);
    layer.fontSize = self.titleFont.pointSize;
    layer.selectedFont = (__bridge CFTypeRef _Nullable)self.selectedTitleFont;
    layer.selectedFontSize = self.selectedTitleFont.pointSize;
    [layer setNeedsLayout];
  }
}

@end