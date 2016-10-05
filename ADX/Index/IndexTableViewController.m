//
//  IndexTableViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/5.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "IndexTableViewController.h"
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
    NSDictionary *parameter =@{@"appcode":@"A01",
                               @"groupcode":@"A01_P1_G2",
                               @"keyvalue":@1,
                               @"userid":@1
                               };
    [[APIClient sharedClient] requestPath:DATA_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        [self hideLoadingView];
        NSArray *items = [JSON objectForKey:@"items"];
        for (NSDictionary * attri in items)
        {
            BaseModel *model = [[BaseModel alloc] initWithAttributes:attri];
            [_datas addObject:model];
            NSLog(@"%@",model);
        }
        [self.tableView reloadData];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
