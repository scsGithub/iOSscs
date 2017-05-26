//
//  Toast.m
//  飓风逍遥
//
//  Created by zxw on 16/10/10.
//  Copyright © 2016年 青岛吾爷网络科技有限公司 All rights reserved.
//

#import "Toast.h"
#import <UIKit/UIFontDescriptor.h>
#define SKmScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define SKmScreenHeight ([UIScreen mainScreen].bounds.size.height)

@implementation Toast
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

+ (void)ToastShow:(NSString *)title withHight:(CGFloat) hight{
    XWToast *toast=[XWToast shared];
    
    [toast initToastView:title withHight:hight];
}
+ (void)ToastShow:(NSString *)title{
    [self ToastShow:title withHight:0];
}

@end


@implementation XWToast

+ (instancetype)shared {
    static id __staticObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __staticObject = [XWToast new];
    });
    return __staticObject;
}


- (instancetype)init
{
    if (self = [super init]) {
        _labToast=[[UILabel alloc] init];
    }
    return self;
}

- (void)initToastView:(NSString *)title withHight:(CGFloat)hight{
    
    if (!_bShow) {
        _bShow=YES;
        CGFloat fontSize = 15;
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(SKmScreenWidth-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
        
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGFloat labHight=100+hight;
        
        CGFloat hei = [UILabel getHeightByWidth:titleSize.width+20 title:title font:[UIFont systemFontOfSize:fontSize]] + 10;
        if (hight == 0) {
            labHight = ([UIApplication sharedApplication].keyWindow.frame.size.height - labHight) / 2 ;
        }

        _labToast.frame =CGRectMake(SKmScreenWidth/2-titleSize.width/2-10,SKmScreenHeight - labHight - hei, titleSize.width+20, hei);
        
        _labToast.textAlignment=1;
        _labToast.text=title;
        _labToast.numberOfLines=0;
        _labToast.alpha=1;
        _labToast.font=[UIFont systemFontOfSize:fontSize];
        _labToast.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
        _labToast.textColor=[UIColor whiteColor];
        _labToast.layer.cornerRadius=5;
        _labToast.layer.masksToBounds=YES;
        _labToast.layer.borderWidth=0;
        
        UIColor *borderColor=[UIColor grayColor];
        _labToast.layer.borderColor=[borderColor CGColor];
        
        [self animationWithView:_labToast duration:0.5];
        [window addSubview:_labToast];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _bShow=NO;
            [_labToast removeFromSuperview];
        });
    }
}

- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [view.layer addAnimation:animation forKey:nil];
}
@end
