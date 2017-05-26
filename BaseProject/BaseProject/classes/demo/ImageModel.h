//
//  ImageModel.h
//  BaseProject
//
//  Created by 张晓伟 on 16/1/14.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "BaseModel.h"

@interface ImageModel : BaseModel

@property (nonatomic,strong) UIImage *image;//刚从相册或者相机中添加的照片
@property (nonatomic,copy) NSString *imageUrl;//图片地址 该地址指的是网络地址
@property (nonatomic,assign) BOOL isDelete;//是否被删除 默认未被删除

+ (ImageModel *)itemModelWithImage:(UIImage *)image imageUrl:(NSString *)imageUrl isDelete:(BOOL)isDelete;

@end
