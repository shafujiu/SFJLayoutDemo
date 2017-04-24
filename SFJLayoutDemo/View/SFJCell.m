//
//  CollectionViewCell.m
//  SFJLayoutDemo
//
//  Created by 沙缚柩 on 2017/4/24.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJCell.h"
@interface SFJCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageViwe;
@property (weak, nonatomic) IBOutlet UILabel *textL;

@end
@implementation SFJCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setText:(NSString *)text{
    _text = text;
    _textL.text = text;
}

- (void)setBgImage:(UIImage *)bgImage{
    _bgImage = bgImage;
    _bgImageViwe.image = bgImage;
}

@end
