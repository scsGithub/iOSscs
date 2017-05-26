//
//  WeChatPay.m
//  飓风逍遥
//
//  Created by zxw on 2017/1/5.
//  Copyright © 2017年 青岛吾爷网络科技有限公司. All rights reserved.
//

#import "WeChatPay.h"
#import <AFNetworking.h>
@implementation WeChatPay

/** 微信 支付接口（本地加密） */
+ (void)wechatClientPayWithInfo:(NSDictionary *)infoDict
{
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    
    WeChatClientPayMethod *method = [WeChatClientPayMethod new];

    // 交易类型
    NSString *trade_type = @"APP";
    
    // 随机字符串变量 这里最好使用和安卓端一致的生成逻辑
    NSString *tradeNO = [method generateTradeNO];
    
    // 设备IP地址
    NSString *addressIP = [HardWareTools getIPAddress];
    
    NSString *wx_appid = WX_APPID;
    
    NSString *mch_id = MCH_ID;
    
    NSString *partner_id = WX_PartnerKey;
    
    NSString *notify_url = WX_NOTIURL;
    
    NSString *body = infoDict[@"body"];
    
    // 交易价格1表示0.01元，10表示0.1元
    NSString *payamount = [NSString stringWithFormat:@"%d", (int)(((NSString *)infoDict[@"payamount"]).floatValue * 100)];
    NSString *paysn = infoDict[@"paysn"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:tradeNO forKey:@"trade_id"];
    [param setValue:body forKey:@"body"];
    [param setValue:paysn forKey:@"pay_sn"];
    [param setValue:payamount forKey:@"payamount"];
    [param setValue:addressIP forKey:@"address_ip"];
    [param setValue:trade_type forKey:@"trade_type"];
    [param setValue:wx_appid forKey:@"app_id"];
    [param setValue:mch_id forKey:@"mch_id"];
    [param setValue:partner_id forKey:@"partner_id"];
    [param setValue:notify_url forKey:@"notify_url"];

//    Log(@"微信支付加密参数:%@",param);
    
    method = [[WeChatClientPayMethod alloc] initWithAppid:wx_appid mch_id:mch_id nonce_str:tradeNO partner_id:partner_id body:body out_trade_no:paysn total_fee:payamount spbill_create_ip:addressIP notify_url:notify_url trade_type:trade_type];
    
    // 转换成XML字符串,这里知识形似XML，实际并不是正确的XML格式，需要使用AF方法进行转义
    NSString *string = [[method dic] XMLString];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 这里传入的XML字符串只是形似XML，但不是正确是XML格式，需要使用AF方法进行转义
    session.securityPolicy = [AFSecurityPolicy new];
    session.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [session.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [session.requestSerializer setValue:WXUNIFIEDORDERURL forHTTPHeaderField:@"SOAPAction"];
    [session.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return string;
    }];
    [session POST:WXUNIFIEDORDERURL parameters:string progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //  输出XML数据
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] ;
        //  将微信返回的xml数据解析转义成字典
        NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
        
        // 判断返回的许可
        if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"]) {
            // 发起微信支付，设置参数
            PayReq *request = [[PayReq alloc] init];
            
            // 将当前时间转化成时间戳
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            UInt32 timeStamp =[timeSp intValue];
            request.timeStamp= timeStamp;
            
            request.openID = [dic objectForKey:@"appid"];
            request.partnerId = [dic objectForKey:@"mch_id"];
            request.prepayId= [dic objectForKey:@"prepay_id"];
            request.package = @"Sign=WXPay";
            request.nonceStr= [dic objectForKey:@"nonce_str"];
            
            
            // 签名加密
            
            request.sign=[method createMD5SingForPay:request.openID
                                           partnerid:request.partnerId
                                            prepayid:request.prepayId
                                             package:request.package
                                            noncestr:request.nonceStr
                                           timestamp:request.timeStamp];
            // 调用微信
            [WXApi sendReq:request];
        }else
        {
            [dic dictToJson];
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"err_code_des"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
        }
    } failure:nil];
    
}

/** 微信 支付接口 （服务器加密） */
+(void)wechatPayWithInfo:(NSDictionary *)info
{
    // 发起微信支付，设置参数
    PayReq *request = [[PayReq alloc] init];

    request.timeStamp = (UInt32)(((NSNumber *)info[@"timestamp"]).longLongValue);
    request.openID = info[@"appid"] ;
    request.partnerId = info[@"partnerid"];
    request.prepayId= info[@"prepayid"];
    request.package = info[@"package"];
    request.nonceStr= info[@"noncestr"];
    request.sign = info[@"paySign"];
    // 调用微信
    [WXApi sendReq:request];
}

#pragma mark - WXApi代理方法
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
            {
                NSLog(@"支付成功");
            }
                break;
                
            default:
                NSLog(@"错误, retcode = %d, retStr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}

@end
