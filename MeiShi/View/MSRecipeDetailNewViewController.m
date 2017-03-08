//
//  MSRecipeDetailNewViewController.m
//  MeiShi
//
//  Created by PeterLee on 2017/3/7.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSRecipeDetailNewViewController.h"
#import "MSRecipeDetailNewViewModel.h"
#import "MSUtils.h"
#import "MSTableViewCell.h"

@interface MSRecipeDetailNewViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIWindow *navWindow;
@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, strong) MSRecipeDetailNewViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerView;

@end

@implementation MSRecipeDetailNewViewController
@dynamic viewModel;

- (void)bindViewModel {
    [super bindViewModel];
    [[RACObserve(self.viewModel, recipeDetailNewData) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }] subscribeNext:^(NSDictionary *dict) {
        self.data = dict;
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:[[_data objectForKey:@"cover_img"] objectForKey:@"big"]]];
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewModel.requestRecipeDetailNewData execute:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(kScreenWidth, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //头图放在table上
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kScreenWidth, kScreenWidth, kScreenWidth)];
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    headerView.clipsToBounds = YES;
    [self.tableView addSubview:headerView];
    self.headerView = headerView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self backButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //释放window
    self.navWindow = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

//隐藏statusBar
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)backButton {
    
    UIWindow *navWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    navWindow.windowLevel = UIWindowLevelStatusBar;
    //显示window
    [navWindow makeKeyAndVisible];
    self.navWindow = navWindow;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    backButton.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [backButton setImage:[[UIImage imageNamed:@"ms_back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [backButton setImage:[[UIImage imageNamed:@"ms_back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navWindow addSubview:backButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(kScreenWidth-44, 0, 44, 44);
    rightButton.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [rightButton setImage:[[UIImage imageNamed:@"ms_new_report"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [rightButton setImage:[[UIImage imageNamed:@"ms_new_report"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    [self.navWindow addSubview:rightButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 2) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0){
        MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
        if (cell == nil) {
            cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
            cell.backgroundColor = kRGBColor(255, 245, 212);
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.numberOfLines = 1;
            titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *favorLabel = [[UILabel alloc] init];
            favorLabel.numberOfLines = 1;
            [cell.contentView addSubview:favorLabel];
            
            UILabel *viewedLabel = [[UILabel alloc] init];
            viewedLabel.numberOfLines = 1;
            [cell.contentView addSubview:viewedLabel];
        }
        
        if(_data != nil) {
            UILabel *titleLabel = [cell.contentView.subviews objectAtIndex:0];
            NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                    initWithString:[_data objectForKey:@"title"]
                                                    attributes:@{
                                                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:25],
                                                                 NSForegroundColorAttributeName:[UIColor blackColor]
                                                                 }];
            titleLabel.attributedText = attributedString;
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).mas_offset(20);
                make.right.equalTo(cell.contentView).mas_offset(-20);
                make.top.equalTo(cell.contentView).mas_offset(25);
                make.height.mas_equalTo(25);
            }];
            
            NSDictionary *attributes = @{
                                        NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                        NSForegroundColorAttributeName:kRGBColor(93, 95, 97)
                                        };
            NSString *favorString = [[_data objectForKey:@"favor_amount"] stringByAppendingString:@"人收藏"];
            UILabel *favorLabel = [cell.contentView.subviews objectAtIndex:1];
            NSAttributedString *favorAttributedString = [[NSAttributedString alloc]
                                                         initWithString:favorString
                                                         attributes:attributes];
            favorLabel.attributedText = favorAttributedString;
            CGSize favorSize = [favorString sizeWithAttributes:attributes];
            CGFloat favorWidth = favorSize.width+10;
            [favorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).mas_offset(15);
                make.left.equalTo(cell.contentView.mas_left).mas_offset(20);
                make.width.mas_equalTo(favorWidth);
                make.height.mas_equalTo(15);
            }];
            
            NSString *viewedString = [[_data objectForKey:@"viewed_amount"] stringByAppendingString:@"人浏览"];
            UILabel *viewedLabel = [cell.contentView.subviews objectAtIndex:2];
            NSAttributedString *viewedAttributedString = [[NSAttributedString alloc]
                                                    initWithString:viewedString
                                                    attributes:attributes];
            viewedLabel.attributedText = viewedAttributedString;
            CGSize viewedSize = [viewedString sizeWithAttributes:attributes];
            CGFloat viewedWidth = viewedSize.width+10;
            [viewedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).mas_offset(15);
                make.left.equalTo(favorLabel.mas_right).mas_offset(5);
                make.width.mas_equalTo(viewedWidth);
                make.height.mas_equalTo(15);
            }];
        }
        return cell;
    }else if(section == 1){
        if (row == 0) {
            MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"authorCell"];
            if (cell == nil) {
                cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"authorCell"];
                UIImageView *avatarView = [[UIImageView alloc] init];
                avatarView.clipsToBounds = YES;
                avatarView.contentMode = UIViewContentModeScaleAspectFill;
                avatarView.layer.cornerRadius = 20;
                [cell.contentView addSubview:avatarView];
                [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView.mas_left).mas_offset(15);
                    make.top.equalTo(cell.contentView.mas_top).mas_offset(25);
                    make.width.mas_equalTo(40);
                    make.height.mas_equalTo(40);
                }];
                
                UIButton *followingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                followingBtn.layer.cornerRadius = 12.5;
                followingBtn.layer.borderColor = [UIColor redColor].CGColor;
                followingBtn.layer.borderWidth = 1;
                NSAttributedString *followAttr = [[NSAttributedString alloc]
                                                  initWithString:@"关注"
                                                  attributes:@{
                                                               NSForegroundColorAttributeName: [UIColor redColor],
                                                               NSFontAttributeName: [UIFont systemFontOfSize:14]
                                                               }];
                [followingBtn setAttributedTitle:followAttr forState:UIControlStateNormal];
                [followingBtn setAttributedTitle:followAttr forState:UIControlStateHighlighted];
                
                [cell.contentView addSubview:followingBtn];
                [followingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView.mas_right).mas_offset(-15);
                    make.top.equalTo(avatarView.mas_top).mas_offset(5);
                    make.width.mas_equalTo(55);
                    make.height.mas_equalTo(25);
                }];
                
                UILabel *nicknameLabel = [UILabel new];
                nicknameLabel.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:nicknameLabel];
                [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(avatarView.mas_right).mas_offset(5);
                    make.right.equalTo(followingBtn.mas_left).mas_offset(5);
                    make.top.equalTo(avatarView.mas_top).mas_offset(5);
                    make.height.mas_equalTo(15);
                }];
               
                UILabel *recipeNumLabel = [UILabel new];
                recipeNumLabel.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:recipeNumLabel];
                [recipeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(nicknameLabel.mas_leading).mas_offset(0);
                    make.top.equalTo(nicknameLabel.mas_bottom).mas_offset(5);
                    make.trailing.equalTo(nicknameLabel.mas_trailing).mas_offset(0);
                    make.height.mas_equalTo(10);
                }];
            }
            
            if (_data != nil) {
                UIImageView *avatarView = [cell.contentView.subviews objectAtIndex:0];
                [avatarView sd_setImageWithURL:[NSURL URLWithString:[[_data objectForKey:@"author"] objectForKey:@"avatar_url"]]];
                if ([[[_data objectForKey:@"author"] objectForKey:@"if_v"] isEqualToString:@"1"]) {
                    UIImageView *vView = [[UIImageView alloc] init];
                    vView.contentMode = UIViewContentModeScaleAspectFill;
                    vView.image = [UIImage imageNamed:@"v"];
                    //vView.layer.cornerRadius = 15;
                    [avatarView addSubview:vView];
                    [vView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(avatarView.mas_right).mas_offset(-3);
                        make.bottom.equalTo(avatarView.mas_bottom).mas_offset(-3);
                        make.width.mas_equalTo(15);
                        make.height.mas_equalTo(15);
                    }];
                }
                UIButton *followingBtn = [cell.contentView.subviews objectAtIndex:1];
                [[followingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                    NSLog(@"关注");
                }];
                
                NSDictionary *attributes = @{
                                             NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                             NSForegroundColorAttributeName:kRGBColor(102, 102, 102)
                                             };
                NSString *nickname = [[_data objectForKey:@"author"] objectForKey:@"nickname"];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:nickname attributes:attributes];
                UILabel *nicknameLabel = [cell.contentView.subviews objectAtIndex:2];
                nicknameLabel.attributedText = attrString;
            
                NSDictionary *recipenumAttributes = @{
                                             NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                             NSForegroundColorAttributeName:kRGBColor(154, 154, 154)
                                             };
                NSString *recipenum = [NSString stringWithFormat:@"同发布了%@篇菜谱", [[_data objectForKey:@"author"] objectForKey:@"pub_recipe_num"]];
                NSAttributedString *recipenumAttrString = [[NSAttributedString alloc] initWithString:recipenum attributes:recipenumAttributes];
                UILabel *recipeNumLabel = [cell.contentView.subviews objectAtIndex:3];
                recipeNumLabel.attributedText = recipenumAttrString;
            }
            
            return cell;
        }else if(row == 1){
            MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCell"];
            if (cell == nil) {
                cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descCell"];
            }
            return cell;
        }
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        return 100;
    }else if (section == 1) {
        if (row == 0) {
            return 80;
        }else if(row == 1){
            return 100;
        }
    }
    return 10;
}

#pragma mark UIScorllViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if(y < -kScreenWidth){
        CGRect rect = self.headerView.frame;
        rect.origin.x = (y+kScreenWidth)/2;
        rect.origin.y = y;
        rect.size.width = -y;
        rect.size.height = -y;
        self.headerView.frame = rect;
    }
}



@end
