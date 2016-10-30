//
//  UCertificateDetailViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/29.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "UCertificateDetailViewController.h"
#import "BaseModel.h"

@interface UCertificateDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *title4;
@property (weak, nonatomic) IBOutlet UILabel *title5;
@property (weak, nonatomic) IBOutlet UILabel *title6;
@property (weak, nonatomic) IBOutlet UILabel *title7;

@property (nonatomic,strong)BaseModel *CertificateData;

@end

@implementation UCertificateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseParameters];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBaseParameters
{
    self.title = @"我的证书";
}

- (void)setHeadData:(BaseModel *)model
{
    if (model == nil)
    {
        return;
    }
    _CertificateData = model;
    _title1.text = _CertificateData.title1;
    _title2.text = _CertificateData.title2;
    _title3.text = _CertificateData.title3;
    _title4.text = _CertificateData.title4;
    _title5.text = _CertificateData.title5;
    _title6.text = _CertificateData.title6;
    _title7.text = _CertificateData.title7;
    
}

- (void)loadData
{
    [self showLoadingView];
    NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID withDefault:FAILED_CODE];
    if (userId == FAILED_CODE)
    {
        [self instantiateStoryBoard:@"Login"];
    }
    
    NSDictionary *parameter = @{pAPPCODE,
                                pGROUPCODE:@"A01_P9_G2",
                                pKEYVALUE:_keyValue,
                                pUSERID:[NSNumber numberWithInteger:userId]};
    
    NSLog(@"%@",parameter);
    [[APIClient sharedClient] requestPath:DATA_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        [self hideLoadingView];
        Response *response = [Response responseWithDict:JSON];
        if (response.code == FAILED_CODE)
        {
            [self showToast:response.message];
        }
        else
        {
            NSArray *items = [JSON objectForKey:@"items"];
            if (items== NULL || items.count <= 0) {
                return ;
            }
            for (NSDictionary *item in items) {
                BaseModel *model = [[BaseModel alloc] initWithDic:item];
                [self setHeadData:model];
            }
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
