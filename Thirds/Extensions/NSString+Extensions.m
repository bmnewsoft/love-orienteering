//
//  NSString+Extensions.m
//  Extentions
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import "NSString+Extensions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(Extensions)

- (NSString *) MD5String
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
    
    
}

//16位MD5加密方式
- (NSString *)MD5String_16{
    //提取32位MD5散列的中间16位
    NSString *md5_32Bit_String=[self MD5String];
    NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    
    return result;
}

- (NSString *) Base64Encode
{
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
}

- (BOOL)isMobileNumber
{
    NSString *pattern = @"^(13[0-9]|14[5,7]|15[0-3,5-9]|17[0,6,7,8]|18[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    if (([regextestmobile evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
