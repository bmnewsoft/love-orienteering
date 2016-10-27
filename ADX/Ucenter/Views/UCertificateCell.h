//
//  UCertificateCell.h
//  ADX
//
//  Created by MDJ on 2016/10/8.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseModel.h"

@interface UCertificateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *CImageView;
@property (weak, nonatomic) IBOutlet UILabel *CtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *CDetailLabel;

@property (nonatomic,strong)BaseModel *model;

@end
