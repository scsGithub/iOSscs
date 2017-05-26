//
//  WD3DTouchImageView.m
//  WuDing
//
//  Created by 张晓伟 on 2017/1/29.
//  Copyright © 2017年 吾丁网. All rights reserved.
//

#import "WD3DTouchImageView.h"

@interface WD3DTouchImageView ()<UIViewControllerPreviewingDelegate>

@end

@implementation WD3DTouchImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self add3DTouch];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self add3DTouch];
    }
    return self;
}

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}


-(void)add3DTouch{
    //判断是否支持3DTouch
    if (self.getViewController.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        //注册Cell支持3DTouch,并设置代理
        [self.getViewController registerForPreviewingWithDelegate:self sourceView:self];
    }else {
        NSLog(@"3D Touch 无效");
    }
}
//当中度按压时调用该方法
//previewingContext:可以从该参数中获取之前注册的View.
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    
    // 用于显示预览的vc
    WD3DTouchImageController *con = [WD3DTouchImageController new];
    con.imageUrl = _imageUrl;
    con.hidesBottomBarWhenPushed = YES;
    
    con.actArray = @[@"one",@"two",@"three"];
    
    con.view.backgroundColor = [UIColor purpleColor];
    // 演示的是传入一个字符串 , 实际可能是你需要的model
    
    con.preferredContentSize = CGSizeMake(200.0f,300.0f);
    con.title = @"dsadasada";
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    CGRect rect = CGRectMake(0, 50, self.kWidth,40);

    previewingContext.sourceRect = rect;
    
    return con;
}

//弹框出现后,继续重按时调用
//viewControllerToCommit:就是上面传入的控制器.
//commitViewController默认是UIViewController,因为peek时返回的控制器是一个导航控制器.那么在这里面自己手动改成的导航控制器.
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UINavigationController *)viewControllerToCommit{
    
    
        //获取导航控制器的根控制器.因为当前已经是一个导航控制器了,不能再继续push一个导航控制器,所以要先获取peek的导航控制器里面的根控制器.
        //然后再拿当前的控制器把获取的控制器push进去.
        WD3DTouchImageController *con = [WD3DTouchImageController new];
        con.title = @"重压";
        //使用show和push是一样的效果
        [self.getViewController showViewController:con sender:self];
}


@end
