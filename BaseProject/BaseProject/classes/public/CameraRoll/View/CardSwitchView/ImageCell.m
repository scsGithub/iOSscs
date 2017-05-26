//
//  ImageCell.m
//  BaseProject
//
//  Created by 张晓伟 on 15/3/20.
//  Copyright (c) 2015年 飓风逍遥. All rights reserved.
//

#import "ImageCell.h"

@interface ImageCell()

@end

@implementation ImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.cornerRadius = 2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
}

@end
