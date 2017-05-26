//
//  DownloadedCell.m
//  Video
//
//  Created by 吾爷科技 on 2017/3/3.
//  Copyright © 2017年 吾爷科技. All rights reserved.
//

#import "DownloadedCell.h"

@implementation DownloadedCell
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
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, cellHeight - 20 - 10, cellHeight - 10 * 2)];
    
    _fileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(image.x + image.width + 5, 10, self.kWidth - 15 - image.x - image.width, 20)];
    
    _sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.kWidth - 100, _fileNameLabel.y + _fileNameLabel.height, 90, 20)];
    
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.image = [UIImage imageNamed:@"file"];
    
    _fileNameLabel.font = [UIFont systemFontOfSize:15];
    _sizeLabel.font = [UIFont systemFontOfSize:13];
    
    _fileNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _sizeLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:image];
    [self.contentView addSubview:_fileNameLabel];
    [self.contentView addSubview:_sizeLabel];
}


-(void)setFileInfo:(ZFFileModel *)fileInfo{
    _fileInfo = fileInfo;
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    self.fileNameLabel.text = fileInfo.fileName;
    self.sizeLabel.text = totalSize;
}

@end
