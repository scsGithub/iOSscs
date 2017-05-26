//
//  PhotoTapDetectingImageView.h
//  PhotoBrowser
//
//  Created by 张晓伟 on 16/2/15.

#import <UIKit/UIKit.h>

@protocol PhotoTapDetectingImageViewDelegate <NSObject>

- (void)singleTapDetected:(UIImageView *)imageView touch:(UITouch *)touch;

- (void)doubleTapDetected:(UIImageView *)imageView touch:(UITouch *)touch;

@end

@interface PhotoTapDetectingImageView : UIImageView

@property (weak, nonatomic) id<PhotoTapDetectingImageViewDelegate> delegate;

@end
