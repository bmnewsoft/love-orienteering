//
//  IWebController.m
//  ADX
//
//  Created by MDJ on 2016/10/30.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "IWebController.h"

@interface IWebController ()
@property (weak, nonatomic) IBOutlet UIWebView *iWebView;

@end

@implementation IWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;
    [_iWebView.scrollView setBounces:NO];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_webUrl]];
    [_iWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
