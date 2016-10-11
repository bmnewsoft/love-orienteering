//
//  TabBarController.m
//  ADX
//
//  Created by MDJ on 2016/10/5.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "TabBarController.h"
#import "IndexTableViewController.h"
#import "UCenterTableViewController.h"

@interface TabBarController ()<UITabBarControllerDelegate>



@end

@implementation TabBarController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.selectIndex = -1;
    [[UIApplication sharedApplication] setStatusBarHidden: NO];
    self.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.shadowImage = [UIImage new];
//    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1)
//    {
//        [UITabBar.appearance setBackgroundImage:[UIImage imageNamed:@"tab_background"]];
//    }
//    
//    [UITabBar.appearance setSelectionIndicatorImage:[[UIImage alloc] init]];
//    
//    [UITabBarItem.appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                     UIColorRGB(150, 150, 150), UITextAttributeTextColor,
//                                                     nil] forState:UIControlStateNormal];
//    [UITabBarItem.appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                     UIColorRGB(10, 195, 197), UITextAttributeTextColor,
//                                                     nil] forState:UIControlStateSelected];
//    
//    
//    
//    UITabBarController *tabBarController = self;
//    UITabBar *tabBar = tabBarController.tabBar;
//    
//    int i = 0;
//    for (UITabBarItem *tabBarItem in tabBar.items)
//    {
//        NSString *imageName = [NSString stringWithFormat:@"item_icon%i", i];
//        NSString *selectedImageName = [NSString stringWithFormat:@"item_icon%i_h", i];
//        
//        
//        
//        //iOS7
//        if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)])
//        {
//            UIImage *image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            UIImage *selectedImage = [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            
//            [tabBarItem setFinishedSelectedImage:selectedImage
//                     withFinishedUnselectedImage:image];
//            tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        }
//        else
//        {
//            UIImage *image = [UIImage imageNamed:imageName];
//            UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
//            
//            [tabBarItem setFinishedSelectedImage:selectedImage
//                     withFinishedUnselectedImage:image];
//        }
//        
//        i++;
//    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger select = tabBarController.selectedIndex;
    if (select == self.selectIndex)
    {
        self.selectIndex = -1;
         UINavigationController *nav = (UINavigationController *)viewController;
//        if ([NSStringFromClass([nav.topViewController class]) isEqualToString:@"IndexTableViewController"])
//        {
//            IndexTableViewController *iVc = (IndexTableViewController *)nav.topViewController;
//            [iVc loadData];
//        }
        if ([NSStringFromClass([nav.topViewController class]) isEqualToString:@"UCenterTableViewController"])
        {
            UCenterTableViewController *uVc = (UCenterTableViewController *)nav.topViewController;
            [uVc loadData];
        }
    }
    else
    {
        self.selectIndex = tabBarController.selectedIndex;
    }
    NSLog(@"%@",NSStringFromClass([viewController class]));
    NSLog(@"%zi",self.selectIndex);
    
}

@end
