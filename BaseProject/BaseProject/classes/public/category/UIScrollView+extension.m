//
//  UIScrollView+extension.m
//  JoyshowCampus_Compose
//
//  Created by zengyanan on 2016/11/3.
//  Copyright © 2016年 Joyshow. All rights reserved.
//

#import "UIScrollView+extension.h"

@implementation UIScrollView (extension)

- (void)addRefreshHeader:(MJRefreshComponentRefreshingBlock)refreshBlock{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshBlock];
}

- (void)addRefreshFooter:(MJRefreshComponentRefreshingBlock)refreshBlock{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:refreshBlock];
//    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshBlock];
}

- (MJRefreshBackNormalFooter *)addWithRefreshFooter:(MJRefreshComponentRefreshingBlock)refreshBlock{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:refreshBlock];
    return (MJRefreshBackNormalFooter *)self.mj_footer;
}

@end
