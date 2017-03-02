//
//  MSThreeMealsViewController.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/20.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSThreeMealsViewController.h"
#import "MSTableViewCell.h"

@interface MSThreeMealsViewController ()

@property (nonatomic, copy) NSDictionary *sancanData;
@property (nonatomic, copy) NSDictionary *weatherData;
@property (nonatomic, assign) NSInteger sancanNow;
@property (nonatomic, copy) NSDictionary *foodList;

@end

@implementation MSThreeMealsViewController
@dynamic viewModel;

- (void)bindViewModel {
    [super bindViewModel];
    
    //过滤信号
    RACSignal *sancanSignal = [RACObserve(self.viewModel, sancanData) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }];
    
    RACSignal *weatherSignal = [RACObserve(self.viewModel, weatherData) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }];
    //合并信号
    [[sancanSignal combineLatestWith:weatherSignal] subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(NSDictionary *sancanData, NSDictionary *weatherData) = tuple;
        self.sancanData = sancanData;
        self.weatherData = weatherData;
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.sancanNow = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hourOfNow];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_weatherData != nil) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != 2) {
        return 1;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weather"];
        if (cell == nil) {
            cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weather"];
            cell.backgroundColor = [UIColor lightGrayColor];
            
            UIImageView *backgroundView = [[UIImageView alloc] init];
            backgroundView.clipsToBounds = YES;
            backgroundView.contentMode = UIViewContentModeScaleAspectFill;
            backgroundView.alpha = 0.8;
            [cell.contentView addSubview:backgroundView];
            
            UILabel *wenduLabel = [[UILabel alloc] init];
            wenduLabel.font = [UIFont systemFontOfSize:70];
            wenduLabel.textColor = [UIColor whiteColor];
            wenduLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            [cell.contentView addSubview:wenduLabel];
            
            UILabel *tianqiLabel = [[UILabel alloc] init];
            tianqiLabel.font = [UIFont systemFontOfSize:16];
            tianqiLabel.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:tianqiLabel];
            
            UILabel *kongqiLabel = [[UILabel alloc] init];
            kongqiLabel.font = [UIFont systemFontOfSize:14];
            kongqiLabel.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:kongqiLabel];
            
            UILabel *cityLabel = [[UILabel alloc] init];
            cityLabel.font = [UIFont systemFontOfSize:12];
            cityLabel.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:cityLabel];
            
            [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            
            [wenduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).mas_offset(20);
                make.top.equalTo(cell.contentView.mas_top).mas_offset(28);
                make.width.mas_equalTo(110);
                make.height.mas_equalTo(60);
            }];
            
            [tianqiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).mas_offset(20);
                make.top.equalTo(wenduLabel.mas_bottom).mas_offset(20);
                make.width.mas_equalTo(110);
                make.height.mas_equalTo(20);
            }];
            
            [kongqiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).mas_offset(20);
                make.top.equalTo(tianqiLabel.mas_bottom).mas_offset(10);
                make.width.mas_equalTo(110);
                make.height.mas_equalTo(20);
            }];
            
            [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).mas_offset(-20);
                make.centerY.equalTo(kongqiLabel.mas_centerY).mas_offset(0);
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(15);
            }];
        }
        
        if (_weatherData != nil) {
            UIImageView *backgroundView = [cell.contentView.subviews objectAtIndex:0];
            [backgroundView sd_setImageWithURL:[NSURL URLWithString:[[[_weatherData objectForKey:@"bg_img"] objectForKey:@"big"] objectForKey:@"text"]]];
            
            UILabel *wenduLabel = [cell.contentView.subviews objectAtIndex:1];
            wenduLabel.text = [[[_weatherData objectForKey:@"temperature"] objectForKey:@"text"] stringByAppendingString:@"°"];
            
            UILabel *tianqiLabel = [cell.contentView.subviews objectAtIndex:2];
            tianqiLabel.text = [[_weatherData objectForKey:@"detail_msg"] objectForKey:@"text"];
            
            UILabel *kongqiLabel = [cell.contentView.subviews objectAtIndex:3];
            kongqiLabel.text = [[_weatherData objectForKey:@"aqi"] objectForKey:@"text"];
            
            UILabel *cityLabel = [cell.contentView.subviews objectAtIndex:4];
            cityLabel.text = [[_weatherData objectForKey:@"location"] objectForKey:@"text"];
            
        }
        
        return cell;
    }else if (indexPath.section == 1){
        MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nav"];
        if (cell == nil) {
            cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nav"];
            NSArray *nav = @[@"早餐", @"午餐", @"下午茶", @"晚餐", @"夜宵"];
            
            CGFloat width = (kScreenWidth-20)/nav.count;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:kRGBColor(144, 144, 144)};
            NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]};
            [nav enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(10+width*idx, 10, width, 40);
                button.tag = 900+idx;
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:str attributes:attributes];
                NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:str attributes:attributes2];
                [button setAttributedTitle:attrString forState:UIControlStateNormal];
                [button setAttributedTitle:attrString2 forState:UIControlStateSelected];
                if (self.sancanNow == idx) {
                    button.selected = YES;
                }
                [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                    button.selected = YES;
                    if (_sancanData != nil) {
                        self.foodList = [[_sancanData objectForKey:@"item"] objectAtIndex:idx];
                        NSLog(@"%@", self.foodList);
                        [self.tableView reloadData];
                    }
                    [cell.contentView.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([btn isEqual:button] == NO) {
                            btn.selected = NO;
                        }
                    }];
                }];
                [cell.contentView addSubview:button];
            }];
        }
        return cell;
    }else if (indexPath.section == 2){
        MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sancan"];
        if (cell == nil) {
            cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sancan"];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [cell.contentView addSubview:imageView];
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textColor = [UIColor blackColor];
            [cell.contentView addSubview:titleLabel];
            
            UIImageView *starView = [[UIImageView alloc] init];
            starView.image = [UIImage imageNamed:@"ms_caipu_level"];
            starView.contentMode = UIViewContentModeLeft;
            starView.clipsToBounds = YES;
            [cell.contentView addSubview:starView];
            
            UILabel *foodsLabel = [UILabel new];
            foodsLabel.font = [UIFont systemFontOfSize:14];
            foodsLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
            foodsLabel.numberOfLines = 2;
            [cell.contentView addSubview:foodsLabel];
            
            UIView *superview = cell.contentView;
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(superview.mas_centerY).mas_offset(0);
                make.size.mas_equalTo(CGSizeMake(140, 140));
                make.left.mas_equalTo(superview.mas_left).mas_offset(10);
            }];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageView.mas_top).mas_offset(10);
                make.size.mas_equalTo(CGSizeMake(130, 20));
                make.left.equalTo(imageView.mas_right).mas_offset(15);
            }];
            
            [starView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).mas_offset(10);
                make.size.mas_equalTo(CGSizeMake(130, 20));
                make.left.equalTo(imageView.mas_right).mas_offset(15);
            }];
            
            [foodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(starView.mas_bottom).mas_offset(10);
                make.size.mas_equalTo(CGSizeMake(130, 40));
                make.left.equalTo(imageView.mas_right).mas_offset(15);
            }];
        }
        
        if (_sancanData != nil) {
            if (self.foodList == nil) {
                self.foodList = [[_sancanData objectForKey:@"item"] objectAtIndex:self.sancanNow];
            }
            if (self.foodList != nil) {
                NSDictionary *foodDict = [[[self.foodList objectForKey:@"items"] objectForKey:@"item"] objectAtIndex:indexPath.row];
                if (foodDict != nil) {
                    UIImageView *imageView = [cell.contentView.subviews objectAtIndex:0];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[[foodDict objectForKey:@"img"] objectForKey:@"text"]]];
                    UILabel *titleLabel = [cell.contentView.subviews objectAtIndex:1];
                    titleLabel.text = [[foodDict objectForKey:@"title"] objectForKey:@"text"];
                    UILabel *foodsLabel = [cell.contentView.subviews objectAtIndex:3];
                    foodsLabel.text = [[foodDict objectForKey:@"foods"] objectForKey:@"text"];
                }
            }
            
        }
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if(_weatherData != nil) {
            CGFloat width = [[[[self.weatherData objectForKey:@"bg_img"] objectForKey:@"width"] objectForKey:@"text"] floatValue];
            CGFloat height = [[[[self.weatherData objectForKey:@"bg_img"] objectForKey:@"height"] objectForKey:@"text"] floatValue];
            return height/width*kScreenWidth;
        }else{
            return 170;
        }
    } else if (indexPath.section == 1) {
        return 50;
    } else if (indexPath.section == 2) {
        return 160;
    }
    
    return 50;
}

- (void)hourOfNow {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger hour = [calendar component:NSCalendarUnitHour fromDate:date];
    
    if (hour>5 && hour <=10) {
        self.sancanNow = 0;
    } else if (hour>10 && hour <=13) {
        self.sancanNow = 1;
    } else if (hour>14 && hour <=17) {
        self.sancanNow = 2;
    } else if (hour>18 && hour <=21) {
        self.sancanNow = 3;
    } else {
        self.sancanNow = 4;
    }
}


@end
