//
//  ADXMacro.h
//  ADX
//
//  Created by MDJ on 2016/10/1.
//  Copyright © 2016年 Bmnew. All rights reserved.
//

#ifndef ADXMacro_h
#define ADXMacro_h

#pragma mark AppDelegate

#define ShareAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])


#pragma mark Color



#define UIColorRGB(r, g, b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)/255.0]
#define UIColorHSL(h, s, l)     [UIColor colorWithHue:(h)/255.0f saturation:(s)/255.0f brightness:(l)/255.0f alpha:1.0f]
#define UIColorHSLA(h, s, l, a) [UIColor colorWithHue:(h)/255.0f saturation:(s)/255.0f brightness:(l)/255.0f alpha:(a)/255.0f]

#pragma mark size

#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ScreenHeigth [[UIScreen mainScreen] bounds].size.height






#pragma mark NSLog



#ifdef DEBUG
#define NSLog(format, ...) do {                                             \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)
#else
#define NSLog(format, ...)
#endif


#pragma mark 控制判断

#define $safe(obj)        ((NSNull *)(obj) == [NSNull null] ? nil : (obj))

#pragma mark Storyboard

#define STORYBOARDWITHNAME(nameStr) [UIStoryboard storyboardWithName:nameStr bundle:[NSBundle mainBundle]];

#define Lang(en,zh) [[NSLocale preferredLanguages][0] rangeOfString:@"zh"].location==0?zh:en


#endif /* ADXMacro_h */
