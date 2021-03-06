//
//  UMatchCell.h
//  ADX
//
//  Created by MDJ on 2016/10/8.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseModel.h"

@interface UMatchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *AimageView;

@property (nonatomic,strong)BaseModel *model;

@end
