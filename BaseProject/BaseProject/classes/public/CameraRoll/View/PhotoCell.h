//
//  PhotoCell.h
//  BaseProject
//
//  Created by 张晓伟 on 16/5/18.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface PhotoCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
