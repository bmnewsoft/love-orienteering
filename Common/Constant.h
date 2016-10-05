//
//  Constant.h
//  ADX
//
//  Created by MDJ on 2016/10/1.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#pragma mark url

//服务器地址
#ifdef DEBUG
#define SERVER_URL          @"http://wx.wispark.cn/QSServer/"
#else
#define SERVER_URL          @"http://123.57.190.60:8080/api/"
#endif

//登陆
#define LOGIN_URL           @"Login"

//发送验证码
#define SMS_URL             @"sms"

//注册
#define REGIST_URL          @"user"

//加密
#define DIGEST_URL          @"digest"

//获取数据
#define DATA_URL                @"DoData"



#endif /* Constant_h */
