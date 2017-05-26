//
//  HUDShow.m
//  BaseProject
//
//  Created by 吾爷科技 on 2017/3/13.
//  Copyright © 2017年 飓风逍遥. All rights reserved.
//

#import "HUDShow.h"
#import "JDStatusBarNotification.h"

#define kHUDQueryViewTag 101
#define kHUDTipViewTag   102
#define KeyWindow [UIApplication sharedApplication].keyWindow
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width  [UIScreen mainScreen].bounds.size.width

@implementation HUDShow
+ (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.tag = kHUDTipViewTag;
        hud.detailsLabel.font = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabel.text = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.0];
    }
}

+ (BOOL)showError:(NSError *)error{
    //通过error解析出来确定的错误信息
    NSString *tipStr = [self tipFromError:error];
    
    [self hideHUDQuery];
    
    if ([JDStatusBarNotification isVisible]) {//如果statusBar上面正在显示信息，则用hud显示error
        [self showHudTipStr:tipStr];
    }else{
        [self showStatusBarErrorStr:tipStr];
    }
    return YES;
}

+ (NSString *)tipFromError:(NSError *)error{
    NSString *errorStr;
    //通过error解析出来确定的错误信息
    switch (error.code) {
        case -1001:
            errorStr = @"网络超时!";
            break;
        case -1016:
            errorStr = @"无法解析数据!";
            break;
        case 1002:
            errorStr = @"请求地址错误!";
            break;
        case 3840:
            errorStr = @"数据格式错误!";
            break;
        case -1009:
            errorStr = @"网络已断开!";
            break;
        default:
            errorStr = @"未知的网络错误！";
            break;
    }
    return errorStr;
}

+ (MBProgressHUD *)showHUDQueryStr:(NSString *)titleStr{
    [self hideHUDQuery];
    titleStr = titleStr.length > 0? titleStr: @"正在获取数据...";
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    hud.tag = kHUDQueryViewTag;
    hud.detailsLabel.text = titleStr;
    hud.detailsLabel.font = [UIFont boldSystemFontOfSize:15.0];
    hud.margin = 10.f;
    return hud;
}
+ (NSUInteger)hideHUDQuery{
    __block NSUInteger count = 0;
    NSArray *huds = [MBProgressHUD allHUDsForView:KeyWindow];
    [huds enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == kHUDQueryViewTag || obj.tag == kHUDTipViewTag) {
            [obj removeFromSuperview];
            count++;
        }
    }];
    return count;
}

+(void) showMaskViewClickAction :(void (^)()) clickAction
{
    UIButton *maskView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    maskView.backgroundColor = [UIColor colorWithHex:0x000000];
    maskView.alpha  = 0.17;
    maskView.tag  = 1000001;
    [KeyWindow addSubview:maskView];
    
    [[maskView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        clickAction();
    }];
    
}

+ (void) hiddenMaskView
{
    [KeyWindow removeViewWithTag:1000001];
}


+ (void)showStatusBarQueryStr:(NSString *)tipStr{
    [JDStatusBarNotification showWithStatus:tipStr styleName:JDStatusBarStyleSuccess];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
}
+ (void)showStatusBarSuccessStr:(NSString *)tipStr{
    if ([JDStatusBarNotification isVisible]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
            [JDStatusBarNotification showWithStatus:tipStr dismissAfter:1.5 styleName:JDStatusBarStyleSuccess];
        });
    }else{
        [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
        [JDStatusBarNotification showWithStatus:tipStr dismissAfter:1.5 styleName:JDStatusBarStyleSuccess];
    }
}
+ (void)showStatusBarErrorStr:(NSString *)errorStr{
    if ([JDStatusBarNotification isVisible]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
            [JDStatusBarNotification showWithStatus:errorStr dismissAfter:1.5 styleName:JDStatusBarStyleError];
        });
    }else{
        [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
        [JDStatusBarNotification showWithStatus:errorStr dismissAfter:1.5 styleName:JDStatusBarStyleError];
    }
}

+ (void)showStatusBarError:(NSError *)error{
    NSString *errorStr = [self tipFromError:error];
    [self showStatusBarErrorStr:errorStr];
}

@end
