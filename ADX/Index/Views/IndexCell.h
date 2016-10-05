//
//  IndexCell.h
//  ADX
//
//  Created by MDJ on 2016/10/5.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface IndexCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *src1;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title4;

@property (nonatomic,strong)BaseModel * model;

@end
