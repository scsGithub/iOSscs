//
//  UIViewController+extension.m
//
//  Created by 张晓伟 on 16/5/18.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import "UIViewController+extension.h"

@implementation UIViewController (extension)

- (void)addChildController:(UIViewController *)childController intoView:(UIView *)view  {
    
    [self addChildViewController:childController];
    
    [view addSubview:childController.view];
    
    [childController didMoveToParentViewController:self];
}
- (void)presentUsePushEffectWithController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];

    [self presentViewController:viewControllerToPresent animated:flag completion:completion];
}

-(void)dismissUsePushEffectViewControllerWithAnimated:(BOOL)flag completion:(void (^)(void))completion{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:flag completion:completion];
}
@end
