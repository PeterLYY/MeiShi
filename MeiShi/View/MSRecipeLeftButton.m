//
//  MSRecipeLeftButton.m
//  MeiShi
//
//  Created by PeterLee on 2017/3/3.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSRecipeLeftButton.h"

@implementation MSRecipeLeftButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 50, 65, 15);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 0, 65, 50);
}

@end
