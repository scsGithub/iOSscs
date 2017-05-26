//
//  PhotoSecondCollectionViewCell.h
//  BaseProject
//
//  Created by 张晓伟 on 16/5/18.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@interface PhotoSecondCollectionViewCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;//相册相片
@property (weak, nonatomic) IBOutlet UILabel *redDotLabel;//小红点

@end
