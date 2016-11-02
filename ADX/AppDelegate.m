//
//  AppDelegate.m
//  ADX
//
//  Created by MDJ on 2016/10/1.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "AppDelegate.h"
#import "IWebController.h"

#import "ADXAppearance.h"

#import "ADXCache.h"

#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"

#import "JPUSHService.h"

#import "BRTBeaconSDK.h"

#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"cheshi");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [UITabBar.appearance setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
    [ADXAppearance setNavigationBarAppearance];
    
    [self setBaseParameters];
    
    [self loadLaunchScreenView];
    
    //极光推送注册
    [self jPushRegisiter:launchOptions];
    
    
    //智石注册
    [self BRTBeaconRegister];
    
    //扫描智石设备
    [self startRangingBRTBeacon];
    
    [self watchBeacon];
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
    
    /*//注册智石
    [BRTBeaconSDK registerApp:bbAPPKEY onCompletion:^(BOOL complete, NSError *error) {
        if (complete == SUCCESS_CODE) {
            NSLog(@"BRT register success");
        }
        else
        {
            NSLog(@"BRT register failed:%@",error.localizedFailureReason);
        }
    }];
    [BRTBeaconSDK startRangingBeaconsInRegions:nil onCompletion:^(NSArray *beacons, BRTBeaconRegion *region, NSError *error){
        NSLog(@"进入区域回调:beacons:%@   /n region:%@",beacons,region);
    }];*/
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

#pragma mark 智石 -

/**
 * 注册
 */
- (void)BRTBeaconRegister
{
    [BRTBeaconSDK registerApp:BRTPPKEY onCompletion:^(BOOL complete,NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

/**
 * 本地通知
 */
- (void)sendLocalNotification:(NSString*)msg
{
    UILocalNotification *notice = [[UILocalNotification alloc] init];
    notice.alertBody = msg;
    notice.alertAction = Lang(@"Open", @"打开软件");
    notice.soundName = UILocalNotificationDefaultSoundName;
    notice.userInfo = @{@"msg":BRTNOTIFIYID};
    [[UIApplication sharedApplication] presentLocalNotificationNow:notice];
}

/**
 * 开始扫描设备
 */
- (IBAction)startRangingBRTBeacon
{
    __unsafe_unretained typeof(self) weakSelf = self;
    //扫描BrihtBeacon额外蓝牙信息。支持连接配置。（含UUID检测iBeacon信息）
    [BRTBeaconSDK startRangingWithUuids:@[[[NSUUID alloc] initWithUUIDString:DEFAULT_UUID]] onCompletion:^(NSArray *beacons, BRTBeaconRegion *region, NSError *error) {
        if (!error) {
            [weakSelf reloadData:beacons];
        }else{
            //检查蓝牙是否打开
            [self showMsg:@"请开启蓝牙"];
        }
    }];
}


/**
 * 设备排序
 */
- (void)reloadData:(NSArray*)beacons
{
    self.beacons = [beacons sortedArrayUsingComparator:^NSComparisonResult(BRTBeacon* obj1, BRTBeacon* obj2){
        return obj1.distance.floatValue>obj2.distance.floatValue?NSOrderedDescending:NSOrderedAscending;
    }];
}

- (void)watchBeacon
{
    //IOS8.0 推送必须询求用户同意，来触发通知（按你程序所需）
    if ([[[UIDevice currentDevice] systemVersion] intValue]>=8) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    //重构当前Beacon所在Region,如果your_region_id一致会覆盖之前的Region,另region监听个数<=20个
    BRTBeaconRegion *region = [[BRTBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString: DEFAULT_UUID] identifier:@"your_region_id"];
    region.notifyOnEntry = YES;
    //    region.notifyOnExit = YES;
    //    region.notifyEntryStateOnDisplay = YES;
    [BRTBeaconSDK startMonitoringForRegions:@[region]];
}

- (void)goWebViewController:(NSString *)url title:(NSString *)title;
{
    if (url == nil || url.length < 1)
    {
        return;
    }
    UIViewController *rootVc = self.window.rootViewController;
    UINavigationController *navigationController;
    if ([rootVc isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *navigator = (UITabBarController *)rootVc;
        navigationController = navigator.selectedViewController;
    }
    else
        return ;
    
    UIStoryboard *storyBoard = STORYBOARDWITHNAME(@"Main");
    IWebController *infoVc = [storyBoard instantiateViewControllerWithIdentifier:@"IWebController"];
    infoVc.webUrl = url;
    infoVc.titleStr = title;
    [navigationController pushViewController:infoVc animated:YES];
}


/**
 * ibeacon设备信息上传
 */
- (void)beaconsMsgUpload
{
    //    [self showLoadingView];
    BRTBeacon *beacontemp;
    if (_beacons.count < 1)
        beacontemp = [[BRTBeacon alloc] init];
    else
        beacontemp = _beacons[0];
    
    NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID withDefault:FAILED_CODE];
    NSString *keyvalueStr = [NSString stringWithFormat:@"%@_%@_%@_%@",beacontemp.major,beacontemp.minor,beacontemp.macAddress == nil ? @"null":beacontemp.macAddress,@"iOS"];
    NSDictionary *parameter = @{@"jsons":[NSString stringWithFormat:@"{\"fkname\": \"\",\"keyvalue\": \"%@\",\"appcode\": \"A01\",\"userid\": \"%zi\",\"target\": \"PushOL\"}",keyvalueStr,userId]};
    
    [[APIClient sharedClient] requestPath:QRUPLOAD_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSInteger code = [JSON[@"success"] integerValue];
        if (code == SUCCESS_CODE)
        {
            [self goWebViewController:JSON[@"message"] title:JSON[@"keyvalue"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


#pragma mark 智石 - Delegate
/**
 * 只能在AppDelegate实现
 *
 * 区域监听失败触发的回调方法，以及关联的错误信息
 *
 * @param manager Bright beacon 管理器
 * @param region Bright beacon 区域
 * @param error 错误信息
 *
 * @return void
 */
-(void)beaconManager:(BRTBeaconManager *)manager
monitoringDidFailForRegion:(BRTBeaconRegion *)region
           withError:(NSError *)error{
    
}

/**
 * 只能在AppDelegate实现
 *
 * 在区域监听中，iOS设备进入beacon设备区域触发该方法
 *
 * @param manager Bright beacon 管理器
 * @param region Bright beacon 区域
 *
 * @return void
 */
-(void)beaconManager:(BRTBeaconManager *)manager didEnterRegion:(BRTBeaconRegion *)region{
    if(region.notifyOnEntry)
        [self sendLocalNotification:Lang(@"Hello!", @"您已经进入了Beacon体验区")];
}


/**
 * 只能在AppDelegate实现
 *
 * 在区域监听中，iOS设备离开beacon设备区域触发该方法
 *
 * @param manager Bright beacon 管理器
 * @param region Bright beacon 区域
 *
 * @return void
 */
-(void)beaconManager:(BRTBeaconManager *)manager
       didExitRegion:(BRTBeaconRegion *)region{
    if(region.notifyOnExit)[self sendLocalNotification:Lang(@"Goodbye.", @"您已经离开")];
}

/**
 * 只能在AppDelegate实现
 *
 * 在调用startMonitoringForRegion:方法，当beacon区域状态变化会触发该方法
 *
 * @param manager Bright beacon 管理器
 * @param state Bright beacon 区域状态
 * @param region Bright beacon 区域
 *
 * @return void
 */
-(void)beaconManager:(BRTBeaconManager *)manager
   didDetermineState:(CLRegionState)state
           forRegion:(BRTBeaconRegion *)region{
    if(region.notifyEntryStateOnDisplay)[self sendLocalNotification:Lang(@"Hello!", @"你处于监听Beacon区域,点亮屏幕收到此推送")];
}

//模拟iBeacon回调
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    
}


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




#pragma mark JPUSH


- (void)jPushRegisiter:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10以上
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //iOS8以上可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //iOS8以下categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    BOOL isProduction = YES;// NO为开发环境，YES为生产环境
    //广告标识符
    //NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //Required(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    [JPUSHService setupWithOption:launchOptions appKey:JPSAPPKEY
                          channel:nil
                 apsForProduction:isProduction
            advertisingIdentifier:nil];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
        NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
-(NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}



#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSLog(@"收到远程通知！!");
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSDictionary *dic = userInfo[@"aps"];
        NSString *descrip = dic[@"alert"];
        
        [self showRemoteNotificationMsg:descrip];
    }
    else if([userInfo[@"msg"] isEqualToString:BRTNOTIFIYID])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"进入ibeacon区域" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *destructive = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self beaconsMsgUpload];
        }];
        [alert addAction:destructive];
        UINavigationController *navigator = (UINavigationController *)self.window.rootViewController;
        [navigator presentViewController:alert animated:YES completion:nil];
        
        return ;
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [UIApplication sharedApplication].applicationIconBadgeNumber= 0;
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self goMsgVc];
    }
    else if([userInfo[@"msg"] isEqualToString:BRTNOTIFIYID])
    {
        [self beaconsMsgUpload];
        
        return ;
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)goMsgVc
{
    
    UIViewController *rootVc = self.window.rootViewController;
    UINavigationController *navigationController;
    if ([rootVc isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *navigator = (UITabBarController *)rootVc;
        navigationController = navigator.selectedViewController;
    }
    else
        return ;
    
    UIStoryboard *storyBoard = STORYBOARDWITHNAME(@"UCenter");
    UIViewController *infoVc = [storyBoard instantiateViewControllerWithIdentifier:@"UMessageTableViewController"];
    [navigationController pushViewController:infoVc animated:YES];
}


- (void)showMsg:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
        
    }];
    [alert addAction:cancel];
    UINavigationController *navigator = (UINavigationController *)self.window.rootViewController;
    [navigator presentViewController:alert animated:YES completion:nil];
}

- (void)showRemoteNotificationMsg:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *destructive = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goMsgVc];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
        
    }];
    [alert addAction:cancel];
    [alert addAction:destructive];
    UINavigationController *navigator = (UINavigationController *)self.window.rootViewController;
    [navigator presentViewController:alert animated:YES completion:nil];
}

@end
