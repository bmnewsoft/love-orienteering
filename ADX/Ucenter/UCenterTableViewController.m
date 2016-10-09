//
//  UCenterTableViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/7.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "UCenterTableViewController.h"
#import "UCenterCell.h"
#import "UIImageView+WebCache.h"

#import "UInfoViewController.h"
#import "UMatchTableViewController.h"
#import "UCertificateTableViewController.h"
#import "UMessageTableViewController.h"
#import "USettingTableViewController.h"

#define CELLTITLE     @[@"我的信息",\
                        @"我的比赛",\
                        @"赛事证书",\
                        @"消息通知",\
                        @"设置"]

#define VCIdentifier  @[@"UInfoViewController",\
                        @"UMatchTableViewController",\
                        @"UCertificateTableViewController",\
                        @"UMessageTableViewController",\
                        @"USettingTableViewController"]


@interface UCenterTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *uHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *nikenameLabel;

@property (nonatomic,strong)NSString *headerUrl;
@property (nonatomic,strong)NSString *nikenameStr;

@property (nonatomic,strong)NSMutableArray *datas;



@end

@implementation UCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseParameters];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setBaseParameters
{
    _datas = [NSMutableArray arrayWithCapacity:1];
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
                                 pKEYVALUE:@"",
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
            [self setNikenameAndHeadImg:model];
            [_datas addObject:model];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self hideLoadingView];
        [self showNetworkNotAvailable];
    }];
}

-(void)setNikenameAndHeadImg:(BaseModel *)model
{
    [_uHeaderImage sd_setImageWithURL:[NSURL URLWithString:model.src1] placeholderImage:[UIImage imageNamed:@"headImage"]];
    _nikenameLabel.text = [NSString stringWithFormat:@"昵称：%@",model.title1];
}


#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CELLTITLE.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCenterCell *cell =[tableView dequeueReusableCellWithIdentifier:@"UCenterCell"];
    cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ucenter_%zi",indexPath.row ]];
    cell.titleLabel.text = CELLTITLE[indexPath.row];
    return cell;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyBoard = STORYBOARDWITHNAME(@"UCenter");
    UIViewController *infoVc = [storyBoard instantiateViewControllerWithIdentifier:VCIdentifier[indexPath.row]];
    infoVc.title = CELLTITLE[indexPath.row];
    if ([VCIdentifier[indexPath.row] isEqualToString:@"UInfoViewController"])
    {
        UInfoViewController *info = (UInfoViewController *)infoVc;
        _datas.count > 0 ?info.model=_datas[0]:nil ;
    }
    [self.navigationController pushViewController:infoVc animated:YES];
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
