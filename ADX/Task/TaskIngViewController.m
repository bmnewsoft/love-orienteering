//
//  TaskIngViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/6.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "TaskIngViewController.h"
#import "BaseModel.h"

@interface TaskIngViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *stepTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@end

@implementation TaskIngViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    [self showLoadingView];
    
    NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID withDefault:FAILED_CODE];
    if (userId == FAILED_CODE)
    {
        [self instantiateStoryBoard:@"Login"];
    }
    
    NSDictionary *parameter = @{pAPPCODE,
                                pGROUPCODE:@"A01_P7_G1",
                                pKEYVALUE:@"1",
                                pUSERID:[NSNumber numberWithInteger:userId]
                                };
    
    [[APIClient sharedClient] requestPath:DATA_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        Response *response = [Response responseWithDict:JSON];
        [self hideLoadingView];
        if (response.code == FAILED_CODE)
        {
            [self showToast:response.message];
            self.noDataView.hidden = NO;
            self.noDataLabel.text = response.message;
        }
        else
        {
            self.noDataView.hidden = YES;
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
