//
//  MSLaunchAdView.h
//  MeiShi
//
//  Created by PeterLee on 2017/2/14.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MSLaunchAdCancleHandle)();
typedef void (^MSLaunchAdJumpHandle)();

@interface MSLaunchAdView : UIView

@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, assign) NSString *sec;
//跳转
@property (nonatomic, copy) MSLaunchAdJumpHandle jumpHanle;

@end
