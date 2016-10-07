//
//  ADXUserDefault.m
//  ADX
//
//  Created by MDJ on 2016/10/7.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "ADXUserDefault.h"

@implementation ADXUserDefault

+(NSString*)getStringWithKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(NSString*)getStringWithKey:(NSString*)key withDefault:(NSString*)d {
    if([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
        return d;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void)setString:(NSString*)v withKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:v forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getBoolWithKey:(NSString*)key {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
}

+(BOOL)getBoolWithKey:(NSString*)key withDefault:(BOOL)d {
    if([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
        return d;
    }
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
}

+(void)setBool:(BOOL)v withKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:v ? @"1" : @"0" forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSInteger)getIntWithKey:(NSString*)key {
    return (NSInteger)[[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+(NSInteger)getIntWithKey:(NSString*)key withDefault:(NSInteger)d {
    if([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
        return d;
    }
    return (NSInteger)[[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+(void)setInt:(NSInteger)v withKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setInteger:v forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)keyExists:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] != nil;
}

+(BOOL)keyUndefined:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] == nil;
}

+(BOOL)isKeyUndefinedThenDefine:(NSString*)key {
    BOOL isKeyUndefined = [ADXUserDefault keyUndefined:key];
    if(isKeyUndefined) {
        [ADXUserDefault setString:key withKey:key];
    }
    return isKeyUndefined;
}

@end
