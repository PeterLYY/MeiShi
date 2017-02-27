//
//  MSRefreshManager.h
//  MeiShi
//
//  Created by PeterLee on 2017/2/10.
//  Copyright © 2017年 PeterLee. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^PullRefreshAndLoadMoreHandle)();

@interface MSRefreshManager : NSObject

+ (void)beginHeaderRefresh: (UIScrollView *)scrollView;
+ (void)endHeaderRefresh: (UIScrollView *)scrollView;
+ (void)beginFooterRefresh: (UIScrollView *)scrollView;
+ (void)endFooterRefresh: (UIScrollView *)scrollView;
+ (void)addLoadMoreWithScrollView: (UIScrollView *)scrollView loadMoreCallBack: (PullRefreshAndLoadMoreHandle)handle;
+ (void)addPullRefreshWithScrollView: (UIScrollView *)scrollView pullRefreshClassBack: (PullRefreshAndLoadMoreHandle)handle;

@end
