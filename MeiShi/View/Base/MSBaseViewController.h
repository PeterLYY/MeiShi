//
//  MSBaseViewController.h
//  MeiShi
//
//  Created by PeterLee on 2017/2/9.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSViewModel;

@interface MSBaseViewController : UIViewController

@property (nonatomic, strong) MSViewModel *viewModel;

- (instancetype)initWithViewModel:(MSViewModel *)viewModel;
- (void)bindViewModel;

@end
