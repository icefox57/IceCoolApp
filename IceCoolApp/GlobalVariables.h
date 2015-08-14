//
//  GlobalVariables.h
//  Youyue
//
//  Created by XiaoJun Hu on 11-9-8.
//  Copyright 2011年 apple energy . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "Foundation.h"
#import <Parse/Parse.h>

@interface GlobalVariables : NSObject
@property (nonatomic,assign) CaseTypes caseType;
@property (nonatomic,assign) BOOL isHomeClicked;

+ (GlobalVariables *)shareGlobalVariables;

//返回UDID
+ (NSString*) stringWithUUID;
//Log字体名字
+(void)getFontNameByFile:(NSString *)fileName;

//异常处理
+(void)handleErrorByError:(NSError *)error;
+(void)handleErrorByString:(NSString *)errorString;

//返回2个日期时间间隔
+(NSTimeInterval)secDifferenceFrom:(NSDate*)date1 date2:(NSDate*)date2;
//判断2个日期
+(BOOL)isSameHour:(NSDate*)date1 date2:(NSDate*)date2;
+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;
+(BOOL)isSameWeek:(NSDate*)date1 date2:(NSDate*)date2;
//返回日期格式
+ (NSDateFormatter*)responseDateFormatter;
+ (NSDateFormatter*)requestDateFormatter;

//返回1/4原图
+ (UIImage*)imageWithImageSimple:(UIImage*)image;
//返回圆形带框图片
+ (UIImage *)circleImage:(UIImage*) oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


//从左至右 渐现动画
+(void)addGradientAnimation:(UIView *)view;
+(void)startGradinentAnimation:(UIView *)view duration:(NSTimeInterval)duration;
//动画震动
+(void)shakeView:(UIView*)viewToShake;
@end
