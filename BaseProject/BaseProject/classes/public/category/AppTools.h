//
//  AppTools.h
//  飓风逍遥
//
//  Created by zxw on 2017/1/11.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppTools : NSObject

/** 获取沙盒app的路径 */
+ (NSString *)getAppPath;

/** 获取沙盒Documents路径 */
+ (NSString *)getDocumentsPath;

/** 获取沙盒Caches路径 */
+ (NSString *)getCachesPath;

/** 获取iOS系统版本号 */
+ (float)getIOSVersion;

/** 获取当前app版本号 */
+ (NSString *)getAppVersion;

/**获取当前APP Build版本号*/
+ (NSString *)getAppBuildVersion;

/** 判断邮箱格式是否正确  */
+ (BOOL)isValidateEmail:(NSString *)email;

/** 判断手机号码格式是否正确 */
+ (BOOL)isValidateMobile:(NSString *)mobile;

/** 获取App的名称 */
+ (NSString *)getAppName;

/**
 保存图片至相册
 
 @param image  要保存的图片
 @param result 保存结果
 */
- (void)initSaveToAlbumWithImage:(UIImage *)image withResult:(void(^)(BOOL result))result;

/**
 拨打电话
 @param phoneNumber 手机号
 */
- (void)callWithPhoneNumber:(NSString *)phoneNumber;

/*
 打开手机qq与指定人聊天
 @param qqNumber QQ号
 @param failure  失败回调
 */
- (void)callWithQQNumber:(NSString *)qqNumber failure:(void(^)(NSString *info))error;

@end
