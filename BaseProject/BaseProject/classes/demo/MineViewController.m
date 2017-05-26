//
//  MineViewController.m
//  BaseProject
//
//  Created by 吾爷科技 on 2017/3/7.
//  Copyright © 2017年 飓风逍遥. All rights reserved.
//

#import "MineViewController.h"
#import "MovieTabbarController.h"
#import "ZhiFuBaoPay.h"
#import "WeChatPay.h"
#import "ThirdLoginTools.h"

@interface MineViewController ()

@end

@implementation MineViewController
{
    ThirdLoginTools *third;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    third = [ThirdLoginTools new];
    [self.tableview registerClass:[BaseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BaseTableViewCell class])];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self showLoadMoreRefreshing];
    
}
-(void)requestData{
    NSLog(@"数据请求:%ld",(long)self.pageIndex);
    NSArray *arr =  @[@"类名push",@"tab跳转",@"视频模块",@"支付宝测试",@"微信测试",@"QQ登录测试",@"微信登录测试",@"SV_Info",@"SV_Success",@"SV_Error",@"SV_Img_Title",@"Toast"];
    NSMutableArray *muarr = [NSMutableArray array];
    
    if (self.pageIndex == 1) {
        muarr = [NSMutableArray arrayWithArray:arr];
    }else{
        muarr = [NSMutableArray arrayWithArray:self.dataSource];
        [muarr addObjectsFromArray:arr];
    }
    self.dataSource = muarr;
    [self refreshData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:{
            //类名push
            [self pushViewControllerWithName:@"HomeViewController"];
        }break;
        case 1:{
            //tab跳转
            [self popToHomePageWithTabIndex:1 completion:nil];
        }break;
        case 2:{
            //视频模块
            MovieTabbarController *movieTab = [MovieTabbarController new];
            [self presentUsePushEffectWithController:movieTab animated:NO completion:nil];
        }break;
        case 3:{
            //支付宝测试
            ZhiFuBaoPay *aliPay = [ZhiFuBaoPay shareManager];
            BizContent *goods = [BizContent new];
            goods.body = @"测试商品";
            goods.subject = @"1";
            goods.timeout_express = @"30m";
            goods.total_amount = @"0.01";
            [aliPay startClientPayWithGoods:goods];
            
        }break;
        case 4:{
            //微信测试
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setValue:@"测试商品" forKey:@"body"];
            [param setValue:@"0.01" forKey:@"payamount"];
            [param setValue:[[WeChatClientPayMethod alloc] generateTradeNO] forKey:@"paysn"];
            
            [WeChatPay wechatClientPayWithInfo:param];
            //    [WeChatPay wechatPayWithInfo:param];
            
        }break;
        case 5:{
            //QQ登录测试
            [third qqLoginSuccess:^(NSDictionary *qqInfo) {
                NSLog(@"%@",[qqInfo dictToJson]);
            } failure:^(NSString *loginError) {
                NSLog(@"%@",loginError);
            }];
            
        }break;
        case 6:{
            //微信登录测试
            [third wxLoginSuccess:^(NSDictionary *info) {
                NSLog(@"%@",[info dictToJson]);
            } failure:^(NSString *loginError) {
                NSLog(@"%@",loginError);
            }];
            
        }break;
        case 7:{
            //SV_Info
            [SVProgressHUD showInfoWithStatus:@"请……………………"];
        }break;
        case 8:{
            //SV_Success
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }break;
        case 9:{
            //SV_Error
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }break;
        case 10:{
            //SV_Img_Title
            [SVProgressHUD showImage:nil status:@"加载中"];
            [SVProgressHUD setMinimumSize:CGSizeFromString(@"加载中")];
            [SVProgressHUD dismissWithDelay:1.0f];

        }break;
        case 11:{
            [Toast ToastShow:@"加载中……"];
        }break;
        default:
            break;
    }
}

@end
