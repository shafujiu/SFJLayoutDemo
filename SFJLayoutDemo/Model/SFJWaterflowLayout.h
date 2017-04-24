//
//  SFJWaterflowLayout.h
//  WaterFlow
//
//  Created by ZhaoWei on 16/3/27.
//  Copyright © 2016年 ZhaoWei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFJWaterflowLayout;
@protocol SFJWaterflowLayoutDelegate <NSObject>

@required
- (CGFloat)waterflowLayout:(SFJWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
//设置列数
- (NSInteger)columnCountInWaterflowLayout:(SFJWaterflowLayout *)waterflowLayout;
//设置列间距
- (CGFloat)columnMarginInWaterflowLayout:(SFJWaterflowLayout *)waterflowLayout;
//设置行间距
- (CGFloat)rowMarginInWaterflowLayout:(SFJWaterflowLayout *)waterflowLayout;
//设置边距
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(SFJWaterflowLayout *)waterflowLayout;

@end

@interface SFJWaterflowLayout : UICollectionViewFlowLayout

/** 代理 */
@property (nonatomic, weak) id<SFJWaterflowLayoutDelegate>delegate;

@end
