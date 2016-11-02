//
//  IWebController.h
//  ADX
//
//  Created by MDJ on 2016/10/30.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "ADXBaseViewController.h"

@interface IWebController : ADXBaseViewController
{
    NSTimer * timer;
}

@property (nonatomic,strong)NSString *webUrl;
@property (nonatomic,strong)NSString *titleStr;

@end
