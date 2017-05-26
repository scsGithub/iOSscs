//
//  Toast.h
//  飓风逍遥
//
//  Created by zxw on 16/10/10.
//  Copyright © 2016年 青岛吾爷网络科技有限公司 All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark - 调用Toast的类
@class XWToast;

@interface Toast : NSObject

+ (void)ToastShow:(NSString *)title withHight:(CGFloat) hight;
+ (void)ToastShow:(NSString *)title;

@end

#pragma mark - 这里是实现toast的类
@interface XWToast :NSObject

@property (nonatomic, strong) UILabel *labToast;
@property Boolean bShow;


/*默认的初始化toast
 *title 为需要显示的文字
 *hight 目前离最下位置的距离+hight
 */
- (void)initToastView:(NSString *)title withHight:(CGFloat) hight;

+ (instancetype)shared;

@end
