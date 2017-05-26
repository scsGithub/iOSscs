//
//  CurrencyAddPhotoCell.h
//  BaseProject
//
//  Created by 张晓伟 on 16/1/14.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "BaseTableViewCell.h"

#define kMaxPhotoNum 4
#define CurrencyAddPhotoCellRowPhotoCount 4 //每一行的数量
#define CurrencyAddPhotoCellRowPhotoSpace 5 //照片间隔
#define CurrencyAddPhotoCellCollectionViewX 5 //x坐标
#define CurrencyAddPhotoCellCollectionViewY 5 //y坐标

@class CurrencyAddPhotoCell;

@protocol CurrencyAddPhotoCellDelegate <NSObject>

@optional
- (void)currencyAddPhotoCell:(CurrencyAddPhotoCell *)cell didSelectItem:(id)selectItem;
- (void)currencyAddPhotoCellAddPhotoButtonAction;

@end

@interface CurrencyAddPhotoCell : BaseTableViewCell

@property (nonatomic,weak) id <CurrencyAddPhotoCellDelegate> delegate;

@end


@interface CurrencyAddPhotoCellModel : NSObject

@property (nonatomic,strong) NSArray *imageAry;//图片数组

+ (CurrencyAddPhotoCellModel *)itemModelWithImageAry:(NSArray *)imageAry;

@end
