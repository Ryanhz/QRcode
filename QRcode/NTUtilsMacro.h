//
//  NeituiUtilsMacro.h
//  neituiDemo
//
//  Created by hzf on 16/6/24.
//  Copyright © 2016年 neitui. All rights reserved.
//

#ifndef NTUtilsMacro_h
#define NTUtilsMacro_h


#define KMainScreen [UIScreen mainScreen]

#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_PLUS_STANDARD ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_PLUS_BIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

#define KSCREEN_WIDTH           [[UIScreen mainScreen] bounds].size.width
#define KSCREEN_HEIGHT           [[UIScreen mainScreen] bounds].size.height
#pragma mark--------------------
#pragma mark--------  水平 垂直 方向的比例
// 水平 垂直 方向的比例
#define k_h_Scale (KSCREEN_WIDTH / 320) // 水平
#define k_v_Scale (KSCREEN_HEIGHT / 568) // 垂直

#define kCVScreenSize                   ([[UIScreen mainScreen] applicationFrame].size)
#define kCVScreenWidth                  kCVScreenSize.width
#define kCVScreenHeight                 kCVScreenSize.height

#define IOS7_OR_LATER   ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)
#define IS_IOS8         ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)

#pragma mark ------------------
#pragma mark --------- color functions
// color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r) / 255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark ----------------
#pragma mark --log
//use dlog to print while in debug model
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// weakSelf
#define FEWeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;

#define userFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"user.date"]

#define defuserDefaults  [NSUserDefaults standardUserDefaults]

#define KNOTIFICATION_logout @"logout"

#define DefaultAvatar @"placeholderHead"
#define loginChangeDic(userType ,state) @{ @"userType" : @(userType), @"loginChange" : @(state)}

#define FENetHepler  [NTNetHelper shareNetHelper]

#endif /* NTUtilsMacro_h */
