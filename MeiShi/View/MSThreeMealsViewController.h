//
//  MSThreeMealsViewController.h
//  MeiShi
//
//  Created by PeterLee on 2017/2/20.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSBaseViewController.h"
#import "MSRecommendViewModel.h"

@interface MSThreeMealsViewController : MSBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MSRecommendViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@end
