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

@interface MSRecipeViewController () <UIScrollViewDelegate>

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
    @weakify(self)
    [[self rac_signalForSelector:@selector(scrollViewDidEndDecelerating:) fromProtocol:@protocol(UIScrollViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        RACTupleUnpack(UIScrollView *scrollView) = tuple;
        CGFloat idx = scrollView.contentOffset.y/self.view.bounds.size.height;
        //UIView *redPoint = [self.view viewWithTag:199];
        self.redPointTopConstraint.mas_offset(idx*90+68);
        [UIView animateWithDuration:0.1 animations:^{
            [self.view layoutIfNeeded];
        }];
        
        ((UIButton *)([self.leftView.subviews objectAtIndex:_currentNumber].subviews.lastObject)).selected = NO;
        _currentNumber = idx;
        UIButton *thisBtn = [self.leftView viewWithTag:1000+idx];
        thisBtn.selected = YES;
        
#if 0
        UIView *backView = [self.leftView.subviews objectAtIndex:idx];
        if (backView.frame.origin.y - self.leftView.contentOffset.y > self.leftView.bounds.size.height/2) {
            //向上滚动视图
            [self.leftView setContentOffset:CGPointMake(0, backView.frame.origin.y - (backView.frame.origin.y - self.leftView.contentOffset.y - self.leftView.bounds.size.height/2))  animated:YES];
        }
        
        
        if (backView.frame.origin.y - self.leftView.contentOffset.y < self.leftView.bounds.size.height/2) {
            //向右滚动视图
            [self.leftView setContentOffset:CGPointMake(0, backView.frame.origin.y+(backView.frame.origin.y - self.leftView.contentOffset.y - self.leftView.bounds.size.height/2))  animated:YES];
        }
#endif
    }];
}

- (void)setCategorylist:(NSArray *)categorylist {
    CGFloat leftButtonWidth = 90;
    CGFloat rightWidth = self.view.bounds.size.width-leftButtonWidth;
    _categorylist = categorylist;
    if (_categorylist != nil) {
        _currentNumber = 0;
        self.leftView.contentSize = CGSizeMake(leftButtonWidth, leftButtonWidth*_categorylist.count);
        self.rightView.contentSize = CGSizeMake(rightWidth, self.view.bounds.size.height*_categorylist.count);
        [_categorylist enumerateObjectsUsingBlock:^(NSDictionary *category, NSUInteger idx, BOOL * _Nonnull stop) {
            //左侧布局
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, idx*leftButtonWidth, leftButtonWidth-5, leftButtonWidth)];
            backView.backgroundColor = [UIColor whiteColor];
            [self.leftView addSubview:backView];
            
            MSRecipeLeftButton *leftButton = [[MSRecipeLeftButton alloc] initWithFrame:CGRectMake(12.5, 12.5, 65, 65)];
            leftButton.tag = 1000+idx;
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
                self.redPointTopConstraint.mas_offset(idx*leftButtonWidth+68);
                [UIView animateWithDuration:0.5 animations:^{
                    [self.view layoutIfNeeded];
                }];
                [self.rightView setContentOffset:CGPointMake(0, self.view.bounds.size.height*idx) animated:YES];
            }];
            
            //右侧布局
            UIScrollView *rightSubview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, idx*self.view.bounds.size.height, rightWidth, self.view.bounds.size.height)];
            rightSubview.bounces = NO;
            rightSubview.showsVerticalScrollIndicator = YES;
            rightSubview.showsHorizontalScrollIndicator = NO;
            [self.rightView addSubview:rightSubview];
            NSArray *subCates = [category objectForKey:@"sub_cates"];
            if(subCates != nil) {
                __block CGFloat rowHeight = 0;
                __block CGFloat rowWidth = 0;
                __block CGFloat prevWidth = 10;
                [subCates enumerateObjectsUsingBlock:^(NSDictionary *subCate, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *titleString = [subCate objectForKey:@"title"];
                    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:kRGBColor(102, 102, 102)};
                    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:titleString attributes:attributes];
                    [rightButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
                    rightButton.layer.borderColor = kRGBColor(185, 185, 185).CGColor;
                    rightButton.layer.borderWidth = 1;
                    rightButton.layer.cornerRadius = 4;
                    [rightSubview addSubview:rightButton];
                    
                    CGSize titleSize = [titleString sizeWithAttributes:attributes];
                    //文本距离边界的间隔
                    CGFloat jiange;
                    //button之前的间隔
                    CGFloat btnJiange = 10;
                    if (titleSize.width < 30) {
                        jiange = 35;
                    }else{
                        jiange = 25;
                    }
                    
                    CGFloat btnWidth = btnJiange+titleSize.width+jiange;
                    CGFloat btnHeight = 30;
                    rowWidth = rowWidth+btnWidth;
                    //换行后
                    if(rowWidth>rightWidth) {
                        rowWidth = btnWidth;
                        prevWidth = btnJiange;
                        rowHeight = rowHeight+50;
                    }
                    
                    rightButton.frame = CGRectMake(prevWidth, rowHeight, titleSize.width+jiange, btnHeight);
                    //*stop = YES;
                    prevWidth = rowWidth+btnJiange;
                }];
                rightSubview.contentSize = CGSizeMake(rightWidth, rowHeight+50);
            }
        }];
        
        UIView *sideView = [[UIView alloc] initWithFrame:CGRectMake(leftButtonWidth-5, 0, 5, _categorylist.count*leftButtonWidth)];
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
        redPoint.tag = 199;
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
        UIScrollView *rightView = [[UIScrollView alloc] initWithFrame:CGRectMake(90, 0, self.view.bounds.size.height-90, self.view.bounds.size.height)];
        rightView.showsVerticalScrollIndicator = NO;
        rightView.showsHorizontalScrollIndicator = NO;
        rightView.bounces = NO;
        rightView.pagingEnabled = YES;
        rightView.delegate = self;
        [self.view addSubview:rightView];
        _rightView = rightView;
    }
    
    return _rightView;
}




@end
