//
//  UMatchTableViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/8.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "UMatchTableViewController.h"

#import "UMatchCell.h"

@interface UMatchTableViewController ()

@end

@implementation UMatchTableViewController

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
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMatchCell *cell =[tableView dequeueReusableCellWithIdentifier:@"UMatchCell"];
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
