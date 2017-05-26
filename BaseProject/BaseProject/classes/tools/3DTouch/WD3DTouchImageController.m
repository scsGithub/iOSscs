//
//  WD3DTouchImageController.m
//  WuDing
//
//  Created by 张晓伟 on 2017/1/29.
//  Copyright © 2017年 吾丁网. All rights reserved.
//

#import "WD3DTouchImageController.h"

@interface WD3DTouchImageController ()

@end

@implementation WD3DTouchImageController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setImageUrl:(NSString *)imageUrl{
    
    _imageUrl = imageUrl;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [self.view addSubview:imageView];
    
}
//3Dtouch会自动调用
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    NSMutableArray *actions = [NSMutableArray array];
    for (NSString *item in _actArray) {
        
        UIPreviewAction *act = [UIPreviewAction actionWithTitle:item style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            if ([self.delegate respondsToSelector:@selector(menuActionSelectedWithController:withItem:)]) {
                [self.delegate menuActionSelectedWithController:self withItem:item];
            }
        }];
        [actions addObject:act];
    }
    return actions;
}

@end
