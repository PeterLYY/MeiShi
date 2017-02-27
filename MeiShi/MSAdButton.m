//
//  MSAdButton.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/14.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSAdButton.h"

@implementation MSAdButton

- (void)setSec:(NSInteger)sec {
    _sec = sec;
    NSString *title = [NSString stringWithFormat:@"跳过 %ld", (long)_sec];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:title attributes:@{
                                                                                    NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                    NSFontAttributeName:[UIFont systemFontOfSize:15.0]
                                                                                    }];
    [self setAttributedTitle:attrString forState:UIControlStateNormal];
    //[self setNeedsDisplay];
}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    self.layer.cornerRadius = 15.0;
//    NSString *title = [NSString stringWithFormat:@"跳过 %ld", (long)_sec];
//    [self setTitle:title forState:UIControlStateNormal];
//}

@end
