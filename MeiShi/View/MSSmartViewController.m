//
//  MSSmartViewController.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/20.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSSmartViewController.h"
#import "MSSmartHeaderView.h"
#import "MSRecommendViewModel.h"

@interface MSSmartViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MSSmartHeaderView *headerView;
@property (nonatomic, strong) MSRecommendViewModel *viewModel;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSArray *firstLetter;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MSSmartViewController
@dynamic viewModel;

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, foodMaterialList) subscribeNext:^(NSDictionary *dict) {
        self.data = dict;
        [self.tableView reloadData];
    }];
}

- (NSArray *)sortFirstLetter:(NSArray *)firstLetter {
    NSArray *orderArray = [firstLetter sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
       return [str1 compare:str2 options:NSCaseInsensitiveSearch];
    }];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:orderArray];
    NSString *lastStr = [mutableArray lastObject];
    [mutableArray removeLastObject];
    [mutableArray insertObject:lastStr atIndex:0];
    return mutableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.data = [NSDictionary new];
    //self.firstLetter = [NSMutableArray new];
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


- (void)viewDidLayoutSubviews {
    UIView *superview = self.view;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).mas_offset(0);
        make.left.equalTo(superview.mas_left).mas_offset(0);
        make.right.equalTo(superview.mas_right).mas_offset(0);
        make.height.mas_equalTo(110);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).mas_offset(110);
        make.left.equalTo(superview.mas_left).mas_offset(0);
        make.right.equalTo(superview.mas_right).mas_offset(0);
        make.bottom.equalTo(superview.mas_bottom).mas_offset(0);
    }];
    
    [super viewDidLayoutSubviews];
}

- (MSSmartHeaderView *)headerView {
    if (_headerView == nil) {
        MSSmartHeaderView *headerView = [[MSSmartHeaderView alloc] init];
        [self.view addSubview:headerView];
        _headerView = headerView;
    }
    
    return _headerView;
}

- (NSArray *)firstLetter {
    if (_firstLetter == nil) {
        NSArray *firstLetter = self.data.allKeys;
        NSArray *orderArray = [firstLetter sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
            return [str1 compare:str2 options:NSCaseInsensitiveSearch];
        }];
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:orderArray];
        NSString *lastStr = [mutableArray lastObject];
        [mutableArray removeLastObject];
        [mutableArray insertObject:lastStr atIndex:0];
        _firstLetter = mutableArray;
    }
    return _firstLetter;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.firstLetter.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [self.firstLetter objectAtIndex:section];
    return [[self.data objectForKey:key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = kRGBColor(230, 230, 230);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 25;
        imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *selected = [[UIImageView alloc] init];
        selected.image = [UIImage imageNamed:@"reddot"];
        selected.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:selected];
    }
    
    UIView *superview = cell.contentView;
    
    NSString *key = [self.firstLetter objectAtIndex:indexPath.section];
    NSDictionary *foodDict = [[self.data objectForKey:key] objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [cell.contentView.subviews objectAtIndex:0];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[foodDict objectForKey:@"icon"]]];
    
    UILabel *titleLabel = [cell.contentView.subviews objectAtIndex:1];
    titleLabel.text = [foodDict objectForKey:@"title"];
    
    UIImageView *selected = [cell.contentView.subviews objectAtIndex:2];
    selected.hidden = YES;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY).offset(0);
        make.left.equalTo(superview.mas_left).mas_offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY).offset(0);
        make.left.equalTo(imageView.mas_right).mas_offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [selected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
        make.centerY.equalTo(superview.mas_centerY).offset(0);
        make.left.equalTo(titleLabel.mas_right).mas_offset(5);
    }];

    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
        headerView.contentView.backgroundColor = kRGBColor(230, 230, 230);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth, 20)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [headerView.contentView addSubview:titleLabel];
    }
    NSString *key = [self.firstLetter objectAtIndex:section];
    UILabel *titleLabel = [headerView.contentView.subviews objectAtIndex:0];
    titleLabel.text = key;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [[tableView cellForRowAtIndexPath:indexPath].subviews objectAtIndex:2].hidden;
}




@end
