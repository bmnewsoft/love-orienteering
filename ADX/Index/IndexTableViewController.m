//
//  IndexTableViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/5.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "IndexTableViewController.h"
#import "AppDelegate.h"
#import "APIClient.h"
#import "BaseModel.h"

#import "IndexCell.h"

@interface IndexTableViewController ()

@property (nonatomic,strong)NSMutableArray * datas;

@end

@implementation IndexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = [NSMutableArray arrayWithCapacity:1];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    [self showLoadingView];
    
    NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID withDefault:FAILED_CODE];
    if (userId == FAILED_CODE)
    {
        [self instantiateStoryBoard:@"Login"];
    }
    
    NSDictionary *parameter =@{pAPPCODE,
                               pGROUPCODE:@"A01_P1_G2",
                               pKEYVALUE:@1,
                               pUSERID:[NSNumber numberWithInteger:userId]
                               };
    
    [[APIClient sharedClient] requestPath:DATA_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        [self hideLoadingView];
        NSArray *items = [JSON objectForKey:@"items"];
        Response *response = [Response responseWithDict:JSON];
        if (response.code == FAILED_CODE) {
            [self showToast:response.message];
        }
        else
        {
            for (NSDictionary * attri in items)
            {
                BaseModel *model = [[BaseModel alloc] initWithDic:attri];
                [_datas addObject:model];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showNetworkNotAvailable];
        [self hideLoadingView];
    }];
}


#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IndexCell *cell =[tableView dequeueReusableCellWithIdentifier:@"IndexCell"];
    [cell setModel:_datas[indexPath.row]];
    return cell;
}

#pragma mark ToLogin


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
