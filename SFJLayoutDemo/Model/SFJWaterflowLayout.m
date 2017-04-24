//
//  SFJWaterflowLayout.m
//  WaterFlow
//
//  Created by ZhaoWei on 16/3/27.
//  Copyright © 2016年 ZhaoWei. All rights reserved.
//

#import "SFJWaterflowLayout.h"

//默认的列数
static const NSInteger SFJDefaultColumnCount = 3;
//每一列之间的间距
static const NSInteger SFJDefaultColumnMargin = 10;
//每一行之间的间距
static const NSInteger SFJDefaultRowMargin = 10;
//边缘的间距
static const UIEdgeInsets SFJDefaultEdgeInsets ={ 10, 10, 10, 10};  //UIEdgeInsetsMake(10, 10, 10, 10);  这里是函数 所以不能用

@interface SFJWaterflowLayout()
//存放所有cell的布局属性
@property (nonatomic, strong) NSMutableArray *attrsArray;
//存放所有 列的当前高度   column 英 'kɒləm 列
@property (nonatomic, strong) NSMutableArray *columnHeights;

// 内容高度
@property (nonatomic, assign) CGFloat contentHeight;

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;

@end
@implementation SFJWaterflowLayout
#pragma mark -- 基本数据设置
- (CGFloat)rowMargin{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    }else{
        return SFJDefaultRowMargin;
    }
}

- (CGFloat)columnMargin{

    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    }else{
        return SFJDefaultColumnMargin;
    }
}

- (NSInteger)columnCount{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    }else{
        return SFJDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    }else{
        return SFJDefaultEdgeInsets;
    }
}

#pragma mark --懒加载
- (NSMutableArray *)attrsArray{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}
//存放所有 列的当前高度
- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}


//TODO:1.初始化  (布局的时候执行一次)
- (void)prepareLayout{
    [super prepareLayout];
    
    //清除以前计算的所有的高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < SFJDefaultColumnCount; i++) {
        [self.columnHeights addObject:@(SFJDefaultEdgeInsets.top)];
    }
    
    
    //创建之前 需要清除之前的所有的布局对象 否则会重复
    [self.attrsArray removeAllObjects];
    
    //开始创建每一个cell对应的布局属性
    //获取有多少个cell
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        //获取indexPath位置的cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArray addObject:attrs];
    }
}

//TODO:2.决定cell的排版（多次执行）
- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{

    return self.attrsArray;
}

//TODO:3.返回indexPath位置cell对应的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

    //创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    //设置布局属性的frame  (总宽度 - 左右边距 - 中间间隙 最后/列数)；
    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1)*self.columnMargin)/self.columnCount;
//    CGFloat h = 50 + arc4random_uniform(100);//生成100---150之间的随机数
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    //找出高度最短的那一列 dest(目标)
    /*   BLOCK遍历
    __block NSInteger destColumn = 0;
    __block CGFloat minColumnHeight = MAXFLOAT;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber  *columnHeightNumber, NSUInteger idx, BOOL * stop) {
        CGFloat columHeight = columnHeightNumber.doubleValue;
        
        if (minColumnHeight > columHeight) {
            minColumnHeight = columHeight;
            destColumn = idx;
        }
    }];
    */
    //找出高度最短的那一列 dest(目标)
    NSInteger destColumn = 0;
    //取出第一个 作为最小值 然后跟其他列比较
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];//MAXFLOAT
    for (NSInteger i = 0; i < self.columnCount; i++) {
        //取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    /*
    CGFloat x = SFJDefaultEdgeInsets.left + (w + SFJDefaultColumnMargin) * destColumn;
    */
    CGFloat x = self.edgeInsets.left + (w + self.columnMargin) * destColumn;
    
    CGFloat y = minColumnHeight;
    
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    
    attrs.frame = CGRectMake(x, y, w, h);
    
    //加上新的cell后 需要更新最短列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    //记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attrs;
}

//TODO:4.设置内容大小
- (CGSize)collectionViewContentSize{
    
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}





@end
