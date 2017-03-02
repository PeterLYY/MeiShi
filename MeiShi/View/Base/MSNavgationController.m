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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(self.viewControllers.count > 0) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ms_back_icon2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:NULL];
        backButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            [viewController.navigationController popViewControllerAnimated:YES];
            return [RACSignal empty];
        }];
        viewController.navigationItem.leftBarButtonItem = backButton;
    }
    [super pushViewController:viewController animated:animated];
}




@end
