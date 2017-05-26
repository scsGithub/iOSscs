//
//  PhotoZoomingScrollView.m
//  PhotoBrowser
//
//  Created by 张晓伟 on 16/2/15.

#import "PhotoZoomingScrollView.h"
#import "PhotoTapDetectingImageView.h"
#import "TapDetectingView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PhotoZoomingScrollView()<UIScrollViewDelegate,PhotoTapDetectingImageViewDelegate,TapDetectingViewDelegate>
{
    PhotoTapDetectingImageView *_photoImageView;
    TapDetectingView *_tapView;
}
@end

@implementation PhotoZoomingScrollView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.delegate = self;
    self.showsHorizontalScrollIndicator = false;
    self.showsVerticalScrollIndicator = false;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    
    // Tap view for background
    _tapView = [[TapDetectingView alloc] initWithFrame:self.bounds];
    _tapView.delegate = self;
    _tapView.backgroundColor = UIColor.blackColor;
    [self addSubview:_tapView];
    
    _photoImageView = [[PhotoTapDetectingImageView alloc] initWithFrame:CGRectZero];
    _photoImageView.delegate = self;
    _photoImageView.contentMode = UIViewContentModeCenter;
    _photoImageView.backgroundColor = UIColor.blackColor;
    [self addSubview:_photoImageView];
}

#pragma mark - 图片显示
- (void)setShowImage:(UIImage *)image {
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    
    _photoImageView.image = image;
    self.contentSize = image.size;
    
    [self setMaxMinZoomScalesForCurrentBounds];
    
    [self setNeedsLayout];
}

- (void)setShowImageWithUrl:(NSString *)url {
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    if(![url hasSuffix:@"moblist"]){
        url = [NSString stringWithFormat:@"%@!moblist",url];
    }
    __weak __typeof(self)weakSelf = self;
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong __typeof(self)self = weakSelf;
        if (image) {
            [self setMaxMinZoomScalesForCurrentBounds];
            [self setNeedsLayout];
        }
    }];
    self.contentSize = _photoImageView.frame.size;
    
    [self setMaxMinZoomScalesForCurrentBounds];
    
    [self setNeedsLayout];
}

- (void)prepareForReuse {
    _photoImageView.image = nil;
}

#pragma mark - 初始化scrollview放大参数

- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat zoomScale = self.minimumZoomScale;
    if (_photoImageView != nil ) {
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = _photoImageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;
        CGFloat yScale = boundsSize.height / imageSize.height;
        if (fabs(boundsAR - imageAR) < 0.17) {
            zoomScale = MIN(xScale, yScale);
            zoomScale = MIN(MAX(self.minimumZoomScale, zoomScale), self.maximumZoomScale);
        }
    }
    return zoomScale;
}

/**
 *  调整尺寸
 */
- (void)setMaxMinZoomScalesForCurrentBounds {
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
//    if (_photoImageView.image == nil) {
//        return;
//    }
    
    // 图片初始位置
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _photoImageView.image.size;
    _photoImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    // 计算最小缩放
    CGFloat xScale = boundsSize.width / imageSize.width;
    CGFloat yScale = boundsSize.height / imageSize.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    // 计算最大缩放
    CGFloat maxScale = 3.0;
    
//    // 超出默认不缩放
//    if (xScale >= 1 && yScale >= 1) {
//        minScale = 1.0;
//    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    
    self.zoomScale = [self initialZoomScaleWithMinScale];
    if (self.zoomScale != minScale) {
        // Centralise
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                         (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
        self.scrollEnabled = false;
    }
    
    // Layout
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floor((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floor((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter)){
        _photoImageView.frame = frameToCenter;
    }
    
    _tapView.frame = self.bounds;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _photoImageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.scrollEnabled = true;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)handleDoubleTap:(CGPoint )touchPoint {
    // Zoom
    if (self.zoomScale != self.minimumZoomScale && self.zoomScale != [self initialZoomScaleWithMinScale]) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - PhotoTapDetectingImageViewDelegate
- (void)singleTapDetected:(UIImageView *)imageView touch:(UITouch *)touch {
    if (_mydelegate && [_mydelegate respondsToSelector:@selector(singleTapDetected:)]) {
        [_mydelegate singleTapDetected:touch];
    }
}

- (void)doubleTapDetected:(UIImageView *)imageView touch:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:imageView];
    [self handleDoubleTap:touchPoint];
}

#pragma mark - TapDetectingViewDelegate
- (void)viewSingleTapDetected:(UIView *)view touch:(UITouch *)touch {
    if (_mydelegate && [_mydelegate respondsToSelector:@selector(singleTapDetected:)]) {
        [_mydelegate singleTapDetected:touch];
    }
}

- (void)viewDoubleTapDetected:(UIView *)view touch:(UITouch *)touch {
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleDoubleTap:CGPointMake(touchX, touchY)];
}

@end
