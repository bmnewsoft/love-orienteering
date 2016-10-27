//
//  UMessageCell.m
//  ADX
//
//  Created by MDJ on 2016/10/9.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "UMessageCell.h"

@implementation UMessageCell

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
    _titelLabel.text = _model.title1;
    _timeLabel.text = _model.title2;
}

@end
