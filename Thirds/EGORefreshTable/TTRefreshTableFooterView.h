//
//  TTRefreshTableFooterView.h
//  TTCommon
//
//  Created by Ma Jianglin on 11/27/13.
//  Copyright (c) 2013 totemtec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTRefreshTableFooterView : UIView


- (void)setMoreDataLoader:(id)loader;

- (void)displayIndicator;
- (void)hideIndicator;

@end
