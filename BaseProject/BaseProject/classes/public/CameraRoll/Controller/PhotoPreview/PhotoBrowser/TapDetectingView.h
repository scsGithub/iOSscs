//
//  TapDetectingView.h
//  PhotoBrowser
//
//  Created by 张晓伟 on 16/2/15.

#import <UIKit/UIKit.h>

@protocol TapDetectingViewDelegate <NSObject>

//单击
- (void)viewSingleTapDetected:(UIView *)view touch:(UITouch *)touch;

//双击
- (void)viewDoubleTapDetected:(UIView *)view touch:(UITouch *)touch;

@end

@interface TapDetectingView : UIView

@property (weak, nonatomic) id<TapDetectingViewDelegate> delegate;

@end
