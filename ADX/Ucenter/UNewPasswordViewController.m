//
//  UNewPasswordViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/9.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "UNewPasswordViewController.h"
#import "BaseModel.h"

@interface UNewPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordCheckTF;

@end

@implementation UNewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Button Aaction
- (IBAction)savePasswordAction:(id)sender {
    if (_passwordTF.text.length < 1)
    {
//        [self showToast:@"不能为空"];
        [_passwordTF becomeFirstResponder];
        return;
    }
    if (_passwordTF.text.length > 0 && _passwordTF.text.length < 6)
    {
        [self showToast:@"密码不能小于6位"];
        [_passwordTF becomeFirstResponder];
        return;
    }
    if (_passwordCheckTF.text.length < 1)
    {
        [self showToast:@"不能为空"];
        [_passwordCheckTF becomeFirstResponder];
        return;
    }
    if (![_passwordTF.text isEqualToString:_passwordCheckTF.text])
    {
        [self showToast:@"两次密码不一样"];
        [_passwordCheckTF becomeFirstResponder];
        return;
    }
    
    [self showLoadingView];
    NSDictionary *parameter = @{@"jsons":[NSString stringWithFormat:@"{\"code\": \"%@\",\"opty\": \"updatapwd\",\"password\": \"%@\",\"phone\": \"%@\"}",_smsCode,_passwordCheckTF.text,_mobile]};
    
    [[APIClient sharedClient] requestPath:USER_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        [self hideLoadingView];
        Response *response = [Response responseWithDict:JSON];
        if (response.code == FAILED_CODE)
        {
            [self showToast:response.message];
        }
        else if(response.code == SUCCESS_CODE)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingView];
        [self showNetworkNotAvailable];
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
