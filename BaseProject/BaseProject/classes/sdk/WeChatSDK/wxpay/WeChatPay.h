//
//  WeChatPay.h
//  飓风逍遥
//
//  Created by zxw on 2017/1/5.
//  Copyright © 2017年 青岛吾爷网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WeChatClientPayMethod.h"

@interface WeChatPay : NSObject<WXApiDelegate>

/** 微信 支付接口（本地加密） */
+ (void)wechatClientPayWithInfo:(NSDictionary *)infoDict;

/** 微信 支付接口 （服务器加密） */
+ (void)wechatPayWithInfo:(NSDictionary *)info;

@end
