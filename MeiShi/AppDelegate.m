//
//  AppDelegate.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/9.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "AppDelegate.h"
#import "MSTabBarController.h"
#import "MSGuidePageView.h"
#import "MSUtils.h"
#import "MSLaunchAdView.h"
#import "MSWebAdvViewController.h"
#import "MSNavgationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    MSTabBarController *tabbar = [[MSTabBarController alloc] init];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    
    [self setupGuidePage];
    //[self setupADPage];
    return YES;
}

//引导页
- (void)setupGuidePage {
    NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kAppVersion];
        NSArray *images = @[@"ms_ui_intro_6p_1",@"ms_ui_intro_6p_2",@"ms_ui_intro_6p_3",@"ms_ui_intro_6p_4"];
        MSGuidePageView *guidePageView = [[MSGuidePageView alloc] initWithImages:images];
        [self.window addSubview:guidePageView];
    }
}

//广告页
- (void)setupADPage {
    
//    [MSNetworkingManager GET:@"http://api.meishi.cc/v6/show.php" parameters:nil progress:nil success:^(id responseObject) {
//        ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:responseObject error:nil];
//        NSArray *arr = [[[document.rootElement firstChildWithTag:@"obj"] firstChildWithTag:@"start_image_next"] childrenWithTag:@"item"];
//        ONOXMLElement *adItem = [arr objectAtIndex:0];
//        NSString *image = [adItem firstChildWithTag:@"image"].stringValue;
//        NSString *show_time = [adItem firstChildWithTag:@"show_time"].stringValue;
//        NSString *href = [adItem firstChildWithTag:@"href"].stringValue;
//        NSDictionary *ad = @{@"image":image, @"show_time":show_time, @"href":href};
//        [[NSUserDefaults standardUserDefaults] setObject:ad forKey:kAdName];
//    } failure:^(NSError *error) {
//        
//    }];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:kAdName] != nil) {
//        NSDictionary *ad = [[NSUserDefaults standardUserDefaults] objectForKey:kAdName];
//        MSLaunchAdView *adView = [[MSLaunchAdView alloc] initWithFrame:self.window.bounds];
//        adView.imgURL = [ad objectForKey:@"image"];
//        adView.sec = [ad objectForKey:@"show_time"];
//        adView.backgroundColor = [UIColor whiteColor];
//        //推到广告页
//        adView.jumpHanle = ^ {
//            NSString *jumpurl = [ad objectForKey:@"href"];
//            MSWebAdvViewController *advVC = [[MSWebAdvViewController alloc] init];
//            advVC.view.frame = self.window.bounds;
//            advVC.adurl = jumpurl;
//            advVC.hidesBottomBarWhenPushed = YES;
//            MSTabBarController *tabbar = (MSTabBarController *)self.window.rootViewController;
//            MSNavgationController *nav = [tabbar.childViewControllers objectAtIndex:0];
//            [nav pushViewController:advVC animated:YES];
//        };
//        [self.window addSubview:adView];
//    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
