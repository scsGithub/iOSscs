//
//  DownloadedCell.h
//  Video
//
//  Created by 吾爷科技 on 2017/3/3.
//  Copyright © 2017年 吾爷科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFDownload/ZFDownloadManager.h>

@interface DownloadedCell : UITableViewCell
@property (nonatomic,strong) UILabel *fileNameLabel;
@property (nonatomic,strong) UILabel *sizeLabel;
/** 下载信息模型 */
@property (nonatomic,strong) ZFFileModel *fileInfo;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withHeight:(CGFloat)hei;

@end
