//
//  CutPhotoViewController.h
//  BaseProject
//
//  Created by 张晓伟 on 16/5/10.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "BaseViewController.h"

@class  CutPhotoViewController;

@protocol CutPhotoViewControllerDelegate <NSObject>

- (void)imageCropper:(CutPhotoViewController *)cropper didFinishCroppingWithImage:(UIImage *)image;

@end

@interface CutPhotoViewController : BaseViewController 

@property (nonatomic, assign) id <CutPhotoViewControllerDelegate> delegate;

- (instancetype)initWithImage:(UIImage*)newImage cropSize:(CGSize)cropSize title:(NSString *)title isLast:(BOOL)isLast;

@end


