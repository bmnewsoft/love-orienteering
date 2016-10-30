//
//  UMatchDetailTVController.m
//  ADX
//
//  Created by MDJ on 2016/10/28.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "UMatchDetailTVController.h"
#import "IWebController.h"

#import "BaseModel.h"
#import "TaskIngCell.h"

@interface UMatchDetailTVController ()
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *title4;
@property (weak, nonatomic) IBOutlet UILabel *title5;
@property (weak, nonatomic) IBOutlet UILabel *title6;
@property (weak, nonatomic) IBOutlet UILabel *timeCountLabel;

@property (nonatomic,strong)BaseModel *headData;

@property (nonatomic,strong)NSMutableArray *datas;

@end

@implementation UMatchDetailTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseParameters];
    [self loadHeadData];
    [self loadListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setBaseParameters
{
    self.title = @"我的比赛";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _datas = [NSMutableArray arrayWithCapacity:1];
}


- (void)loadHeadData
{
    [self showLoadingView];
    NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID withDefault:FAILED_CODE];
    if (userId == FAILED_CODE)
    {
        [self instantiateStoryBoard:@"Login"];
    }
    
    NSDictionary *parameter = @{pAPPCODE,
                                pGROUPCODE:@"A01_P4_G1",
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


- (void)loadListData
{
    [self showLoadingView];
    NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID withDefault:FAILED_CODE];
    if (userId == FAILED_CODE)
    {
        [self instantiateStoryBoard:@"Login"];
    }
    
    NSDictionary *parameter = @{pAPPCODE,
                                pGROUPCODE:@"A01_P6_G2",
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
                [_datas addObject:model];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingView];
        [self showNetworkNotAvailable];
    }];
    
}

- (void)setHeadData:(BaseModel *)model
{
    if (model == nil)
    {
        return;
    }
    _headData = model;
    _title1.text = _headData.title1;
    _title2.text = _headData.title2;
    _title3.text = _headData.title3;
    _title4.text = _headData.title4;
    _title5.text = _headData.title5;
    _title6.text = _headData.title6;
    
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
    TaskIngCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TaskIngCell"];
    //    BaseModel *model = _datas[indexPath.row];
    [cell setModel:_datas[indexPath.row]];
    if (indexPath.row == 0)
    {
        cell.task_point.image = [UIImage imageNamed:@"taskpoint_head"];
    }
    else if (indexPath.row == _datas.count - 1)
    {
        cell.task_point.image = [UIImage imageNamed:@"taskpoint_foot"];
    }
    else
    {
        cell.task_point.image = [UIImage imageNamed:@"taskpoint_bady"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 250;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  nil;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseModel *model =  _datas[indexPath.row];
    if (model.title4 == nil)
    {
        return;
    }
    UIStoryboard *story = STORYBOARDWITHNAME(@"Main");
    IWebController *myView = [story instantiateViewControllerWithIdentifier:@"IWebController"];
    myView.webUrl = model.title4;
    myView.titleStr = model.title2;
    [self.navigationController pushViewController:myView animated:YES];
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
