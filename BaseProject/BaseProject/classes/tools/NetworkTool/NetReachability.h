//
//  NetReachability.h
//  BaseProject
//
//  Created by 吾爷科技 on 2017/3/13.
//  Copyright © 2017年 飓风逍遥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability.h>

typedef NS_ENUM(NSInteger,NetWorkStatus){
    NetworkStatusNone = 0,
    NetworkStatusWIFI = 1,
    NetworkStatus2G = 2,
    NetworkStatus3G = 3,
    NetworkStatus4G = 4
};

@interface NetReachability : NSObject

@property(nonatomic,assign,readonly) NetWorkStatus networkStatus;

+ (NetReachability *)shareNetworkCenter;

@end
