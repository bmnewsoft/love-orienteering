//
//  TaskIngCell.m
//  ADX
//
//  Created by MDJ on 2016/10/6.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "TaskIngCell.h"

@implementation TaskIngCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//“1” 已完成节点，“2” 正在进行，“3” 未进行，“0” 异常


-(void)setModel:(BaseModel *)model
{
    if (model == nil)
    {
        return;
    }
    _model = model;
    NSString * statusStr;
    if ([_model.title1 isEqualToString:@"1"]) {
        statusStr = @"已完成";
        _statusLabel.textColor = UIColorRGB(80, 92, 112);
        _taskPointRight.hidden = TRUE;
    }
    else if([_model.title1 isEqualToString:@"2"])
    {
        statusStr = @"进行中";
        _statusLabel.textColor = [UIColor whiteColor];
        _taskPointRight.hidden = FALSE;
    }
    else if([_model.title1 isEqualToString:@"3"])
    {
        statusStr = @"未执行";
        _statusLabel.textColor = [UIColor redColor];
        _taskPointRight.hidden = TRUE;
    }
    else
    {
        statusStr = @"未知";
        _statusLabel.textColor = UIColorRGB(80, 92, 112);
        _taskPointRight.hidden = TRUE;
        
    }
    _indexLabel.text = _model.title3;
    _deatelLabel.text = _model.title2;
    _statusLabel.text = statusStr;
}

@end
