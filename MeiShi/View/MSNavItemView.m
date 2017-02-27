//
//  MSNavItemView.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/17.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSNavItemView.h"

@interface MSNavItemView()

@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation MSNavItemView

- (void)setItems:(NSArray *)items {
    if (_items == nil) {
        self.labels = [NSMutableArray new];
        [items enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label = [UILabel new];
            label.text = item;
            label.textColor = kRGBColor(120, 120, 120);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:18];
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                self.clickHandle(idx);
            }];
            [label addGestureRecognizer:tap];
            [self.labels addObject:label];
            [self addSubview:label];
        }];
    }
    _items = items;
}

- (void)layoutSubviews {
    __block CGFloat contentWidth = 0;
    [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
        //获取文字宽度
        CGFloat width = [label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}].width+20;
        label.frame = CGRectMake(contentWidth, 0, width, 50);
        contentWidth += width;
    }];
    self.contentSize = CGSizeMake(contentWidth, 50);
}


- (void)setClickItemNum:(NSInteger)clickItemNum {
    for (NSUInteger i=0; i<self.items.count; i++) {
         UILabel *defaultLabel = [self.labels objectAtIndex:i];
        if(i == clickItemNum) {
            defaultLabel.textColor = kRGBColor(255, 0, 0);
        }else{
            defaultLabel.textColor = kRGBColor(120, 120, 120);
        }
    }
}

@end
