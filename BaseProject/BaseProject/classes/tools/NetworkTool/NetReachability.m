//
//  NetReachability.m
//  BaseProject
//
//  Created by 吾爷科技 on 2017/3/13.
//  Copyright © 2017年 飓风逍遥. All rights reserved.
//

#import "NetReachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AFNetworkActivityIndicatorManager.h>

@interface NetReachability()

@property(nonatomic,strong)NSMutableDictionary *info;

@end

@implementation NetReachability
{
    Reachability *_reachability;
}
static NetReachability *center = nil;

-(NSMutableDictionary *)info{
    if (_info == nil) {
        _info = [NSMutableDictionary dictionary];
        [_info setValue:@"网络链接异常" forKey:@"0"];
        [_info setValue:@"WIFI网络已连接" forKey:@"1"];
        [_info setValue:@"2G网络已连接" forKey:@"2"];
        [_info setValue:@"3G网络已连接" forKey:@"3"];
        [_info setValue:@"4G网络已连接" forKey:@"4"];
    }
    return _info;
}

+ (NetReachability *)shareNetworkCenter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[NetReachability alloc] init];
        [center initReachability];
    });
    return center;
}

- (void)initReachability{
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    [self reachabilityChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:Nil];
}

- (void)reachabilityChanged{
    switch (_reachability.currentReachabilityStatus) {
        case NotReachable:
            _networkStatus = NetworkStatusNone;
            break;
            
        case ReachableViaWiFi:
            _networkStatus = NetworkStatusWIFI;
            break;
            
        case ReachableViaWWAN:{
            CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
            if ([networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
                _networkStatus = NetworkStatus2G;
            }else if ([networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] ||
                      [networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA] ||
                      [networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA] ||
                      [networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA] ||
                      [networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x] ||
                      [networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
                      [networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
                      [networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]){
                _networkStatus = NetworkStatus3G;
            }else if ([networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE] ||
                      [networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]){
                _networkStatus = NetworkStatus4G;
            }
        }break;
            
        default:
            break;
    }
    [self postChangeNetworkNotification];
}

- (void)postChangeNetworkNotification{
    [HUDShow showStatusBarSuccessStr:self.info[[NSString stringWithFormat:@"%ld",(long)_networkStatus]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkDidChangeNotification object:nil];
}

@end
