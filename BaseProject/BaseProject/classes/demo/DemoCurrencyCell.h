//
//  DemoCurrencyCell.h
//  BaseProject
//
//  Created by 张晓伟 on 16/10/27.
//  Copyright © 2016年 Yiss Inc. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface DemoCurrencyCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end



#pragma mark - Model

@interface DemoCurrencyCellModel : NSObject

@property (nonatomic,copy) NSString *title;

+ (DemoCurrencyCellModel *)itemModelWithTitle:(NSString *)title;

@end
