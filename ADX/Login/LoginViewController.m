//
//  LoginViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/2.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "LoginViewController.h"
#import "APIClient.h"
#import "NSString+Extensions.h"
#import "NSString+URLEncoding.h"
#import "BaseModel.h"
#import "AppDelegate.h"
#import "ADXUserDefault.h"

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
#ifdef DEBUG
    _userNameTextField.text = @"18301182342";
    _passwordTextField.text = @"047X";
#endif
    
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
        [self showToast:@"手机号不能为空"];
        return;
    }
    if (self.passwordTextField.text.length<= 0)
    {
        [self showToast:@"密码不能为空"];
        return;
    }
    
    if (![self.userNameTextField.text isMobileNumber])
    {
        [self showToast:@"请输入正确的手机号"];
        return;
    }
    [self showLoadingView];
    UIButton *button = (UIButton *)sender;
    button.enabled = NO;
    NSString *password = [APIClient digestPassword:self.passwordTextField.text];
    
    NSDictionary *paramet = @{@"appcode":@"A01",
                              @"groupcode":@"DataSysUser",
                              
                              @"loginname":self.userNameTextField.text,
                              @"pwd":password
                              };
    
    [[APIClient sharedClient] requestPath:LOGIN_URL parameters:paramet success:^(AFHTTPRequestOperation *operation, id JSON) {
        [self hideLoadingView];
        button.enabled = YES;
        if ([JSON objectForKey:@"success"])
        {
            [self showToast:[JSON objectForKey:@"message"]];
        }
        else
        {
            ShareAppDelegate.user = [MUser UserWithDic:(NSDictionary *)JSON];
            [ADXUserDefault setInt:ShareAppDelegate.user.userID withKey:kUSERID];
            [self instantiateStoryBoard:@"Main"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        button.enabled = YES;
        [self showNetworkNotAvailable];
        [self hideLoadingView];
    }];
    
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
