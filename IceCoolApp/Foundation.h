//
//  Foundation.h
//  Youyue
//
//  Created by XiaoJun Hu on 11-9-8.
//  Copyright 2011年 apple energy . All rights reserved.
//

//-----------------------  数据库类型  -------------------------------

//数据库字段
#define Column_objectid         @"objectId"
#define Column_createdAt        @"createdAt"
#define Column_updatedAt        @"updatedAt"


typedef enum
{
    PlaneTypeDefault = 1,
    PlaneType25,
    PlaneType50
} PlaneTypes;

typedef enum
{
    CaseType1 = 1,
    CaseType2,
    CaseType3,
    CaseType4
} CaseTypes;

typedef enum
{
	DietTypeInvail = 0,
	DietTypeLow,
	DietTypeMiddel,
    DietTypeHigh
} DietTypes;//模块类型

//-----------------------  系统关键字  -------------------------------
#define kUserInfo                               @"kUserInfo"

//-----------------------  系统函数  -------------------------------

#define UTColor(r,g,b,a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]
#define UTLocalizeString(s) NSLocalizedString(s,nil)

#define RANDOM_SEED() srandom(time(NULL)) 
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + arc4random() % ((__MAX__+1) - (__MIN__)))

#define DEGREES_TO_RADIANS(degrees) (degrees/180.0*M_PI)
#define RADIANS_TO_DEGREES(angle) (angle*180.0/M_PI)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
//-----------------------  系统基本变量 -----------------------------

#define ApplicationDelegate (AppDelegate *)[UIApplication sharedApplication].delegate

//-----------------------  系统颜色值 ------------------------------

#define ColorRed            UTColor(230,0,72,1)

//-----------------------  系统字符串 ------------------------------



//-----------------Server Info------------
#define HuceoDBHost @"http://api.huceo.com/"
#define BaiduDBHost @"http://apis.baidu.com/txapi/mvtp/"
#define HuceoAppKey @"925de129881df83de903972443b635ed"
#define BaiduAppKey @"a3b62beaf144fca03b63b3855fa61418"


