//
//  ADXAppearance.m
//  ADX
//
//  Created by MDJ on 2016/10/4.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "ADXAppearance.h"

@implementation ADXAppearance

+ (void)setNavigationBarAppearance
{
    
    //标题颜色
    UIColor *titleColor = [UIColor whiteColor];
    UIFont *titleFont = [UIFont boldSystemFontOfSize:18];
    
    //标题颜色
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName:titleColor,
       UITextAttributeFont:titleFont,
       UITextAttributeTextColor:titleColor,
       UITextAttributeTextShadowColor:[UIColor clearColor],
       UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)]
       }];
    
    
    [UIBarButtonItem.appearance setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                       forBarMetrics:UIBarMetricsDefault];
    
    
    UIImage *backImage = [UIImage imageNamed:@"nav_back"];
    
    //iOS 7 or later
    if ([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)])
    {
        [UINavigationBar.appearance setBarTintColor:[UIColor whiteColor]];
        [UINavigationBar.appearance setTintColor:[UIColor whiteColor]];
        [UINavigationBar.appearance setBackgroundImage:[UIImage imageNamed:@"navi_bg"]
                                         forBarMetrics:UIBarMetricsDefault];
        
    }
    else //iOS 6 or earlier
    {
        [UINavigationBar.appearance setBackgroundImage:[UIImage imageNamed:@"navi_bg"]
                                         forBarMetrics:UIBarMetricsDefault];
        
        //#pragma mark 解决出现两个返回图标的问题
        backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 10)];
        
        [UIBarButtonItem.appearance setBackButtonBackgroundImage:backImage
                                                        forState:UIControlStateNormal
                                                      barMetrics:UIBarMetricsDefault];
        
        [UIBarButtonItem.appearance setTitleTextAttributes:@{
                                                             UITextAttributeTextColor:[UIColor whiteColor],
                                                             UITextAttributeFont:[UIFont systemFontOfSize:14.0f]
                                                             } forState:UIControlStateNormal];
    }
    
}

@end
