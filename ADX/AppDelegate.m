//
//  AppDelegate.m
//  ADX
//
//  Created by MDJ on 2016/10/1.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "AppDelegate.h"
#import "ADXAppearance.h"

#import "ADXCache.h"

#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"

//#import "BRTBeaconSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"cheshi");
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [UITabBar.appearance setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
    [ADXAppearance setNavigationBarAppearance];
    [self setBaseParameters];
    
    [self loadLaunchScreenView];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark InitBaseParameters

- (void) setBaseParameters
{
    [[UINavigationBar appearance] setTranslucent:NO];
    
    //注册智石
//    [BRTBeaconSDK registerApp:bbAPPKEY onCompletion:^(BOOL complete, NSError *error) {
//        if (complete == SUCCESS_CODE) {
//            NSLog(@"BRT register success");
//        }
//        else
//        {
//            NSLog(@"BRT register failed:%@",error.localizedFailureReason);
//        }
//    }];
//    [BRTBeaconSDK startRangingBeaconsInRegions:nil onCompletion:^(NSArray *beacons, BRTBeaconRegion *region, NSError *error){
//        NSLog(@"进入区域回调:beacons:%@   /n region:%@",beacons,region);
//    }];
    
    
    
}

#pragma mark User
@synthesize user = _user;

- (void)setUser:(MUser *)user
{
    _user = user;
    if (_user)
    {
        [ADXCache writeObject:_user toFile:fUserCache];
        
    }
    else
    {
        [ADXCache removeObjectForName:fUserCache];
    }
}

- (MUser*)user
{
    if (!_user)
    {
        _user = [ADXCache objectFromFile:fUserCache];
    }
    return _user;
}

#pragma mark 智石
/*//监听失败回调
-(void)beaconManager:(BRTBeaconManager *)manager monitoringDidFailForRegion:(BRTBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"%@",region);
    if (error)
    {
        NSLog(@"%@",error.localizedFailureReason);
    }
}
//进入区域回调
-(void)beaconManager:(BRTBeaconManager *)manager didEnterRegion:(BRTBeaconRegion *)region{
    if(region.notifyOnEntry){
        //to do
        NSLog(@"进入区域回调:manager:%@   /n region:%@",manager,region);
    }
}
//离开区域回调
-(void)beaconManager:(BRTBeaconManager *)manager didExitRegion:(BRTBeaconRegion *)region{
    if(region.notifyOnExit){
         NSLog(@"离开区域回调:manager:%@   /n region:%@",manager,region);
        //to do
    }
}
//屏幕点亮区域检测、requestStateForRegions回调
-(void)beaconManager:(BRTBeaconManager *)manager didDetermineState:(CLRegionState)state forRegion:(BRTBeaconRegion *)region{
    if(region.notifyEntryStateOnDisplay){
        //to do
        NSLog(@"notifyEntryStateOnDisplay:manager:%@   /n region:%@",manager,region);
    }else if(region.notifyOnEntry){
        //to do
        NSLog(@"notifyOnEntry:manager:%@   /n region:%@",manager,region);
    }else if(region.notifyOnExit){
        //to do
        NSLog(@"notifyOnExit:manager:%@   /n region:%@",manager,region);
    }
}*/


#pragma mark LaunchScreen
-(void) loadLaunchScreenView
{
    _lunchView = [[UIView alloc] init];
    _lunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
    [ self.window.rootViewController.view addSubview:_lunchView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:_lunchView.frame];
    imageV.image = [UIImage sd_animatedGIFNamed:@"launch"];
//    imageV.image = [UIImage imageNamed:@"login_bg"];
    [_lunchView addSubview:imageV];
    [ self.window.rootViewController.view bringSubviewToFront:_lunchView];
    
    [NSTimer scheduledTimerWithTimeInterval:4.5 target:self selector:@selector(removeLaunchScreen) userInfo:nil repeats:NO];
}
- (void)removeLaunchScreen
{
    [_lunchView removeFromSuperview];
}


@end
