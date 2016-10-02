//
//  APIClient.m
//  ADX
//
//  Created by MDJ on 2016/10/2.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

//- (NSDictionary *)constructParameters:(NSDictionary *)params
//{
//    NSMutableDictionary* newParams = [NSMutableDictionary dictionaryWithDictionary:params];
//    
//    if (ShareAppDelegate.user.userId.length > 0)
//    {
//        [newParams setObject:ShareAppDelegate.user.userId forKey:@"user_id"];
//    }
//    if (ShareAppDelegate.user.accessToken.length > 0)
//    {
//        [newParams setObject:SharedAppDelegate.user.accessToken forKey:@"access_token"];
//    }
//    return newParams;
//}

- (AFHTTPRequestOperation *)requestPath:(NSString *)path
                             parameters:(NSDictionary *)params
                                success:(void (^)(AFHTTPRequestOperation *operation, id JSON))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
//    NSDictionary *newParams = [self constructParameters:params];
    
    return [super POST:path parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)requestPath:(NSString *)path
                             parameters:(NSDictionary *)params
              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
//    NSDictionary *newParams = [self constructParameters:params];
    return [super POST:path parameters:params constructingBodyWithBlock:block success:success failure:failure];
}

static NSString * const APIBaseURLString = SERVER_URL;

+ (instancetype)sharedClient
{
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURLString]];
                      [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
                  });
    
    return _sharedClient;
}


@end
