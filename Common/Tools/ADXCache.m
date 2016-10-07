//
//  ADXCache.m
//  ADX
//
//  Created by MDJ on 2016/10/7.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#import "ADXCache.h"

@implementation ADXCache
+ (NSString*)documentDirectory
{
    //for test
#ifdef DEBUG
    static NSString *documentPath = @"/Users/yuanqiuyan/Desktop/爱定向/cache";
#else
    static NSString *documentPath = nil;
#endif
    
    if (documentPath == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,   NSUserDomainMask, YES);
        documentPath = [paths objectAtIndex:0];
    }
    
    return documentPath;
}

+ (BOOL)writeObject:(id)object toFile:(NSString*)fileName;
{
    NSString *filePath = [[ADXCache documentDirectory] stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    NSData *data = nil;
    if ([fileName hasSuffix:@".json"])
    {
        NSError *error;
        data = [NSJSONSerialization dataWithJSONObject:object options:kNilOptions error:&error];
        if (error)
        {
            NSLog(@"write cache json error: %@", error.localizedDescription);
        }
    }
    else if([fileName hasSuffix:@".plist"])
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:object];
    }
    BOOL success = [data writeToFile:filePath atomically:YES];
    return success;
}


+ (id)objectFromFile:(NSString *)fileName
{
    NSString *filePath = [[ADXCache documentDirectory] stringByAppendingPathComponent:fileName];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data == nil)
    {
        return nil;
    }
    
    id object = nil;
    
    if ([fileName hasSuffix:@".json"])
    {
        NSError *error;
        object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error)
        {
            NSLog(@"read cache json error: %@", error.localizedDescription);
        }
    }
    else if([fileName hasSuffix:@".plist"])
    {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return object;
}


+ (void)removeObjectForName:(NSString*)aName
{
    NSString *filePath = [[ADXCache documentDirectory] stringByAppendingPathComponent:aName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}
@end
