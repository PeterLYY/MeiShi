//
//  MSCommendViewController.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/20.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSTabBarController.h"
#import "MSNavgationController.h"
#import "MSCommendViewController.h"
#import "MSRecommendViewModel.h"
#import "MSRecommendViewController.h"
#import "MSRecommendTopBannerCell.h"
#import "MSWebAdvViewController.h"
#import "MSTableViewCell.h"
#import "MSRefreshManager.h"

#define kTopBannersCellId   @"topBannersCell"

@interface MSCommendViewController ()

@property (nonatomic, strong) MSRecommendViewModel *viewModel;
@property (nonatomic, copy) NSArray *topbannerData;
@property (nonatomic, copy) NSDictionary *sancan;
@property (nonatomic, copy) NSDictionary *hotGoods;
@property (nonatomic, copy) NSDictionary *recommendGoods;
@property (nonatomic, copy) NSDictionary *weeklyTopic;
@property (nonatomic, copy) NSDictionary *recommendReadings;

@property (nonatomic, strong) UILabel *sancanTitleLabel;
@property (nonatomic, copy) NSDictionary *data;

@property (nonatomic, assign) CGFloat weeklyTopicImageHeight;
@property (nonatomic, assign) CGFloat recommendReadingsImageHeight;


@end

@implementation MSCommendViewController
@dynamic viewModel;

- (void)bindViewModel {
    [RACObserve(self.viewModel, data) subscribeNext:^(NSDictionary *data) {
        if (data != nil) {
            self.tableView.hidden = NO;
            self.data  = data;
            self.topbannerData = [[data objectForKey:@"top_banners"] objectForKey:@"item"];
            self.sancan = [data objectForKey:@"sancan"];
            self.hotGoods = [data objectForKey:@"hot_goods"];
            self.recommendGoods = [data objectForKey:@"recommend_goods"];
            self.weeklyTopic = [data objectForKey:@"weekly_topic"];
            self.recommendReadings = [data objectForKey:@"recommend_readings"];
            [self.tableView reloadData];
        }else{
            //没有数据，隐藏
            self.tableView.hidden = YES;
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kRGBColor(245, 245, 245);
    [self.tableView registerClass:[MSRecommendTopBannerCell class] forCellReuseIdentifier:kTopBannersCellId];
    [MSRefreshManager addPullRefreshWithScrollView:self.tableView pullRefreshClassBack:^{
        [self.viewModel.requestDataCommand execute:nil];
        [RACObserve(self.viewModel, data) subscribeNext:^(id  _Nullable x) {
            if(x != nil) {
                [self.tableView reloadData];
                [MSRefreshManager endHeaderRefresh:self.tableView];
            }
        }];
    }];
}

- (void)viewDidLayoutSubviews {
    //重设frame
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 4;
    }else if (section == 2) {
        return 2;
    }else if (section == 3) {
        return 2;
    }else if (section == 4) {
        NSUInteger num = [[[self.weeklyTopic objectForKey:@"items"] objectForKey:@"item"] count];
        return num+1;
    }else if (section == 5) {
        NSUInteger num = [[[self.recommendReadings objectForKey:@"groups"] objectForKey:@"item"] count];
        return num+1;
    }
    return 1;
}

- (MSTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
#pragma mark - 轮播
    if (section == 0) {
        MSRecommendTopBannerCell *topbannerCell = [tableView dequeueReusableCellWithIdentifier:kTopBannersCellId forIndexPath:indexPath];
        topbannerCell.backgroundColor = [UIColor whiteColor];
        if(self.topbannerData != nil){
            topbannerCell.data = self.topbannerData;
            topbannerCell.tapGetureHandle = ^(NSString *urlString) {
                MSWebAdvViewController *webAdVC = [[MSWebAdvViewController alloc] init];
                webAdVC.adurl = urlString;
                [self.parentViewController.navigationController pushViewController:webAdVC animated:YES];
            };
        }
        return topbannerCell;
#pragma mark - 三餐
    }else if (section == 1) {
        
        if (indexPath.row == 0) {
            MSTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"sancanTitleCell"];
            if(myCell == nil){
                myCell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sancanTitleCell"];
                UILabel *titleLabel = [[UILabel alloc] init];
                [myCell.contentView addSubview:titleLabel];
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(myCell.mas_left).mas_offset(15);
                    make.right.mas_equalTo(myCell.mas_right).mas_offset(-50);
                    make.top.mas_equalTo(myCell.mas_top).mas_offset(0);
                    make.bottom.mas_equalTo(myCell.mas_bottom).mas_offset(0);
                }];
                UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [moreButton setTitle:@"全部" forState:UIControlStateNormal];
                [moreButton setTitleColor:kRGBColor(170, 170, 170) forState:UIControlStateNormal];
                moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
                [moreButton setBackgroundColor:[UIColor whiteColor]];
                [myCell.contentView addSubview:moreButton];
                [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(myCell.mas_right).offset(-10);
                    make.top.mas_equalTo(myCell.mas_top).offset(0);
                    make.bottom.mas_equalTo(myCell.mas_bottom).offset(0);
                    make.width.mas_equalTo(@40);
                }];
                _sancanTitleLabel = titleLabel;
            }
            if (self.sancan != nil) {
                _sancanTitleLabel.text = [[self.sancan objectForKey:@"title"] objectForKey:@"text"];
            }
            return myCell;
        }else {
            MSTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"sancanCell"];
            if (myCell == nil) {
                myCell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sancanCell"];
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.backgroundColor = [UIColor lightGrayColor];
                imageView.contentMode = UIViewContentModeScaleToFill;
                imageView.clipsToBounds = YES;
                [myCell.contentView addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(myCell.mas_left).offset(5);
                    make.top.mas_equalTo(myCell.mas_top).offset(5);
                    make.bottom.mas_equalTo(myCell.mas_bottom).offset(0);
                    make.width.mas_equalTo(@140);
                }];
                
                UIView *rightView = [[UIView alloc] init];
                [myCell.contentView addSubview:rightView];
                [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(imageView.mas_right).offset(0);
                    make.right.mas_equalTo(myCell.mas_right).offset(-5);
                    make.top.mas_equalTo(myCell.mas_top).offset(5);
                    make.bottom.mas_equalTo(myCell.mas_bottom).offset(0);
                }];
                
                UILabel *titleLable = [[UILabel alloc] init];
                titleLable.font = [UIFont systemFontOfSize:14];
                [rightView addSubview:titleLable];
                
                UIImageView *levelView = [[UIImageView alloc] init];
                levelView.image = [UIImage imageNamed:@"ms_caipu_level"];
                levelView.contentMode = UIViewContentModeLeft;
                [rightView addSubview:levelView];
                
               
                
                UILabel *descLabel = [[UILabel alloc] init];
                descLabel.font = [UIFont systemFontOfSize:12];
                descLabel.textColor = kRGBColor(118, 116, 116);
                descLabel.numberOfLines = 2;
                descLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
                [rightView addSubview:descLabel];
                
                [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(rightView.mas_left).offset(10);
                    make.right.mas_equalTo(rightView.mas_right).offset(-10);
                    make.top.mas_equalTo(rightView.mas_top).offset(15);
                    make.height.mas_equalTo(@25);
                }];
                
                [levelView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(titleLable.mas_bottom).offset(5);
                    make.leading.mas_equalTo(titleLable).offset(0);
                    make.width.mas_equalTo(@110);
                    make.height.mas_equalTo(@25);
                }];
                
                [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(levelView.mas_bottom).offset(5);
                    make.leading.mas_equalTo(levelView).offset(0);
                    make.right.mas_equalTo(rightView.mas_right).offset(-10);
                    make.height.mas_equalTo(@50);
                }];
            }
            
            if (self.sancan != nil) {
                NSString *imgString = [[[[[self.sancan objectForKey:@"items"] objectForKey:@"item"] objectAtIndex:(indexPath.row-1)] objectForKey:@"img"] objectForKey:@"text"];
                UIImageView *imageView = (UIImageView *)[myCell.contentView.subviews objectAtIndex:0];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imgString]];
                
                NSString *bgColor = [[[[[self.sancan objectForKey:@"items"] objectForKey:@"item"] objectAtIndex:(indexPath.row-1)] objectForKey:@"bg_color"] objectForKey:@"text"];
                NSString *hexString = @"#FFFFFF";
                if (bgColor != nil && bgColor.length == 9) {
                    hexString = [@"#" stringByAppendingString:[bgColor substringWithRange:NSMakeRange(3, 6)]];
                }
                UIView *rightView = (UIView *)[myCell.contentView.subviews objectAtIndex:1];
                rightView.backgroundColor = [UIColor colorWithHexString:hexString alpha:0.2];
                
                NSString *titleLableText = [[[[[self.sancan objectForKey:@"items"] objectForKey:@"item"] objectAtIndex:(indexPath.row-1)] objectForKey:@"title"] objectForKey:@"text"];
                UILabel *titleLable = (UILabel *)[rightView.subviews objectAtIndex:0];
                titleLable.text = titleLableText;
                
                NSString *descLabelText = [[[[[self.sancan objectForKey:@"items"] objectForKey:@"item"] objectAtIndex:(indexPath.row-1)] objectForKey:@"recommend_msg"] objectForKey:@"text"];
                NSMutableParagraphStyle *mutableParagraphStyle = [NSMutableParagraphStyle new];
                mutableParagraphStyle.lineSpacing = 10.0f;
                NSAttributedString *descLabelAttrString = [[NSAttributedString alloc] initWithString:descLabelText attributes:@{NSParagraphStyleAttributeName:mutableParagraphStyle}];
                UILabel *descLabel = (UILabel *)[rightView.subviews objectAtIndex:2];
                descLabel.attributedText = descLabelAttrString;
            }
            
            return myCell;
        }
#pragma mark - 热门商品
    }else if (section == 2) {
        if (indexPath.row == 0) {
            MSTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"HotGoodsTitle"];
            if(myCell == nil){
                myCell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HotGoodsTitle"];
                UILabel *titleLabel = [[UILabel alloc] init];
                [myCell.contentView addSubview:titleLabel];
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(myCell.mas_left).mas_offset(15);
                    make.right.mas_equalTo(myCell.mas_right).mas_offset(-50);
                    make.top.mas_equalTo(myCell.mas_top).mas_offset(0);
                    make.bottom.mas_equalTo(myCell.mas_bottom).mas_offset(0);
                }];
            }
            if(self.hotGoods != nil){
                UILabel *titleLabel = [myCell.contentView.subviews objectAtIndex:0];
                titleLabel.text = [[self.hotGoods objectForKey:@"title"] objectForKey:@"text"];
            }
            return myCell;
        }else{
            MSTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"HotGoodsImageView"];
            if (myCell == nil) {
                myCell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HotGoodsImageView"];
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.backgroundColor = [UIColor lightGrayColor];
                imageView.contentMode = UIViewContentModeScaleToFill;
                imageView.clipsToBounds = YES;
                [myCell.contentView addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(myCell.mas_left).offset(5);
                    make.right.mas_equalTo(myCell.mas_right).offset(-5);
                    make.top.mas_equalTo(myCell.mas_top).offset(5);
                    make.bottom.mas_equalTo(myCell.mas_bottom).offset(-5);
                }];
            }
            
            UIImageView *imageView = [myCell.contentView.subviews objectAtIndex:0];
            NSString *imgString = [[[self.hotGoods objectForKey:@"cover_img"] objectForKey:@"big"] objectForKey:@"text"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgString]];
            
            return myCell;
        }
#pragma mark - 推荐商品
    }else if (section == 3) {
        if (indexPath.row == 0) {
            MSTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendGoodsTitle"];
            if(myCell == nil){
                myCell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecommendGoodsTitle"];
                UILabel *titleLabel = [[UILabel alloc] init];
                [myCell.contentView addSubview:titleLabel];
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(myCell.mas_left).mas_offset(15);
                    make.right.mas_equalTo(myCell.mas_right).mas_offset(-50);
                    make.top.mas_equalTo(myCell.mas_top).mas_offset(0);
                    make.bottom.mas_equalTo(myCell.mas_bottom).mas_offset(0);
                }];
            }
            
            UILabel *titleLabel = [myCell.contentView.subviews objectAtIndex:0];
            if(self.recommendGoods != nil){
                titleLabel.text = [[self.recommendGoods objectForKey:@"title"] objectForKey:@"text"];
            }
            
            return myCell;
        }else{
            MSTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"RecommendGoodsItems"];
            if (myCell == nil) {
                myCell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecommendGoodsItems"];
                UIView *superview = myCell.contentView;
                NSArray *items = [[self.recommendGoods objectForKey:@"items"] objectForKey:@"item"];
                [items enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
                    //背景view
                    UIView *goodsView = [[UIView alloc] init];
                    goodsView.backgroundColor = [UIColor whiteColor];
                    goodsView.layer.borderColor = kRGBColor(240, 240, 240).CGColor;
                    goodsView.layer.borderWidth = 1.0;
                    goodsView.layer.cornerRadius = 5;
                    goodsView.clipsToBounds = YES;
                    [superview addSubview:goodsView];
                    CGFloat width = (kScreenWidth-20)/3;
                    CGFloat left = 5*(idx+1)+idx*width;
                    [goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(superview.mas_left).offset(left);
                        make.top.mas_equalTo(superview.mas_top).offset(5);
                        make.bottom.mas_equalTo(superview.mas_bottom).offset(-5);
                        make.width.mas_equalTo(@(width));
                    }];
                    //图片
                    UIImageView *imageView = [[UIImageView alloc] init];
                    NSString *imageString = [[dict objectForKey:@"cover_img"] objectForKey:@"text"];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:imageString]];
                    imageView.contentMode = UIViewContentModeScaleToFill;
                    imageView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
                    [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                        NSLog(@"click");
                    }];
                    [imageView addGestureRecognizer:tap];
                    [goodsView addSubview:imageView];
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(goodsView.mas_left).offset(0);
                        make.top.mas_equalTo(goodsView.mas_top).offset(0);
                        make.width.mas_equalTo(@(width));
                        make.height.mas_equalTo(@(width));
                    }];

                    //标题
                    UILabel *titleLabel = [[UILabel alloc] init];
                    NSString *title = [[dict objectForKey:@"title"] objectForKey:@"text"];
                    titleLabel.text = title;
                    titleLabel.numberOfLines = 1;
                    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    titleLabel.font = [UIFont systemFontOfSize:12];
                    titleLabel.textColor = [UIColor blackColor];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    [goodsView addSubview:titleLabel];
                    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(imageView.mas_bottom).offset(5);
                        make.left.mas_equalTo(goodsView.mas_left).offset(5);
                        make.right.mas_equalTo(goodsView.mas_right).offset(-5);
                        make.height.mas_equalTo(@(15));
                    }];
                    //价格
                    UILabel *priceLabel = [[UILabel alloc] init];
                    NSString *price =[@"¥" stringByAppendingString:[[dict objectForKey:@"price"] objectForKey:@"text"]];
                    priceLabel.text = price;
                    priceLabel.numberOfLines = 1;
                    priceLabel.font = [UIFont systemFontOfSize:10];
                    priceLabel.textColor = [UIColor redColor];
                    priceLabel.textAlignment = NSTextAlignmentCenter;
                    [goodsView addSubview:priceLabel];
                    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(titleLabel.mas_bottom).offset(5);
                        make.left.mas_equalTo(goodsView.mas_left).offset(5);
                        make.right.mas_equalTo(goodsView.mas_right).offset(-5);
                        make.height.mas_equalTo(@(10));
                    }];
                }];
                
            }
            return myCell;
        }
#pragma mark - 本周专题
    }else if (section == 4) {
        if (indexPath.row == 0) {
            MSTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"weeklyTopicTitle"];
            if(myCell == nil){
                myCell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weeklyTopicTitle"];
                UILabel *titleLabel = [[UILabel alloc] init];
                if(self.weeklyTopic != nil){
                    titleLabel.text = [[self.weeklyTopic objectForKey:@"title"] objectForKey:@"text"];
                }else{
                    titleLabel.text = @"";
                }
                [myCell addSubview:titleLabel];
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(myCell.mas_left).mas_offset(15);
                    make.right.mas_equalTo(myCell.mas_right).mas_offset(-50);
                    make.top.mas_equalTo(myCell.mas_top).mas_offset(0);
                    make.bottom.mas_equalTo(myCell.mas_bottom).mas_offset(0);
                }];
            }
            return myCell;
        }else{
            MSTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"WeeklyTopicItems"];
            if (myCell == nil) {
                myCell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WeeklyTopicItems"];
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.contentMode = UIViewContentModeScaleToFill;
                imageView.userInteractionEnabled = YES;
                [myCell.contentView addSubview:imageView];
            }
            
            if (self.weeklyTopic != nil) {
                
                UIView *superview = myCell.contentView;
                UIImageView *imageView = (UIImageView *)[myCell.contentView.subviews objectAtIndex:0];
                NSDictionary *item = [[[self.weeklyTopic objectForKey:@"items"] objectForKey:@"item"] objectAtIndex:(indexPath.row-1)];
                
                NSString *widthStr = [[[item objectForKey:@"cover_img"] objectForKey:@"width"] objectForKey:@"text"];
                CGFloat width = widthStr.floatValue;
                NSString *heightStr = [[[item objectForKey:@"cover_img"] objectForKey:@"height"] objectForKey:@"text"];
                CGFloat height = heightStr.floatValue;
                CGFloat imageViewWidth = kScreenWidth-10;
                CGFloat imageViewHeight = imageViewWidth*height/width;
                
                NSString *imageString = [[[item objectForKey:@"cover_img"] objectForKey:@"big"] objectForKey:@"text"];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageString]];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
                [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                    NSLog(@"click");
                }];
                [imageView addGestureRecognizer:tap];
            
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(superview.mas_left).offset(5);
                    make.top.mas_equalTo(superview.mas_top).offset(5);
                    make.width.mas_equalTo(@(imageViewWidth));
                    make.height.mas_equalTo(@(imageViewHeight));
                }];
                self.weeklyTopicImageHeight = imageViewHeight;
            }
            
            return myCell;
        }
#pragma mark - 推荐阅读
    } else if (section == 5) {
        if (indexPath.row == 0) {
            MSTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"recommendReadingsTitle"];
            if(myCell == nil){
                myCell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recommendReadingsTitle"];
                UILabel *titleLabel = [[UILabel alloc] init];
                [myCell.contentView addSubview:titleLabel];
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(myCell.mas_left).mas_offset(15);
                    make.right.mas_equalTo(myCell.mas_right).mas_offset(-50);
                    make.top.mas_equalTo(myCell.mas_top).mas_offset(0);
                    make.bottom.mas_equalTo(myCell.mas_bottom).mas_offset(0);
                }];
            }
            
            if(self.weeklyTopic != nil){
                UILabel *titleLabel = (UILabel *)[myCell.contentView.subviews objectAtIndex:0];
                titleLabel.text = [[self.recommendReadings objectForKey:@"title"] objectForKey:@"text"];
            }
            
            return myCell;
        }else{
            MSTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"recommendReadingsItems"];
            if (myCell == nil) {
                myCell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recommendReadingsItems"];
                for (int i=0; i<4; i++) {
                    if (i == 0) {
                        UIImageView *imageView = [[UIImageView alloc] init];
                        imageView.contentMode = UIViewContentModeScaleToFill;
                        imageView.userInteractionEnabled = YES;
                        [myCell.contentView addSubview:imageView];
                        
                        UILabel *titleLabel = [UILabel new];
                        titleLabel.font = [UIFont systemFontOfSize:14];
                        titleLabel.textColor = [UIColor whiteColor];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        titleLabel.numberOfLines = 1;
                        [imageView addSubview:titleLabel];
                    }else{
                        UIView *bgView = [[UIView alloc] init];
                        [myCell.contentView addSubview:bgView];
                        
                        UIImageView *imageView = [[UIImageView alloc] init];
                        imageView.contentMode = UIViewContentModeScaleToFill;
                        imageView.userInteractionEnabled = YES;
                        [bgView addSubview:imageView];
                        
                        UILabel *titleLabel = [UILabel new];
                        titleLabel.font = [UIFont systemFontOfSize:12];
                        titleLabel.textColor = [UIColor blackColor];
                        titleLabel.textAlignment = NSTextAlignmentCenter;
                        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        titleLabel.numberOfLines = 1;
                        [bgView addSubview:titleLabel];
                        
                        UILabel *subtitleLabel = [UILabel new];
                        subtitleLabel.font = [UIFont systemFontOfSize:10];
                        subtitleLabel.textColor = kRGBColor(126, 130, 130);
                        subtitleLabel.textAlignment = NSTextAlignmentCenter;
                        subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        subtitleLabel.numberOfLines = 1;
                        [bgView addSubview:subtitleLabel];
                    }
                }
            }
            
            if (self.recommendReadings != nil) {
                __block CGFloat firstImageHeight = 0;
                [myCell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof id _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIView *superview = myCell.contentView;
                    NSArray *groups = [[[[[self.recommendReadings objectForKey:@"groups"] objectForKey:@"item"] objectAtIndex:(indexPath.row-1)] objectForKey:@"items"] objectForKey:@"item"];
                    
                    NSString *widthStr = [[[[groups objectAtIndex:idx] objectForKey:@"cover_img"] objectForKey:@"width"] objectForKey:@"text"];
                    CGFloat width = widthStr.floatValue;
                    NSString *heightStr = [[[[groups objectAtIndex:idx] objectForKey:@"cover_img"] objectForKey:@"height"] objectForKey:@"text"];
                    CGFloat height = heightStr.floatValue;
                    CGFloat imageViewWidth = 0;
                    if (idx == 0) {
                        imageViewWidth = kScreenWidth-10;
                    }else{
                        imageViewWidth = (kScreenWidth-20)/3;
                    }
                    CGFloat imageViewHeight = imageViewWidth*height/width;
                    if (idx == 0) {
                        firstImageHeight = imageViewHeight;
                    }
                    NSString *imageString = [[[[groups objectAtIndex:idx] objectForKey:@"cover_img"] objectForKey:@"big"] objectForKey:@"text"];
                    NSString *bgcolor = [[[groups objectAtIndex:idx] objectForKey:@"title_bg_color"] objectForKey:@"text"];
                    NSString *hexString = @"#FFFFFF";
                    if (bgcolor != nil && bgcolor.length == 9) {
                        hexString = [@"#" stringByAppendingString:[bgcolor substringWithRange:NSMakeRange(3, 6)]];
                    }
                    if (idx == 0) {
                        UIImageView *imageView = (UIImageView *)object;
                        [imageView sd_setImageWithURL:[NSURL URLWithString:imageString]];
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
                        [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                            NSLog(@"click");
                        }];
                        [imageView addGestureRecognizer:tap];
                        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(superview.mas_left).offset(5);
                            make.top.mas_equalTo(superview.mas_top).offset(5);
                            make.width.mas_equalTo(@(imageViewWidth));
                            make.height.mas_equalTo(@(imageViewHeight));
                        }];
                        
                        UILabel *titleLabel =(UILabel *)[imageView.subviews objectAtIndex:0];
                        NSString *title = [[[groups objectAtIndex:idx] objectForKey:@"title"] objectForKey:@"text"];
                        titleLabel.text = title;
                        titleLabel.backgroundColor = [UIColor colorWithHexString:hexString alpha:0.8];
                        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(imageView.mas_left).offset(10);
                            make.bottom.mas_equalTo(imageView.mas_bottom).offset(-15);
                            make.width.mas_equalTo(@150);
                            make.height.mas_equalTo(@30);
                        }];
                    }else{
                        UIView *bgView = (UIView *)object;
                        bgView.backgroundColor = [UIColor colorWithHexString:hexString alpha:0.2];
                        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(superview.mas_top).offset(10+firstImageHeight);
                            make.left.mas_equalTo(superview.mas_left).offset(5*idx+imageViewWidth*(idx-1));
                            make.bottom.mas_equalTo(superview.mas_bottom).offset(-5);
                            make.width.mas_equalTo(@(imageViewWidth));
                        }];
                        
                        UIImageView *imageView = (UIImageView *)[bgView.subviews objectAtIndex:0];
                        [imageView sd_setImageWithURL:[NSURL URLWithString:imageString]];
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
                        [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                            NSLog(@"click");
                        }];
                        [imageView addGestureRecognizer:tap];
                        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(bgView.mas_left).offset(0);
                            make.top.mas_equalTo(bgView.mas_top).offset(0);
                            make.width.mas_equalTo(@(imageViewWidth));
                            make.height.mas_equalTo(@(imageViewHeight));
                        }];
                        
                        UILabel *titleLabel = (UILabel *)[bgView.subviews objectAtIndex:1];
                        NSString *title = [[[groups objectAtIndex:idx] objectForKey:@"title"] objectForKey:@"text"];
                        titleLabel.text = title;
                        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(imageView.mas_bottom).offset(10);
                            make.left.mas_equalTo(bgView.mas_left).offset(0);
                            make.right.mas_equalTo(bgView.mas_right).offset(0);
                            make.height.mas_equalTo(@15);
                        }];
                        
                        UILabel *subtitleLabel = (UILabel *)[bgView.subviews objectAtIndex:2];
                        NSString *subtitle = [[[groups objectAtIndex:idx] objectForKey:@"subtitle"] objectForKey:@"text"];
                        subtitleLabel.text = subtitle;
                        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(titleLabel.mas_bottom).offset(5);
                            make.left.mas_equalTo(bgView.mas_left).offset(0);
                            make.right.mas_equalTo(bgView.mas_right).offset(0);
                            make.height.mas_equalTo(@15);
                        }];
                        
                        self.recommendReadingsImageHeight = firstImageHeight+imageViewHeight+60;
                    }
                    
                }];
            }
            
            
            return myCell;
        }
    }

    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        return 170;
    }else if (section == 1) {
        if (indexPath.row == 0) {
            return 50;
        }
        return 145;
    }else if (section == 2) {
        if (indexPath.row == 0) {
            return 50;
        }
        return 150;
    }else if (section == 3) {
        if (indexPath.row == 0) {
            return 50;
        }
        CGFloat height = (kScreenWidth-20)/3+55;
        return height;
    }else if (section == 4) {
        if (indexPath.row == 0) {
            return 50;
        }
        return self.weeklyTopicImageHeight+10;
    }else if (section == 5) {
        if (indexPath.row == 0) {
            return 50;
        }
        return self.recommendReadingsImageHeight+10;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    MSRecommendViewController *parentVC = (MSRecommendViewController *)self.parentViewController;
    if (parentVC.transformShowButton) {
        [parentVC animationHeaderHideView];
    }
    if(scrollView.contentOffset.y > 50 && parentVC.showHelloMsg){
        [parentVC animationHeaderView];
    }
    if(scrollView.contentOffset.y < -20 && parentVC.showHelloMsg == NO) {
        [parentVC animationHeaderView];
    }
}






@end
