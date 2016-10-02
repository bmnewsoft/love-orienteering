//
//  ADXRefreshTableViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/2.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "ADXRefreshTableViewController.h"

@interface ADXRefreshTableViewController ()

@end

@implementation ADXRefreshTableViewController

- (NSDate *)lastUpdatedTime
{
    NSAssert(NO, @"lastUpdatedTime method must be override!");
    
    // Demo
    
    //读取刷新时间
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDate *date = [prefs objectForKey:@"my_table_last_updated_time"];  //Key必须保持唯一，否则就读取别人的了
    return date;   //从来没有刷新过，就返回nil
}

- (void)loadDataForPage:(int)pageIndex
{
    NSAssert(NO, @"loadDataForPage: method must be override!");
    
    // Demo
    BOOL loadingSuccess = YES;
    //如果加载成功了
    if (loadingSuccess)
    {
        //第一页的刷新，重置数组
        if (pageIndex == 1)
        {
            self.dataArray = [NSMutableArray array];
            
            //纪录刷新时间
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:[NSDate date] forKey:@"my_table_last_updated_time"];  //Key必须保持唯一，否则就写成别人的了
            [prefs synchronize];
        }
        
        //将新数据加入数组
        for (int i = 0; i < 100; i++)
        {
            [self.dataArray addObject:[NSObject new]];
        }
        
        //通过接口字段判断是否有下一页数据
        id JSON = nil;
        _hasMore = [[JSON objectForKey:@"has_more"] boolValue];
        
        //完成加载
        [self doneLoadingData];
    }
    else
    {
        //提示错误信息
        NSLog(@"网络错误");
    }
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

#pragma mark - View Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    //    _pageIndex = 1;
    //
    //    if (self.tableView == nil && [self.view isKindOfClass:[UITableView class]])
    //    {
    //        self.tableView = (UITableView *)self.view;
    //    }
    //
    //    if (_headerView == nil)
    //    {
    //        CGRect rect = self.tableView.bounds;
    //        rect = CGRectMake(0.0f, 0.0f - rect.size.height, rect.size.width, rect.size.height);
    //		_headerView = [[EGORefreshTableHeaderView alloc] initWithFrame:rect];
    //		_headerView.delegate = self;
    //        [self.tableView addSubview:_headerView];
    //	}
    //
    //	[_headerView refreshLastUpdatedDate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if( !_headerView.hasEdgeInset)
    {
        _headerView.edgeInset = self.tableView.contentInset;
        _headerView.hasEdgeInset = YES;
    }
    
    if (self.dataArray == nil)
    {
        [_headerView egoRefreshScrollViewDataSourceStartManualLoading:self.tableView];
    }
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"tableView:cellForRowAtIndexPath: method must be override!");
    
    //For Examples
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"row = %li", (long)indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

//下拽刷新，开始加载第1页数据
//- (void)reloadTableViewDataSource
//{
//    //加载第1页
//	_loading = YES;
//	[self loadDataForPage:1];
//}

//下拽刷新，开始加载第1页数据
- (void)refreshData:(id)sender
{
    //加载第1页
    _loading = YES;
    [self loadDataForPage:1];
}
//点击更多按钮，或者底部上拽加载更多
- (void)loadMore
{
    if (_hasMore)
    {
        _loading = YES;
        [_footerView displayIndicator];
        
        [self loadDataForPage:_pageIndex+1];
    }
}

//完成加载数据
- (void)doneLoadingData
{
    _loading = NO;
    [_footerView hideIndicator];
    [_headerView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.tableView reloadData];
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_headerView != nil) {
        [_headerView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self endOfTableView:scrollView] <= -kPullDownOffset && !_loading)
    {
        self.isUpRefresh = YES;
        [self loadMore];
    }
    else
    {
        self.isUpRefresh = NO;
        [_headerView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

//#pragma mark -
//#pragma mark EGORefreshTableHeaderDelegate Methods
//
//- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
//{
////	[self reloadTableViewDataSource];
//    [self performSelector:@selector(reloadTableViewDataSource) withObject:nil afterDelay:1.5];
//}
//
//- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
//{
//	return _loading; // should return if data source model is reloading
//}
//
//- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
//{
//	return [self lastUpdatedTime];
//}


#pragma mark -
#pragma mark Memory Management

- (void)viewDidUnload
{
    [super viewDidUnload];
    _headerView = nil;
    _footerView = nil;
}

- (void)dealloc
{
    _headerView = nil;
    _footerView = nil;
}

- (void)setHeaderViewInset:(UIEdgeInsets)insert {
    if (_headerView) {
        _headerView.edgeInset = insert;
    }
}


@end
