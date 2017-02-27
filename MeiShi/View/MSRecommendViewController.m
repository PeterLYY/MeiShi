//
//  MSRecommendViewController.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/10.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSRecommendViewController.h"
#import "MSRecommendViewModel.h"
#import "MSHeaderHideButton.h"
#import "MSHeaderHideView.h"
#import "MSSeachView.h"
#import "MSNavItemView.h"
#import "MSCommendViewController.h"
#import "MSSmartViewController.h"
#import "MSThreeMealsViewController.h"
#import "MSRecipeViewController.h"
#import "MSRecommendScrollView.h"

@interface MSRecommendViewController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) MSRecommendViewModel *viewModel;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *helloMsgLable;
@property (strong, nonatomic) IBOutlet UIView *searchBgView;
@property (strong, nonatomic) IBOutlet UIButton *showButton;
@property (strong, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) IBOutlet MSNavItemView *navItemView;
@property (strong, nonatomic) IBOutlet MSRecommendScrollView *recommendScrollView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerImageViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *helloMsgHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *SearchBgViewTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *SearchTextTralling;


@property (nonatomic, strong) UIView *headerHideView;
@property (nonatomic, strong) MSSeachView *searchView;


@property (nonatomic, copy) NSString *helloMsg;
@property (nonatomic, copy) NSString *searchPlaceHolder;
@end

@implementation MSRecommendViewController
@dynamic viewModel;

- (void)bindViewModel {
    [super bindViewModel];
    [self.viewModel.requestDataCommand execute:nil];
    @weakify(self)
    
    [RACObserve(self.viewModel, data) subscribeNext:^(NSDictionary *data) {
        @strongify(self)
        if (data == nil) {
            self.helloMsg = @"欢迎使用美食杰！";
            self.searchPlaceHolder = @"菜谱、食材";
        }else{
            self.helloMsg = [[data objectForKey:@"hello_msg"] objectForKey:@"text"];
            self.searchPlaceHolder = [[data objectForKey:@"search_hint"] objectForKey:@"text"];
        }
        self.helloMsgLable.text = self.helloMsg;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.searchPlaceHolder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:0.8]}];
        self.searchText.attributedPlaceholder = attrString;
    }];
 

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHeaderView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupHeaderView {
    
    //头部背景图
    self.headerImageView.image = [UIImage imageNamed:@"ms_header"];
    self.headerImageView.contentMode = UIViewContentModeTopLeft;
    self.headerImageView.clipsToBounds = YES;
    
    //问候语
    self.helloMsgLable.font = [UIFont systemFontOfSize:26.0f];
    self.helloMsgLable.textColor = [UIColor whiteColor];
    self.showHelloMsg = YES;
    
    //搜索框
    self.searchText.delegate = self;
    self.searchBgView.backgroundColor = [UIColor clearColor];
    self.searchText.layer.cornerRadius = 5;
    self.searchText.font = [UIFont systemFontOfSize:16];
    self.searchText.textColor = [UIColor whiteColor];
    self.searchText.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    self.searchText.background = [UIImage new];
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    searchIcon.image = [UIImage imageNamed:@"topsearchicon_grey_2"];
    searchIcon.contentMode = UIViewContentModeCenter;
    self.searchText.leftView = searchIcon;
    self.searchText.leftViewMode = UITextFieldViewModeAlways;
    UIButton *cancleSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleSearchButton.frame = CGRectMake(0, 0, 60, 30);
    [cancleSearchButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleSearchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleSearchButton setBackgroundColor:[UIColor clearColor]];
    cancleSearchButton.titleLabel.font = [UIFont systemFontOfSize:16];
    cancleSearchButton.alpha = 0.8;
    [[cancleSearchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.searchText resignFirstResponder];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.searchPlaceHolder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:0.8]}];
        self.searchText.attributedPlaceholder = attrString;
        if (self.showHelloMsg == YES) {
            self.helloMsgLable.hidden = NO;
            self.headerImageViewHeight.constant = 140;
            self.SearchBgViewTop.constant = 20;
        }else{
            self.headerImageViewHeight.constant = 80;
        }
        self.showButton.hidden = NO;
        self.navItemView.hidden = NO;
        self.recommendScrollView.hidden = NO;
        self.searchView.hidden = YES;
        self.transformShowButton = NO;
        self.SearchTextTralling.constant = 20;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
    self.searchText.rightView = cancleSearchButton;
    self.searchText.rightViewMode = UITextFieldViewModeWhileEditing;
    self.searchText.spellCheckingType = UITextSpellCheckingTypeNo;
    self.searchText.autocorrectionType = UITextAutocorrectionTypeNo;
    
    
    
    //福
    [self.showButton setBackgroundImage:[UIImage imageNamed:@"fu"] forState:UIControlStateNormal];
    [self.showButton setBackgroundImage:[UIImage imageNamed:@"fu"] forState:UIControlStateHighlighted];
    self.showButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.showButton.layer.borderWidth = 1.0f;
    self.showButton.layer.cornerRadius = 5.0f;
    self.showButton.transform = CGAffineTransformMakeRotation(-M_PI/4*3);
    self.transformShowButton = NO;
    @weakify(self)
    [[self.showButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self animationHeaderHideView];
    }];
    
    [self setupHeaderHideView];
    [self setupSearchView];
    
    
    [self setupNavItems];
    [self setupRecommendScrollView];
    
}

//头部隐藏
- (void)setupHeaderHideView {
    MSHeaderHideView *hideView = [[MSHeaderHideView alloc] init];
    hideView.backgroundColor = [UIColor clearColor];
    hideView.alpha = 0;
    [self.view addSubview:hideView];
    
    UIView *superview = self.view;
    [hideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(superview.mas_left).offset(10);
        make.right.mas_equalTo(superview.mas_right).offset(-50);
        make.top.mas_equalTo(self.searchBgView.mas_bottom).offset(20);
        make.height.mas_equalTo(60);
    }];
  
    NSArray *buttonArray = @[
                          @{@"title":@"扫一扫", @"imagename":@"publish_photograph"},
                          @{@"title":@"晒作品", @"imagename":@"publish_photograph"},
                          @{@"title":@"上传菜谱", @"imagename":@"publish_photograph"},
                          @{@"title":@"消息", @"imagename":@"publish_photograph"}
                          ];
    hideView.data = buttonArray;
    _headerHideView = hideView;
}

//搜索页
- (void)setupSearchView {
    MSSeachView *searchView = [[MSSeachView alloc] init];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.hidden = YES;
    [self.view addSubview:searchView];
    
    UIView *superview = self.view;
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(superview.mas_left).offset(0);
        make.right.mas_equalTo(superview.mas_right).offset(0);
        make.top.mas_equalTo(self.searchBgView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(superview.mas_bottom).offset(0);
    }];
    
    _searchView = searchView;
}

//导航
- (void)setupNavItems {
    self.navItemView.items = @[@"推荐", @"智能组菜", @"每日三餐", @"菜谱分类"];
    self.navItemView.backgroundColor = [UIColor whiteColor];
    self.navItemView.clickItemNum = 0;
    self.navItemView.showsHorizontalScrollIndicator = NO;
    @weakify(self)
    self.navItemView.clickHandle = ^(NSUInteger num) {
        @strongify(self)
        [self scrollNavItemByNum:num  Scroll:YES];
    };
    
}

- (void)setupRecommendScrollView {
    self.recommendScrollView.delegate = self;
    self.recommendScrollView.backgroundColor = [UIColor whiteColor];
    self.recommendScrollView.bounces = NO;
    self.recommendScrollView.pagingEnabled = YES;
    self.recommendScrollView.showsVerticalScrollIndicator = NO;
    self.recommendScrollView.showsHorizontalScrollIndicator = NO;
    NSArray *recommendSubviews = @[@"Commend", @"Smart", @"ThreeMeals", @"Recipe"];
    [recommendSubviews enumerateObjectsUsingBlock:^(NSString *child, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *childFullName = [NSString stringWithFormat:@"MS%@ViewController", child];
        MSBaseViewController *childVC = (MSBaseViewController *)[[NSClassFromString(childFullName) alloc] initWithViewModel:self.viewModel];
        [self addChildViewController:childVC];
        [childVC didMoveToParentViewController:self];
        [self.recommendScrollView addSubview:childVC.view];
    }];
}

- (void)viewDidLayoutSubviews {
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController *childVC, NSUInteger idx, BOOL * _Nonnull stop) {
        childVC.view.frame = CGRectMake(idx*self.recommendScrollView.frame.size.width, 0, self.recommendScrollView.frame.size.width, self.recommendScrollView.frame.size.height);
    }];
    self.recommendScrollView.contentSize = CGSizeMake(self.recommendScrollView.frame.size.width*self.recommendScrollView.subviews.count, self.recommendScrollView.frame.size.height);
}

- (void)scrollNavItemByNum: (NSUInteger)num Scroll:(BOOL)scroll {
    self.navItemView.clickItemNum = num;
    CGFloat labelMergin = 0;
    if (num != 0 && num != self.navItemView.items.count-1) {
        labelMergin = 40;
    }
    UILabel *label = (UILabel *)[self.navItemView.subviews objectAtIndex:num];
    if (label.frame.origin.x - self.navItemView.contentOffset.x > kScreenWidth - (labelMergin+label.bounds.size.width)) {
        //向左滚动视图
        [self.navItemView setContentOffset:CGPointMake(label.frame.origin.x - (kScreenWidth- (labelMergin+label.bounds.size.width)), 0)  animated:YES];
    }
    
    
    if (label.frame.origin.x - self.navItemView.contentOffset.x < labelMergin) {
        //向右滚动视图
        [self.navItemView setContentOffset:CGPointMake(label.frame.origin.x - labelMergin, 0)  animated:YES];
    }
    
    if(scroll){
        CGFloat x = self.recommendScrollView.frame.size.width*num;
        [self.recommendScrollView setContentOffset:CGPointMake(x, 0)];
    }
}

//头部动画
- (void)animationHeaderView {
    if (self.showHelloMsg == YES) {
        self.helloMsgLable.hidden = YES;
        self.headerImageViewHeight.constant = 80;
        self.SearchBgViewTop.constant = -30;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.showHelloMsg = NO;
        }];
    }else{
        self.helloMsgLable.hidden = NO;
        self.headerImageViewHeight.constant = 140;
        self.SearchBgViewTop.constant = 30;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.showHelloMsg = YES;
        }];
    }
    
}

//头部按钮动画
- (void)animationHeaderHideView {
    CGFloat angle;
    CGFloat alpha;
    NSTimeInterval delay;
    NSTimeInterval duration;
    if (self.transformShowButton == NO) {
        angle = M_PI/4;
        if (self.showHelloMsg) {
            self.headerImageViewHeight.constant = 220;
        }else{
            self.headerImageViewHeight.constant = 160;
        }

        alpha = 1;
        delay = 0.2;
        duration = 0.3;
        self.transformShowButton = YES;
    }else{
        angle = -M_PI/4*3;
        if (self.showHelloMsg) {
            self.headerImageViewHeight.constant = 140;
        }else{
            self.headerImageViewHeight.constant = 80;
        }
        alpha = 0;
        delay = 0;
        duration = 0.1;
        self.transformShowButton = NO;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.showButton.transform = CGAffineTransformMakeRotation(angle);
        [self.view layoutIfNeeded];
    }];
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.headerHideView.alpha = alpha;
    } completion:nil];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"搜索你感兴趣的" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:0.8]}];
    textField.attributedPlaceholder = attrString;
    self.helloMsgLable.hidden = YES;
    self.showButton.hidden = YES;
    self.navItemView.hidden = YES;
    self.recommendScrollView.hidden = YES;
    self.searchView.hidden = NO;
    
    self.headerHideView.alpha = 0;
    self.headerImageViewHeight.constant = 80;
    self.SearchBgViewTop.constant = -30;
    self.SearchTextTralling.constant = -40;
    [UIView animateWithDuration:0.5 animations:^{
        self.showButton.transform = CGAffineTransformMakeRotation(-M_PI/4*3);
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger num = (NSUInteger)(scrollView.contentOffset.x/scrollView.frame.size.width);
    [self scrollNavItemByNum:num Scroll:NO];
    
}


@end
