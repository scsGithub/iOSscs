//
//  UILabel+extension.h
//
//  Created by 张晓伟 on 16/4/21.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (extension)

/// 创建文本标签
///
/// @param text     文本
/// @param fontSize 字体大小
/// @param color    颜色
///
/// @return UILabel
+ (instancetype)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color;
/** 宽度固定，高度自适应 */
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;
/** 高度固定，宽度自适应 */
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

@end
