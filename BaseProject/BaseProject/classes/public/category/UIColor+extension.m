//
//  UIColor+extension.m
//
//  Created by 张晓伟 on 16/4/21.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import "UIColor+extension.h"

@implementation UIColor (extension)

+ (instancetype)colorWithHex:(uint32_t)hex {
    
    uint8_t r = (hex & 0xff0000) >> 16;
    uint8_t g = (hex & 0x00ff00) >> 8;
    uint8_t b = hex & 0x0000ff;
    
    return [self colorWithRed:r green:g blue:b];
}

+ (instancetype)randomColor {
    return [UIColor colorWithRed:arc4random_uniform(256) green:arc4random_uniform(256) blue:arc4random_uniform(256)];
}

+ (instancetype)colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}
-(UIImage *)createImageWithColor
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


/** 吾丁网主体背景颜色 */
+ (instancetype)wdBgColor{
    return [UIColor colorWithHex:0xececec];
}

/** 吾丁网主体红色 */
+ (instancetype)wdRedColor{
    return [UIColor colorWithHex:0xD61718];
}

/** 吾丁网1级灰色(黑) */
+ (instancetype)wdLevel1Color{
    return [UIColor colorWithHex:0x333333];
}

/** 吾丁网2级灰色(中) */
+ (instancetype)wdLevel2Color{
    return [UIColor colorWithHex:0x666666];
}

/** 吾丁网3级灰色(灰) */
+ (instancetype)wdLevel3Color{
    return [UIColor colorWithHex:0x757575];
}
/** 吾丁网按钮正常背景颜色 */
+(instancetype)wdBtnNormalBgColor{
    return [UIColor colorWithHex:0xff5a5f];
}

/** 吾丁网按钮正常文字颜色 */
+(instancetype)wdBtnNormalTextColor{
    return [UIColor colorWithHex:0xffffff];
}

/** 吾丁网按钮不可用背景颜色 */
+(instancetype)wdBtnLockBgColor{
    return [UIColor colorWithHex:0xfd797d];
}

/** 吾丁网按钮不可用文字颜色 */
+(instancetype)wdBtnLockTextColor{
    return [UIColor colorWithHex:0xffe8e9];
}

/** 吾丁网按钮高亮颜色 */
+(instancetype)wdBtnHighLightColor{
    return [UIColor colorWithHex:0xe84248];
}

@end
