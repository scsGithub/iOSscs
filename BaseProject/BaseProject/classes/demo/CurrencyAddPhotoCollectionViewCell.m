//
//  CurrencyAddPhotoCollectionViewCell.m
//  BaseProject
//
//  Created by 张晓伟 on 16/1/14.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "CurrencyAddPhotoCollectionViewCell.h"
#import "AssetHelper.h"

@implementation CurrencyAddPhotoCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setData:(id)data delegate:(id)delegate {
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = data;
        NSString *type = dic[@"type"];
        self.layer.borderWidth = 0;
        if ([type isEqualToString:@"add"]) {
            _photoImage.clipsToBounds = YES;
            NSString *url = [dic[@"url"] length] > 0 ? dic[@"url"] : @"";
            self.layer.borderWidth = 0.5;
            self.layer.borderColor = [UIColor colorWithHex:0xDEDEDE].CGColor;
            _photoImage.image = [UIImage imageNamed:url];
            _photoImage.contentMode = UIViewContentModeCenter;
        } else {
            id dicAdd = dic[@"url"];
            _photoImage.image = nil;
            _photoImage.contentMode = UIViewContentModeScaleAspectFill;
            _photoImage.clipsToBounds =YES;
            if ([dicAdd isKindOfClass:[UIImage class]]) {
                _photoImage.layer.borderWidth = 0;
                _photoImage.layer.borderColor = [UIColor clearColor].CGColor;
                _photoImage.image = dicAdd;
            }else{
                NSString *url = [dic[@"url"] length] > 0 ? dic[@"url"] : @"";
                  if (![url hasSuffix:@"dplist"]) {
                    url = [NSString stringWithFormat:@"%@!dplist",url];
                }
                _photoImage.layer.borderWidth = 0;
                _photoImage.layer.borderColor = [UIColor clearColor].CGColor;
                
                [_photoImage sd_setImageWithURL:[NSURL URLWithString:url]];
            }
        }
    }
}





@end
