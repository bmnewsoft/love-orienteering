//
//  IWebController.m
//  ADX
//
//  Created by MDJ on 2016/10/30.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "IWebController.h"

@interface IWebController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *iWebView;

@end

@implementation IWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;
    [_iWebView.scrollView setBounces:NO];
    _iWebView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_webUrl]];
    [_iWebView loadRequest:request];
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideLoadingView) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoadingView];
    [self showToast:error.description];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
