//
//  MSTableViewController.h
//  MeiShi
//
//  Created by PeterLee on 2017/2/9.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSBaseViewController.h"

@interface MSTableViewController : MSBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
