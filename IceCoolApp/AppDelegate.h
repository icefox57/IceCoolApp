//
//  AppDelegate.h
//  IceCoolApp
//
//  Created by ice.hu on 15/8/13.
//  Copyright (c) 2015年 medithink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FeSpinnerTenDot.h"
#import "UIColor+flat.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,FeSpinnerTenDotDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FeSpinnerTenDot *HUD;


-(void)showLoadingHUD:(NSString *)text view:(UIView *)view;
@end

