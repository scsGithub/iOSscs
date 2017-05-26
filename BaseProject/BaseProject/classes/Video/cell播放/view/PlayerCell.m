//
//  PlayerCell.m
//  Video
//
//  Created by 吾爷科技 on 2017/3/3.
//  Copyright © 2017年 吾爷科技. All rights reserved.
//

#import "PlayerCell.h"

@implementation PlayerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self cutRoundView:self.avatarImageView];
//
        // 设置imageView的tag，在PlayerView中取（建议设置100以上）
        self.picView.tag = 101;
//
        // 代码添加playerBtn到imageView上
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
        [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        [self.picView addSubview:self.playBtn];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.picView);
            make.width.height.mas_equalTo(50);
        }];

    }
    return self;
}
-(void)setupUI{
    
    CGFloat marginToLeft = 10;
    CGFloat marginToTop = 5;
    CGFloat avatarW = 60;
    CGFloat margin = 5;
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginToLeft, marginToTop, avatarW, avatarW)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(marginToLeft, _avatarImageView.y + _avatarImageView.height + margin / 2, self.kWidth - marginToLeft * 2, 0.3)];
    line.backgroundColor = [UIColor colorWithHex:0xcccccc];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.x + avatarW + margin, _avatarImageView.y, self.kWidth - margin - marginToLeft * 2 - avatarW, avatarW / 2)];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.x + avatarW + margin, _titleLabel.y + _titleLabel.height, _titleLabel.width, _titleLabel.height)];
    _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginToLeft, _avatarImageView.y + _avatarImageView.height + margin, self.kWidth - marginToLeft * 2, 30)];
    _picView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _subTitleLabel.y + _subTitleLabel.height + margin, self.kWidth, 180)];
    _picView.userInteractionEnabled = YES;

    _avatarImageView.image = [UIImage imageNamed:@"defaultUserIcon"];
    _subTitleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_avatarImageView];
    [self.contentView addSubview:line];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_subTitleLabel];
    [self.contentView addSubview:_picView];

}

// 切圆角
- (void)cutRoundView:(UIImageView *)imageView {
    CGFloat corner = imageView.frame.size.width / 2;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
    shapeLayer.path = path.CGPath;
    imageView.layer.mask = shapeLayer;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setModel:(VideoModel *)model {
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.coverForFeed] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.video_description;
    self.timeLabel.text = model.date;
}

- (void)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}



@end
