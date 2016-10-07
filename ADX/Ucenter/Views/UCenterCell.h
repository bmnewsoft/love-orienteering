//
//  UCenterCell.h
//  ADX
//
//  Created by MDJ on 2016/10/7.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface UCenterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong)BaseModel *model;

@end
