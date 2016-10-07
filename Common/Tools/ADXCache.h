//
//  ADXCache.h
//  ADX
//
//  Created by MDJ on 2016/10/7.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADXCache : NSObject

+ (NSString*)documentDirectory;

//把数据写成文件缓存起来，根据文件后缀判断数据存储格式，支持.json和.plist
//支持的数据类型包含NSDictionary和NSArray，其中包含自定义对象的话，必须实现<NSCoding>协议，并且只支持plist格式
+ (BOOL)writeObject:(id)object toFile:(NSString*)fileName;

//返回NSDictionary和NSArray对象
+ (id)objectFromFile:(NSString*)fileName;

+ (void)removeObjectForName:(NSString*)aName;

@end
