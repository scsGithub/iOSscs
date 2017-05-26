//
//  movieTabbarController.m
//  BaseProject
//
//  Created by 吾爷科技 on 2017/3/10.
//  Copyright © 2017年 飓风逍遥. All rights reserved.
//

#import "MovieTabbarController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "BaseNavigationController.h"

@interface MovieTabbarController ()

@end

@implementation MovieTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    FirstViewController *first = [FirstViewController new];
    SecondViewController *second = [SecondViewController new];
    ThirdViewController *third = [ThirdViewController new];
    
    [self setWithController:first withImageName:@"tab_index" withTitle:@"普通播放"];
    [self setWithController:second withImageName:@"tab_classify" withTitle:@"cell播放"];
    [self setWithController:third withImageName:@"tab_shopcar" withTitle:@"下载列表"];
}
//给每个Controller加入到TabBar中
-(void)setWithController:(UIViewController *)controller withImageName:(NSString *)imageName withTitle:(NSString *)title
{
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:[imageName stringByAppendingString:@"select"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.title = title;
    
    BaseNavigationController *navigation = [[BaseNavigationController alloc]initWithRootViewController:controller];
    //去除navigationBar的磨砂效果
    navigation.navigationBar.translucent = NO;
    
    //设置tabbar文字yanse
    [self.tabBar setTintColor:[UIColor colorWithRed:0.14 green:0.568 blue:0.2745 alpha:1]];
    
    //去除scrollView导航条的偏移效果（给ViewController添加属性）
    controller.edgesForExtendedLayout = UIRectEdgeNone;
    navigation.navigationBar.hidden = NO;
    [self addChildViewController:navigation];
}


@end
