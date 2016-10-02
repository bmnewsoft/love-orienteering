//
//  LoginViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/2.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark keyboard listener

- (IBAction)endEditAction:(UITextField *)sender
{
    if (sender == self.userNameTextField)
    {
        [sender resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    }
    else
    {
        [self.passwordTextField resignFirstResponder];
    }
}

#pragma mark login action

- (IBAction)loginAction:(id)sender
{
    if (self.userNameTextField.text.length<= 0)
    {
        [self showToast:@"账号不能为空"];
        return;
    }
    if (self.passwordTextField.text.length<= 0)
    {
        [self showToast:@"密码不能为空"];
        return;
    }
    [self showLoadingView];
    [self showAlertWithTitle:@"cheng" message:@"gong"];
    [self hideLoadingView];
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
