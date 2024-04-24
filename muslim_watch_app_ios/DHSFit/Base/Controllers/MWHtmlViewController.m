//
//  MWHtmlViewController.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "MWHtmlViewController.h"
#import <WebKit/WebKit.h>

@interface MWHtmlViewController ()<WKNavigationDelegate>
/// 页面容器
@property(nonatomic, strong) WKWebView *mainWebView;

@end

@implementation MWHtmlViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorNamed:@"D_#3C3C3C"];

    [self setupUI];
//    [self performSelector:@selector(loadRequest) withObject:nil afterDelay:2.0];
    [self loadRequest];
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    
    [self.mainWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.offset(-kBottomHeight);
    }];
    
    self.mainWebView.allowsBackForwardNavigationGestures = NO;
    self.mainWebView.opaque = false;
}

- (void)loadRequest {
    if (self.urlString.length) {
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
        [self.mainWebView loadRequest:request];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}

#pragma mark- WKUIDelegate


#pragma mark - get and set 属性的set和get方法

- (WKWebView *)mainWebView {
    if (!_mainWebView) {
        _mainWebView = [[WKWebView alloc] init];
        _mainWebView.backgroundColor = [UIColor colorNamed:@"D_#3C3C3C"];
        _mainWebView.navigationDelegate = self;
        _mainWebView.allowsBackForwardNavigationGestures = NO;
        _mainWebView.opaque = false;
        [self.view addSubview:_mainWebView];
    }
    return _mainWebView;
}

@end
