//
//  BaseTableViewController.m
//  BaseProject
//
//  Created by 张晓伟 on 16/5/10.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@property (nonatomic,strong) MJRefreshNormalHeader *header;
@property (nonatomic,strong) MJRefreshBackNormalFooter *footer;
@property (nonatomic,strong) UIButton *backToTopBtn;//返回顶部按钮

@end

@implementation BaseTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self header];
    [self footer];
    [self.view addSubview:self.tableview];
    [self hideLoadMoreRefreshing];
    self.tableview.tableFooterView = [UIView new];
}

#pragma mark - 网络请求

- (void)requestData {
    [self endRefreshing];
}

#pragma mark UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource.count > 0) {
        return self.dataSource.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource.count > 0) {
        id obj = self.dataSource[section];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)obj;
            return [arr count];
        }
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > 0) {
        
        id obj = self.dataSource[indexPath.section];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *section = (NSArray *)obj;
            
            id dicObj = section[indexPath.row];
            if ([dicObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *cellDict = (NSDictionary *)dicObj;
                
                Class classs = cellDict[@"class"];
                
                BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(classs)];
                if (!cell) {
                    cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(classs)];
                }
                
                [cell setSeperatorLineForIOS7:indexPath numberOfRowsInSection:section.count];
                
                NSNumber *delFlag = cellDict[@"delegate"];
                
                id delegate = nil;
                
                if (delFlag && delFlag.boolValue) {
                    delegate = self;
                }
                
                [cell setData:cellDict delegate:delegate];
                
                return cell;
            }
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    NSString *numStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    NSString *title = self.dataSource[indexPath.section];
    cell.textLabel.text = [title isEqualToString:@""] ? numStr : title ;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > 0) {
        id obj = self.dataSource[indexPath.section];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *section = (NSArray *)obj;
            
            id dicObj = section[indexPath.row];
            if ([dicObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *cellDict = (NSDictionary *)dicObj;
                float height = [cellDict[@"height"] floatValue];
                return height;
            }
        } else {
            return 44;
        }
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataSource.count > 0) {
        
        id obj = self.dataSource[indexPath.section];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *section = (NSArray *)obj;
            
            id dicObj = section[indexPath.row];
            if ([dicObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *cellDict = (NSDictionary *)dicObj;
                
                if ([cellDict[@"action"] length] > 0) {
                    NSString *actiongStr = cellDict[@"action"];
                    SEL customSelector = NSSelectorFromString(actiongStr);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self performSelector:customSelector];
#pragma clang diagnostic pop
                }
            }
        }
    }
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    if (scrollView.contentOffset.y >= 300) {
        [self showBackToTopBtn];
    }else{
        [self hideBackToTopBtn];
    }
}

#pragma mark - refreshData

/**
 *  刷新tableView
 */
- (void)refreshData {
    [self.tableview reloadData];
    [self endRefreshing];
}

/**
 数据源

 @param dataSource 数据源数据
 */
-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self refreshData];
}
#pragma mark - 返回顶部

//显示返回顶部按钮
- (void)showBackToTopBtn {
    if ( _backToTopBtn == nil) {
        _backToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backToTopBtn.frame = CGRectMake(self.view.width - 36 - 20, self.view.height - 36 - 20, 36, 36);
        [_backToTopBtn setBackgroundImage:[UIImage imageNamed:@"back_to_top"] forState:UIControlStateNormal];
        [_backToTopBtn addTarget:self action:@selector(onBackToTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backToTopBtn];
    }
    else{
        [self.view bringSubviewToFront:_backToTopBtn];
    }
    
    _backToTopBtn.alpha = 1.0f;
}

//隐藏返回顶部按钮
- (void)hideBackToTopBtn {
    [UIView animateWithDuration:0.3 animations:^{
        _backToTopBtn.alpha = 0.0;
    }];
}

//返回顶部事件
- (void)onBackToTopBtnClick {
    [self.tableview setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - MJRefresh上下拉加载

- (void)refresh {
    self.pageIndex = 1;
    [self requestData];
}

- (void)loadMore {
    self.pageIndex ++;
    [self requestData];
}

- (void)endRefreshing {
    if (_header) {
        [self.header endRefreshing];
    }
    if (_footer) {
        [self.footer endRefreshing];
    }
}

- (void)removedRefreshing {
    _header = nil;
    _footer = nil;
    self.tableview.mj_header = nil;
    self.tableview.mj_footer = nil;
}

- (void)showLoadMoreRefreshing {
    self.footer.hidden = NO;
}

- (void)hideLoadMoreRefreshing {
    self.footer.hidden = YES;
}

- (MJRefreshNormalHeader *)header {
    if (!_header) {
        __weak __typeof(self)weakSelf = self;
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof(self)self = weakSelf;
            [self refresh];
        }];
        self.tableview.mj_header = _header;
    }
    return [self setRefreshNormalHeaderParameter:_header];
}

- (MJRefreshBackNormalFooter *)footer {
    if (!_footer) {
        __weak __typeof(self)weakSelf = self;
       _footer = [self.tableview addWithRefreshFooter:^{
            __strong __typeof(self)self = weakSelf;
            [self loadMore];
        }];
        self.tableview.mj_footer = _footer;
    }
    return [self setRefreshBackNormalFooterParameter:_footer];
}

#pragma mark - 懒加载

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}

@end
