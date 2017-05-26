//
//  UIFont+extension.m
//  WuDing
//
//  Created by 吾爷科技 on 2017/2/16.
//  Copyright © 2016年 吾丁网. All rights reserved.
//

#import "UIFont+extension.h"

@implementation UIFont (extension)

/**  快速修改字体大小 ，并修改字体为定义的字体 */
+(instancetype)changeFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
}

@end
