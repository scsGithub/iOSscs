//
//  PhotoPreviewViewController.h
//  BaseProject
//
//  Created by 张晓伟 on 16/5/10.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "BaseViewController.h"

@interface PhotoPreviewViewController : BaseViewController

@property (nonatomic,copy) NSString *superTitle;

//删除照片
@property (nonatomic,copy) void (^deleteCompletion)(PhotoPreviewViewController *vc, NSArray *photos,id currentDeleteImage);

/**
 *  初始化
 *
 *  @param photos 需要显示的照片，可以是ALAsset或者UIImage
 *  @param index  显示第几张 index 防止越界
 *
 */
- (instancetype)initWithPhotos:(NSArray *)photos index:(NSInteger)index;

@end
