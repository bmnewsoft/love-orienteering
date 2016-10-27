//
//  URePasswordViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/9.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "URePasswordViewController.h"
#import "BaseModel.h"
#import "AppDelegate.h"
#import "UNewPasswordViewController.h"

#import "NSString+Extensions.h"

@interface URePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTF;
@property (weak, nonatomic) IBOutlet UILabel *ButtonLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBt;

@property (nonatomic,strong)NSString *smsCode;
@property (nonatomic,strong)NSString *userPhoneNum;


@property (strong,nonatomic) NSTimer * timer;

@end

@implementation URePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MUser *user = ShareAppDelegate.user;
     self.userPhoneNum = ShareAppDelegate.user.phoneNum;
    if (self.userPhoneNum != nil && self.userPhoneNum.length == 11)
    {
        NSRange range = {3,4};
        _mobileTF.text = [self.userPhoneNum stringByReplacingCharactersInRange:range withString:@"****"];
    }
    _mobileTF.enabled = NO;
//    _mobileTF.text = @"18523633632";
    [self setBaseParameters];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBaseParameters
{
    self.title = @"修改密码";
    
//    ShareAppDelegate.userInfo
}

#pragma mark Button Action
static int myTime;

- (void)changeButtonName
{
    if (myTime > 0)
    {
        self.sendCodeBt.enabled = NO;
        myTime--;
        NSString * string = [NSString stringWithFormat:@"%ds",myTime];
        self.ButtonLabel.text = string;
        
    }
    else
    {
        [self.timer invalidate];
        self.ButtonLabel.text = @"重新获取";
        self.sendCodeBt.enabled = YES;
    }
}

- (IBAction)getSMSCode:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (self.userPhoneNum.length <= 0 || ![self.userPhoneNum isMobileNumber])
    {
        [self instantiateStoryBoard:@"Login"];
        return;
    }
    
    NSDictionary * parameter = @{@"jsons":[NSString stringWithFormat:@"{\"minu\": \"5\",\"n\": 4,\"phone\": \"%@\",\"version\": \"43242\"}",self.userPhoneNum]
                                 };
    self.sendCodeBt.enabled = NO;
    [[APIClient sharedClient] requestPath:SMS_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         [self hideLoadingView];
         self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeButtonName) userInfo:nil repeats:YES];
         self.ButtonLabel.text = @"60s";
         myTime = 60;
         Response *response = [Response responseWithDict:JSON];
         if (response.code == FAILED_CODE)
         {
             self.ButtonLabel.text = @"验证码获取失败";
             myTime = 1;
             [self showToast:@"验证码获取失败"];
         }
         else if (response.code == SUCCESS_CODE)
         {
             _smsCode = response.keyvalue;
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self hideLoadingView];
         [self showNetworkNotAvailable];
         self.sendCodeBt.enabled = YES;
     }];

}


#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"RePasswordNexSegueID"]) {
        UIButton *button = (UIButton*)sender;
        button.enabled = NO;
        if (_smsCode.length > 0 && ![_smsCode isEqualToString:[_smsCodeTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]])
        {
            [self showToast:@"请输入正确验证码"];
            button.enabled = YES;
            return NO;
        }
        else
        {
            button.enabled = YES;
            return YES;
        }
    }
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UNewPasswordViewController * nextVc = segue.destinationViewController;
    nextVc.mobile = [self.mobileTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    nextVc.smsCode = [_smsCodeTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}




@end
