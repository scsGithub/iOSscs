//
//  UIScrollView+extension.h
//  JoyshowCampus_Compose
//
//  Created by zengyanan on 2016/11/3.
//  Copyright © 2016年 Joyshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>


@interface UIScrollView (extension)

- (void)addRefreshHeader:(MJRefreshComponentRefreshingBlock)refreshBlock;

- (void)addRefreshFooter:(MJRefreshComponentRefreshingBlock)refreshBlock;

- (MJRefreshBackNormalFooter *)addWithRefreshFooter:(MJRefreshComponentRefreshingBlock)refreshBlock;

@end
