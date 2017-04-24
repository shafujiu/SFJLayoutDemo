//
//  SFJWaterLayoutController.m
//  SFJLayoutDemo
//
//  Created by 沙缚柩 on 2017/4/24.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJWaterLayoutController.h"
#import "SFJCell.h"
#import "SFJWaterflowLayout.h"

@interface SFJWaterLayoutController ()<UICollectionViewDataSource,SFJWaterflowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SFJWaterLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SFJWaterflowLayout *wLayout = [[SFJWaterflowLayout alloc] init];
    wLayout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:wLayout];
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SFJCell class]) bundle:nil] forCellWithReuseIdentifier:SFJCellID];
    [self.view addSubview:_collectionView];
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 50;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SFJCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SFJCellID forIndexPath:indexPath];
    cell.text = [NSString stringWithFormat:@"%ld",indexPath.item];
    return cell;
}
#pragma mark - <SFJWaterflowLayoutDelegate>

- (CGFloat)waterflowLayout:(SFJWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    return [self getRandomNumber:50 to:200];
}

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
@end
