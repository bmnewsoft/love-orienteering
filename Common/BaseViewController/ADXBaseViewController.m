//
//  ADXBaseViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/2.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "ADXBaseViewController.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"

#define ToastShowTime 1.0

@interface ADXBaseViewController ()
{
    MBProgressHUD *HUD;
    UIActivityIndicatorView *_activityIndicator;
}

@end

@implementation ADXBaseViewController

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

- (void)showLoadingView
{
    [self showLoadingViewWithMessage:nil];
}

- (void)showLoadingViewWithMessage:(NSString *)message
{
    [self hideLoadingView];
    HUD = [[MBProgressHUD alloc] initWithView:ShareAppDelegate.window];
    [ShareAppDelegate.window addSubview:HUD];
    
    HUD.dimBackground = NO;
    HUD.labelText = message;
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
}

- (void)hideLoadingView
{
    if (HUD)
    {
        [HUD hide:YES];
        HUD = nil;
    }
}

- (void)setBackButton
{
    if (self.navigationController.viewControllers.count == 0 || self.navigationController.viewControllers[0] == self)
    {
        return;
    }
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back_1"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [backButton addTarget:self
                   action:@selector(backAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                  target:nil action:nil];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        leftSpace.width = -12;
    }
    else
    {
        leftSpace.width = -1;
    }
    self.navigationItem.leftBarButtonItems = @[leftSpace, backItem];
}

- (void)setLeftButton:(NSString *)title
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setTitleColor:UIColorRGB(255, 255, 255) forState:UIControlStateNormal];
    [backButton setTitleColor:UIColorRGB(114, 114, 114) forState:UIControlStateHighlighted];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [backButton addTarget:self
                   action:@selector(backAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                  target:nil action:nil];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        leftSpace.width = -12;
    }
    else
    {
        leftSpace.width = -1;
    }
    self.navigationItem.leftBarButtonItems = @[leftSpace, backItem];
}

- (void)setRightButton:(id)target action:(SEL)action title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorRGB(255, 255, 255) forState:UIControlStateNormal];
    [button setTitleColor:UIColorRGB(114, 114, 114) forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        negativeSpacer.width = -12;
    }
    else
    {
        negativeSpacer.width = -1;
    }
    self.navigationItem.rightBarButtonItems =@[negativeSpacer, rightItem];
}

- (void )setRightButton:(id)target action:(SEL)action icon:(NSString *)icon
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setTitleColor:UIColorRGB(255, 255, 255) forState:UIControlStateNormal];
    [button setTitleColor:UIColorRGB(114, 114, 114) forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        negativeSpacer.width = -12;
    }
    else
    {
        negativeSpacer.width = -1;
    }
    self.navigationItem.rightBarButtonItems =@[negativeSpacer, rightItem];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [self hideLoadingView];
    
}

- (void)showConnectionTimeout
{
    
}


- (void)showNetworkNotAvailable
{
    [self showToast:@"网络连接失败，请检查网络稍后重试" duration:1.0];
}

- (void)showToast:(NSString*)message
{
    [self showToast:message duration:ToastShowTime];
}

- (void)showToast:(NSString*)message duration:(float)seconds
{
    [ShareAppDelegate.window makeToast:message duration:seconds position:@"center"];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]])
        {
            UITextField *textField = (UITextField*)view;
            [textField resignFirstResponder];
        }
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)instantiateStoryBoard:(NSString *)storyBoardName
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    UIViewController *Vc = [storyBoard instantiateInitialViewController];
    [UIView transitionWithView:ShareAppDelegate.window
                      duration:0.01
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        ShareAppDelegate.window.rootViewController = Vc;
                    }
                    completion:nil];
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
