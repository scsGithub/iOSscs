//
//  UITabBar+extension.m
//  BaseProject
//
//  Created by 张晓伟 on 2017/3/7.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "UITabBar+extension.h"
#import "AppDelegate.h"

@implementation UITabBar (extension)
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSInteger tabbarItemNums = dele.baseTabBar.viewControllers.count;
    
    //确定小红点的位置
    float percentX = (index +0.6) / tabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:badgeView];
}
    
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}
    
- (void)removeBadgeOnItemIndex:(int)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}

@end
