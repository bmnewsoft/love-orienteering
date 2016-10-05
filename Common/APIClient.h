//
//  APIClient.h
//  ADX
//
//  Created by MDJ on 2016/10/2.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface APIClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

- (AFHTTPRequestOperation *)requestPath:(NSString *)path
                             parameters:(NSDictionary *)params
                                success:(void (^)(AFHTTPRequestOperation *operation, id JSON))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)requestPath:(NSString *)path
                             parameters:(NSDictionary *)params
              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (NSString *) digestPassword:(NSString *)origin;

@end
