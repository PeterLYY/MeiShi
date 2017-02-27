//
//  MSGuidePageView.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/14.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSGuidePageView.h"

@interface MSGuidePageView() <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MSGuidePageView

- (instancetype)initWithImages:(NSArray *)images {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.images = images;
    }
    
    return self;
}

- (UIScrollView *)scrollView {
    if(_scrollView == nil){
        NSInteger pageCount = [_images count];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        scrollView.contentSize = CGSizeMake(kScreenWidth*pageCount, kScreenHeight);
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = YES;
        scrollView.delegate = self;
        scrollView.bounces = NO;
        scrollView.pagingEnabled = YES;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    if (images.count) {
        [images enumerateObjectsUsingBlock:^(NSString *imgStr, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*idx, 0, kScreenWidth, kScreenHeight)];
            imageView.image = [UIImage imageNamed:imgStr];
            [self.scrollView addSubview:imageView];
            return ;
        }];
    }
}

- (void)hideGuidView {
    [UIView animateWithDuration:0.5 animations:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    int cuttentIndex = (int)(scrollView.contentOffset.x + kScreenWidth/2)/kScreenWidth;
    if (cuttentIndex == self.images.count - 1) {
        [self hideGuidView];
    }
}

@end
