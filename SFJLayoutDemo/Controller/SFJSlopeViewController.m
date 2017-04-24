//
//  SFJSlopeViewController.m
//  SFJLayoutDemo
//
//  Created by 沙缚柩 on 2017/4/24.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJSlopeViewController.h"
#import "SFJSlopeLayout.h"
#import "SFJCell.h"


@interface SFJSlopeViewController ()<UICollectionViewDataSource,SFJSlopeLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SFJSlopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SFJSlopeLayout *sLayout = [[SFJSlopeLayout alloc] init];
    sLayout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:sLayout];
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

#pragma mark - <SFJSlopeLayoutDelegate>
- (CGSize)itemSizeInSlopeLayout:(SFJSlopeLayout *)slopeLayout{
    return CGSizeMake(100, 100);
}

@end
