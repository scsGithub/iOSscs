//
//  ThirdLoginTools.m
//  飓风逍遥
//
//  Created by 张晓伟 on 2017/1/8.
//  Copyright © 2017年 青岛吾爷网络科技有限公司. All rights reserved.
//

#import "ThirdLoginTools.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface ThirdLoginTools ()<TencentSessionDelegate>
@property (nonatomic, copy) void(^info)(NSDictionary *info);
@property (nonatomic, copy) void(^loginError)(NSString *loginError);
@end

@implementation ThirdLoginTools
{
    TencentOAuth *tencentOAuth;
    NSArray *permissions;
}
-(instancetype)init
{
    if (self = [super init])
    {
        tencentOAuth=[[TencentOAuth alloc]initWithAppId:kQQAPPID andDelegate:self];
        //设置需要的权限列表，此处尽量使用什么取什么。
        permissions= [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t",nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxLogin:) name:@"wxlogin" object:nil];

    }
    return self;
}
#pragma mark -QQ登录
/** QQ登录 */
-(void)qqLoginSuccess:(void (^)(NSDictionary *))info failure:(void (^)(NSString *))loginError
{
    self.info = info;
    self.loginError = loginError;
    [tencentOAuth authorize:permissions inSafari:NO];
}

// QQ获取信息代理
//登陆完成调用
- (void)tencentDidLogin
{
    if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length]){
        //获取到用户信息
        if (![tencentOAuth getUserInfo]){
            self.loginError(@"授权失败");
        }
    }
    else{
        //获取信息失败
        self.loginError(@"登录失败");
    }
}
//非网络错误导致登录失败：
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        self.loginError(@"用户取消登录");
    } else {
        self.loginError(@"登录失败");
    }
}
//网络错误导致登录失败：
-(void)tencentDidNotNetWork
{
    self.loginError(@"网络连接失败");
}
//获取到的用户信息
-(void)getUserInfoResponse:(APIResponse *)response{
    self.info(response.jsonResponse);
}

#pragma mark -微信登录
/** 微信登录 */
-(void)wxLoginSuccess:(void (^)(NSDictionary *))info failure:(void (^)(NSString *))loginError
{
    self.info = info;
    self.loginError = loginError;

    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}
/** 微信通知回调 */
-(void)wxLogin:(NSNotification *)notifition{
    NSDictionary *dict = notifition.userInfo;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:dict[@"secret"] forKey:@"secret"];
    [param setValue:dict[@"code"] forKey:@"code"];
    [param setValue:dict[@"appid"] forKey:@"appid"];
    [param setValue:@"authorization_code"forKey:@"grant_type"];
    //1.获取access_token和openid
    [[NetworkTools manager]downLoadWithMethod:GET withURL:@"https://api.weixin.qq.com/sns/oauth2/access_token" withParam:param success:^(id responseObject) {
        NSString *access_token = responseObject[@"access_token"];
        NSString *open_id = responseObject[@"openid"];
        if (access_token && open_id) {
            //2.获取用户信息
            [[NetworkTools manager] downLoadWithMethod:GET withURL:@"https://api.weixin.qq.com/sns/userinfo" withParam:@{@"access_token":access_token,@"openid":open_id} success:^(id responseObject) {
                self.info(responseObject);
            } error:^(NSError *error) {
                self.loginError(@"获取用户信息失败");
            }];
        }
    } error:^(NSError *error) {
        self.loginError(@"获取授权失败");
    }];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"wxlogin"];
}
@end
