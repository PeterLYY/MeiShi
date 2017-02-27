//
//  MSRecommendTopBannerCell.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/20.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSRecommendTopBannerCell.h"

@interface MSRecommendTopBannerCell()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *progressView;

@end

@implementation MSRecommendTopBannerCell

- (void)setData:(NSArray *)data {
    if(data.count > 0 && _data == nil){
        [data enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *coverImg = [[[dict objectForKey:@"cover_img"] objectForKey:@"big"] objectForKey:@"text"];
            NSString *jumpString = [[dict objectForKey:@"jump"] objectForKey:@"text"];
            NSDictionary *jumpDict = [NSJSONSerialization JSONObjectWithData:[jumpString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            NSString *urlString = [[jumpDict objectForKey:@"property"] objectForKey:@"urlString"];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:[NSURL URLWithString:coverImg]];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
            [[tapGesture rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                self.tapGetureHandle(urlString);
            }];
            [imageView addGestureRecognizer:tapGesture];
            [self.scrollView addSubview:imageView];
        }];
        _data = data;
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat scrollViewWidth = self.bounds.size.width-10;
    CGFloat scrollViewHeight = self.bounds.size.height-10;
    self.scrollView.frame = CGRectMake(5, 5, scrollViewWidth, scrollViewHeight);
    self.scrollView.contentSize = CGSizeMake(scrollViewWidth*self.scrollView.subviews.count, scrollViewHeight);
    @weakify(self)
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        imageView.frame = CGRectMake(idx*self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    }];
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

@end
