//
//  UIView+extension.h
//
//  Created by 张晓伟 on 16/5/11.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat kWidth;
@property (nonatomic, assign) CGFloat kHeight;

/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;

/// 返回视图截图
- (UIImage *)snapshotImage;

+ (instancetype)viewFromXib;

+(id)cellWithTableView:(UITableView *)tableView;

- (instancetype)changeLayerWithBorderColor:(UIColor *)color withBorderWidth:(CGFloat)width withRadius:(CGFloat)radius;

- (void)removeViewWithTag:(NSInteger)tag;
@end
