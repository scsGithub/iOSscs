//
//  HUDShow.h
//  BaseProject
//
//  Created by 吾爷科技 on 2017/3/13.
//  Copyright © 2017年 飓风逍遥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUDShow : NSObject
+ (void)showHudTipStr:(NSString *)tipStr;
+ (BOOL)showError:(NSError *)error;
+ (NSString *)tipFromError:(NSError *)error;
+ (MBProgressHUD *)showHUDQueryStr:(NSString *)titleStr;
+ (NSUInteger)hideHUDQuery;
+ (void)showStatusBarQueryStr:(NSString *)tipStr;
+ (void)showStatusBarSuccessStr:(NSString *)tipStr;
+ (void)showStatusBarErrorStr:(NSString *)errorStr;
+ (void)showStatusBarError:(NSError *)error;


+(void) showMaskViewClickAction :(void (^)()) clickAction;
+ (void) hiddenMaskView;

@end
