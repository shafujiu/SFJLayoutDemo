//
//  SFJSlopeLayout.h
//  SFJImageLabelDemo
//
//  Created by 沙缚柩 on 2017/4/19.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFJSlopeLayout;

@protocol SFJSlopeLayoutDelegate <NSObject>
// whRatioInSlopeLayout or 、、 任选一个
- (CGSize)itemSizeInSlopeLayout:(SFJSlopeLayout *)slopeLayout;

@optional
/** 宽高比 根据宽高比 屏幕大小 自动计算item大小 */
- (CGFloat)whRatioInSlopeLayout:(SFJSlopeLayout *)slopeLayout;
/** 行间距 */
- (CGFloat)rowMarginInSlopeLayout:(SFJSlopeLayout *)slopeLayout;
/** 列间距 */
- (CGFloat)columnMarginInSlopeLayout:(SFJSlopeLayout *)slopeLayout;
/** 列数，默认6 */
- (NSInteger)columnCountInSlopeLayout:(SFJSlopeLayout *)slopeLayout;
/** 内容边距 与contentInset 无关 只是单纯通过调整item的摆放预留的 */
- (UIEdgeInsets)edgeInsetsInSlopeLayout:(SFJSlopeLayout *)slopeLayout;

/**
 *  调整 排布
*/
/** 同一行 相邻两个item的Y差 */
- (CGFloat)rowGapYInSlopeLayout:(SFJSlopeLayout *)slopeLayout;
/** 同一行 相邻两个item的X差 */
- (CGFloat)rowGapXInSlopeLayout:(SFJSlopeLayout *)slopeLayout;
/** 同一列 相邻两个item的X差 */
- (CGFloat)columnGapXInSlopeLayout:(SFJSlopeLayout *)slopeLayout;

@end


@interface SFJSlopeLayout : UICollectionViewLayout

@property (nonatomic, weak) id<SFJSlopeLayoutDelegate> delegate;

@end
