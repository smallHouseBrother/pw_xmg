//
//  XGRefundProtocolViewController.m
//  XYGJ
//
//  Created by Zhao Chen on 2017/10/19.
//  Copyright © 2017年 Zhao Chen. All rights reserved.
//

#import "XMGWebViewController.h"

@interface XMGWebViewController () <UIWebViewDelegate>
{
    UIWebView * _webView;
    UIView    * _progressView;
    NSString  * _titleString;
    NSString  * _urlString;
}
@end

@implementation XMGWebViewController

- (instancetype)initWithTitle:(NSString *)title withUrl:(NSString *)urlString
{
    self = [super init];
    if (self)
    {
        _titleString  = title;
        _urlString    = urlString;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = _titleString;
    
    [self addSubViews];
    
    [self setNavigation];
}

- (void)setNavigation
{
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:0 target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItems = @[back];
    if (_webView.canGoBack) {
        UIBarButtonItem * close = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_Close"] style:0 target:self action:@selector(closePage)];
        self.navigationItem.leftBarButtonItems = @[back, close];
    }
}

- (void)addSubViews
{
    UIWebView * webView = [[UIWebView alloc] init];
    webView.backgroundColor = COLOR_HEX(@"#f5f5f5");
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    self.view = _webView = webView;
    webView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
    [webView loadRequest:request];
}

#pragma mark - WebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * absoluteString = request.URL.absoluteString;
    
    if (absoluteString == nil)  return YES;
    
    ///url合理时才出现
    if ([absoluteString hasPrefix:@"http://"] || [absoluteString hasPrefix:@"https://"]) {
        [self loadStart];
    }
    
    return YES;
}

///完成加载
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadFinish];
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [self setNavigation];
}

/**
 *  开始加载
 */
- (void)loadStart
{
    CGFloat top = iPhoneX ? 88 : 64;
    [_progressView removeFromSuperview];
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, top, 0, 2)];
    _progressView.backgroundColor = COLOR_HEX(@"#ff6c13");
    [self.view addSubview:_progressView];
    
    if (iPhoneX)
    {
        [UIView animateWithDuration:0.8f animations:^{
            _progressView.frame = CGRectMake(0, 88, ScreenWidth*2/3, 2);
        }];
        return;
    }
    [UIView animateWithDuration:0.8f animations:^{
        _progressView.frame = CGRectMake(0, 64, ScreenWidth*2/3, 2);
    }];
}

/**
 *  加载完成
 */
- (void)loadFinish
{
    if (iPhoneX)
    {
        [UIView animateWithDuration:0.3f animations:^{
            _progressView.frame = CGRectMake(0, 88, ScreenWidth, 2);
        } completion:^(BOOL finished) {
            [_progressView removeFromSuperview];
            _progressView = nil;
        }];
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        _progressView.frame = CGRectMake(0, 64, ScreenWidth, 2);
    } completion:^(BOOL finished) {
        [_progressView removeFromSuperview];
        _progressView = nil;
    }];
}

- (void)backAction
{
    if ([_webView canGoBack])
    {
        [_webView goBack];
        return;
    }
    [super backAction];
}

- (void)closePage
{
    [super backAction];
}

@end
