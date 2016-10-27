//
//  UAboutViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/10.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "UAboutViewController.h"

@interface UAboutViewController ()
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@end

@implementation UAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseParameter];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBaseParameter
{
    self.title = @"关于我们";
    [self.aboutTextView.layer setCornerRadius:5];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
