//
//  ADXBaseTableViewController.h
//  ADX
//
//  Created by MDJ on 2016/10/2.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TTRefreshTableFooterView;

@interface ADXBaseTableViewController : UITableViewController

{
    BOOL _loading;  //是否正在加载中
    BOOL _hasMore;  //是否有更多数据
    long long _lastId;  //翻页的最后一条
    
    TTRefreshTableFooterView    *_footerView;        //更多按钮，需要变更加载状态
}

- (void)setBackButton;
- (void)setLeftButton:(NSString *)title;
- (void)setRightButton:(id)target action:(SEL)action title:(NSString *)title;
- (void)refreshData:(id)sender;   //强制刷新数据
- (void)doneLoadingData;          //数据加载完成调用
- (void)showLoadMore;             //检测并现实加载更多按钮

- (void)showLoadingView;        //显示加载视图
- (void)showLoadingViewWithMessage:(NSString *)message; //显示加载视图，带提示消息
- (void)hideLoadingView;        //隐藏加载视图
- (void)showNetworkNotAvailable;
-(void)showToast:(NSString *)message;

- (void)instantiateStoryBoard:(NSString *)storyBoardName; //实例化故事板

@end
