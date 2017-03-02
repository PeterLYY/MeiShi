//
//  MSSmartHeaderView.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/28.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSSmartHeaderView.h"

@interface MSSmartHeaderView()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchText;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *okButton;

@end

@implementation MSSmartHeaderView

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    UIView *superview = self;
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).mas_offset(0);
        make.left.equalTo(superview.mas_left).mas_offset(0);
        make.right.equalTo(superview.mas_right).mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLine.mas_bottom).mas_offset(50);
        make.left.equalTo(superview.mas_left).mas_offset(0);
        make.right.equalTo(superview.mas_right).mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLine.mas_bottom).mas_offset(12.5);
        make.left.equalTo(superview.mas_left).mas_offset(10);
        make.right.equalTo(superview.mas_right).mas_offset(-10);
        make.height.mas_equalTo(25);
    }];
    
    
    [self.searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.searchView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.mas_bottom).mas_offset(15);
        make.right.equalTo(superview.mas_centerX).mas_offset(-27.5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.mas_bottom).mas_offset(15);
        make.left.equalTo(superview.mas_centerX).mas_offset(27.5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [super updateConstraints];
}

//顶部线
- (UIView *)topLine {
    if(_topLine == nil){
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = kRGBColor(229, 229, 229);
        [self addSubview:topLine];
        _topLine = topLine;
    }
    
    return _topLine;
}

//底部线
- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = kRGBColor(229, 229, 229);
        [self addSubview:bottomLine];
        _bottomLine = bottomLine;
    }
    
    return _bottomLine;
}

//食材栏
- (UIView *)searchView {
    if(_searchView == nil) {
        UIView *searchView = [[UIView alloc] init];
        searchView.backgroundColor = [UIColor whiteColor];
        [self addSubview:searchView];
        _searchView = searchView;
    }
    
    return _searchView;
}

//搜索栏
- (UITextField *)searchText {
    if (_searchText == nil) {
        UITextField *searchText = [[UITextField alloc] init];
        searchText.borderStyle = UITextBorderStyleNone;
        searchText.placeholder = @"添加食材";
        searchText.font = [UIFont systemFontOfSize:14.0f];
        searchText.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        [self.searchView addSubview:searchText];
        _searchText = searchText;
    }
    
    return _searchText;
}

//取消按钮
- (UIButton *)cancleButton {
    if (_cancleButton == nil) {
        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSAttributedString *disabledTitle = [[NSAttributedString alloc]
                                             initWithString:@"清除"
                                             attributes:@{
                                                          NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                          NSForegroundColorAttributeName:[[UIColor grayColor] colorWithAlphaComponent:0.4]
                                                          }
                                             ];
        [cancleButton setAttributedTitle:disabledTitle forState:UIControlStateDisabled];
        NSAttributedString *enableTitle = [[NSAttributedString alloc]
                                             initWithString:@"清除"
                                             attributes:@{
                                                          NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                          NSForegroundColorAttributeName:[[UIColor grayColor] colorWithAlphaComponent:0.8]
                                                          }
                                             ];
        [cancleButton setAttributedTitle:enableTitle forState:UIControlStateNormal];
        cancleButton.layer.cornerRadius = 15;
        cancleButton.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
        cancleButton.layer.borderWidth = 1;
        cancleButton.enabled = NO;
        [self addSubview:cancleButton];
        _cancleButton = cancleButton;
    }
    
    return _cancleButton;
}

//确定按钮
- (UIButton *)okButton {
    if (_okButton == nil) {
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *disabledTitle = [[NSAttributedString alloc]
                                             initWithString:@"确定"
                                             attributes:@{
                                                          NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                          NSForegroundColorAttributeName:[[UIColor grayColor] colorWithAlphaComponent:0.4]
                                                          }
                                             ];
        [okButton setAttributedTitle:disabledTitle forState:UIControlStateDisabled];
        NSAttributedString *enableTitle = [[NSAttributedString alloc]
                                           initWithString:@"确定"
                                           attributes:@{
                                                        NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                        NSForegroundColorAttributeName:[[UIColor grayColor] colorWithAlphaComponent:0.8]
                                                        }
                                           ];
        [okButton setAttributedTitle:enableTitle forState:UIControlStateNormal];
        okButton.layer.cornerRadius = 15;
        okButton.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
        okButton.layer.borderWidth = 1;
        okButton.enabled = NO;
        [self addSubview:okButton];
        _okButton = okButton;
    }
    
    return _okButton;
}
@end
