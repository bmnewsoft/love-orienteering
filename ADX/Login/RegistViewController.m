//
//  RegistViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/2.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "RegistViewController.h"
#import "APIClient.h"
#import "NSString+Extensions.h"
#import "AppDelegate.h"
#import "BaseModel.h"
#import "ADXUserDefault.h"

@interface RegistViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *sendCodeLable;


@property (nonatomic ,strong)NSString *smsCode;
@property (nonatomic,assign)BOOL isSendSms;
@property (strong,nonatomic) NSTimer * timer;

@end

@implementation RegistViewController

static int myTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackButton];
    self.sendCodeLable.layer.cornerRadius = 5;
    self.sendCodeLable.layer.masksToBounds = YES;
#ifdef DEBUG
    _mobileField.text = @"18523633632";
    _passwordTextField.text = @"1234";
    _verifyCodeField.text = @"1234";
#endif
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
    _isSendSms = NO;
}

#pragma mark count number
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


#pragma mark ent editing

- (IBAction)endEditing:(UITextField *)sender
{
    [self.passwordTextField resignFirstResponder];
}


#pragma mark send code action
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
    
    if (![mobile isMobileNumber])
    {
        [self showToast:@"请输入正确的手机号"];
        return;
    }
    
    NSDictionary * parameter = @{@"jsons":[NSString stringWithFormat:@"{\"minu\": \"5\",\"n\": 4,\"phone\": \"%@\",\"version\": \"43242\"}",mobile]
                                 };
    _isSendSms = NO;
    [[APIClient sharedClient] requestPath:SMS_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         [self hideLoadingView];
         self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeButtonName) userInfo:nil repeats:YES];
         self.sendCodeButton.enabled = NO;
         self.sendCodeLable.backgroundColor = [UIColor grayColor];
         self.sendCodeLable.text = @"60秒后重新获取";
         myTime = 60;
         if ([[JSON objectForKey:@"success"] integerValue] != SUCCESS_CODE)
         {
             self.sendCodeLable.text = @"验证码获取失败";
             myTime = 1;
             [self showToast:@"验证码获取失败"];
         }
         else
         {
             self.smsCode = [JSON valueForKey:@"keyvalue"];
             _isSendSms = YES;
         }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.sendCodeButton.enabled = NO;
        self.sendCodeLable.backgroundColor = [UIColor grayColor];
        self.sendCodeLable.text = @"验证码获取失败";
        myTime = 1;
        [self hideLoadingView];
        [self showNetworkNotAvailable];
        
    }];
    
}


#pragma mark register button action
- (IBAction)userRegister:(UIButton *)sender
{
    
    NSString *mobile = [self.mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = self.passwordTextField.text;
    NSString *verifyCode = [self.verifyCodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (mobile.length <= 0)
    {
        [self showToast:@"手机号不能为空"];
        return;
    }
    else if (![mobile isMobileNumber])
    {
        [self showToast:@"请输入正确的手机号"];
        return;
    }
    else if (password.length <= 0)
    {
        [self showToast:@"密码不能为空"];
        return;
    }
    else if (!_isSendSms)
    {
        [self showToast:@"请获取验证码"];
        return;
    }
    else if (verifyCode.length <= 0)
    {
        [self showToast:@"验证码不能为空"];
        return;
    }
    else if (![verifyCode isEqualToString:self.smsCode]) {
        [self showToast:@"验证码不正确"];
        return;
    }
    password = [APIClient digestPassword:password];
    NSDictionary * parameter = @{@"jsons":[NSString stringWithFormat:@"{\"code\": \"%@\",\"opty\": \"register\",\"phone\": \"%@\",\"password\": \"%@\"}",verifyCode,mobile,password]
                                 };
    [[APIClient sharedClient] requestPath:USER_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        [self hideLoadingView];
        if([[JSON objectForKey:@"success"] integerValue] != SUCCESS_CODE)
        {
        [self showToast:[JSON valueForKey:@"message"]];
        }
        else
        {
            [ADXUserDefault setInt:[[JSON valueForKey:@"keyvalue"] integerValue] withKey:kUSERID];
            [self instantiateStoryBoard:@"Main"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
