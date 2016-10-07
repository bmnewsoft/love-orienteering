//
//  ADXUserDefault.h
//  ADX
//
//  Created by MDJ on 2016/10/7.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADXUserDefault : NSObject

//NSString
+(void)setString:(NSString*)v withKey:(NSString*)key;
+(NSString*)getStringWithKey:(NSString*)key ;
+(NSString*)getStringWithKey:(NSString*)key withDefault:(NSString*)d;

//BOOL
+(void)setBool:(BOOL)v withKey:(NSString*)key;
+(BOOL)getBoolWithKey:(NSString*)key;
+(BOOL)getBoolWithKey:(NSString*)key withDefault:(BOOL)d;

//Integer
+(void)setInt:(NSInteger)v withKey:(NSString*)key;
+(NSInteger)getIntWithKey:(NSString*)key;
+(NSInteger)getIntWithKey:(NSString*)key withDefault:(NSInteger)d;



//KEY EXIST
+(BOOL)keyExists:(NSString*)key;
+(BOOL)keyUndefined:(NSString*)key;
+(BOOL)isKeyUndefinedThenDefine:(NSString*)what;
@end
