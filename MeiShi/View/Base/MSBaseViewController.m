//
//  MSBaseViewController.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/9.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSBaseViewController.h"
#import "MSViewModel.h"

@interface MSBaseViewController ()

@end

@implementation MSBaseViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    MSBaseViewController *baseVC = [super allocWithZone:zone];
    //调用viewDidLoad时调用bindViewModel
    @weakify(baseVC)
    [[baseVC rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id  _Nullable x) {
        @strongify(baseVC)
        [baseVC bindViewModel];
    }];
    return baseVC;
}


- (instancetype)initWithViewModel:(MSViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)bindViewModel {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
