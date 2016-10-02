//
//  FindPasswordViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/2.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *sendCodeLable;

@property (strong,nonatomic) NSTimer * timer;

@end

@implementation FindPasswordViewController

static int myTime;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setBackButton];
    self.sendCodeLable.layer.cornerRadius = 5;
    self.sendCodeLable.layer.masksToBounds = YES;
    
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
}

- (void)changeButtonName
{
    if (myTime > 0)
    {
        self.sendCodeButton.enabled = NO;
        myTime--;
        NSString * string = [NSString stringWithFormat:@"%d秒后重新获取",myTime];
        
        self.sendCodeLable.text = string;
        
    }
    else
    {
        [self.timer invalidate];
        
        self.sendCodeLable.backgroundColor = UIColorRGB(71.0, 195.0, 195.0);
        self.sendCodeLable.text = @"重新获取";
        self.sendCodeButton.enabled = YES;
    }
}

- (IBAction)userSendCode:(UIButton *)sender
{
    
    [self.view endEditing:YES];
    
    //取出手机号，并且去掉首尾的空格和回车
    NSString *mobile  = [self.mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if (mobile.length <= 0)
    {
        [self showToast:@"手机号不能为空"];
        return;
    }
}

- (IBAction)userFindPassword:(UIButton *)sender {
    
    NSString *mobile = [self.mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = self.passwordTextField.text;
    NSString *rePassword = self.rePasswordTextField.text;
    NSString *verifyCode = [self.verifyCodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (mobile.length <= 0)
    {
        [self showToast:@"手机号不能为空"];
        return;
    }
    if (password.length <= 0)
    {
        [self showToast:@"密码不能为空"];
        return;
    }
    if (verifyCode.length <= 0)
    {
        [self showToast:@"验证码不能为空"];
        return;
    }
    if (![password isEqualToString:rePassword]) {
        [self showToast:@"两次输入密码不一致"];
        return;
    }
}

- (IBAction)endEditing:(UITextField *)sender {
    [self.passwordTextField resignFirstResponder];
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
