//
//  CHRSegmentedTitleLayer.h
//  CHRSegmentedControl
//
//  Created by yicha on 16/4/25.
//  Copyright © 2016年 JianZhang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CHRSegmentedLayer : CALayer

/// 标题层
@property (nonatomic, readonly, strong, nonnull) CATextLayer *titleLayer;

/// 标题颜色
@property (nonatomic, readwrite, nullable) CGColorRef titleColor;

/// 选中标题颜色
@property (nonatomic, readwrite, nullable) CGColorRef selectedTitleColor;

/// 标题选中背景颜色
@property (nonatomic, readwrite, nullable) CGColorRef normalBackgroundColor;

/// 选中背景颜色
@property (nonatomic, readwrite, nullable) CGColorRef selectedBackgroundColor;

/// 可以是 CTFontRef, a CGFontRef, 或者是字体的名字. 默认为 Helvetica font
/// 只有 title 是 NSString 时有效
@property (nonatomic, readwrite, nullable) CFTypeRef font;

/// 标题字号
@property (nonatomic, readwrite, assign) CGFloat fontSize;

/// 选中字体
/// 可以是 CTFontRef, a CGFontRef, 或者是字体的名字. 默认为 Helvetica font
/// 只有 title 是 NSString 时有效
@property (nonatomic, readwrite, nullable) CFTypeRef selectedFont;

/// 选中字体字号
@property (nonatomic, readwrite, assign) CGFloat selectedFontSize;

/// 可以是 NSString 或者 NSAttributedString
@property (nonatomic, readwrite, copy, nullable) id title;

/// 可以是 NSString 或者 NSAttributedString
@property (nonatomic, readwrite, copy, nullable) id selectedTitle;

/// 设置选中或者非选中
@property (nonatomic, readwrite, getter=isSelected, assign) BOOL selected;

@end