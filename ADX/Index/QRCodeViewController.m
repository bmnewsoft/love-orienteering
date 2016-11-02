//
//  QRCodeViewController.m
//  ADX
//
//  Created by MDJ on 2016/10/6.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *scanFrameImageView;
@property (weak, nonatomic) IBOutlet UIImageView *scanLineImageView;


@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoadingView];
    [self.bgImageView removeFromSuperview];
    upOrdown = NO;
    num =0;
    lineIV_Y = CGRectGetMinY(_scanLineImageView.frame);
    [self cameraAuthor];
//    self.view
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self isCamerAuthorized]) {
        if (_session && ![_session isRunning]) {
            [_session startRunning];
        }
//        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(scanAnimation) userInfo:nil repeats:YES];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];

}

-(void)startScan
{
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(scanAnimation) userInfo:nil repeats:YES];
}

#pragma mark 设置相机

- (void)setupCamera
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            // Preview
            _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            //    _preview.frame =CGRectMake(20,110,280,280);
            _preview.frame = self.view.bounds;
            [self.view.layer insertSublayer:self.preview atIndex:0];
            // Start
            [self.session startRunning];
            [self startScan];
            [self hideLoadingView];
        });
    });
}
#pragma mark 相机权限
- (BOOL)isCamerAuthorized
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        hasCameraRight = YES;
        return YES;
    }
    hasCameraRight = NO;
    return NO;
}

#pragma mark 相机授权
-(void)cameraAuthor
{
    if(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined:{
                // 许可对话没有出现，发起授权许可
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted)
                    {
                        //第一次用户接受
                        
                        [self setupCamera];
                    }else{
                        //用户拒绝
                        hasCameraRight = NO;
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized:{
                // 已经开启授权，可继续
                [self setupCamera];
                break;
            }
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                // 用户明确地拒绝授权，或者相机设备无法访问
                [self hideLoadingView];
                [self showToast:@"请到设置-隐私-相机中授权"];
                break;
            default:
                break;
        }
    }
}

#pragma mark 懒加载

-(AVCaptureMetadataOutput *)output
{
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    return _output;
}
-(AVCaptureSession *)session
{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:_output];
            
            NSArray *typeList = _output.availableMetadataObjectTypes;
            NSLog(@"availableMetadataObjectTypes : %@", typeList);
            if ([typeList containsObject:AVMetadataObjectTypeQRCode])
            {
                self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
            }
        }
    }
    return _session;
}

#pragma mark 扫描动画
-(void)scanAnimation
{
    if (upOrdown == NO) {
        num ++;
        _scanLineImageView.frame = CGRectMake(CGRectGetMinX(_scanLineImageView.frame), lineIV_Y + 2*num, CGRectGetWidth(_scanLineImageView.frame), CGRectGetHeight(_scanLineImageView.frame));
        if (2 * num >= CGRectGetHeight(_scanFrameImageView.frame) - 15) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _scanLineImageView.frame = CGRectMake(CGRectGetMinX(_scanLineImageView.frame), lineIV_Y + 2*num, CGRectGetWidth(_scanLineImageView.frame), CGRectGetHeight(_scanLineImageView.frame));
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    [self showLoadingView];
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        [_session stopRunning];
        [timer invalidate];
        
        
        NSInteger userId = [ADXUserDefault getIntWithKey:kUSERID withDefault:FAILED_CODE];
        if (userId == FAILED_CODE)
        {
            [self instantiateStoryBoard:@"Login"];
        }
        NSDictionary *parameter = @{@"jsons":[NSString stringWithFormat:@"{ \"appcode\":\"A01\",\"keyvalue\": \"%@\",\"userid\": \"%zi\",\"target\": \"2DOL\"}",stringValue,userId]};
        NSLog(@"%@",parameter);
        [[APIClient sharedClient] requestPath:QRUPLOAD_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSLog(@"%@",JSON);
            [self showToast:JSON[@"message"]];
            if (self.excutie)
            {
                self.excutie();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showToast:@"扫描失败"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }
    [self hideLoadingView];
    
}


@end
