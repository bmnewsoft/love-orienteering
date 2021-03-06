//
//  QRCodeViewController.h
//  ADX
//
//  Created by MDJ on 2016/10/6.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "ADXBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^Excutie)();

@interface QRCodeViewController : ADXBaseViewController <AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CGFloat lineIV_Y;
    BOOL hasCameraRight;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;

@property (nonatomic,assign) Excutie excutie;

@end
