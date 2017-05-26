//
//  ZhiFuBaoPay.h
//  飓风逍遥
//
//  Created by zxw on 2017/1/5.
//  Copyright © 2017年 青岛吾爷网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"

@interface ZhiFuBaoPay : NSObject
+ (instancetype) shareManager;
- (void)startPayWithInfo:(NSDictionary *)info;
- (void)startClientPayWithGoods:(BizContent *) goods;

@end
