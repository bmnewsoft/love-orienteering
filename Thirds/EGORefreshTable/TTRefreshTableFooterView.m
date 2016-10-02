//
//  TTRefreshTableFooterView.m
//  TTCommon
//
//  Created by Ma Jianglin on 11/27/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import "TTRefreshTableFooterView.h"

#define kLoadMoreText   @"加载更多"
#define kLoadingText    @"正在加载..."

@interface TTRefreshTableFooterView()
{
    UIActivityIndicatorView *_indicator;
    UIButton *_button;
}

@end

@implementation TTRefreshTableFooterView

+ (id) new
{
    CGRect rect = CGRectMake(0, 0, 320, 40);
    TTRefreshTableFooterView *footer = [[TTRefreshTableFooterView alloc] initWithFrame:rect];
    footer.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    return footer;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitle:kLoadMoreText forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"more_button_bg"] forState:UIControlStateNormal];
        [self addSubview:button];
        button.tag = 1;
    }
    return self;
}

- (void)setMoreDataLoader:(id)loader
{
    if (_button == nil)
    {
        _button = (UIButton*)[self viewWithTag:1];
    }
    
//    SEL selector = sel_registerName("loadMore");
    SEL selector = NSSelectorFromString(@"loadMore");
    [_button addTarget:loader action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)displayIndicator
{
    if (_indicator == nil)
    {
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width- self.frame.size.height) / 2 - 60, 0.0f,
                                                                               self.frame.size.height, self.frame.size.height)];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _indicator.transform = CGAffineTransformScale(_indicator.transform, 0.75, 0.75);
        [self addSubview:_indicator];
    }
    
    if (_button == nil)
    {
        _button = (UIButton*)[self viewWithTag:1];
    }
    
    [_button setTitle:kLoadingText forState:UIControlStateNormal];
    _button.userInteractionEnabled = NO;
    
    _indicator.hidden = NO;
    [_indicator startAnimating];
}


- (void)hideIndicator
{
    _button.userInteractionEnabled = YES;
    [_button setTitle:kLoadMoreText forState:UIControlStateNormal];
    
    [_indicator stopAnimating];
    _indicator.hidden = YES;
}


@end
