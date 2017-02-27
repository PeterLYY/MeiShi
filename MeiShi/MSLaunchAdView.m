//
//  MSLaunchAdView.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/14.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSLaunchAdView.h"
#import "MSAdButton.h"
@interface MSLaunchAdView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MSAdButton *cancleButton;

@end

@implementation MSLaunchAdView

- (void)setImgURL:(NSString *)imgURL {
    _imgURL = imgURL;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [self removeFromSuperview];
            _jumpHanle();
        }];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (UIButton *)cancleButton {
    if (_cancleButton == nil) {
        __block NSInteger time = _sec.integerValue;
        MSAdButton *cancleButton = [MSAdButton buttonWithType:UIButtonTypeCustom];
        cancleButton.layer.cornerRadius = 15.0;
        [cancleButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
        cancleButton.sec = time;
        [[cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self hideAdView];
        }];
        [self addSubview:cancleButton];
        _cancleButton = cancleButton;
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            time--;
            if (time >= 0) {
                cancleButton.sec = time;
            }else{
                [timer invalidate];
                
                [self hideAdView];
            }
        }];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    return _cancleButton;
}

- (void)hideAdView {
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    self.imageView.frame = self.bounds;
    self.cancleButton.frame = CGRectMake(kScreenWidth-100, 20, 80, 30);
}




@end
