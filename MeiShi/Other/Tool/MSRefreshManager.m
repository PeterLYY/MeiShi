//
//  MSRefreshManager.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/10.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSRefreshManager.h"
#import "MJRefresh.h"

@implementation MSRefreshManager

//开始下拉刷新
+ (void)beginHeaderRefresh: (UIScrollView *)scrollView {
    [scrollView.mj_header beginRefreshing];
}

//结束下拉刷新
+ (void)endHeaderRefresh: (UIScrollView *)scrollView {
    [scrollView.mj_header endRefreshing];
}

//开始上拉刷新
+ (void)beginFooterRefresh: (UIScrollView *)scrollView {
    [scrollView.mj_footer beginRefreshing];
}

//结束上拉刷新
+ (void)endFooterRefresh: (UIScrollView *)scrollView {
    [scrollView.mj_footer endRefreshing];
}

//上拉刷新
+ (void)addLoadMoreWithScrollView: (UIScrollView *)scrollView loadMoreCallBack: (PullRefreshAndLoadMoreHandle)handle {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (handle) {
            handle();
        }
    }];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了~" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = kRGBColor(90, 90, 90);
    footer.stateLabel.font = [UIFont systemFontOfSize:13.0f];
    footer.backgroundColor = [UIColor clearColor];
    
    scrollView.mj_footer = footer;
}

//下拉刷新
+ (void)addPullRefreshWithScrollView: (UIScrollView *)scrollView pullRefreshClassBack: (PullRefreshAndLoadMoreHandle)handle {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (handle) {
            handle();
        }
    }];
    
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉立即刷新" forState:MJRefreshStateIdle];
    header.stateLabel.textColor = kRGBColor(90, 90, 90);
    header.stateLabel.font = [UIFont systemFontOfSize:13.0f];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    scrollView.mj_header = header;
}


@end
