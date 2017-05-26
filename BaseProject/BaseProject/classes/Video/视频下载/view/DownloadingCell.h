//
//  DownloadingCell.h
//  Video
//
//  Created by 吾爷科技 on 2017/3/3.
//  Copyright © 2017年 吾爷科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFDownload/ZFDownloadManager.h>

typedef void(^ZFBtnClickBlock)(void);

@interface DownloadingCell : UITableViewCell

@property (nonatomic,strong) UILabel *fileNameLabel;
@property (nonatomic,strong) UIProgressView *progress;
@property (nonatomic,strong) UILabel *progressLabel;
@property (nonatomic,strong) UILabel *speedLabel;
@property (nonatomic,strong) UIButton *downloadBtn;
/** 下载按钮点击回调block */
@property (nonatomic, copy  ) ZFBtnClickBlock btnClickBlock;
/** 下载信息模型 */
@property (nonatomic, strong) ZFFileModel *fileInfo;
/** 该文件发起的请求 */
@property (nonatomic,retain ) ZFHttpRequest *request;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withHeight:(CGFloat)hei;

@end
