//
//  VideoModel.m
//  Video
//
//  Created by 吾爷科技 on 2017/3/3.
//  Copyright © 2017年 吾爷科技. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 转换系统关键字description
    if ([key isEqualToString:@"description"]) {
        self.video_description = value;
    }
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"playInfo"]) {
        self.playInfo = [NSMutableArray array];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dataDic in value) {
            VideoResolutionModel *resolution = [[VideoResolutionModel alloc] init];
            [resolution setValuesForKeysWithDictionary:dataDic];
            [array addObject:resolution];
        }
        [self.playInfo removeAllObjects];
        [self.playInfo addObjectsFromArray:array];
    } else if ([key isEqualToString:@"title"]) {
        self.title = value;
    } else if ([key isEqualToString:@"playUrl"]) {
        self.playUrl = value;
    } else if ([key isEqualToString:@"coverForFeed"]) {
        self.coverForFeed = value;
    } else if ([key isEqualToString:@"description"]) {
        self.video_description = value;
    } else if ([key isEqualToString:@"date"]) {
        value = [[NSString stringWithFormat:@"%lld",((NSNumber *)value).longLongValue] substringWithRange:NSMakeRange(0, 10)];
        self.date = [value dateTime];
    }
    
}

@end
