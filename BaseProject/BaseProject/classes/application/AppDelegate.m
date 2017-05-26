//
//  AppDelegate.m
//  BaseProject
//
//  Created by 张晓伟 on 2017/3/6.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "AppDelegate.h"

//支付宝头文件
#import <AlipaySDK/AlipaySDK.h>
//微信头文件
#import "WXApi.h"
//QQ头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "NetReachability.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //微信注册
    [WXApi registerApp:WX_APPID];
    
    //QQ注册
    TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAPPID andDelegate:nil];
    tencentOAuth.redirectURI = kQQREDIRECTURI;

    //网络变化监测
    [NetReachability shareNetworkCenter];
    
    //界面初始化
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    _baseTabBar = [BaseTabBarController new];
    self.window.rootViewController = _baseTabBar;
    [self.window makeKeyAndVisible];
    
    return YES;
}


// 9.0以后  回调APP使用
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options NS_AVAILABLE_IOS(9_0)
{
    [self openWithURL:url];
    return YES;
}
// 9.0之前  回调APP使用
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [self openWithURL:url];
    return YES;
}

-(void)openWithURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"])
    {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [resultDic dictToJson];
            NSString *result = resultDic[@"result"];
            if ([NSString isVaildString:result]) {
                //成功
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Alipay object:nil userInfo:@{@"succeed":[NSNumber numberWithBool:YES]}];
            }else{
                //取消
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Alipay object:nil userInfo:@{@"succeed":[NSNumber numberWithBool:NO]}];
            }
        }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            [resultDic dictToJson];
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else if([url.host isEqualToString:@"pay"])
    {
        //微信分享
        [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    }else if ([url.host isEqualToString:@"qzapp"])
    {
        //QQ登录
        [TencentOAuth HandleOpenURL:url];
    }else if ([url.host isEqualToString:@"oauth"]){
        //微信登录
        NSArray *array = [url.absoluteString componentsSeparatedByString:@"oauth?code="];
        NSString *code = [array.lastObject componentsSeparatedByString:@"&state="].firstObject;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:code forKey:@"code"];
        [param setValue:WX_APPID forKey:@"appid"];
        [param setValue:WX_SECERT forKey:@"secret"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wxlogin" object:self userInfo:param];
    }
    
}

//微信支付通知
-(void)onResp:(BaseResp *)resp
{
    NSString *strMsg;
    if([resp isKindOfClass:[PayResp class]]){
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"success";
                NSNotification *notification = [NSNotification notificationWithName:kNotify_WeiXin object:strMsg];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }break;
            case WXErrCodeUserCancel:
            {
                strMsg = @"支付结果：用户点击取消！";
                NSNotification *notification = [NSNotification notificationWithName:kNotify_WeiXin object:strMsg];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            } break;
            case WXErrCodeSentFail:
            {
                strMsg = @"支付结果：发送失败！";
                NSNotification *notification = [NSNotification notificationWithName:kNotify_WeiXin object:strMsg];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }break;
            case WXErrCodeAuthDeny:
            {
                strMsg = @"支付结果：授权失败！";
                NSNotification *notification = [NSNotification notificationWithName:kNotify_WeiXin object:strMsg];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }break;
                
            default:
            {
                strMsg = @"支付结果：微信不支持！";
                NSNotification *notification = [NSNotification notificationWithName:kNotify_WeiXin object:strMsg];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }break;
        }
    }
}


@end
