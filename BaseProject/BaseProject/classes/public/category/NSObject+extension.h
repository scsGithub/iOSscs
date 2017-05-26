//
//  NSObject+extension.h
//
//  Created by 张晓伟 on 16/6/11.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (extension)

/// 使用字典数组创建当前类对象的数组
///
/// @param array 字典数组
///
/// @return 当前类对象的数组
+ (NSArray *)objectsWithArray:(NSArray *)array;

/// 返回当前类的属性数组
///
/// @return 属性数组
+ (NSArray *)propertiesList;

/// 返回当前类的成员变量数组
///
/// @return 成员变量数组
+ (NSArray *)ivarsList;

/** 打印模型 */
- (void)printModel;

/** 字典转换JSON格式打印 */
- (NSString *)dictToJson;

/** 获取当前页面的控制器 */
- (UIViewController *)getViewController;

/** 返回到根控制器页面 */
- (void)turnToGame;

@end
