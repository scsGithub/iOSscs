//
//  AppConfig.h
//  BaseProject
//
//  Created by 张晓伟 on 16/1/14.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h
/*
typedef enum ServerType {
    ProductionMode = 0, //生产环境
    StagingMode = 1,    //预发布环境
    TestMode = 2,       //测试环境
} ServerType;

#define RELEASE_MODE 0 //appstore 改为0

//测试环境
#define kDebugSvrAddr @""
#define kDebugSvrPort 9000

//预发布环境
#define kPreReleaseSvrAddr @""
#define kPreReleaseSvrPort 8080

//正式环境
#define kReleaseSvrAddr @""
#define kReleaseSvrPort 80
*/


//七牛云存储 以下为本人的空间参数，仅供测试，不得用于非法用途
#define kScope @"xywzxw" //存储空间空间名 建议创建华东空间 默认就是华东空间的配置，其他空间需要自己设置
#define kAccessKey @"IbwEKRcuBxYanlW2IH-rVHryspdsoBDZaevXvH5i" //AccessKey 见密钥管理
#define kSecretKey @"2qKk5x2WV5YkDPYIyxYiIYZBUBpiw7H9D5ey2Vs3" //SecretKey 见密钥管理
#define kQiNiuHost @"http://ohurok03z.bkt.clouddn.com"; //见存储空间内容管理 外链默认域名

//UI颜色控制
#define kUIToneBackgroundColor [UIColor colorWithHex:0x00bd8c] //UI整体背景色调 与文字颜色一一对应
#define kUIToneTextColor [UIColor colorWithHex:0xffffff] //UI整体文字色调 与背景颜色对应
#define kStatusBarStyle UIStatusBarStyleLightContent //状态栏样式
#define kViewBackgroundColor [UIColor colorWithHex:0xf5f5f5] //界面View背景颜色


// 微信统一下单接口连接
#define WXUNIFIEDORDERURL @"https://api.mch.weixin.qq.com/pay/unifiedorder"
#define WX_PartnerKey @"Y7n9oimE8ze3qQHy7k2wE78dCj4ygZG3"
// 微信支付商户号
#define MCH_ID  @"1365134602"
#define WX_APPID @"wxf2cba13e5f57e51c"
#define WX_SECERT @"fc3ca47adc5e42900eaf2db11619e4f8"
#define WX_NOTIURL @"https://c.selanwang.com/api/payment/wxpay_app/notify_url.php"

//QQ信息
#define kQQAPPID @"101326728"
#define kQQREDIRECTURI @"https://www.selanwang.com"

#define AppScheme @"BaseProject"
#define kNotify_Alipay @"pay_alipay"
#define kNotify_WeiXin @"pay_weixin"

//网络状态监听
#define kNetworkDidChangeNotification  @"kNetworkDidChangeNotification"

#endif
