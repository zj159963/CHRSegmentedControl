//
//  CHRSegmentedControl.h
//  CHRSegmentedControl
//
//  Created by JianZhang on 16/4/24.
//  Copyright © 2016年 JianZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHRSegmentedControl;

/// 选中 callback 声明
typedef void(^CHRSegmentedControlSelectedCallback)( CHRSegmentedControl * _Nonnull segmentedControl, NSUInteger selectedIndex);

@interface CHRSegmentedControl : UIControl

#pragma mark - Properties

/// 标题， 可以为 NSString 或者是 NSAttributedString
@property (nonatomic, readonly, copy, nullable) NSArray *titles;

/// 选中索引的标题， 默认为 titles， 若只想改变某一个索引的选中标题
/// 传入类型应该与 titles 相同
/// 使用 - setSelectedTitle:forIndex:
/// selectedTitles 应该与 titles 的个数一致
/// eg: titles 只有两个原色， 而selectedTitles 有三个元素
@property (nonatomic, readwrite, copy, nullable) NSArray *selectedTitles;

/// 所有索引的标题颜色， 默认为 [UIColor blueColor]
@property (nonatomic, readwrite, strong, nullable) UIColor *titleColor;

/// 选中索引的标题颜色， 默认为 [UIColor grayColor]
@property (nonatomic, readwrite, strong, nullable) UIColor *selectedTitleColor;

/// 所有索引的背景颜色， 默认为 [UIColor whiteColor]
/// 若要设置某一组索引的背景颜色，使用 - setItemBackgroundColor: forIndexSet:
@property (nonatomic, readwrite, strong, nullable) UIColor *itemBackgroundColor;

/// 所有索引的选中背景颜色， 默认为 [UIColor whiteColor]
/// 若要设置某一组索引的选中背景颜色，使用 - setSelectedBackgroundColor:forIndexSet:
@property (nonatomic, readwrite, strong, nullable) UIColor *selectedBackgroundColor;

/// 底部选中提示条颜色， 默认为 selectedTitleColor
@property (nonatomic, readwrite, strong, nullable) UIColor *indicatorColor;

/// 底部选中提示条占每个索引的宽度的百分比， 默认为 0.8
@property (nonatomic, readwrite, assign) CGFloat indicatorWidthFactor;

/// 底部选中指示条的高度， 默认为 1.0
@property (nonatomic, readwrite, assign) CGFloat indicatorHeight;

/// 索引之间的分割线颜色， 默认为蓝色
@property (nonatomic, readwrite, strong, nullable) UIColor *seperatorColor;

/// 分割线占整个 segmentedControl 的高度的百分比, 默认为 0.8
@property (nonatomic, readwrite, assign) CGFloat seperatorHeightFactor;

/// 分割线宽度， 默认为 1.0
@property (nonatomic, readwrite, assign) CGFloat seperatorWidth;

/// 所有索引是否等宽， 默认为 YES
@property (nonatomic, readwrite, assign) BOOL itemWidthEqually;

/// 选中的索引
@property (nonatomic, readwrite, assign) NSUInteger selectedIndex;

/// 是否可以重复选中
/// eg: 当前共有三个索引，选中了第三个索引
///     当用户再次选中第三个索引，是否会触发 selectedCallBack 或者 target 事件
@property (nonatomic, readwrite, getter=isSelectRepeatable, assign) BOOL selectRepeatable;

/// 选中索引的 callback
/// 推荐使用 callback， 而不是 - addTarget:action:forControlEvents:controlEvents
/// 使用 - addTarget:action:forControlEvents:controlEvents 依然可用
@property (nonatomic, copy, nullable) CHRSegmentedControlSelectedCallback selectedCallback;

#pragma mark - Initializers

- (nonnull instancetype)initWithTitles:(nullable NSArray *)titles;

/// 设置某个索引的选中标题， 索引不能超过 titles 的范围
/// eg: titles 只有两个元素， 而入参 Index 为 2
- (void)setSelectedTitle:(nullable NSString *)selectedTitle forIndex:(NSUInteger)index;

/// 设置某一组索引的标题颜色， 若入参 titleColor 为 nil
/// 则该组索引的标题颜色为 titleColor
/// indexSet 不能超出 titles 的范围
- (void)setTitleColor:(nullable UIColor *)titleColor forIndexSet:(nullable NSIndexSet *)indexSet;

/// 设置某一组索引标题的选中颜色， 若入参 selectedTitleColor 为 nil
/// 则该组索引标题的选中颜色为 selectedTitleColor
/// indexSet 不能超出 titles 范围
- (void)setSelectedTitleColor:(nullable UIColor *)selectedTitleColor forIndexSet:(nullable NSIndexSet *)indexSet;

/// 设置某一组索引标题的 attributes
/// indexSet 不能超出 titles 范围
- (void)setTitleAttributes:(nullable NSDictionary *)attributes forIndexSet:(nullable NSIndexSet *)indexSet;

/// 设置某一组索引的选中标题 attributes
//  indexSet 不能超出 titles 范围
- (void)setSelectedTitleAttributes:(nullable NSDictionary *)attributes forIndexSet:(nullable NSIndexSet *)indexSet;

/// 设置某一组索引的背景颜色， index 不能超出 titles 范围
- (void)setItemBackgroundColor:(nullable UIColor *)itemBackgroundColor forIndexSet:(nullable NSIndexSet *)indexSet;

/// 设置某一组索引的选中背景颜色， indexSet 不能超出 titles 范围
- (void)setSelectedBackgroundColor:(nullable UIColor *)selectedBackgroundColor forIndexSet:(nullable NSIndexSet *)indexSet;

/// 以动画或者非动画的方式，设置选中的索引
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

/// 标记更新开始
/// 开始之后，若没有提交（- commit），则设置 selectedIndex 方法均无效
- (void)beginUpdate;

/// 设置选中索引的偏移量
/// @param offset [0, 1]
/// 在调用这个方法之前， 总是应该使用 - beginUpdate， 并在结束的时候调用 - commit
/// 用于基于 scrollView 偏移量等类似的情况更改索引，在提交（- commit）之后，会自动选择距离最近的一个索引
/// 若调用此方法前没有调用 - beginUpdate 或者已经调用了提交方法（- commit）后，则此方法无效
/// eg: 一个 scrollView 的 contentSize 为 [100.0, 0.0]
///     要使 segmentedControl 根据 scrollView 的偏移量变化而变化，应该滚动的时候：
///     1.先调用 - beginUpdate
///     2.调用 - setOffset: fabs(scrollView.contentOffset.x)
///     3.提交， 在 scrollView scrollViewDidEndDecelerating 时， 调用 -commit
- (void)setOffset:(CGFloat)offset;

/// 提交更新， 标记更新结束
- (void)commit;

@end