//
//  DownloadingCell.m
//  Video
//
//  Created by 吾爷科技 on 2017/3/3.
//  Copyright © 2017年 吾爷科技. All rights reserved.
//

#import "DownloadingCell.h"

@implementation DownloadingCell
{
    CGFloat cellHeight;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withHeight:(CGFloat)hei{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        cellHeight = hei;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    CGFloat margin = 20;
    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(margin, cellHeight / 2 - 1, self.kWidth - margin * 2 - 30, 2)];
    _fileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 5, self.kWidth - margin * 3, 25)];
    _progressLabel = [[UILabel alloc] initWithFrame:_fileNameLabel.frame];
    _progressLabel.width = _fileNameLabel.width / 3 * 2;
    _progressLabel.y = _progress.y + _progress.height + 5;
    
    _speedLabel = [[UILabel alloc] initWithFrame:_progressLabel.frame];
    _speedLabel.x = _progressLabel.x + _progressLabel.width;
    _speedLabel.width = _fileNameLabel.width / 3 ;
    
    _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downloadBtn.frame = CGRectMake(_progress.x + _progress.width + margin, 20, 20, 20);
    [_downloadBtn setImage:[UIImage imageNamed:@"menu_pause"] forState:UIControlStateNormal];
    [_downloadBtn setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateSelected];
    [_downloadBtn addTarget:self action:@selector(clickDownload:) forControlEvents:UIControlEventTouchUpInside];
    
    _speedLabel.textAlignment = NSTextAlignmentRight;
    
    _speedLabel.font = [UIFont systemFontOfSize:14];
    _fileNameLabel.font = [UIFont systemFontOfSize:14];
    _progressLabel.font = [UIFont systemFontOfSize:14];

    [self.contentView addSubview:_fileNameLabel];
    [self.contentView addSubview:_progressLabel];
    [self.contentView addSubview:_progress];
    [self.contentView addSubview:_speedLabel];
    [self.contentView addSubview:_downloadBtn];

}

- (void)clickDownload:(UIButton *)btn {
    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    btn.userInteractionEnabled = NO;
    ZFFileModel *downFile = self.fileInfo;
    ZFDownloadManager *filedownmanage = [ZFDownloadManager sharedDownloadManager];
    if(downFile.downloadState == ZFDownloading) { //文件正在下载，点击之后暂停下载 有可能进入等待状态
        self.downloadBtn.selected = YES;
        [filedownmanage stopRequest:self.request];
    } else {
        self.downloadBtn.selected = NO;
        [filedownmanage resumeRequest:self.request];
    }
    
    // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
    btn.userInteractionEnabled = YES;
}

- (void)setFileInfo:(ZFFileModel *)fileInfo {
    _fileInfo = fileInfo;
    self.fileNameLabel.text = fileInfo.fileName;
    // 服务器可能响应的慢，拿不到视频总长度 && 不是下载状态
    if ([fileInfo.fileSize longLongValue] == 0 && !(fileInfo.downloadState == ZFDownloading)) {
        self.progressLabel.text = @"";
        if (fileInfo.downloadState == ZFStopDownload) {
            self.speedLabel.text = @"已暂停";
        } else if (fileInfo.downloadState == ZFWillDownload) {
            self.downloadBtn.selected = YES;
            self.speedLabel.text = @"等待下载";
        }
        self.progress.progress = 0.0;
        return;
    }
    NSString *currentSize = [ZFCommonHelper getFileSizeString:fileInfo.fileReceivedSize];
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%@ / %@ (%.2f%%)",currentSize, totalSize, progress*100];
    
    self.progress.progress = progress;
    
    NSString *spped = [NSString stringWithFormat:@"%@/S",[ZFCommonHelper getFileSizeString:[NSString stringWithFormat:@"%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]]]];
    self.speedLabel.text = spped;
    
    if (fileInfo.downloadState == ZFDownloading) { //文件正在下载
        self.downloadBtn.selected = NO;
    } else if (fileInfo.downloadState == ZFStopDownload&&!fileInfo.error) {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"已暂停";
    }else if (fileInfo.downloadState == ZFWillDownload&&!fileInfo.error) {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"等待下载";
    } else if (fileInfo.error) {
        self.downloadBtn.selected = YES;
        self.speedLabel.text = @"错误";
    }
}

@end
