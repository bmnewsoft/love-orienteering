//
//  BaseModel.h
//  ADX
//
//  Created by MDJ on 2016/10/5.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property(nonatomic,strong) NSString *evet;
@property(nonatomic,strong) NSString *target;
@property(nonatomic,strong) NSString *refresh;
@property(nonatomic,strong) NSString *layouttype;
@property(nonatomic,strong) NSString *visible;
@property(nonatomic,strong) NSString *fkvalue;
@property(nonatomic,strong) NSString *keyvalue;
@property(nonatomic,strong) NSString *title1;
@property(nonatomic,strong) NSString *title2;
@property(nonatomic,strong) NSString *title3;
@property(nonatomic,strong) NSString *title4;
@property(nonatomic,strong) NSString *title5;
@property(nonatomic,strong) NSString *title6;
@property(nonatomic,strong) NSString *title7;
@property(nonatomic,strong) NSString *title8;
@property(nonatomic,strong) NSString *title9;
@property(nonatomic,strong) NSString *title10;
@property(nonatomic,strong) NSString *src1;
@property(nonatomic,strong) NSString *src2;
@property(nonatomic,strong) NSString *src3;
@property(nonatomic,strong) NSString *src4;
@property(nonatomic,strong) NSString *src5;
@property(nonatomic,strong) NSString *src6;
@property(nonatomic,strong) NSString *src7;
@property(nonatomic,strong) NSString *src8;
@property(nonatomic,strong) NSString *src9;
@property(nonatomic,strong) NSString *src10;
@property(nonatomic,strong) NSString *doviewname;

-(in) initWithDic:(NSDictionary *)dic;

@end

@interface MUser : NSObject<NSCoding>
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *phoneNum;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,assign) NSInteger userID;
+(MUser *)UserWithDic:(NSDictionary *)dic;
@end

@interface Response : NSObject

@property (nonatomic) NSInteger code;
@property (nonatomic, strong) NSString* message;
@property (nonatomic) BOOL hasMore;

+ (Response*)responseWithDict:(NSDictionary*)dict;


@end

