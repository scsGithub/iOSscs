//
//  PhotosViewController.h
//  BaseProject
//
//  Created by 张晓伟 on 16/5/18.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "BaseCollectionViewController.h"

@interface PhotosViewController : BaseCollectionViewController

@property (nonatomic,assign) NSInteger photoCount;//最大添加照片数
@property (nonatomic,copy) void (^completion)(PhotosViewController *vc, NSArray *photos);
@end
