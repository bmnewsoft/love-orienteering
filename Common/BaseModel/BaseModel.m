//
//  BaseModel.m
//  ADX
//
//  Created by MDJ on 2016/10/5.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation NSDictionary (NullReplace)

- (id)objectForKeyNotNull:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNumber class]] ||
        [object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSArray class]] ||
        [object isKindOfClass:[NSDictionary class]])
    {
        return object;
    }
    return nil;
}

@end


@implementation BaseModel

-(id) initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self && dic)
    {
        self.evet       = $safe([dic objectForKey:@"evet"]);
        self.target     = $safe([dic objectForKey:@"target"]);
        self.refresh    = $safe([dic objectForKey:@"refresh"]);
        self.layouttype = $safe([dic objectForKey:@"layouttype"]);
        self.visible    = $safe([dic objectForKey:@"visible"]);
        self.fkvalue    = $safe([dic objectForKey:@"fkvalue"]);
        self.keyvalue   = $safe([dic objectForKey:@"keyvalue"]);
        self.title1     = $safe([dic objectForKey:@"title1"]);
        self.title2     = $safe([dic objectForKey:@"title2"]);
        self.title3     = $safe([dic objectForKey:@"title3"]);
        self.title4     = $safe([dic objectForKey:@"title4"]);
        self.title5     = $safe([dic objectForKey:@"title5"]);
        self.title6     = $safe([dic objectForKey:@"title6"]);
        self.title7     = $safe([dic objectForKey:@"title7"]);
        self.title8     = $safe([dic objectForKey:@"title8"]);
        self.title9     = $safe([dic objectForKey:@"title9"]);
        self.title10    = $safe([dic objectForKey:@"title10"]);
        self.src1       = $safe([dic objectForKey:@"src1"]);
        self.src2       = $safe([dic objectForKey:@"src2"]);
        self.src3       = $safe([dic objectForKey:@"src3"]);
        self.src4       = $safe([dic objectForKey:@"src4"]);
        self.src5       = $safe([dic objectForKey:@"src5"]);
        self.src6       = $safe([dic objectForKey:@"src6"]);
        self.src7       = $safe([dic objectForKey:@"src7"]);
        self.src8       = $safe([dic objectForKey:@"src8"]);
        self.src9       = $safe([dic objectForKey:@"src9"]);
        self.src10      = $safe([dic objectForKey:@"src10"]);
        self.doviewname = $safe([dic objectForKey:@"doviewname"]);
    }
    return  self;
}

- (NSDictionary *)mapPropertiesToDictionary {
    // 用以存储属性（key）及其值（value）
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    // 获取当前类对象类型
    Class cls = [self class];
    // 获取类对象的成员变量列表，ivarsCount为成员个数
    uint ivarsCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarsCount);
    // 遍历成员变量列表，其中每个变量为Ivar类型的结构体
    const Ivar *ivarsEnd = ivars + ivarsCount;
    for (const Ivar *ivarsBegin = ivars; ivarsBegin < ivarsEnd; ivarsBegin++) {
        Ivar const ivar = *ivarsBegin;
        //　获取变量名
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        /*
         若此变量声明为属性，则变量名带下划线前缀'_'
         比如 @property (nonatomic, copy) NSString *name;则 key = _name;
         为方便查看属性变量，在此特殊处理掉下划线前缀
         */
        if ([key hasPrefix:@"_"]) key = [key substringFromIndex:1];
        //　获取变量值
        id value = [self valueForKey:key];
        // 处理属性未赋值属性，将其转换为null，若为nil，插入将导致程序异常
        [dictionary setObject:value ? value : [NSNull null]
                       forKey:key];
    }
    if (ivars) {
        free(ivars);
    }
    return dictionary;
}
-(NSString *)description
{
    NSMutableString *str = [NSMutableString string];
    NSDictionary *dic = [self mapPropertiesToDictionary];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"%@ = %@\n", key, obj];
    }];
    return str;
}

@end

@implementation MUser

-(instancetype) initWithDic:(NSDictionary *)dic
{
    self = [super  init];
    if(self && [dic isKindOfClass:[NSDictionary class]])
    {
        self.password       = $safe([dic objectForKey:@"password"]);
        self.phoneNum     = $safe([dic objectForKey:@"phoneNum"]);
        self.userID    = [$safe([dic objectForKey:@"userID"]) integerValue];
        self.userName = $safe([dic objectForKey:@"userName"]);
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.phoneNum = [aDecoder decodeObjectForKey:@"phoneNum"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.userID = [aDecoder decodeIntegerForKey:@"userID"];
    }
    return self;
}
-(void )encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.phoneNum forKey:@"phoneNum"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
}

+(MUser *)UserWithDic:(NSDictionary *)dic
{
    return [[MUser alloc] initWithDic:dic];
}

@end

@implementation Response

+ (Response*)responseWithDict:(NSDictionary*)dict
{
    Response* response = [[Response alloc] init];
    response.code = [[dict objectForKeyNotNull:@"success"] integerValue];
    response.message = [dict objectForKeyNotNull:@"message"];
    response.hasMore = [[dict objectForKeyNotNull:@"has_more"] boolValue];
    return response;
}

@end

