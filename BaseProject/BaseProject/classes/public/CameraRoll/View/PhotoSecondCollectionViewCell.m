//
//  PhotoSecondCollectionViewCell.m
//  BaseProject
//
//  Created by 张晓伟 on 16/5/18.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "PhotoSecondCollectionViewCell.h"
#import "AssetHelper.h"

@implementation PhotoSecondCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setData:(id)data delegate:(id)delegate {
    if ([data isKindOfClass:[NSDictionary class]]) {
        ALAsset *asset = data[@"url"];
        NSString *numStr = data[@"num"];
        _photoImageView.image = [ASSETHELPER getImageFromAsset:asset type:ASSET_PHOTO_THUMBNAIL];
        if (![numStr isEqualToString:@"0"]) {
            _redDotLabel.hidden = NO;
            _redDotLabel.text = kSafeString(numStr);
            NSLog(@"numStr: %@ %@",data[@"num"],numStr);
        } else {
            _redDotLabel.hidden = YES;
        }
    }
}

@end
