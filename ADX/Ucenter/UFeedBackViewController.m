//
//  UFeedBackViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/10.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "UFeedBackViewController.h"
#import "BaseModel.h"

@interface UFeedBackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

@end

@implementation UFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseParameters];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBaseParameters
{
    [self.feedbackTextView.layer setCornerRadius:5];
    self.title = @"吐槽";
}

#pragma mark Button Action
- (IBAction)submitAction:(id)sender {
    NSString *feedText = [self.feedbackTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    feedText = [feedText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    feedText = [feedText stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    if (feedText.length < 3 || feedText.length >255)
    {
        [self showToast:@"字数在3~255"];
        [_feedbackTextView becomeFirstResponder];
        return;
    }
    
    feedText = [feedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self showLoadingView];
    NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID];
    
    NSDictionary *parameter = @{@"jsons":[NSString stringWithFormat:@"{\"AddReport\":{ \"1userid\":%zi,\"2Contents\": \"%@\"}}",userId,feedText]};
    
    [[APIClient sharedClient] requestPath:SUBMIT_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        [self hideLoadingView];
        Response *response = [Response responseWithDict:JSON];
        if (response.code == FAILED_CODE)
        {
            [self showToast:response.message];
        }
        else if(response.code == SUCCESS_CODE)
        {
            [self showToast:response.message];
            [self backAction:nil];
        }
        else
        {
            [self showNetworkNotAvailable];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
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
