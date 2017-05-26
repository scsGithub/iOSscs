//
//  CardSwitchView.h
//  BaseProject
//
//  Created by 张晓伟 on 16/5/18.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineLayout.h"

@interface CardSwitchView : UIView

@property (nonatomic, strong) LineLayout *layout;

- (void)deleteWithIndex:(NSInteger)index;
- (void)setCardSwitchViewAry:(NSArray *)cardSwitchViewAry;

@end
