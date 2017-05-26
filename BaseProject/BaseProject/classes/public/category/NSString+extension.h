//
//  NSString+extension.h
//
//  Created by 张晓伟 on 16/6/7.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (extension)
    
    //去掉无意义的0
+ (NSString *)stringDisposeWithFloatStringValue:(NSString *)floatStringValue;
    
+ (NSString *)stringDisposeWithFloatValue:(float)floatNum;
    
    //千分位格式化数据
+ (NSString *)itemThousandPointsFromNumString:(NSString *)numString;
    
    //计算字符串的CGSize
- (CGSize)ex_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/// 对当前字符串进行 BASE 64 编码，并且返回结果
- (NSString *)base64Encode;

/// 对当前字符串进行 BASE 64 解码，并且返回结果
- (NSString *)base64Decode;

/** MD5加密 */
- (NSString *)MD5Hash;


/** 文字竖排显示 */
- (NSString *)verticalString;

/**
 非空字符串值判断
 
 @param value 对比的字符串
 @return 布尔值
 */
+ (BOOL)isVaildString:(NSString *)value;

/** 时间戳转时间 */
- (NSString *)dateTime;
@end
