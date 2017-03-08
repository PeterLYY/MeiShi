//
//  MSRecommendViewController.h
//  MeiShi
//
//  Created by PeterLee on 2017/2/10.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSBaseViewController.h"

@interface MSRecommendViewController : MSBaseViewController

@property (nonatomic, assign) BOOL transformShowButton;
@property (nonatomic, assign) BOOL showHelloMsg;
- (void)animationHeaderView;;
- (void)animationHeaderHideView;
- (void)scrollNavItemByNum: (NSUInteger)num Scroll:(BOOL)scroll;

@end
