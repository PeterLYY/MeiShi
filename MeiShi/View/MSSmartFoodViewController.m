//
//  MSSmartFoodViewController.m
//  MeiShi
//
//  Created by PeterLee on 2017/3/1.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSSmartFoodViewController.h"

@interface MSSmartFoodViewController ()

@end

@implementation MSSmartFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
