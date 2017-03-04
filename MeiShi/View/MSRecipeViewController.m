//
//  MSRecipeViewController.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/20.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSRecipeViewController.h"
#import "MSRecipeLeftButton.h"
#import "UIButton+WebCache.h"

@interface MSRecipeViewController ()

@property (nonatomic, strong) UIScrollView *leftView;
@property (nonatomic, strong) UIScrollView *rightView;
@property (nonatomic, strong) NSArray *categorylist;
@property (nonatomic, assign) NSInteger currentNumber;

@property (nonatomic, strong) MASConstraint *redPointTopConstraint;

@end

@implementation MSRecipeViewController
@dynamic viewModel;

- (void)bindViewModel {
    [super bindViewModel];
    
    [[RACObserve(self.viewModel, recipeData) filter:^BOOL(id  _Nullable value) {
        return value == nil ? NO : YES;
    }] subscribeNext:^(id  _Nullable x) {
        self.categorylist = x;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setCategorylist:(NSArray *)categorylist {
    CGFloat leftButtonWith = 90;
    _categorylist = categorylist;
    if (_categorylist != nil) {
        _currentNumber = 0;
        self.leftView.contentSize = CGSizeMake(leftButtonWith, leftButtonWith*_categorylist.count);
        [_categorylist enumerateObjectsUsingBlock:^(NSDictionary *category, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, idx*leftButtonWith, leftButtonWith-5, leftButtonWith)];
            backView.backgroundColor = [UIColor whiteColor];
            [self.leftView addSubview:backView];
            
            MSRecipeLeftButton *leftButton = [[MSRecipeLeftButton alloc] initWithFrame:CGRectMake(12.5, 12.5, 65, 65)];
            [backView addSubview:leftButton];
            
            [leftButton setTitle:[category objectForKey:@"title"] forState:UIControlStateNormal];
            
            [leftButton setTitleColor:kRGBColor(102, 102, 102) forState:UIControlStateNormal];
            [leftButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            if (_currentNumber == idx) {
                leftButton.selected = YES;
            }
            leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
            leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [leftButton sd_setImageWithURL:[NSURL URLWithString:[category objectForKey:@"icon"]] forState:UIControlStateNormal];
            [leftButton sd_setImageWithURL:[NSURL URLWithString:[category objectForKey:@"icon"]] forState:UIControlStateHighlighted];
            leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            //block会捕获自动变量
            [[leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                ((UIButton *)([self.leftView.subviews objectAtIndex:_currentNumber].subviews.lastObject)).selected = NO;
                _currentNumber = idx;
                x.selected = YES;
                self.redPointTopConstraint.mas_offset(idx*leftButtonWith+68);
                [UIView animateWithDuration:0.5 animations:^{
                    [self.view layoutIfNeeded];
                }];
            }];
        }];
        
        UIView *sideView = [[UIView alloc] initWithFrame:CGRectMake(leftButtonWith-5, 0, 5, _categorylist.count*leftButtonWith)];
        sideView.backgroundColor = [UIColor whiteColor];
        [self.leftView addSubview:sideView];
        
        UIView *sideLine = [[UIView alloc] init];
        sideLine.backgroundColor = kRGBColor(238, 238, 238);
        [sideView addSubview:sideLine];
        [sideLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(sideView.mas_centerX).mas_offset(0);
            make.top.equalTo(sideView.mas_top).mas_offset(0);
            make.bottom.equalTo(sideView.mas_bottom).mas_offset(0);
            make.width.mas_equalTo(1);
        }];
        
        UIView *redPoint = [[UIView alloc] init];
        redPoint.backgroundColor = [UIColor redColor];
        redPoint.layer.cornerRadius = 2.5;
        [sideView addSubview:redPoint];
        [redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(5);
            make.height.mas_equalTo(5);
            self.redPointTopConstraint = make.top.mas_equalTo(sideView.mas_top).mas_offset(68);
            make.left.mas_equalTo(sideView.mas_left).mas_equalTo(0);
        }];
    }
}

- (UIScrollView *)leftView {
    if (_leftView == nil) {
        UIScrollView *leftView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 90, self.view.bounds.size.height)];
        leftView.backgroundColor = [UIColor whiteColor];
        leftView.showsVerticalScrollIndicator = NO;
        leftView.showsHorizontalScrollIndicator = NO;
        leftView.bounces = YES;
        [self.view addSubview:leftView];
        _leftView = leftView;
    }
    
    return _leftView;
}

- (UIScrollView *)rightView {
    if (_rightView == nil) {
        UIScrollView *rightView = [[UIScrollView alloc] init];
        rightView.showsVerticalScrollIndicator = NO;
        rightView.showsHorizontalScrollIndicator = NO;
        rightView.bounces = NO;
        rightView.pagingEnabled = YES;
        [self.view addSubview:rightView];
        _rightView = rightView;
    }
    
    return _rightView;
}




@end
