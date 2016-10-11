//
//  ADXBaseTableViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/2.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "ADXBaseTableViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"
#import "TTRefreshTableFooterView.h"
#import "SDImageCache.h"

@interface ADXBaseTableViewController ()
{
    MBProgressHUD *HUD;
}

@end

@implementation ADXBaseTableViewController

-(void)showToast:(NSString *)message
{
    [ShareAppDelegate.window makeToast:message duration:1.0 position:@"center"];
}

- (void)backAction:(id)sender
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self.refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    
    [self setDefaultBackGroundImage];
    
}
- (void) setDefaultBackGroundImage
{
    CGSize size = CGSizeMake(ScreenWidth, ScreenHeigth);
    UIImage * image = [UIImage imageNamed:@"app_bg"];
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width + 16, size.height)];
    _bgImageView.image = image;
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg"]];
    self.tableView.backgroundView = _bgImageView;

//    [self.view addSubview:_bgImageView];
//    [self.view sendSubviewToBack:_bgImageView];
}

- (void)loadData
{
    NSAssert(NO, @"loadData method must be override!");
}

- (void)showLoadMore
{
    if (_hasMore)
    {
        if (_footerView == nil)
        {
            _footerView = [TTRefreshTableFooterView new];
            [_footerView setMoreDataLoader:self];
        }
        
        self.tableView.tableFooterView = _footerView;
    }
    else
    {
        self.tableView.tableFooterView = nil;
    }
}

- (void)showNetworkNotAvailable
{
    [self showToast:@"网络连接失败，请检查网络稍后重试"];
}
#pragma mark - MBProgressHUD

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

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

//下拽刷新，开始加载第1页数据
- (void)refreshData:(id)sender
{
    //加载第1页
    _loading = YES;
    _lastId = 0;
    [self loadData];
}

//点击更多按钮，或者底部上拽加载更多
- (void)loadMore
{
    if (_hasMore)
    {
        _loading = YES;
        [_footerView displayIndicator];
        
        [self loadData];
    }
}

//完成加载数据
- (void)doneLoadingData
{
    _loading = NO;
    [self.tableView reloadData];
    
    [_footerView hideIndicator];
    [self.refreshControl endRefreshing];
    [self showLoadMore];
}

//这个是处理数据条数不够一屏的情况
- (float)tableViewHeight
{
    if (self.tableView.contentSize.height < self.tableView.frame.size.height)
    {
        return self.tableView.frame.size.height;
    }
    else
    {
        return self.tableView.contentSize.height;
    }
}

//这个是处理数据条数不够一屏的情况
- (float)endOfTableView:(UIScrollView *)scrollView
{
    
    return [self tableViewHeight] - scrollView.bounds.size.height - scrollView.bounds.origin.y;
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate)
    {
        [self performSelector:@selector(loadMore:) withObject:scrollView afterDelay:0.5f];
    }
    else
    {
        [self loadMore:scrollView];
    }
    
}


-(void)loadMore:(UIScrollView *)scrollView
{
    if ([self endOfTableView:scrollView] <= 30 && !_loading)
    {
        [self loadMore];
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if ([self endOfTableView:scrollView] <= 30 && !_loading)
//    {
//        [self loadMore];
//    }
//}

#pragma mark -
#pragma mark Memory Management

- (void)viewDidUnload
{
    [super viewDidUnload];
    _footerView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc
{
    _footerView = nil;
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


@end
