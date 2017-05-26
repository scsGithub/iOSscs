//
//  ThirdViewController.m
//  Video
//
//  Created by 吾爷科技 on 2017/3/3.
//  Copyright © 2017年 吾爷科技. All rights reserved.
//

#import "ThirdViewController.h"
#import "DownloadedCell.h"
#import "DownloadingCell.h"
#import "MoviePlayerController.h"


@interface ThirdViewController ()<ZFDownloadDelegate>
@property (nonatomic,strong) NSMutableArray *downloadObjectArr;
@property (nonatomic,strong)ZFDownloadManager *manager;
@end

@implementation ThirdViewController
{
    CGFloat rowHeight;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    // 更新数据源
    rowHeight = 60;
    [self refreshData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部开始" style:UIBarButtonItemStylePlain target:self action:@selector(startAll)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部暂停" style:UIBarButtonItemStylePlain target:self action:@selector(pauseAll)];
    
}
-(NSArray *)dataSource{
    _manager = [ZFDownloadManager sharedDownloadManager];
    _manager.downloadDelegate = self;
    [self.manager startLoad];
    _downloadObjectArr = [NSMutableArray array];
    NSMutableArray *downladed = self.manager.finishedlist;
    NSMutableArray *downloading = self.manager.downinglist;
    [self.downloadObjectArr addObject:downladed];
    [self.downloadObjectArr addObject:downloading];
    return _downloadObjectArr;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *downloadedID = @"downloadedCell";
        DownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadedID];
        if (cell == nil) {
            cell = [[DownloadedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downloadedID withHeight:rowHeight];
        }
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        cell.fileInfo = fileInfo;
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *downloadingID = @"downloadingCell";
        DownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadingID];
        if (cell == nil) {
            cell = [[DownloadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downloadingID withHeight:rowHeight];
        }
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        if (request == nil) { return nil; }
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        
        __weak typeof(self) weakSelf = self;
        // 下载按钮点击时候的要刷新列表
        cell.btnClickBlock = ^{
            [weakSelf refreshData];
        };
        // 下载模型赋值
        cell.fileInfo = fileInfo;
        // 下载的request
        cell.request = request;
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        return;
    }
    MoviePlayerController *player = [MoviePlayerController new];
    ZFFileModel *fileModel = self.downloadObjectArr[indexPath.section][indexPath.row];
    // 文件存放路径
    NSString *path = FILE_PATH(fileModel.fileName);
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    
    ZFPlayerModel *model = [ZFPlayerModel new];
    model.videoURL = videoURL;
    player.model = model;
    player.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:player animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        [_manager deleteFinishFile:fileInfo];
    }else if (indexPath.section == 1) {
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        [_manager deleteRequest:request];
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [self refreshData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @[@"下载完成",@"下载中"][section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (((NSArray *)self.downloadObjectArr[section]).count == 0) {
        return 0;
    }
    else return 40;
}

#pragma mark - ZFDownloadDelegate

// 开始下载
- (void)startDownload:(ZFHttpRequest *)request {
    NSLog(@"开始下载!");
}

// 下载中
- (void)updateCellProgress:(ZFHttpRequest *)request {
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

// 下载完成
- (void)finishedDownload:(ZFHttpRequest *)request {
    [self refreshData];
}

// 更新下载进度
- (void)updateCellOnMainThread:(ZFFileModel *)fileInfo {
    NSArray *cellArr = [self.tableview visibleCells];
    for (id obj in cellArr) {
        if([obj isKindOfClass:[DownloadingCell class]]) {
            DownloadingCell *cell = (DownloadingCell *)obj;
            if([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL]) {
                cell.fileInfo = fileInfo;
            }
        }
    }
}
/** 全部开始 */
-(void)startAll{
    [_manager startAllDownloads];
}
/** 全部暂停 */
-(void)pauseAll{
    [_manager pauseAllDownloads];
}
@end
