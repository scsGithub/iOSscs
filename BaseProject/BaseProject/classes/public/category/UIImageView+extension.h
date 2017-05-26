//
//  UIImageView+SLFitImageView.h
//  SeLan
//
//  Created by admin on 16/8/1.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (extension)
/**
 *  图片自适应UIImageView
 *
 *  @param urlStr 图片的URL地址
 *
 *  @return 加上image的UIImageView
 */
-(UIImageView *)fitImageViewWithURL:(NSString *)urlStr;

@end
