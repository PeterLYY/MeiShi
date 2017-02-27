//
//  MSTabBarController.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/9.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSTabBarController.h"
#import "MSNavgationController.h"
#import "MSRecommendViewModel.h"
#import "MSRecommendViewController.h"
#import "MSDiscoverViewModel.h"
#import "MSDiscoverViewController.h"
#import "MSShopViewModel.h"
#import "MSShopViewController.h"
#import "MSTopicsViewModel.h"
#import "MSTopicsViewController.h"
#import "MSMyViewModel.h"
#import "MSMyViewController.h"

@interface MSTabBarController ()

@end

@implementation MSTabBarController

+ (void)initialize {
    [super initialize];
    
    [UITabBar appearance].translucent = NO;
    [UITabBar appearance].barTintColor = kRGBColor(255, 255, 255);
    [UITabBar appearance].tintColor = kRGBColor(255, 77, 130);
    
    NSDictionary *normalAttr = @{NSForegroundColorAttributeName:kRGBColor(180, 180, 180), NSFontAttributeName:[UIFont systemFontOfSize:9.0f]};
    [[UITabBarItem appearance] setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    NSDictionary *selectedAttr = @{NSForegroundColorAttributeName:kRGBColor(255, 77, 130), NSFontAttributeName:[UIFont systemFontOfSize:9.0f]};
    [[UITabBarItem appearance] setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -2)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *tabbarData = @[
                        @{@"name":@"推荐", @"classname":@"Recommend", @"imagename":@"tabbar_recommend"},
                        @{@"name":@"发现", @"classname":@"Discover", @"imagename":@"tabbar_discover"},
                        @{@"name":@"商城", @"classname":@"Shop", @"imagename":@"tabbar_shop"},
                        @{@"name":@"食话", @"classname":@"Topics", @"imagename":@"tabbar_topics"},
                        @{@"name":@"我的", @"classname":@"My", @"imagename":@"tabbar_my"}
                        ];
    [self addChildViewControllerByArray:tabbarData];
    
}

- (void)addChildViewControllerByArray:(NSArray *)data {
    if (data.count > 0) {
        [data enumerateObjectsUsingBlock:^(NSDictionary *tabbar, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *viewControllerName = [NSString stringWithFormat:@"MS%@ViewController", [tabbar objectForKey:@"classname"]];
            NSString *viewModelName = [NSString stringWithFormat:@"MS%@ViewModel", [tabbar objectForKey:@"classname"]];
            id viewModel = [[NSClassFromString(viewModelName) alloc] init];
            UIViewController *childVC = [[NSClassFromString(viewControllerName) alloc] initWithViewModel:viewModel];
            MSNavgationController *nav = [[MSNavgationController alloc] initWithRootViewController:childVC];
            nav.tabBarItem.title = [tabbar objectForKey:@"name"];
            nav.tabBarItem.image = [UIImage imageNamed:[tabbar objectForKey:@"imagename"]];
            nav.tabBarItem.selectedImage = [UIImage imageNamed:[[tabbar objectForKey:@"imagename"] stringByAppendingString:@"_pass"]];
            [self addChildViewController:nav];
        }];
    }
}


@end
