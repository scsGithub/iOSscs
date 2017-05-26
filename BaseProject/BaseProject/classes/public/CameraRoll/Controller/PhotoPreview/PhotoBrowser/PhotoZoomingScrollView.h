//
//  PhotoZoomingScrollView.h
//  PhotoBrowser
//
//  Created by 张晓伟 on 16/2/15.

#import <UIKit/UIKit.h>

@protocol PhotoZoomingScrollViewDelegate <NSObject>

//单击
- (void)singleTapDetected:(UITouch *)touch;

@end

@interface PhotoZoomingScrollView : UIScrollView
@property (weak, nonatomic) id<PhotoZoomingScrollViewDelegate> mydelegate;

/**
 *  显示图片
 *
 *  @param image 图片
 */
- (void)setShowImage:(UIImage *)image;

- (void)setShowImageWithUrl:(NSString *)url;

/**
 *  调整尺寸
 */
- (void)setMaxMinZoomScalesForCurrentBounds;

/**
 *  重用，清理资源
 */
- (void)prepareForReuse;

@end
