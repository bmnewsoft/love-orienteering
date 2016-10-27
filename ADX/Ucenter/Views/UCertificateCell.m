//
//  UCertificateCell.m
//  ADX
//
//  Created by MDJ on 2016/10/8.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "UCertificateCell.h"

@implementation UCertificateCell

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
    _CDetailLabel.text = _model.title1;
}

@end
