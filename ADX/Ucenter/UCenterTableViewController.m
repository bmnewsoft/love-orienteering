//
//  UCenterTableViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/7.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "UCenterTableViewController.h"
#import "UCenterCell.h"

#import "UInfoViewController.h"

#define CELLTITLE @[@"我的信息",@"我的比赛",@"赛事证书",@"消息通知",@"设置"]

#define VCIdentifier @[@"UInfoViewController"]


@interface UCenterTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *uHeaderImage;

@property (nonatomic,strong)NSMutableArray *datas;

@end

@implementation UCenterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseParameters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setBaseParameters
{
    _datas = [NSMutableArray arrayWithCapacity:1];
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
    NSLog(@"测试 第 %zi组，第%zi行",indexPath.section,indexPath.row);
    if(indexPath.row == 0)
    {
        UIStoryboard *storyBoard = STORYBOARDWITHNAME(@"UCenter");
        UInfoViewController *infoVc = [storyBoard instantiateViewControllerWithIdentifier:VCIdentifier[indexPath.row]];
        infoVc.title = @"我的信息";
        [self.navigationController pushViewController:infoVc animated:YES];
    }
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
