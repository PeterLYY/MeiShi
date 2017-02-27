//
//  MSHeaderHideButton.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/16.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSHeaderHideButton.h"

@implementation MSHeaderHideButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(10, contentRect.size.height-15, contentRect.size.width-20, 10);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(10, 5, contentRect.size.width-20, 30);
}

@end
