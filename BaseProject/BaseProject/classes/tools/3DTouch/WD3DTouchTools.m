//
//  WD3DTouchTools.m
//  飓风逍遥
//
//  Created by 吾爷科技 on 2017/1/18.
//  Copyright © 2017年 青岛吾爷网络科技有限公司. All rights reserved.
//

#import "WD3DTouchTools.h"

@implementation WD3DTouchTools

+(void)createShortcutItemWithResource:(NSString *)resource{
    // 创建系统风格的icon
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *muarr = [NSMutableArray array];
    for (NSDictionary *obj in array) {
        
        NSString *imageName = obj[@"image"];
        NSString *type = obj[@"type"];
        NSString *title = obj[@"title"];
        NSString *subTitle = obj[@"subtitle"];
        
        UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:imageName];
        
        UIApplicationShortcutItem *item;
        
        item = [[UIApplicationShortcutItem alloc]initWithType:type localizedTitle:title localizedSubtitle:subTitle icon:icon userInfo:nil];

        [muarr addObject:item];
    }
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = muarr;

}
+(void)dealWithShortcutItem:(UIApplicationShortcutItem *)shortcutItem{
    if (shortcutItem) {
        if ([shortcutItem.type isEqualToString:@"scanner"]){
            
        }else if ([shortcutItem.type isEqualToString:@"clear"]){
            //清理图片缓存
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];//可有可无

            NSLog(@"缓存清理完毕");
        }
        
    }
}
@end
