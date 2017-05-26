//
//  ZhiFuBaoPay.m
//  飓风逍遥
//
//  Created by zxw on 2017/1/5.
//  Copyright © 2017年 青岛吾爷网络科技有限公司. All rights reserved.
//

#import "ZhiFuBaoPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "RSADataSigner.h"

@implementation ZhiFuBaoPay

static ZhiFuBaoPay *manager = nil;
static NSString *appScheme = AppScheme;
static NSString *appID = @"ggggg";
static NSString *rsaPrivateKey = @"gggg";
static NSString *rsa2PrivateKey = @"gggg";

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager = [[ZhiFuBaoPay alloc] init];
    });
    return manager;
}
- (void)startPayWithInfo:(NSDictionary *)info
{
    [[AlipaySDK defaultService]payOrder:@"orderString" fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        [resultDic dictToJson];
        NSString *result = resultDic[@"result"];
        if ([NSString isVaildString:result])
        {
            //成功
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Alipay object:nil userInfo:@{@"succeed":[NSNumber numberWithBool:YES]}];
        }else{
            //取消
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Alipay object:nil userInfo:@{@"succeed":[NSNumber numberWithBool:NO]}];
        }
    }];
}

- (void)startClientPayWithGoods:(BizContent *)goods
{
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";

    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    
    order.biz_content.body = goods.body;
    order.biz_content.subject = goods.subject;
    order.biz_content.out_trade_no = goods.out_trade_no; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = goods.timeout_express == nil?@"30m":goods.timeout_express; //超时时间设置
    order.biz_content.total_amount = goods.total_amount; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil)
    {
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:AppScheme callback:^(NSDictionary *resultDic)
         {
           [resultDic dictToJson];
            NSString *result = resultDic[@"result"];
            if ([NSString isVaildString:result])
            {
                //成功
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Alipay object:nil userInfo:@{@"succeed":[NSNumber numberWithBool:YES]}];
            }else{
                //取消
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Alipay object:nil userInfo:@{@"succeed":[NSNumber numberWithBool:NO]}];
            }

        }];
    }
}
/** 生成随机订单编号 */
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
