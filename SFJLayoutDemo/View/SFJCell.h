//
//  CollectionViewCell.h
//  SFJLayoutDemo
//
//  Created by 沙缚柩 on 2017/4/24.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const SFJCellID = @"SFJCellID";

@interface SFJCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, copy) NSString *text;

@end
