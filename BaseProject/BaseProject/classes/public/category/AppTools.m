//
//  AppTools.m
//  飓风逍遥
//
//  Created by zxw on 2017/1/11.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "AppTools.h"


@interface AppTools()
@property (nonatomic, copy) void(^result)(BOOL result);
@property (nonatomic, copy) void(^error)(NSString *error);
@end

@implementation AppTools

/**
 保存图片至相册
 
 @param image 要保存的图片
 @param result 保存结果
 */
-(void)initSaveToAlbumWithImage:(UIImage *)image withResult:(void(^)(BOOL result))result
{
    self.result = result;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
}

/**保存图片代理方法*/
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil)
    {
        self.result(YES);
    }else
    {
        self.result(NO);
    }
}

/** 获取沙盒app的路径 */
+ (NSString *)getAppPath
{
    return [NSString stringWithFormat:@"%@/",[[NSBundle mainBundle] resourcePath]];
}
/** 获取沙盒Documents路径 */
+ (NSString *)getDocumentsPath
{
    return [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
}
/** 获取沙盒Caches路径 */
+ (NSString *)getCachesPath
{
    return [NSString stringWithFormat:@"%@/Library/Caches/",NSHomeDirectory()];
}

/** 获取ios系统版本号 */
+ (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

/** 获取当前app版本号 */
+ (NSString *)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *newVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:newVersion forKey:@"oldVersion"];
    return newVersion;
}

/**获取当前APP Build版本号*/
+ (NSString *)getAppBuildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

/** 判断邮箱格式是否正确  */
+(BOOL)isValidateEmail:(NSString *)email;
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/** 判断手机号码格式是否正确 */
+ (BOOL)isValidateMobile:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[56]))\\d{8}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(17[37])|(18[019]))\\d{8}$";
        
        /**
         * 虚拟号段正则表达式
         */
        NSString *VM_NUM = @"^((17[01]))\\d{8}$";
        
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VM_NUM];
        BOOL isMatch4 = [pred4 evaluateWithObject:mobile];
        
        
        if (isMatch1 || isMatch2 || isMatch3 || isMatch4) {
            return YES;
        }else{
            return NO;
        }
    }
}


/** 获取App的名称 */
+ (NSString *)getAppName{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
}

/**
 打开手机qq与指定人聊天
 @param qqNumber QQ号
 @param error failure 失败回调
 */
- (void)callWithQQNumber:(NSString *)qqNumber failure:(void(^)(NSString *info))error{
    self.error = error;
    //需要在info.plist中增加LSApplicationQueriesSchemes数组，然后添加item0，item0对应的值为mqqapi；增加item1，item1的值为mqq。
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
        NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qqNumber]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [webView loadRequest:request];
        
        [self.getViewController.view addSubview:webView];
        
    }else{
        self.error(@"未安装QQ客户端");
    }
}

/** 拨打电话 */
-(void)callWithPhoneNumber:(NSString *)phoneNumber{
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]  ];
}


@end
