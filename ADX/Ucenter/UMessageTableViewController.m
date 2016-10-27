//
//  UMessageTableViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/9.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "UMessageTableViewController.h"
#import "UMessageCell.h"
#import "BaseModel.h"

@interface UMessageTableViewController ()

@property (nonatomic,strong)NSMutableArray *datas;

@end

@implementation UMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setBaseParameters
{
    _datas = [NSMutableArray arrayWithCapacity:1];
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
                                pGROUPCODE:@"A01_P9_G1",
                                pKEYVALUE:@"",
                                pUSERID:[NSNumber numberWithInteger:userId]};
    
    
    [[APIClient sharedClient] requestPath:DATA_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        [self hideLoadingView];
        Response *response = [Response responseWithDict:JSON];
        if (response.code == FAILED_CODE)
        {
            [self showToast:response.message];
        }
        else if(response.code == SUCCESS_CODE)
        {
            NSArray *items = [JSON objectForKey:@"items"];
            for (NSDictionary *item in items) {
                BaseModel *model = [[BaseModel alloc] initWithDic:item];
                if (model.keyvalue != NULL)
                {
                    [_datas addObject:model];
                }
            }
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingView];
        [self showNetworkNotAvailable];
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
    UMessageCell *cell =[tableView dequeueReusableCellWithIdentifier:@"UMessageCell"];
    [cell setModel:_datas[indexPath.row]];
    return cell;
}


//#pragma mark UITableViewDelegate
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"测试 第 %zi组，第%zi行",indexPath.section,indexPath.row);
//    if(indexPath.row == 0)
//    {
//        UIStoryboard *storyBoard = STORYBOARDWITHNAME(@"UCenter");
//        UInfoViewController *infoVc = [storyBoard instantiateViewControllerWithIdentifier:VCIdentifier[indexPath.row]];
//        infoVc.title = CELLTITLE[indexPath.row];
//        [self.navigationController pushViewController:infoVc animated:YES];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
