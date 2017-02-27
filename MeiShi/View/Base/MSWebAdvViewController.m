//
//  MSWebAdvViewController.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/14.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSWebAdvViewController.h"

@interface MSWebAdvViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation MSWebAdvViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ms_back_icon2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:NULL];
    backButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        [self.navigationController popViewControllerAnimated:YES];
        return [RACSignal empty];
    }];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setAdurl:(NSString *)adurl {
    _adurl = adurl;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:adurl]];
    [self.webView loadRequest:request];
}

- (UIWebView *)webView {
    if (_webView == nil) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.delegate = self;
        [self.view addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if(_hud  == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide = YES;
        _hud = hud;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView.isLoading == NO) {
        [_hud hideAnimated:YES];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_hud hideAnimated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"加载失败";
    [hud hideAnimated:YES afterDelay:1.5];
}


@end
