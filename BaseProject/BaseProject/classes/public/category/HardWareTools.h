//
//  HardWareTools.h
//  WuDing
//
//  Created by 吾爷科技 on 2017/2/13.
//  Copyright © 2016年 吾丁网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HardWareTools : NSObject

/** 获取设备的IP地址 */
+ (NSString *)getIPAddress;

/** 获取本机所有的ip地址 */
+ (NSDictionary *)getIPAddresses;

/** 验证ip地址是否合法 */
+ (BOOL)isValidatIP:(NSString *)ipAddress;

/** 获取设备名称 */
+ (NSString *)getDeviceName;

/** 获取设备唯一标识符 */
+ (NSString *)getDeviceUUID;

/** 获取设备的型号 */
+ (NSString *)getDeviceModel;

/** 获取设备的型号名称 */
+ (NSString *)getDeviceModelName;

/** 获取当前设备可用内存(单位：MB） */
+ (double)getAvailableMemory;

/** 占用的内存（单位：MB） */
+ (double)getUsedMemory;

/** 总的磁盘空间 */
+ (double)getTotalDiskSpace;

/** 可用磁盘空间 */
+ (double)getFreeDiskSpace;

/**
 打开/关闭闪光灯
 
 @param flag YES:打开  NO:关闭
 */
+ (void)turnFlashLight:(BOOL)flag;

/** 获取运营商的信息 */
+ (NSString *)getCarrierName;

/** 获取连接类型 */
+ (NSString *)getConnectType;

/** 获取连接的WiFi名称 */
+ (NSString *)getWiFiName;

@end
