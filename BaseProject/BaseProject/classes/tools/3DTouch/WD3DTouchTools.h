//
//  WD3DTouchTools.h
//  飓风逍遥
//
//  Created by 吾爷科技 on 2017/1/18.
//  Copyright © 2017年 青岛吾爷网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WD3DTouchTools : NSObject

+(void)createShortcutItemWithResource:(NSString *)resource;

+(void)dealWithShortcutItem:(UIApplicationShortcutItem *)shortcutItem;

@end
