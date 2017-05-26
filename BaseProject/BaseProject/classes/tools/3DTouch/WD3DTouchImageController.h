//
//  WD3DTouchImageController.h
//  WuDing
//
//  Created by 张晓伟 on 2017/1/29.
//  Copyright © 2017年 吾丁网. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WD3DTouchImageController;

@protocol WD3DTouchImageControllerDelegate <NSObject>

/** PreviewAction按钮点击事件代理 */
- (void)menuActionSelectedWithController:(WD3DTouchImageController *)con withItem:(NSString *)item;

@end



@interface WD3DTouchImageController : UIViewController

@property (nonatomic,copy) NSArray *actArray;

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,weak)id<WD3DTouchImageControllerDelegate> delegate;

@end
