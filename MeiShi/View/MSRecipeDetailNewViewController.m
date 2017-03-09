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
#import "MSStarView.h"

@interface MSRecipeDetailNewViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, assign) CGFloat storyContentHeight;
@property (nonatomic, assign) CGFloat stepHeight;

@end

@implementation MSRecipeDetailNewViewController
@dynamic viewModel;

- (void)bindViewModel {
    [super bindViewModel];
    
    RACSignal *recipeSignal = [RACObserve(self, data) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }];
    RACSignal *plSignal = [RACObserve(self, plData) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }];
    RACSignal *questionSignal = [RACObserve(self, questionData) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }];
    RACSignal *goodsRecommendSignal = [RACObserve(self, goodsRecommendData) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }];
    RACSignal *recipeRecommendSignal = [RACObserve(self, recipeRecommendData) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }];
    
    [[RACSignal combineLatest:@[recipeSignal, plSignal, questionSignal, goodsRecommendSignal, recipeRecommendSignal]] subscribeNext:^(RACTuple *tuple) {
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:[[_data objectForKey:@"cover_img"] objectForKey:@"big"]]];
        //[self.tableView reloadData];
    }];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(kScreenWidth, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = kRGBColor(240, 240, 240);
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //头图放在table上
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kScreenWidth, kScreenWidth, kScreenWidth)];
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    headerView.clipsToBounds = YES;
    [self.tableView addSubview:headerView];
    self.headerView = headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_data objectForKey:@"cook_steps"] count]+9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger steps = [[_data objectForKey:@"cook_steps"] count];
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 3;
    }else if (section == 2) {
        return [[_data objectForKey:@"main_ingredient"] count]+1;
    }else if (section == 3) {
        return [[_data objectForKey:@"secondary_ingredient"] count]+1;
    }else if (section == 4) {
        return 1;
    }else if (section == steps+5){
        return 5;
    }else if (section == steps+6){
        return 6;
    }else if (section == steps+7){
        return 2;
    }else if (section == steps+8){
        return 3;
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
        
            return cell;
        }else if(row == 1){
            MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCell"];
            if (cell == nil) {
                cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descCell"];
                UILabel *detailLabel = [UILabel new];
                detailLabel.numberOfLines = 0;
                [cell.contentView addSubview:detailLabel];
                [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 15, 20, 30));
                }];
            }
            
        
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 10;
            NSDictionary *attributes = @{
                                         NSFontAttributeName: [UIFont systemFontOfSize:16],
                                         NSForegroundColorAttributeName: kRGBColor(48, 48, 48),
                                         NSParagraphStyleAttributeName: style
                                         };
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[_data objectForKey:@"story_content"] attributes:attributes];
            UILabel *detailLabel = [cell.contentView.subviews objectAtIndex:0];
            detailLabel.attributedText = attributedString;
            CGSize size = [detailLabel sizeThatFits:CGSizeMake(detailLabel.frame.size.width, CGFLOAT_MAX)];
            self.storyContentHeight = size.height+20;
            
            return cell;
        }else if(row == 2){
            MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pingfenCell"];
            if (cell == nil) {
                cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pingfenCell"];
                
                UIView *superview = cell.contentView;
                
                UILabel *pingfen = [UILabel new];
                pingfen.text = @"评分";
                pingfen.textColor = kRGBColor(51, 51, 51);
                pingfen.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:pingfen];
                [pingfen mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(superview.mas_left).mas_offset(15);
                    make.top.equalTo(superview.mas_top).mas_offset(30);
                    make.width.mas_equalTo(30);
                    make.height.mas_equalTo(20);
                }];
                
                MSStarView *star = [[MSStarView alloc] init];
                star.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:star];
                [star mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(pingfen.mas_right).mas_offset(15);
                    make.top.equalTo(pingfen.mas_top).mas_offset(0);
                    make.width.mas_equalTo(125);
                    make.height.equalTo(pingfen.mas_height);
                }];
                
                UIImageView *favor = [UIImageView new];
                favor.image = [UIImage imageNamed:@"detail_favor"];
                favor.contentMode = UIViewContentModeScaleAspectFill;
                [cell.contentView addSubview:favor];
                [favor mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(superview.mas_top).mas_offset(0);
                    make.right.equalTo(superview.mas_right).mas_offset(-15);
                    make.width.mas_equalTo(45);
                    make.height.mas_equalTo(75);
                }];

                UIImageView *technologyImageView = [UIImageView new];
                technologyImageView.image = [UIImage imageNamed:@"detail_technology"];
                technologyImageView.contentMode = UIViewContentModeCenter;
                [cell.contentView addSubview:technologyImageView];
                [technologyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(pingfen.mas_leading).mas_offset(0);
                    make.top.equalTo(favor.mas_bottom).mas_offset(0);
                    make.width.mas_equalTo(20);
                    make.height.mas_equalTo(20);
                }];
                UILabel *technologyLabel = [UILabel new];
                technologyLabel.tag = 901;
                technologyLabel.textColor = kRGBColor(134, 134, 134);
                technologyLabel.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:technologyLabel];
                [technologyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(technologyImageView.mas_right).mas_offset(15);
                    make.top.equalTo(technologyImageView.mas_top).mas_offset(0);
                    make.width.mas_equalTo(100);
                    make.height.equalTo(technologyImageView.mas_height);
                }];
                
                UIImageView *tasteImageView = [UIImageView new];
                tasteImageView.image = [UIImage imageNamed:@"detail_taste"];
                tasteImageView.contentMode = UIViewContentModeCenter;
                [cell.contentView addSubview:tasteImageView];
                [tasteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(technologyImageView.mas_leading).mas_offset(0);
                    make.top.equalTo(technologyImageView.mas_bottom).mas_offset(10);
                    make.width.equalTo(technologyImageView.mas_width);
                    make.height.equalTo(technologyImageView.mas_height);
                }];
                UILabel *tasteLabel = [UILabel new];
                tasteLabel.tag = 902;
                tasteLabel.textColor = kRGBColor(134, 134, 134);
                tasteLabel.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:tasteLabel];
                [tasteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(technologyLabel.mas_leading).mas_offset(0);
                    make.top.equalTo(technologyLabel.mas_bottom).mas_offset(10);
                    make.width.equalTo(technologyLabel.mas_width);
                    make.height.equalTo(technologyLabel.mas_height);
                }];

                UIImageView *cookingTimeImageView = [UIImageView new];
                cookingTimeImageView.image = [UIImage imageNamed:@"detail_clock"];
                cookingTimeImageView.contentMode = UIViewContentModeCenter;
                [cell.contentView addSubview:cookingTimeImageView];
                [cookingTimeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(tasteImageView.mas_leading).mas_offset(0);
                    make.top.equalTo(tasteImageView.mas_bottom).mas_offset(10);
                    make.width.equalTo(tasteImageView.mas_width);
                    make.height.equalTo(tasteImageView.mas_height);
                }];
                UILabel *cookingTimeLabel = [UILabel new];
                cookingTimeLabel.tag = 903;
                cookingTimeLabel.textColor = kRGBColor(134, 134, 134);
                cookingTimeLabel.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:cookingTimeLabel];
                [cookingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(tasteLabel.mas_leading).mas_offset(0);
                    make.top.equalTo(tasteLabel.mas_bottom).mas_offset(10);
                    make.width.equalTo(tasteLabel.mas_width);
                    make.height.equalTo(tasteLabel.mas_height);
                }];

                UIImageView *caloricImageView = [UIImageView new];
                caloricImageView.image = [UIImage imageNamed:@"detail_fire"];
                caloricImageView.contentMode = UIViewContentModeCenter;
                [cell.contentView addSubview:caloricImageView];
                [caloricImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(cookingTimeImageView.mas_leading).mas_offset(0);
                    make.top.equalTo(cookingTimeImageView.mas_bottom).mas_offset(10);
                    make.width.equalTo(cookingTimeImageView.mas_width);
                    make.height.equalTo(cookingTimeImageView.mas_height);
                }];
                UILabel *caloricLabel = [UILabel new];
                caloricLabel.tag = 904;
                caloricLabel.textColor = kRGBColor(134, 134, 134);
                caloricLabel.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:caloricLabel];
                [caloricLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(cookingTimeLabel.mas_leading).mas_offset(0);
                    make.top.equalTo(cookingTimeLabel.mas_bottom).mas_offset(10);
                    make.width.equalTo(cookingTimeLabel.mas_width);
                    make.height.equalTo(cookingTimeLabel.mas_height);
                }];
                
            }
            
            
            MSStarView *star = [cell.contentView.subviews objectAtIndex:1];
            star.num = [[_data objectForKey:@"rate"] integerValue];
            UILabel *technologyLabel = [cell.contentView viewWithTag:901];
            technologyLabel.text = [_data objectForKey:@"technology"];
            UILabel *tasteLabel = [cell.contentView viewWithTag:902];
            tasteLabel.text = [_data objectForKey:@"taste"];
            UILabel *cookingTimeLabel = [cell.contentView viewWithTag:903];
            cookingTimeLabel.text = [_data objectForKey:@"cooking_time"];
            UILabel *caloricLabel = [cell.contentView viewWithTag:904];
            caloricLabel.text = [_data objectForKey:@"caloric"];
            
            return cell;
        }
    
    }else if(section == 2) {
        
        if (row == 0) {
            MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhuliaoheaderCell"];
            if (cell == nil) {
                cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zhuliaoheaderCell"];
                cell.backgroundColor = kRGBColor(255, 245, 212);
                UILabel *titleLabel = [UILabel new];
                titleLabel.text = @"主料";
                titleLabel.textColor = [UIColor blackColor];
                titleLabel.font = [UIFont systemFontOfSize:16];
                [cell.contentView addSubview:titleLabel];
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView.mas_left).mas_offset(15);
                    make.centerY.equalTo(cell.contentView.mas_centerY).mas_offset(0);
                    make.size.mas_equalTo(CGSizeMake(40, 20));
                }];
                UILabel *amountLabel = [UILabel new];
                amountLabel.textColor = kRGBColor(102, 102, 102);
                amountLabel.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:amountLabel];
                [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleLabel.mas_right).mas_equalTo(15);
                    make.centerY.equalTo(titleLabel.mas_centerY).mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(40, 15));
                }];
            }
            
            
            UILabel *amountLabel = [cell.contentView.subviews objectAtIndex:1];
            amountLabel.text = [_data objectForKey:@"amount"];
            
            return cell;
        }else{
            MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhuliaoCell"];
            if (cell == nil) {
                cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zhuliaoCell"];
                UILabel *titleLabel = [UILabel new];
                titleLabel.textColor = [UIColor blackColor];
                titleLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:titleLabel];
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView.mas_left).mas_offset(15);
                    make.centerY.equalTo(cell.contentView.mas_centerY).mas_offset(0);
                    make.size.mas_equalTo(CGSizeMake(170, 20));
                }];
                UILabel *numLabel = [UILabel new];
                numLabel.textColor = [UIColor blackColor];
                numLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:numLabel];
                [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleLabel.mas_right).mas_equalTo(0);
                    make.centerY.equalTo(titleLabel.mas_centerY).mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(100, 20));
                }];
            }
            
           
            UILabel *titleLabel = [cell.contentView.subviews objectAtIndex:0];
            titleLabel.text = [[[_data objectForKey:@"main_ingredient"] objectAtIndex:row-1] objectForKey:@"title"];
            UILabel *numLabel = [cell.contentView.subviews objectAtIndex:1];
            numLabel.text = [[[_data objectForKey:@"main_ingredient"] objectAtIndex:row-1] objectForKey:@"amount"];
            
            return cell;
        }
        
    }else if(section == 3) {
        
        if (row == 0) {
            MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fuliaoheaderCell"];
            if (cell == nil) {
                cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fuliaoheaderCell"];
                cell.backgroundColor = kRGBColor(255, 245, 212);
                UILabel *titleLabel = [UILabel new];
                titleLabel.text = @"辅料";
                titleLabel.textColor = [UIColor blackColor];
                titleLabel.font = [UIFont systemFontOfSize:16];
                [cell.contentView addSubview:titleLabel];
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView.mas_left).mas_offset(15);
                    make.centerY.equalTo(cell.contentView.mas_centerY).mas_offset(0);
                    make.size.mas_equalTo(CGSizeMake(40, 20));
                }];
            }
            
            return cell;
        }else{
            MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fuliaoCell"];
            if (cell == nil) {
                cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fuliaoCell"];
                UILabel *titleLabel = [UILabel new];
                titleLabel.textColor = [UIColor blackColor];
                titleLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:titleLabel];
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView.mas_left).mas_offset(15);
                    make.centerY.equalTo(cell.contentView.mas_centerY).mas_offset(0);
                    make.size.mas_equalTo(CGSizeMake(170, 20));
                }];
                UILabel *numLabel = [UILabel new];
                numLabel.textColor = [UIColor blackColor];
                numLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:numLabel];
                [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleLabel.mas_right).mas_equalTo(0);
                    make.centerY.equalTo(titleLabel.mas_centerY).mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(100, 20));
                }];
            }
            
            UILabel *titleLabel = [cell.contentView.subviews objectAtIndex:0];
            titleLabel.text = [[[_data objectForKey:@"secondary_ingredient"] objectAtIndex:row-1] objectForKey:@"title"];
            UILabel *numLabel = [cell.contentView.subviews objectAtIndex:1];
            numLabel.text = [[[_data objectForKey:@"secondary_ingredient"] objectAtIndex:row-1] objectForKey:@"amount"];
            
            return cell;
        }
        
    }else if(section == 4) {
        MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toolCell"];
        if (cell == nil) {
            cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"toolCell"];
        }
        return cell;
    }
    
    NSInteger steps = [[_data objectForKey:@"cook_steps"] count];
    if (section >= 5 && section <= steps+4) {
        MSTableViewCell *cell = [[MSTableViewCell alloc] init];
        CGFloat cHeight = 0;
        
        NSDictionary *cookSteps = [[_data objectForKey:@"cook_steps"] objectAtIndex:section-5];
        id picUrls = [cookSteps objectForKey:@"pic_urls"];
        if(picUrls != [NSNull null]){
            NSDictionary *stepDict = [[cookSteps objectForKey:@"pic_urls"] objectAtIndex:0];
            NSString *big = [stepDict objectForKey:@"big"];
            CGFloat width = [[stepDict objectForKey:@"width"] floatValue];
            CGFloat height = [[stepDict objectForKey:@"height"] floatValue];
            cHeight += kScreenWidth/width*height;
            UIImageView *imageView = [UIImageView new];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [cell.contentView addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:big]];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(cell.contentView).mas_offset(0);
                make.height.mas_offset(cHeight);
            }];
        }
        
        NSString *content = [cookSteps objectForKey:@"content"];
        if(content != nil){
            UILabel *textLabel = [UILabel new];
            textLabel.numberOfLines = 0;
            [cell.contentView addSubview:textLabel];
        
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            style.lineSpacing = 10;
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:14],
                                         NSForegroundColorAttributeName:kRGBColor(60, 60, 60),
                                         NSParagraphStyleAttributeName:style
                                         };
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
            textLabel.attributedText = attrString;
            CGSize size = [textLabel sizeThatFits:CGSizeMake(kScreenWidth-45, CGFLOAT_MAX)];
            [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView.mas_top).mas_offset(cHeight+20);
                make.left.equalTo(cell.contentView.mas_left).mas_offset(15);
                make.right.equalTo(cell.contentView.mas_right).mas_offset(-30);
                make.height.mas_offset(size.height);
            }];
            
            cHeight += size.height+40;
        }
        
        self.stepHeight = cHeight;
        
        
        
        return cell;
    }
    
    if (section == steps+5){
        MSTableViewCell *cell = [[MSTableViewCell alloc] init];
        if (row == 0) {
            UIView *line = [UIView new];
            line.backgroundColor = kRGBColor(240, 240, 240);
            [cell.contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }else if(row == 1) {
            UILabel *label = [UILabel new];
            label.text = @"评论";
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:18];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).mas_offset(15);
                make.top.equalTo(cell.contentView.mas_top).mas_offset(25);
                make.size.mas_equalTo(CGSizeMake(40, 25));
            }];
        }else if(row == 4){
            UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            moreBtn.layer.cornerRadius = 20;
            moreBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            moreBtn.layer.borderWidth = 1;
            NSString *totalAmount = [_plData objectForKey:@"total_amount"];
            NSString *moreBtnString = [NSString stringWithFormat:@"更多评论(%@)", totalAmount];
            [moreBtn setTitle:moreBtnString forState:UIControlStateNormal];
            [moreBtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
            moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            
            [cell.contentView addSubview:moreBtn];
            [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_centerX).mas_offset(-10);
                make.top.equalTo(cell.contentView.mas_top).mas_offset(0);
                make.size.mas_equalTo(CGSizeMake(130, 40));
            }];
            
            UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            commentBtn.layer.cornerRadius = 20;
            commentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            commentBtn.layer.borderWidth = 1;
            NSString *commentBtnString = @"我要评论";
            [commentBtn setTitle:commentBtnString forState:UIControlStateNormal];
            [commentBtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
            commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:commentBtn];
            [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_centerX).mas_offset(10);
                make.top.equalTo(cell.contentView.mas_top).mas_offset(0);
                make.size.mas_equalTo(CGSizeMake(130, 40));
            }];
        }else{
            UIView *superview = cell.contentView;
            NSDictionary *item = [[_plData objectForKey:@"items"] objectAtIndex:row-2];
            NSString *avatarUrl = [[item objectForKey:@"author"] objectForKey:@"avatar_url"];
            UIImageView *avatar = [UIImageView new];
            [avatar sd_setImageWithURL:[NSURL URLWithString:avatarUrl]];
            avatar.contentMode = UIViewContentModeScaleAspectFill;
            avatar.layer.cornerRadius = 20;
            avatar.clipsToBounds = YES;
            [cell.contentView addSubview:avatar];
            [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(superview.mas_left).mas_offset(15);
                make.top.equalTo(superview.mas_top).mas_offset(15);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
            
            UILabel *nickname = [UILabel new];
            nickname.text = [[item objectForKey:@"author"] objectForKey:@"nickname"];
            nickname.font = [UIFont systemFontOfSize:10];
            nickname.textColor = kRGBColor(111, 111, 111);
            [cell.contentView addSubview:nickname];
            [nickname mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(avatar.mas_right).mas_offset(10);
                make.top.equalTo(avatar.mas_top).mas_offset(5);
                make.width.mas_equalTo(140);
                make.height.mas_equalTo(15);
            }];
            
            UILabel *time = [UILabel new];
            time.text = [item objectForKey:@"create_time"];
            time.font = [UIFont systemFontOfSize:8];
            time.textColor = kRGBColor(111, 111, 111);
            [cell.contentView addSubview:time];
            [time mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(nickname.mas_leading).mas_offset(0);
                make.top.equalTo(nickname.mas_bottom).mas_offset(5);
                make.width.mas_equalTo(140);
                make.height.mas_equalTo(10);
            }];

            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [cell.contentView addSubview:rightBtn];
            [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(superview.mas_right).offset(-15);
                make.top.equalTo(superview.mas_top).mas_offset(15);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            
            NSString *contentString = [item objectForKey:@"content"];
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            style.lineSpacing = 10;
            NSDictionary *attributes = @{
                                         NSFontAttributeName: [UIFont systemFontOfSize:14],
                                         NSForegroundColorAttributeName: [UIColor blackColor],
                                         NSParagraphStyleAttributeName: style
                                         };
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:contentString attributes:attributes];
            UILabel *content = [UILabel new];
            content.attributedText = attributedString;
            content.numberOfLines = 0;
            CGSize size = [content sizeThatFits:CGSizeMake(kScreenWidth-30, CGFLOAT_MAX)];
            [cell.contentView addSubview:content];
            [content mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(avatar.mas_leading).mas_offset(0);
                make.top.equalTo(avatar.mas_bottom).mas_offset(10);
                make.width.mas_equalTo(kScreenWidth-30);
                make.height.mas_equalTo(size.height+20);
            }];
            
            
        }
        return cell;
    }else if (section == steps+6){
        MSTableViewCell *cell = [[MSTableViewCell alloc] init];
        return cell;
    }else if (section == steps+7){
        MSTableViewCell *cell = [[MSTableViewCell alloc] init];
        return cell;
    }else if (section == steps+8){
        MSTableViewCell *cell = [[MSTableViewCell alloc] init];
        return cell;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSInteger steps = [[_data objectForKey:@"cook_steps"] count];
    if (section >= 5 && section <= steps+4) {
        NSDictionary *stepDict = [[_data objectForKey:@"cook_steps"] objectAtIndex:(section-5)];
        NSString *title = [stepDict objectForKey:@"title"];
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor whiteColor];
        return titleLabel;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger steps = [[_data objectForKey:@"cook_steps"] count];
    if (section >= 5 && section <= steps+4) {
        return 50;
    }
    return 0;
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
            return self.storyContentHeight;
        }else if (row == 2  ) {
            return 222;
        }
    }else if (section == 2  ) {
        if (row == 0) {
            return 40;
        }
        return 50;
    }else if (section == 3  ) {
        if (row == 0) {
            return 40;
        }
        return 50;
    }else if (section == 4 ) {
        return 50;
    }
    
    
    NSInteger steps = [[_data objectForKey:@"cook_steps"] count];
    if (section >= 5 && section <= steps+4) {
        return self.stepHeight;
    }
    
    if (section == steps+5){
        if (row == 0) {
            return 20;
        }else if(row == 1){
            return 50;
        }else{
            return 125;
        }
        return 50;
    }else if (section == steps+6){
        return 100;
    }else if (section == steps+7){
         return 100;
    }else if (section == steps+8){
         return 100;
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
    
    //调整contentInset，以显示头图
    if (y > kScreenWidth) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        scrollView.contentInset = UIEdgeInsetsMake(kScreenWidth, 0, 0, 0);
    }
    
}



@end
