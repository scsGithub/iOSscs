//
//  UIViewController+extension.h
//
//  Created by 张晓伟 on 16/5/18.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (extension)

/**
 * 在当前视图控制器中添加子控制器，将子控制器的视图添加到 view 中
 *
 * @param childController 要添加的子控制器
 * @param view            要添加到的视图
 */
- (void)addChildController:(UIViewController *)childController intoView:(UIView *)view;


/**
 present模态使用push的转场效果(进入)

 @param viewControllerToPresent viewControllerToPresent
 @param flag 是否有转场效果
 @param completion 转场完成后回调
 */
- (void)presentUsePushEffectWithController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

/**
 present模态使用push的转场效果(退出)
 
 @param flag 是否有转场效果
 @param completion 转场完成后回调
 */
-(void)dismissUsePushEffectViewControllerWithAnimated:(BOOL)flag completion:(void (^)(void))completion;
@end
