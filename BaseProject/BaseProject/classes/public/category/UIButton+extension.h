//
//  UIButton+extension.h
//
//  Created by 张晓伟 on 16/5/17.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (extension)

/**
 创建文本按钮

 @param title            标题文字
 @param fontSize         字体大小
 @param normalColor      默认颜色
 @param highlightedColor 高亮颜色

 @return UIButton
 */
+ (instancetype)textButton:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor;


/**
 创建文本按钮

 @param title               标题文字
 @param fontSize            字体大小
 @param normalColor         默认颜色
 @param highlightedColor    高亮颜色
 @param backgroundImageName 背景图像名称

 @return UIButton
 */
+ (instancetype)textButton:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor backgroundImageName:(NSString *)backgroundImageName;

/**
 创建图像按钮

 @param imageName           图像名称
 @param backgroundImageName 背景图像名称

 @return UIButton
 */
+ (instancetype)imageButton:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName;

@end
