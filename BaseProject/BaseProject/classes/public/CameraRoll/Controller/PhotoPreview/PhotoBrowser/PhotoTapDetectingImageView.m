//
//  PhotoTapDetectingImageView.m
//  PhotoBrowser
//
//  Created by 张晓伟 on 16/2/15.

#import "PhotoTapDetectingImageView.h"

@implementation PhotoTapDetectingImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(singleTapDetected:touch:)]) {
                [_delegate singleTapDetected:self touch:touch];
            }
        }
            break;
            
        case 2:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(doubleTapDetected:touch:)]) {
                [_delegate doubleTapDetected:self touch:touch];
            }
        }
            break;
    }
}

- (void)dealloc {
    _delegate = nil;
}

@end
