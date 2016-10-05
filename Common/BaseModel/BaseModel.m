//
//  BaseModel.m
//  ADX
//
//  Created by MDJ on 2016/10/5.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

-(in) initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self && attributes)
    {
        self.evet       = $safe([attributes objectForKey:@"evet"]);
        self.target     = $safe([attributes objectForKey:@"target"]);
        self.refresh    = $safe([attributes objectForKey:@"refresh"]);
        self.layouttype = $safe([attributes objectForKey:@"layouttype"]);
        self.visible    = $safe([attributes objectForKey:@"visible"]);
        self.fkvalue    = $safe([attributes objectForKey:@"fkvalue"]);
        self.keyvalue   = $safe([attributes objectForKey:@"keyvalue"]);
        self.title1     = $safe([attributes objectForKey:@"title1"]);
        self.title2     = $safe([attributes objectForKey:@"title2"]);
        self.title3     = $safe([attributes objectForKey:@"title3"]);
        self.title4     = $safe([attributes objectForKey:@"title4"]);
        self.title5     = $safe([attributes objectForKey:@"title5"]);
        self.title6     = $safe([attributes objectForKey:@"title6"]);
        self.title7     = $safe([attributes objectForKey:@"title7"]);
        self.title8     = $safe([attributes objectForKey:@"title8"]);
        self.title9     = $safe([attributes objectForKey:@"title9"]);
        self.title10    = $safe([attributes objectForKey:@"title10"]);
        self.src1       = $safe([attributes objectForKey:@"src1"]);
        self.src2       = $safe([attributes objectForKey:@"src2"]);
        self.src3       = $safe([attributes objectForKey:@"src3"]);
        self.src4       = $safe([attributes objectForKey:@"src4"]);
        self.src5       = $safe([attributes objectForKey:@"src5"]);
        self.src6       = $safe([attributes objectForKey:@"src6"]);
        self.src7       = $safe([attributes objectForKey:@"src7"]);
        self.src8       = $safe([attributes objectForKey:@"src8"]);
        self.src9       = $safe([attributes objectForKey:@"src9"]);
        self.src10      = $safe([attributes objectForKey:@"src10"]);
        self.doviewname = $safe([attributes objectForKey:@"doviewname"]);
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
    NSString *className = NSStringFromClass([self class]);
    NSDictionary *dic = [self mapPropertiesToDictionary];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"%@ = %@\n", key, obj];
    }];
    return str;
}

@end
