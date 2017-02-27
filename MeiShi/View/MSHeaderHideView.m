//
//  MSHeaderHideView.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/16.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSHeaderHideView.h"
#import "MSHeaderHideButton.h"

@implementation MSHeaderHideView

- (void)updateConstraints {
    [self.data enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        MSHeaderHideButton *button = [MSHeaderHideButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[[UIImage imageNamed:[dict objectForKey:@"imagename"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [button setImage:[[UIImage imageNamed:[dict objectForKey:@"imagename"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
        button.imageView.contentMode = UIViewContentModeCenter;
        button.imageView.tintColor = [UIColor whiteColor];
        [button setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        button.alpha = 0.8;
        [self addSubview:button];
    }];
    [super updateConstraints];
}

- (void)layoutSubviews {
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = self.bounds.size.width/self.data.count;
        CGFloat height = self.bounds.size.height;
        button.frame = CGRectMake(idx*width, 0, width, height);
    }];
}

@end
