//
//  ADXBaseViewController.h
//  ADX
//
//  Created by MDJ on 2016/10/2.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "ADXMacro.h"

@interface ADXBaseViewController : UIViewController

@property (nonatomic,strong)UIImageView *bgImageView;


- (void)setRightButton:(id)target action:(SEL)action title:(NSString *)title;
- (void )setRightButton:(id)target action:(SEL)action icon:(NSString *)icon;
- (void)setLeftButton:(NSString *)title;
- (void)setBackButton;
- (void)showLoadingView;        //显示加载视图
- (void)showLoadingViewWithMessage:(NSString *)message; //显示加载视图，带提示消息
- (void)hideLoadingView;        //隐藏加载视图

- (void)showConnectionTimeout;      //显示连接超时提示
- (void)showNetworkNotAvailable;    //显示网络不可用提示

- (void)showToast:(NSString*)message;   //显示提示消息，不影响用户继续操作
- (void)showToast:(NSString*)message duration:(float)seconds;   //显示提示消息，可以设定显示时间

- (IBAction)backAction:(id)sender;  //使用导航返回上一个视图
- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message;


- (void)instantiateStoryBoard:(NSString *)storyBoardName; //实例化故事板



@end
