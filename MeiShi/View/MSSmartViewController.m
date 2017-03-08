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
#import "MSSmartFoodViewController.h"
#import "MSSmartViewModel.h"

@interface MSSmartViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MSSmartHeaderView *headerView;
@property (nonatomic, strong) MSRecommendViewModel *viewModel;
@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, copy) NSArray *firstLetter;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectedId;
@property (nonatomic, strong) NSMutableDictionary *selectedFood;
@property (nonatomic, strong) NSMutableDictionary *selectedCheckedView;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UIButton *cancleBtn;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.data = [NSDictionary new];
    self.selectedId = [NSMutableArray new];
    self.selectedFood = [NSMutableDictionary new];
    self.selectedCheckedView = [NSMutableDictionary new];
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
        
        UIView *superview = cell.contentView;
        
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

    }
    
    NSString *key = [self.firstLetter objectAtIndex:indexPath.section];
    NSDictionary *foodDict = [[self.data objectForKey:key] objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [cell.contentView.subviews objectAtIndex:0];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[foodDict objectForKey:@"icon"]]];
    
    UILabel *titleLabel = [cell.contentView.subviews objectAtIndex:1];
    titleLabel.text = [foodDict objectForKey:@"title"];
    
    UIImageView *selected = [cell.contentView.subviews objectAtIndex:2];
    NSString *foodId = [foodDict objectForKey:@"id"];
    if ([self.selectedId containsObject:foodId] == NO) {
        [selected setHidden:YES];
    }else{
        [selected setHidden:NO];
    }
    
    
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
    NSArray *subviews = [tableView cellForRowAtIndexPath:indexPath].contentView.subviews;
    UIView *checkedView = [subviews objectAtIndex:2];
    NSString *key = [self.firstLetter objectAtIndex:indexPath.section];
    NSDictionary *foodDict = [[self.data objectForKey:key] objectAtIndex:indexPath.row];
    UIView *foodBasket = [self.headerView.subviews objectAtIndex:2];
    if (_cancleBtn == nil) {
        _cancleBtn = [self.headerView.subviews objectAtIndex:3];
        [[_cancleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSArray *ids = [self.selectedId copy];
            [ids enumerateObjectsUsingBlock:^(NSString *foodID, NSUInteger idx, BOOL * _Nonnull stop) {
                UIView *checkedView2 = [self.selectedCheckedView objectForKey:foodID];
                [self removeFoodImageView:foodID FoodBasket:foodBasket CheckedView:checkedView2 Cancle:_cancleBtn Ok:_okBtn];
            }];
        }];
    }
    if (_okBtn == nil) {
        _okBtn = [self.headerView.subviews objectAtIndex:4];
        [[_okBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            MSSmartViewModel *viewModel = [[MSSmartViewModel alloc] init];
            MSSmartFoodViewController *smartFoodVC = [[MSSmartFoodViewController alloc] initWithViewModel:viewModel];
            smartFoodVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:smartFoodVC animated:YES];
        }];
    }
    //显示
    if (checkedView.hidden) {
        if (self.selectedId.count >= 5) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows.lastObject animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"组合食材不得超过5个";
            [hud hideAnimated:YES afterDelay:1];
            return;
        }
        
        [self addFoodImageView:foodDict FoodBasket:foodBasket CheckedView:checkedView Cancle:_cancleBtn Ok:_okBtn];
        
    //隐藏
    }else{
        if (self.selectedId.count <= 0) {
            return;
        }
        
        [self removeFoodImageView:[foodDict objectForKey:@"id"] FoodBasket:foodBasket CheckedView:checkedView Cancle:_cancleBtn Ok:_okBtn];
    }
    
    NSLog(@"%@", self.selectedId);
}

//添加食材
- (void)addFoodImageView:(NSDictionary *)foodDict FoodBasket:(UIView *)foodBasket CheckedView:(UIView *)checkedView Cancle:(UIButton *)cancleBtn Ok:(UIButton *)okBtn {
    NSString *foodId = [foodDict objectForKey:@"id"];
    [self.selectedId addObject:foodId];
    
    [checkedView setHidden:NO];
    if (cancleBtn.enabled == NO) {
        cancleBtn.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.8].CGColor;
        [cancleBtn setEnabled:YES];
    }
    if (okBtn.enabled == NO) {
        okBtn.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.8].CGColor;
        [okBtn setEnabled:YES];
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = kRGBColor(230, 230, 230);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = 12.5;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[foodDict objectForKey:@"icon"]]];
    [foodBasket addSubview:imageView];
    //删除手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self removeFoodImageView:[foodDict objectForKey:@"id"] FoodBasket:foodBasket CheckedView:checkedView Cancle:cancleBtn Ok:okBtn];
    }];
    [imageView addGestureRecognizer:tap];
    
    [self.selectedFood setObject:imageView forKey:foodId];
    [self.selectedCheckedView setObject:checkedView forKey:foodId];
    CGFloat offsetLeft = (self.selectedId.count-1)*35;
    CGFloat searchTextOffsetLeft = self.selectedId.count*35;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(foodBasket.mas_top).mas_offset(0);
        make.bottom.equalTo(foodBasket.mas_bottom).mas_offset(0);
        make.left.equalTo(foodBasket.mas_left).mas_offset(offsetLeft);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    id object = [foodBasket.subviews objectAtIndex:0];
    if (object != nil && [object isKindOfClass:[UITextField class]]) {
        UITextField *searchText = (UITextField *)object;
        [searchText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(foodBasket.mas_left).mas_offset(searchTextOffsetLeft);
        }];
    }
}

//删除食材
- (void)removeFoodImageView:(NSString *)foodId FoodBasket:(UIView *)foodBasket CheckedView:(UIView *)checkedView Cancle:(UIButton *)cancleBtn Ok:(UIButton *)okBtn {
    [self.selectedId removeObject:foodId];
    
    [checkedView setHidden:YES];
    if (self.selectedId.count <= 0) {
        if (cancleBtn.enabled == YES) {
            cancleBtn.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
            [cancleBtn setEnabled:NO];
        }
        if (okBtn.enabled == YES) {
            okBtn.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
            [okBtn setEnabled:NO];
        }
    }
   
    UIImageView *imageView = [self.selectedFood objectForKey:foodId];
    [imageView removeFromSuperview];
    [self.selectedFood removeObjectForKey:foodId];
    [self.selectedCheckedView removeObjectForKey:foodId];
    
    //重新计算offset
    [foodBasket.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat offsetLeft = (idx-1)*35;
        CGFloat searchTextOffsetLeft = self.selectedId.count*35;
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField *searchText = (UITextField *)obj;
            [searchText mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(foodBasket.mas_left).mas_offset(searchTextOffsetLeft);
            }];
        }else if([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)obj;
            [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(foodBasket.mas_left).mas_offset(offsetLeft);
            }];
        }
    }];
}




@end
