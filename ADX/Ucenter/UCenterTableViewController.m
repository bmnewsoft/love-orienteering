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


@interface UCenterTableViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *uHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *nikenameLabel;

@property (nonatomic,strong)NSString *headerUrl;
@property (nonatomic,strong)NSString *nicknameStr;
@property (nonatomic,strong)UIImage *headImage;

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
    self.tableView.backgroundView = nil;
    _datas = [NSMutableArray arrayWithCapacity:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:nRELOADUSERCENTER object:nil];
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
    [_uHeaderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URL,model.src1]] placeholderImage:_headImage == nil ?[UIImage imageNamed:@"headImage"]:_headImage];
    _nikenameLabel.text = [NSString stringWithFormat:@"昵称：%@",model.title1];
    _nicknameStr = model.title1;
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

#pragma mark button action

//点击头像
- (IBAction)headImageAction:(UIButton *)sender
{
    /**
     *  弹出提示框
     */
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//点击昵称
- (IBAction)nicknameAction:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alert) weakAlert = alert;
    UIAlertAction *destructive = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"destructive");
        NSArray *textArray = [weakAlert textFields];
        UITextField *nameText = textArray[0];
        [self editNickname:nameText.text];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
        //        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [alert addAction:destructive];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.font = [UIFont systemFontOfSize:15];
        textField.text = _nicknameStr;
        textField.textColor = UIColorRGB(80, 92, 112);
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

//选择头像回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _uHeaderImage.image = newPhoto;
    [picker dismissViewControllerAnimated:YES completion:^{}];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self uploadHeadImage:newPhoto];
}


//修改头像
- (BOOL) uploadHeadImage:(UIImage *)headImage
{
    NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID withDefault:FAILED_CODE];
    NSDictionary *parameter = @{@"type":@"headimg",
                                @"userid":[NSNumber numberWithInteger:userId],
                                @"nickname":@"",
                                @"headimg":@""
                                };
    
    [[APIClient sharedClient] requestPath:UPLOAD_URL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImagePNGRepresentation(headImage);
        [formData appendPartWithFileData:imageData name:@"gravatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self showToast:@"修改成功"];
        _headImage = headImage;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-----");
        _uHeaderImage.image = _headImage;
    }];
    return NO;
}

//修改昵称
- (void) editNickname:(NSString *)nickname
{
    if ([nickname isEqualToString:_nicknameStr])
    {
        return ;
    }
    NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID withDefault:FAILED_CODE];
    NSDictionary *parameter = @{@"type":@"update",
                                @"userid":[NSNumber numberWithInteger:userId],
                                @"nickname":nickname
                                };
    [[APIClient sharedClient] requestPath:UPLOAD_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
        _nikenameLabel.text = [NSString stringWithFormat:@"昵称：%@" ,nickname];
        _nicknameStr = nickname;
        [self showToast:@"修改成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showToast:@"修改失败"];
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
