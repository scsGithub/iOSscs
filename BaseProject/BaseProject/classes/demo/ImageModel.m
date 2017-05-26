//
//  ImageModel.m
//  BaseProject
//
//  Created by 张晓伟 on 16/1/14.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel

+ (ImageModel *)itemModelWithImage:(UIImage *)image imageUrl:(NSString *)imageUrl isDelete:(BOOL)isDelete {
    ImageModel *model = [ImageModel new];
    model.image = image;
    NSString *str = kSafeString(imageUrl);
    str = [str stringByReplacingOccurrencesOfString:@"!small9" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"!dplist" withString:@""];
    model.imageUrl = str;
    model.isDelete = isDelete;
    return model;
}

@end
