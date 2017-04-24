//
//  SFJCircleLayout.h
//  SFJImageLabelDemo
//
//  Created by 沙缚柩 on 2017/4/23.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFJCircleLayout;

@protocol SFJCircleLayoutDelegate <NSObject>

@optional
/**
 * item的大小，如果不传将调用默认值 70 70
 */
- (CGSize)itemSizeInCircleLayout:(SFJCircleLayout *)circleLayout indexPath:(NSIndexPath *)indexPath;
/**
 * collectionView的内容大小，默认跟collectionView一样大
 */
- (CGSize)contentSizeInCircleLayout:(SFJCircleLayout *)circleLayout;

/**
 * 中心点 默认是content的中点
 */
- (CGPoint)centerInCircleLayout:(SFJCircleLayout *)circleLayout;
/**
 * * item中心点到布局中心的距离（半径）
 *  如果直径超过屏幕宽度，实现contentSizeInCircleLayout
 *  中心点需要根据该参数来计算。后续优化考虑自动适应居中。
 */
- (CGFloat)radiusInCircleLayout:(SFJCircleLayout *)circleLayout;


@end

@interface SFJCircleLayout : UICollectionViewLayout

@property (nonatomic, weak) id<SFJCircleLayoutDelegate> delegate;

@end

