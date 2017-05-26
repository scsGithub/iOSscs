//
//  PhotoFirstCollectionViewCell.m
//  BaseProject
//
//  Created by 张晓伟 on 16/5/18.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "PhotoFirstCollectionViewCell.h"

@implementation PhotoFirstCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setData:(id)data delegate:(id)delegate {
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = data;
        _icoImageView.image = [UIImage imageNamed:dic[@"image"]];
        _titleLabel.text = dic[@"title"];
    }
}

@end
