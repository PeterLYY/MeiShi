//
//  MSNavgationController.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/9.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSNavgationController.h"

@interface MSNavgationController ()

@end

@implementation MSNavgationController

+ (void)initialize {
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].barTintColor = kRGBColor(255, 255, 255);
    NSDictionary *titleAttr = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:16.0f]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleAttr];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return  UIStatusBarStyleLightContent;
}




@end
