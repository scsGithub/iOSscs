//
//  VideoModel.h
//  Video
//
//  Created by 吾爷科技 on 2017/3/3.
//  Copyright © 2017年 吾爷科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoResolutionModel.h"

@interface VideoModel : NSObject

/** 标题 */
@property (nonatomic, copy  ) NSString *title;
/** 时间 */
@property (nonatomic, copy  ) NSString *date;
/** 描述 */
@property (nonatomic, copy  ) NSString *video_description;
/** 视频地址 */
@property (nonatomic, copy  ) NSString *playUrl;
/** 封面图 */
@property (nonatomic, copy  ) NSString *coverForFeed;
/** 视频分辨率的数组 */
@property (nonatomic, strong) NSMutableArray *playInfo;


@end
