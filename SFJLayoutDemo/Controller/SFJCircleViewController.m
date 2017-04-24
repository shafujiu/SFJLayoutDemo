//
//  SFJCircleViewController.m
//  SFJLayoutDemo
//
//  Created by 沙缚柩 on 2017/4/24.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJCircleViewController.h"
#import "SFJCircleLayout.h"
#import "SFJCell.h"

@interface SFJCircleViewController ()<UICollectionViewDataSource,SFJCircleLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SFJCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SFJCircleLayout *cLayout = [[SFJCircleLayout alloc] init];
    cLayout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:cLayout];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SFJCell class]) bundle:nil] forCellWithReuseIdentifier:SFJCellID];
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SFJCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SFJCellID forIndexPath:indexPath];
    cell.text = [NSString stringWithFormat:@"%ld",indexPath.item];
    return cell;
}

#pragma mark - <SFJCircleLayoutDelegate>

/**
 * item的大小，如果不传将调用默认值 70 70
 */
- (CGSize)itemSizeInCircleLayout:(SFJCircleLayout *)circleLayout indexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 100);
}

/**
 * * item中心点到布局中心的距离（半径）
 *  如果直径超过屏幕宽度，实现contentSizeInCircleLayout
 *  中心点需要根据该参数来计算。后续优化考虑自动适应居中。
 */
- (CGFloat)radiusInCircleLayout:(SFJCircleLayout *)circleLayout{
    return (self.collectionView.frame.size.width - 100) * .5;
}



@end
