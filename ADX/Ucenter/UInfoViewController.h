//
//  UInfoViewController.h
//  ADX
//
//  Created by MDJ on 2016/10/7.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "ADXBaseViewController.h"
#import "BaseModel.h"

@interface UInfoViewController : ADXBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *sexTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UITextField *IdentityIdTF;

@property (nonatomic,strong)BaseModel *model;

@end
