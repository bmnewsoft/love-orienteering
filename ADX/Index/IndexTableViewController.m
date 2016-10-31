//
//  IndexTableViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/5.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "IndexTableViewController.h"
#import "IWebController.h"


#import "AppDelegate.h"
#import "APIClient.h"
#import "BaseModel.h"

#import "IndexCell.h"

#import "BRTBeaconSDK.h"

@interface IndexTableViewController ()

@property (nonatomic,strong)NSMutableArray * datas;

@property (nonatomic,strong)NSArray *beacons;

@end

@implementation IndexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = [NSMutableArray arrayWithCapacity:1];
    [self loadData];
//    [self startButtonClicked:nil];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    [self showLoadingView];
    [_datas removeAllObjects];
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

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseModel *model =  _datas[indexPath.row];
    if (model.title2 == nil)
    {
        return;
    }
    UIStoryboard *story = STORYBOARDWITHNAME(@"Main");
    IWebController *myView = [story instantiateViewControllerWithIdentifier:@"IWebController"];
    myView.webUrl = model.title2;
    myView.titleStr = model.title1;
    [self.navigationController pushViewController:myView animated:YES];
}

#pragma mark 智石

- (IBAction)startButtonClicked:(id)sender
{
    __unsafe_unretained typeof(self) weakSelf = self;
    //扫描BrihtBeacon额外蓝牙信息。支持连接配置。（含UUID检测iBeacon信息）
    [BRTBeaconSDK startRangingWithUuids:@[[[NSUUID alloc] initWithUUIDString:DEFAULT_UUID]] onCompletion:^(NSArray *beacons, BRTBeaconRegion *region, NSError *error) {
        if (!error) {
            [weakSelf reloadData:beacons];
        }else{
            //检查蓝牙是否打开
            [self showToast:error.description];
        }
    }];
}

- (void)reloadData:(NSArray*)beacons
{
    self.beacons = [beacons sortedArrayUsingComparator:^NSComparisonResult(BRTBeacon* obj1, BRTBeacon* obj2){
        return obj1.distance.floatValue>obj2.distance.floatValue?NSOrderedDescending:NSOrderedAscending;
    }];
}


- (void)beaconsMsgUpload:(BRTBeacon *)beacon
{
//    [self showLoadingView];
    
    NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID withDefault:FAILED_CODE];
    if (userId == FAILED_CODE)
    {
        [self instantiateStoryBoard:@"Login"];
    }
    NSString *keyvalueStr = @"";
     NSDictionary *parameter = @{@"jsons":[NSString stringWithFormat:@"{\"fkname\": \"\",\"keyvalue\": \"%@\",\"appcode\": \"A01\",\"userid\": \"%zi\",\"target\": \"PushOL\"}",keyvalueStr,userId]};
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
