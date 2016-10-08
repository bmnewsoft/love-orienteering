//
//  USettingTableViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/9.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "USettingTableViewController.h"

#import "USettingCell.h"


#define CELLTITLE     @[@"修改密码",\
                        @"吐槽产品",\
                        @"关于"]


@interface USettingTableViewController ()

@end

@implementation USettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    USettingCell *cell =[tableView dequeueReusableCellWithIdentifier:@"USettingCell"];
    cell.titleLabel.text = CELLTITLE[indexPath.row];
    return cell;
}
- (IBAction)LoginOutAction:(UIButton *)sender {
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
