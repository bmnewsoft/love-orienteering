//
//  UMessageCell.h
//  ADX
//
//  Created by MDJ on 2016/10/9.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseModel.h"

@interface UMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titelLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong)BaseModel *model;

@end
