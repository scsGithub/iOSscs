//
//  UIColor+extension.h
//
//  Created by 张晓伟 on 16/4/21.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (extension)

/// 使用 16 进制数字创建颜色，例如 0xFF0000 创建红色
///
/// @param hex 16 进制无符号32位整数
///
/// @return 颜色
+ (instancetype)colorWithHex:(uint32_t)hex;


/// 生成随机颜色
///
/// @return 随机颜色
+ (instancetype)randomColor;

/// 使用 R / G / B 数值创建颜色
///
/// @param red   red
/// @param green green
/// @param blue  blue
///
/// @return 颜色
+ (instancetype)colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;

/** 将颜色转换为图片格式 */
-(UIImage *)createImageWithColor;

/** 吾丁网主体背景灰色 */
+ (instancetype)wdBgColor;

/** 吾丁网主体红色 */
+ (instancetype)wdRedColor;

/** 吾丁网1级灰色(黑) */
+ (instancetype)wdLevel1Color;

/** 吾丁网2级灰色(中) */
+ (instancetype)wdLevel2Color;

/** 吾丁网3级灰色(灰) */
+ (instancetype)wdLevel3Color;

/** 吾丁网按钮正常背景颜色 */
+(instancetype)wdBtnNormalBgColor;

/** 吾丁网按钮正常文字颜色 */
+(instancetype)wdBtnNormalTextColor;

/** 吾丁网按钮不可用背景颜色 */
+(instancetype)wdBtnLockBgColor;

/** 吾丁网按钮不可用文字颜色 */
+(instancetype)wdBtnLockTextColor;

/** 吾丁网按钮高亮颜色 */
+(instancetype)wdBtnHighLightColor;

@end
