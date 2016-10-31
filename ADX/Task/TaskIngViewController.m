//
//  TaskIngViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/6.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "TaskIngViewController.h"
#import "QRCodeViewController.h"
#import "IWebController.h"
#import "BaseModel.h"
#import "TaskIngCell.h"


@interface TaskIngViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *stepTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@property (nonatomic,strong)NSDate * beginDate;

@property (nonatomic,strong)NSMutableArray  *datas;

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)NSTimeInterval timeinterval;

@end

@implementation TaskIngViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseParameters];
    [self loadData:LoadData_Time];
    [self loadData:LoadData_Data];
    
    
    // Do any additional setup after loading the view.
}

- (void)initBaseParameters
{
    self.stepTableView.delegate = self;
    self.stepTableView.dataSource = self;
    
    _datas = [[NSMutableArray alloc] initWithCapacity:1];
    _timeinterval = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
}

-(void)loadData:(NSInteger)type
{
    [self showLoadingView];
    
    NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID withDefault:FAILED_CODE];
    if (userId == FAILED_CODE)
    {
        [self instantiateStoryBoard:@"Login"];
    }
    NSDictionary *parameter;
    if (type == LoadData_Time)
    {
        parameter = @{pAPPCODE,
                      pGROUPCODE:@"A01_P7_G2",
                      pKEYVALUE:@"1",
                      pUSERID:[NSNumber numberWithInteger:userId]
                      };
    }
    else
    {
        parameter = @{pAPPCODE,
                      pGROUPCODE:@"A01_P7_G1",
                      pKEYVALUE:@"1",
                      pUSERID:[NSNumber numberWithInteger:userId]
                      };
    }
    
    [[APIClient sharedClient] requestPath:DATA_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        Response *response = [Response responseWithDict:JSON];
        [self hideLoadingView];
        if (response.code == FAILED_CODE)
        {
            if (type == LoadData_Data)
            {
                [self showToast:response.message];
                self.noDataView.hidden = NO;
                self.noDataLabel.text = response.message;
            }
        }
        else
        {
            NSArray *items = [JSON objectForKey:@"items"];
            if (type == LoadData_Data)
            {
                self.noDataView.hidden = YES;
                for (NSDictionary *item in items) {
                    BaseModel *model = [[BaseModel alloc] initWithDic:item];
                    if (model.keyvalue != NULL)
                    {
                        [_datas addObject:model];
                    }
                }
                [_stepTableView reloadData];
            }
            else
            {
                if (items.count > 0)
                {
                    NSDictionary *item = items[0];
                    BaseModel *model = [[BaseModel alloc] initWithDic:item];
                    _timeinterval  = [self timeFromNow:model.title2];
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingView];
    }];
}

#pragma mark 计时器
-(void)startTimer
{
    _timeinterval = _timeinterval + 1;
    NSInteger hour = 0;
    NSInteger min = 0;
    NSInteger second = 0;
    hour = _timeinterval/(60*60);
    min =  (_timeinterval - (hour * 60 * 60)) / (60);
    second = _timeinterval - hour * 60 * 60 - min * 60;
    _timeCountLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,second];
}

- (NSTimeInterval)timeFromNow:(NSString *)timeStr
{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *beginDate = [df dateFromString:timeStr];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval begin = [beginDate timeIntervalSince1970];
    NSTimeInterval end   = [nowDate timeIntervalSince1970];
    return end - begin;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    QRCodeViewController *qVC = (QRCodeViewController*)segue.destinationViewController;
    __weak TaskIngViewController *weakSelf = self;
    qVC.excutie = ^()
    {
        [weakSelf loadData:LoadData_Data];
    };
}


@end
