//
//  IndexCell.m
//  ADX
//
//  Created by MDJ on 2016/10/5.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "IndexCell.h"
#import "UIImageView+WebCache.h"

@implementation IndexCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(BaseModel *)model
{
    if (model ==nil)
    {
        return;
    }
    _model = model;
    [_src1 sd_setImageWithURL:[NSURL URLWithString:_model.src1]];
    _title1.text = _model.title1;
    _title4.text = _model.title4;
}

@end
