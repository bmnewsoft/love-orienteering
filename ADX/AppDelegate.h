//
//  AppDelegate.h
//  ADX
//
//  Created by MDJ on 2016/10/1.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@class MUser;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) MUser *user;

@property (nonatomic,strong) UIView *lunchView;

@property (nonatomic,strong) NSArray *beacons;


@end

