//
//  SFJCircleLayout.m
//  SFJImageLabelDemo
//
//  Created by 沙缚柩 on 2017/4/23.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJCircleLayout.h"

#define kCircleLayoutDefaultItemSize CGSizeMake(70, 70)
#define kCircleLayoutDefaultRadius MIN(self.contentSize.width, self.contentSize.height) / 2.5

@interface SFJCircleLayout ()
{
    NSInteger itemCount_;
    CGPoint center_;
    CGFloat radius_;
    CGFloat contentWidth_;
//    CGSize itemSize_;
}

- (CGSize)contentSize;
- (CGPoint)center;
- (CGFloat)radius;

@end

@implementation SFJCircleLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    [self p_commontInit];
}

- (void)p_commontInit{
    itemCount_ = [self.collectionView numberOfItemsInSection:0];

    center_ = self.center;
    radius_ = self.radius;
    contentWidth_ = 0;
}

- (CGSize)collectionViewContentSize{
    return self.contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGSize size;
    if ([self.delegate respondsToSelector:@selector(itemSizeInCircleLayout:indexPath:)]) {
        size = [self.delegate itemSizeInCircleLayout:self indexPath:indexPath];
    }else{
        size = kCircleLayoutDefaultItemSize;
    }
    
    attributes.size = size;
    
    CGFloat x = center_.x + radius_ * cosf(2 * indexPath.item * M_PI / itemCount_);
    CGFloat y = center_.y + radius_ * sinf(2 * indexPath.item * M_PI / itemCount_);
    attributes.center = CGPointMake(x,y);
 
    CGFloat cWidth = 2 * radius_ + size.width;
    if (contentWidth_ < cWidth) {
        contentWidth_ = cWidth;
    }
    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < itemCount_; i++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    return attributes;
}

#pragma mark - getter

- (CGPoint)center{
    if ([self.delegate respondsToSelector:@selector(centerInCircleLayout:)]) {
        return [self.delegate centerInCircleLayout:self];
    }
    CGSize size = self.contentSize;
    return CGPointMake(size.width / 2.0, size.height / 2.0);
}

- (CGSize)contentSize{
    if ([self.delegate respondsToSelector:@selector(contentSizeInCircleLayout:)]) {
        return [self.delegate contentSizeInCircleLayout:self];
    }
    
    if((contentWidth_) > MIN(self.collectionView.frame.size.width,self.collectionView.frame.size.height)){
        return CGSizeMake(contentWidth_, self.collectionView.frame.size.height);
    }else{
        return self.collectionView.frame.size;
    }
}

- (CGFloat)radius{
    if ([self.delegate respondsToSelector:@selector(radiusInCircleLayout:)]) {
        return [self.delegate radiusInCircleLayout:self];
    }
    return kCircleLayoutDefaultRadius;
}
@end
