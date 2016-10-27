//
//  TaskIngCell.h
//  ADX
//
//  Created by MDJ on 2016/10/6.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface TaskIngCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *deatelLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *task_point;
@property (weak, nonatomic) IBOutlet UIImageView *taskPointRight;

@property (nonatomic,strong)BaseModel *model;

@end
