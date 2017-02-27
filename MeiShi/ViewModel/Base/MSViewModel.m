//
//  MSViewModel.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/14.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSViewModel.h"

@implementation MSViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    MSViewModel *viewModel = [super allocWithZone:zone];
    if (viewModel) {
        [viewModel initialize];
    }
    return viewModel;
}

- (void)initialize {}

@end
