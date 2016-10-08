//
//  UInfoViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/7.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "UInfoViewController.h"

#import "ADXUserDefault.h"

#import "BaseModel.h"

#import "ASBirthSelectSheet.h"

@interface UInfoViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSegment;

@end

@implementation UInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setBackButton];
    [self setBaseParameters];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBaseParameters
{
//    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
//    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
}

-(void)loadData
{
    [self showLoadingView];
    NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID withDefault:FAILED_CODE];
    if (userId == FAILED_CODE)
    {
        [self instantiateStoryBoard:@"Login"];
    }
    NSDictionary * parameter = @{pAPPCODE,
                                 pGROUPCODE:@"A01_P9_G3",
                                 pKEYVALUE:@"1",
                                 pUSERID:[NSNumber numberWithInteger:userId]
                                 };
    [[APIClient sharedClient] requestPath:DATA_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        [self hideLoadingView];
        Response *response = [Response responseWithDict:JSON];
        if (response.code == FAILED_CODE)
        {
            [self showToast:response.message];
        }
        else
        {
            NSArray *items = [JSON valueForKey:@"items"];
            BaseModel *model = [[BaseModel alloc] initWithDic:items[0]];
            [self setInfo:model];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingView];
        [self showNetworkNotAvailable];
    }];
    
}

-(void)setInfo:(BaseModel *)model
{
    _nameTF.text        = model.title2;
    _sexTF.text         = model.title3;
    _ageTF.text         = model.title4;
    _IdentityIdTF.text  = model.title5;
    
}

#pragma mark button action
- (IBAction)saveAction:(UIButton *)sender {
    
    [self showLoadingView];
    NSInteger sele =  _sexSegment.selectedSegmentIndex;
    
    NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID];
    
//    "SetMyProfile": {
//        "1userid ":"7",
//        "2username ": "张三",
//        "3sex ": "1",
//        "4birthday ": “1988-11-25",
//        “5CardID”:”230321515451545151”
//    }
    
    NSDictionary *parameter = @{@"jsons":[NSString stringWithFormat:@"{\"SetMyProfile\":{ \"1userid\":%zi\",\"2username\": \"%@\",\"3sex\": \"%zi\",\"4birthday\": \"%@\",\"5CardID\": \"%@\"}}",userId,_nameTF.text,sele+1,_ageTF.text,_IdentityIdTF.text]};
    
    [[APIClient sharedClient] requestPath:INFOCHANGE_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        [self hideLoadingView];
        NSLog(@"%@",JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingView];
    }];
    
//    NSLog(@"save button clicked%zi",sele);
    
    
}
- (IBAction)dataPickerAction:(id)sender {
    ASBirthSelectSheet *datesheet = [[ASBirthSelectSheet alloc] initWithFrame:self.view.bounds];
    if (_ageTF.text.length <= 0)
    {
        datesheet.selectDate = @"1999-01-01";
    }
    else{
        datesheet.selectDate = _ageTF.text;
    }
    datesheet.GetSelectDate = ^(NSString *dateStr) {
        self.ageTF.text = dateStr;
    };
    [self.view addSubview:datesheet];
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
