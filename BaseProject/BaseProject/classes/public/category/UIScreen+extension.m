//
//  UIScreen+extension.m
//
//  Created by 张晓伟 on 16/5/17.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import "UIScreen+extension.h"

@implementation UIScreen (extension)

+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)scale {
    return [UIScreen mainScreen].scale;
}

@end
