//
//  HXHomeViewController.m
//  BaseProject
//
//  Created by 张晓伟 on 16/1/14.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "HomeViewController.h"

#import "AddImageViewController.h"

#import "DemoCurrencyCell.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self.tableview registerNib:[UINib nibWithNibName:@"DemoCurrencyCell" bundle:nil] forCellReuseIdentifier:@"DemoCurrencyCell"];
    [self removedRefreshing];
    [self request];
    //只需要向self.dataSouce中传入数据  就可以实现数据的刷新
    
}
-(NSArray *)getData{
    NSMutableArray *arr = [NSMutableArray array];
    
    NSMutableArray *subarr = nil;
    NSDictionary *dict = nil;
    
    //section 0
    subarr = [NSMutableArray array];
    dict =  @{@"class":DemoCurrencyCell.class,
              @"height":@([DemoCurrencyCell getCellFrame:nil]),
              @"data":[DemoCurrencyCellModel itemModelWithTitle:@"单张图片上传示例"],
              @"action":@"uploadData",
              @"delegate":@YES};
    [subarr addObject:dict];
    [arr addObject:subarr];
    
    //section 1
    subarr = [NSMutableArray array];
    
    //row 0
    dict =  @{@"class":DemoCurrencyCell.class,
              @"height":@([DemoCurrencyCell getCellFrame:nil]),
              @"data":[DemoCurrencyCellModel itemModelWithTitle:@"去图片上传界面"],
              @"action":@"gotoAddImageViewController",
              @"delegate":@YES};
    [subarr addObject:dict];
    
    //row 1
    dict =  @{@"class":DemoCurrencyCell.class,
              @"height":@([DemoCurrencyCell getCellFrame:nil]),
              @"data":[DemoCurrencyCellModel itemModelWithTitle:@"网络请求示例"],
              @"action":@"request",
              @"delegate":@YES};
    [subarr addObject:dict];
    
    [arr addObject:subarr];
    return arr;
}

#pragma mark - goto

//网络请求
- (void)request {
    [[NetworkTools manager] downLoadWithMethod:GET withURL:@"https://c.selanwang.com/index.php?act=index" withParam:nil success:^(id responseObject) {
        NSLog(@"%@",[responseObject dictToJson]);
        self.dataSource = [self getData];
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)gotoAddImageViewController {
    AddImageViewController *vc = [AddImageViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)uploadData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ceshi.jpg" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    
    [self.uploadManager uploadData:data type:nil progress:nil completion:^(NSError *error, NSString *link,NSData *data,NSInteger index) {
        NSLog(@"上传成功 图片地址:%@",link);
    }];
}

@end
