//
//  MSRecipeDetailViewController.m
//  MeiShi
//
//  Created by PeterLee on 2017/3/9.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSRecipeDetailViewController.h"
#import "MSRecipeDetailNewViewModel.h"
#import "MSRecipeDetailNewViewController.h"

@interface MSRecipeDetailViewController ()

@property (nonatomic, strong) UIWindow *navWindow;
@property (nonatomic, strong) MSRecipeDetailNewViewModel *viewModel;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) MSRecipeDetailNewViewController *detailNewVC;

@end

@implementation MSRecipeDetailViewController
@dynamic viewModel;

- (void)bindViewModel {
    [super bindViewModel];
    RACSignal *recipeSignal = [RACObserve(self.viewModel, recipeDetailNewData) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }];
    RACSignal *plSignal = [RACObserve(self.viewModel, plListData) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }];
    RACSignal *questionSignal = [RACObserve(self.viewModel, questionListData) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }];
    RACSignal *goodsRecommendtSignal = [RACObserve(self.viewModel, goodsRecommendData) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }];
    RACSignal *recipeRecommendSignal = [RACObserve(self.viewModel, recipeRecommendData) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }];
    
    [[RACSignal combineLatest:@[recipeSignal, plSignal, questionSignal, goodsRecommendtSignal, recipeRecommendSignal]] subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(NSDictionary *data, NSDictionary *plData, NSDictionary *questionData, NSDictionary *goodsRecommendtData, NSDictionary *recipeRecommendData) = tuple;
        MSRecipeDetailNewViewController *detailNewVC = [[MSRecipeDetailNewViewController alloc] init];
        detailNewVC.data = data;
        detailNewVC.plData = plData;
        detailNewVC.questionData = questionData;
        detailNewVC.goodsRecommendData = goodsRecommendtData;
        detailNewVC.recipeRecommendData = recipeRecommendData;
        [self addChildViewController:detailNewVC];
        [self.view addSubview:detailNewVC.view];
        self.detailNewVC = detailNewVC;
        [self.hud hideAnimated:YES];
    }];
    
}

//- (void)setData:(NSDictionary *)data {
//    if (_data == nil) {
//        MSRecipeDetailNewViewController *detailNewVC = [[MSRecipeDetailNewViewController alloc] init];
//        detailNewVC.data = data;
//        [self addChildViewController:detailNewVC];
//        [self.view addSubview:detailNewVC.view];
//        self.detailNewVC = detailNewVC;
//    }
//    _data = data;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self backButton];
    [self.viewModel.requestRecipeDetailNewData execute:nil];
    [self.viewModel.requestPLListData execute:nil];
    [self.viewModel.requestQuestionListData execute:nil];
    [self.viewModel.requestGoodsRecommendData execute:nil];
    [self.viewModel.requestRecipeRecommendData execute:nil];
    
    //是否执行
    [self.viewModel.requestRecipeDetailNewData.executing subscribeNext:^(NSNumber * _Nullable x) {
        if(x.boolValue){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.removeFromSuperViewOnHide = YES;
            self.hud = hud;
        }
    }];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //释放window
    self.navWindow = nil;
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


@end
