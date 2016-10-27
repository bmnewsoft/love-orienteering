//
//  UMatchCell.m
//  ADX
//
//  Created by MDJ on 2016/10/8.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "UMatchCell.h"
#import "UIImageView+WebCache.h"

@implementation UMatchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(BaseModel *)model
{
    if (model == nil)
    {
        return;
    }
    _model = model;
    _subTitelLabel.text = _model.title1;
    [_AimageView sd_setImageWithURL:[NSURL URLWithString:_model.src1]];
}

@end
