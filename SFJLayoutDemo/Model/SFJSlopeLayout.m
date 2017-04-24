//
//  SFJSlopeLayout.m
//  SFJImageLabelDemo
//
//  Created by 沙缚柩 on 2017/4/19.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJSlopeLayout.h"
#import "SFJDectationView.h"

static CGFloat const SFJDefaultColumnMargin = -25;
static CGFloat const SFJDefaultRowMargin = -10;
static NSInteger const SFJDefaultColumnCount = 6;

static CGFloat const SFJDefaultRowGapY = 20;
static CGFloat const SFJDefaultRowGapX = 60;
static CGFloat const SFJDefaultColumnGapX = 40;
static CGFloat const SFJDefaultWHRatio = 114 / 130.0;

static NSString *const SFJDectationViewID = @"SFJDectationViewID";

@interface SFJSlopeLayout ()

@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat contentWidth;

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
//- (NSInteger)rowCount;
- (UIEdgeInsets)edgeInsets;

/** 同一行 相邻两个item的Y差 */
- (CGFloat)rowGapY;
/** 同一行 相邻两个item的X差 */
- (CGFloat)rowGapX;
/** 同一列 相邻两个item的X差 */
- (CGFloat)columnGapX;

/** 宽高比 */
- (CGFloat)whRatio;
/** itemSize */
- (CGSize)itemSize;
@end

@implementation SFJSlopeLayout
{
    NSInteger rowCount_; // 列数
    NSInteger itemCount_; // item数
    CGPoint startPoint_; // 第一个item的位置
    
    CGSize itemSize_;
    CGFloat rowWidth_;
    CGFloat columnHeight_;
    
    CGFloat collectionViewW_;
    CGFloat collectionViewH_;
}
/**
 * 初始化 每次刷新界面都会调用
 */
- (void)prepareLayout{
    [super prepareLayout];
    
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([SFJDectationView class]) bundle:nil] forDecorationViewOfKind:SFJDectationViewID];
    
    [self p_commonInit];
}

- (void)p_commonInit{
    
//    self.contentHeight = 0;
//    self.contentWidth = 0;
    
    collectionViewW_ = self.collectionView.frame.size.width;
    collectionViewH_ = self.collectionView.frame.size.height;
    
    itemCount_ = [self.collectionView numberOfItemsInSection:0];
    CGFloat temp = itemCount_ * 1.0 / self.columnCount ;
    rowCount_ = ceil(temp);
    
    itemSize_ = [self itemSize];
    rowWidth_ = [self p_rowWidth];
    columnHeight_ = [self p_columnHeight];
    
    startPoint_ = [self p_caculateStartPoint];
}
/**
 *  @brief 决定背景 以及cell的排布的数组
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < itemCount_; i ++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [arr addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    // 背景装饰 插入到第一个
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [arr insertObject:[self layoutAttributesForDecorationViewOfKind:SFJDectationViewID atIndexPath:indexPath] atIndex:0];
    
    return arr;
}
/**
 * 返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attrs.frame = [self p_attrsFrameWithIndex:indexPath.row];
    return attrs;
}
/**
 *  决定装饰视图的排布
*/
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:SFJDectationViewID withIndexPath:indexPath];
    att.frame = CGRectMake(0, 0, self.contentWidth, self.contentHeight);
    att.zIndex = -1;
    return att;
}
/**
 *  计算每个cell的frame
*/
- (CGRect)p_attrsFrameWithIndex:(NSInteger)index{
    
    CGFloat itemW = itemSize_.width;
    CGFloat itemH = itemSize_.height;
    
    NSInteger row = index / self.columnCount;
    NSInteger column = index % self.columnCount;
    
    CGFloat rowGapY = [self rowGapY]; // y差
    CGFloat rowGapX = [self rowGapX]; // x差
    CGFloat columnGapX = [self columnGapX];
    
    CGPoint startPoint = startPoint_;
    
    CGFloat itemX = (startPoint.x + rowGapX * column) - columnGapX * row;
    CGFloat itemY = startPoint.y + ((itemH + self.rowMargin) * row) + rowGapY * column;
    
//    [self p_updateContentHeight];
//    [self p_updateContentWidth];
    
    return CGRectMake(itemX, itemY, itemW, itemH);
}

- (CGPoint)p_caculateStartPoint{
    
    CGFloat y = (self.collectionView.frame.size.height - columnHeight_) *.5;
    if (columnHeight_ > self.collectionView.frame.size.height ) {
        y = self.edgeInsets.top;
    }
    CGFloat x = (self.collectionView.frame.size.width - rowWidth_) * .5;
    if (rowWidth_ > self.collectionView.frame.size.width) {
        x = self.edgeInsets.left + (rowCount_ - 1) * [self columnGapX];
    }
    CGPoint startPoint = CGPointMake(x, y);
    return startPoint;
}

// 更新获取内容高度
//- (void)p_updateContentHeight{
//    
//    if (self.contentHeight < columnHeight_) {
//        self.contentHeight = columnHeight_;
//    }
//    if (self.contentHeight < collectionViewH_) {
//        self.contentHeight = collectionViewH_;
//    }
//}

- (CGFloat)p_columnHeight{
    CGFloat rowGapY = [self rowGapY]; // y差
    CGPoint endPoint = CGPointMake(0, rowCount_ * itemSize_.height + self.rowMargin * (rowCount_ - 1));
    
    CGFloat columnHeight = endPoint.y + rowGapY * (self.columnCount - 1) + self.edgeInsets.top + self.edgeInsets.bottom;
    return columnHeight;
}

//- (void)p_updateContentWidth{
//    if (self.contentWidth < rowWidth_) {
//        self.contentWidth = rowWidth_;
//    }
//    if (self.contentWidth < collectionViewW_) {
//        self.contentWidth = collectionViewW_;
//    }
//}

- (CGFloat)p_rowWidth{
    
    CGFloat columnGapX = [self columnGapX];
    CGFloat rowGapX = [self rowGapX];
    CGPoint startPoint = CGPointMake((rowCount_ - 1) * columnGapX, 0);
    CGFloat width = startPoint.x + rowGapX * self.columnCount + (itemSize_.width - rowGapX)  + self.edgeInsets.left + self.edgeInsets.right;
    if (itemCount_ < self.columnCount) {
        width = startPoint.x + itemSize_.width * itemCount_ + ((itemCount_ - 1) * self.columnMargin) + self.edgeInsets.left + self.edgeInsets.right;
    }
    return width;
}

//- (CGFloat)p_itemWidth{
//    if ([self.delegate respondsToSelector:@selector(itemSizeInSlopeLayout:)]) {
//        return [self.delegate itemSizeInSlopeLayout:self].width;
//    }
//    
//    CGFloat itemW = (collectionViewW_ - self.columnMargin * (self.columnCount - 1)) / self.columnCount;
//    return itemW;
//}
//
//- (CGFloat)p_itemHeight{
//    if ([self.delegate respondsToSelector:@selector(itemSizeInSlopeLayout:)]) {
//        return [self.delegate itemSizeInSlopeLayout:self].height;
//    }
//    CGFloat ratio = 1.0 / [self whRatio];        // 高 宽比
//    CGFloat itemH = [self p_itemWidth] * (ratio);
//    return itemH;
//}
/**
 *  决定 contentSize
 */
- (CGSize)collectionViewContentSize{
    
    CGFloat width = self.contentWidth;
    CGFloat height = self.contentHeight;
    return CGSizeMake(width, height);
}

#pragma mark -  getter
- (CGFloat)columnMargin{
    
    if ([self.delegate respondsToSelector:@selector(columnMarginInSlopeLayout:)]) {
        return [self.delegate columnMarginInSlopeLayout:self];
    }
    return SFJDefaultColumnMargin;
}

- (NSInteger)columnCount{
    if ([self.delegate respondsToSelector:@selector(columnCountInSlopeLayout:)]) {
        return [self.delegate columnCountInSlopeLayout:self];
    }
    return SFJDefaultColumnCount;
}

- (CGFloat)rowMargin{
    if ([self.delegate respondsToSelector:@selector(rowMarginInSlopeLayout:)]) {
        return [self.delegate rowMarginInSlopeLayout:self];
    }
    return SFJDefaultRowMargin;
}

- (UIEdgeInsets)edgeInsets{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInSlopeLayout:)]) {
        return [self.delegate edgeInsetsInSlopeLayout:self];
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/** 同一行 相邻两个item的Y差 */
- (CGFloat)rowGapY{
    if ([self.delegate respondsToSelector:@selector(rowGapYInSlopeLayout:)]) {
        return [self.delegate rowGapYInSlopeLayout:self];
    }
    return SFJDefaultRowGapY;
}
/** 同一行 相邻两个item的X差 */
- (CGFloat)rowGapX{
    if ([self.delegate respondsToSelector:@selector(rowGapXInSlopeLayout:)]) {
        return [self.delegate rowGapXInSlopeLayout:self];
    }
    return SFJDefaultRowGapX;
}
/** 同一列 相邻两个item的X差 */
- (CGFloat)columnGapX{
    if ([self.delegate respondsToSelector:@selector(columnGapXInSlopeLayout:)]) {
        return [self.delegate columnGapXInSlopeLayout:self];
    }
    return SFJDefaultColumnGapX;
}
/** 宽高比 */
- (CGFloat)whRatio{
    if ([self.delegate respondsToSelector:@selector(itemSizeInSlopeLayout:)]) {
        CGSize size = [self.delegate itemSizeInSlopeLayout:self];
        return size.width / size.height;
    }
    
    if ([self.delegate respondsToSelector:@selector(whRatioInSlopeLayout:)]) {
        return [self.delegate whRatioInSlopeLayout:self];
    }
    return SFJDefaultWHRatio;
}

- (CGSize)itemSize{
    if ([self.delegate respondsToSelector:@selector(itemSizeInSlopeLayout:)]) {
        return [self.delegate itemSizeInSlopeLayout:self];
    }
    CGFloat itemW = (collectionViewW_ - self.columnMargin * (self.columnCount - 1)) / self.columnCount;
    CGFloat ratio = 1.0 / [self whRatio];        // 高 宽比
    CGFloat itemH = itemW * (ratio);

//    CGFloat itemH = [self p_itemHeight];
    return  CGSizeMake(itemW, itemH);
}

- (CGFloat)contentWidth{
    if (collectionViewW_ < rowWidth_) {
        return rowWidth_;
    }
    return collectionViewW_;
}

- (CGFloat)contentHeight{
    if (collectionViewH_ < columnHeight_) {
        return columnHeight_;
    }
    return collectionViewH_;
}

@end
