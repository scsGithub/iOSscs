//
//  UIImageView+SLFitImageView.m
//  SeLan
//
//  Created by admin on 16/8/1.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import "UIImageView+extension.h"

@implementation UIImageView (extension)

-(UIImageView *)fitImageViewWithURL:(NSString *)urlStr
{
    self.contentMode = UIViewContentModeScaleAspectFit;
//    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr]];
//    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default_goods_image"]];
    return self;
}

@end
