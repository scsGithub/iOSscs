//
//  BaseTabBarController.m
//  BaseProject
//
//  Created by 张晓伟 on 16/1/14.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "BaseTableViewController.h"
#import "SVProgressHUD.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSVProgressHUD];
    [self removeTabarTopLine];
    [self setViewControllers];

}

- (void)viewWillLayoutSubviews{
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.origin.y = self.view.frame.size.height - self.tabBar.frame.size.height;
    self.tabBar.frame = tabFrame;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.4)];
    line.backgroundColor = [UIColor grayColor];
    [self.tabBar addSubview:line];
}

- (void)setSVProgressHUD {
    //SVProgressHUDMaskType 设置显示的样式
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight]; //样式使用自定义
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];// 整个后面的背景选择
    [SVProgressHUD setBackgroundColor:[UIColor darkGrayColor]];// 弹出框颜色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];// 弹出框内容颜色
    CGFloat hubW = 100;
    [SVProgressHUD setMinimumSize:CGSizeMake(hubW, hubW)];
}

- (void)setViewControllers {
    //UITabBarController 数据源
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TabBarConfigure" ofType:@"plist"];
    NSArray *dataAry = [[NSArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary *dataDic in dataAry) {
        //每个tabar的数据po
        Class classs = NSClassFromString(dataDic[@"class"]);
        NSString *title = dataDic[@"title"];
        NSString *imageName = dataDic[@"image"];
        NSString *selectedImage = dataDic[@"selectedImage"];
        NSString *badgeValue = dataDic[@"badgeValue"];
        
        [self addChildViewController:[self itemChildViewController:classs title:title imageName:imageName selectedImage:selectedImage badgeValue:badgeValue]];
    }
}

- (BaseNavigationController *)itemChildViewController:(Class)classs title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage badgeValue:(NSString *)badgeValue {
    
    UIViewController *vc = [classs new];
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[[UIImage imageNamed:selectedImage] imageToColor:kUIToneBackgroundColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //起点-8图标才会到顶，然后加上计算出来的y坐标
    float origin = -9 + 6;
    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(origin, 0, -origin,0);
    vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(-2 + 8, 2-8);
    //title设置
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kUIToneBackgroundColor,NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
    vc.tabBarItem.title = title;
    
    //小红点
    vc.tabBarItem.badgeValue = badgeValue.intValue > 0 ? badgeValue : nil;
    //导航
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.topItem.title = title;
    [nav.rootVcAry addObject:classs];
    return nav;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [SVProgressHUD dismiss];
}

#pragma 设置小红点数值
//设置指定tabar 小红点的值
- (void)setBadgeValue:(NSString *)badgeValue index:(NSInteger)index {
    if (index + 1 > self.viewControllers.count || index < 0) {
        //越界或者数据异常直接返回
        return;
    }
    BaseNavigationController *base = self.viewControllers[index];
    if (base.viewControllers.count == 0) {
        return;
    }
    UIViewController *vc = base.viewControllers[0];
    vc.tabBarItem.badgeValue = badgeValue.intValue > 0 ? badgeValue : nil;
}

#pragma 设置小红点显示或者隐藏

//显示小红点 没有数值
- (void)showBadgeWithIndex:(int)index {
    [self.tabBar showBadgeOnItemIndex:index];
}

//隐藏小红点 没有数值
- (void)hideBadgeWithIndex:(int)index {
    [self.tabBar hideBadgeOnItemIndex:index];
}

#pragma mark - 去掉tabBar顶部线条

//去掉tabBar顶部线条
- (void)removeTabarTopLine {
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
