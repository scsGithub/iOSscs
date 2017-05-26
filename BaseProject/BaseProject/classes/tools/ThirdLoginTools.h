//
//  ThirdLoginTools.h
//  飓风逍遥
//
//  Created by 张晓伟 on 2017/1/8.
//  Copyright © 2017年 青岛吾爷网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdLoginTools : NSObject
/** QQ登录 */
-(void)qqLoginSuccess:(void(^)(NSDictionary *info))info failure:(void(^)(NSString *loginError))loginError;

/** 微信登录 */
-(void)wxLoginSuccess:(void(^)(NSDictionary *info))info failure:(void(^)(NSString *loginError))loginError;

@end
