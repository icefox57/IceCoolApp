//
//  GlobalVariables.m
//  Youyue
//
//  Created by XiaoJun Hu on 11-9-8.
//  Copyright 2011年 apple energy . All rights reserved.
//

#import "Foundation.h"
#import "GlobalVariables.h"
#import "AppDelegate.h"

@implementation GlobalVariables

static GlobalVariables *_instance = nil;

+ (GlobalVariables *)shareGlobalVariables 
{
	if (_instance == nil) 
    {
		_instance = [[GlobalVariables alloc] init];
	}
    
	return _instance;
}

#pragma mark - Error handle

+(void)handleErrorByError:(NSError *)error
{
    NSString *errorString = [NSString stringWithFormat:@"系统错误:请尝试重启App. 错误信息:%@",[[error userInfo] objectForKey:@"error"]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorString message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

+(void)handleErrorByString:(NSString *)errorString
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorString message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

//+(void)handleErrorBySound:(NSString *)filePath
//{
//    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
//    AVAudioPlayer *effectSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
//    [effectSoundPlayer prepareToPlay];
//    [effectSoundPlayer play];
//}

#pragma mark - date handle

+ (NSTimeInterval)secDifferenceFrom:(NSDate*)date1 date2:(NSDate*)date2
{
    return  [date1 timeIntervalSince1970] - [date2 timeIntervalSince1970];
}

+ (BOOL)isSameHour:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = kCFCalendarUnitYear | kCFCalendarUnitMonth |  kCFCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 hour]   == [comp2 hour] &&
    [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = kCFCalendarUnitYear | kCFCalendarUnitMonth |  kCFCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+ (BOOL)isSameWeek:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = kCFCalendarUnitYear | kCFCalendarUnitMonth |  kCFCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 weekOfYear]   == [comp2 weekOfYear] &&
    [comp1 year]  == [comp2 year];
}

+ (NSDateFormatter*)responseDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return dateFormatter;
}

+ (NSDateFormatter*)requestDateFormatter
{
    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [threadDict objectForKey:@"RequestDateFormatter"];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss z"];
        [threadDict setObject:dateFormatter forKey:@"ASIS3RequestHeaderDateFormatter"];
    }
    return dateFormatter;
}


#pragma mark - image handle

+ (UIImage*)imageWithImageSimple:(UIImage*)image
{
    CGSize newSize = CGSizeMake(image.size.width/4, image.size.height/4);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)circleImage:(UIImage*) oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    //    UIImage *oldImage = [UIImage imageNamed:name];
    
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - animation handle

+(void)addGradientAnimation:(UIView *)view{
    CAGradientLayer *mask = [CAGradientLayer layer];
    mask.frame = view.bounds;
    mask.colors = [NSArray arrayWithObjects:
                   (__bridge id)[UIColor whiteColor].CGColor,
                   (__bridge id)[UIColor clearColor].CGColor,
                   nil];
    mask.startPoint = CGPointMake(0, .5); // middel left
    mask.endPoint = CGPointMake(1, .5); // middel right
    view.layer.mask = mask;
    ((CAGradientLayer *)view.layer.mask).locations = @[@0,@0];
}

+(void)startGradinentAnimation:(UIView *)view duration:(NSTimeInterval)duration{
    view.alpha = 1;

    [UIView animateWithDuration:duration animations:^{
        [CATransaction begin];
        [CATransaction setAnimationDuration:duration];
        
        ((CAGradientLayer *)view.layer.mask).locations = @[@1,@1];
        
        [CATransaction commit];
    } completion:^(BOOL finished) {
    }];
}

+(void)shakeView:(UIView*)viewToShake
{
    CGFloat t =2.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}



#pragma mark - others handle

+ (NSString*) stringWithUUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

+(void)getFontNameByFile:(NSString *)fileName;
{
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"otf"];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
    CGFontRef font_ref =CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(font_ref));
    NSString *fullName = CFBridgingRelease(CGFontCopyFullName(font_ref));
    NSLog(@"fontName:%@  -  %@",fullName,fontName);
}



@end
