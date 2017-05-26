//
//  PlayerCell.h
//  Video
//
//  Created by 吾爷科技 on 2017/3/3.
//  Copyright © 2017年 吾爷科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"
#import "VideoModel.h"

typedef void(^PlayBtnCallBackBlock)(UIButton *);

@interface PlayerCell : UITableViewCell

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIImageView *picView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *playBtn;

/** model */
@property (nonatomic, strong) VideoModel *model;
/** 播放按钮block */
@property (nonatomic, copy) PlayBtnCallBackBlock playBlock;

@end
