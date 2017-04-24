# SFJLayoutDemo
自定义了三种常用的布局
UICollectionView 常用的布局是UICollectionViewFlowLayout，但是只这一种往往是不够用的，
该demo自定义了三种布局。布局并不是特别炫。旨在理解自定义布局的流程，以及装饰视图的添加整套流程。
通常做自己的项目的时候，还是需要高度的自定义，再添加一些自己的想法在布局里面。
## 1.圆形布局 SFJCircleLayout

### 效果 以及变量说明
![](http://on5ajnh9a.bkt.clouddn.com/1493017038.png?imageMogr2/auto-orient/thumbnail/!50p/blur/1x0/quality/75|watermark/2/text/c2hhZnVqaXU=/font/YXJpYWw=/fontsize/240/fill/I0JCNTcxNQ==/dissolve/49/gravity/SouthEast/dx/5/dy/5|imageslim)

### 代理
> 没有必须实现的代理，因为在实现文件里面都有一套默认值，代理只是方便自己调整，通常就item大小，
与半径的代理方法比较常用
```Objective-c
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
```
## 2.平行四边形 SFJSlopeLayout

### 效果 以及变量说明
![](http://on5ajnh9a.bkt.clouddn.com/WX20170424-142501.png?imageMogr2/auto-orient/thumbnail/!50p/blur/1x0/quality/75|watermark/2/text/c2hhZnVqaXU=/font/YXJpYWw=/fontsize/240/fill/I0JCNTcxNQ==/dissolve/49/gravity/SouthEast/dx/5/dy/5|imageslim)

### 代理
```Objective-c
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
```

## 3.瀑布流 SFJWaterflowLayout
### 效果 以及变量说明

![](http://on5ajnh9a.bkt.clouddn.com/1493017117.png?imageMogr2/auto-orient/thumbnail/!50p/blur/1x0/quality/75|watermark/2/text/c2hhZnVqaXU=/font/YXJpYWw=/fontsize/240/fill/I0JCNTcxNQ==/dissolve/49/gravity/SouthEast/dx/5/dy/5|imageslim)

### 代理 
```Objective-c
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
```
流水布局原版参照黑马ios教程

## 关于自定义布局
> 1. 子类化UICollectionViewLayout
> 2. 重写以下方法
```Objective-c
/**
 * 初始化 每次刷新界面都会调用
 */
- (void)prepareLayout{
    // 注意调用父类的方法
    [super prepareLayout];
}

/**
 *  @brief 决定背景 以及cell的排布的数组
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;
/**
 * 返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = [self p_attrsFrameWithIndex:indexPath.row]; // 调整frame
    return attrs;
}

/**
 *  决定 contentSize
 */
- (CGSize)collectionViewContentSize;
```
当然 想要构造一个炫酷复杂的布局，这几个函数是不够，比如还可以为布局做动画。
又比如想要给我们的UICollectionView添加一个与contentSize大小的背景。此时需
要用到装饰视图

## 装饰视图
该视图也属于布局的一部分。
实现办法 
> 1. 自定义装饰视图 子类化UICollectionReusableView
> 2. 在prepare中注册
> 3. 实现如下方法
```Objective-c
/**
 *  决定装饰视图的排布
*/
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:SFJDectationViewID withIndexPath:indexPath];
    att.frame = CGRectMake(0, 0, self.contentWidth, self.contentHeight);
    att.zIndex = -1;
    return att;
}
// 需要将装饰的Attributes添加到布局数组的第一个
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

```
详细 使用参考demo circleLayout 有bug，当直径+itemWidth超过屏幕宽度的时候，找不准中间位置。




