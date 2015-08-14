//
//  HomeViewController.m
//  IceCoolApp
//
//  Created by ice.hu on 15/8/13.
//  Copyright (c) 2015年 medithink. All rights reserved.
//

#import "HomeViewController.h"
#import "YLImageView.h"
#import "YLGIFImage.h"

@interface HomeViewController ()
{
    BOOL isAdCached;
}
@property (weak, nonatomic) IBOutlet YLImageView *imgBg;
@property (weak, nonatomic) IBOutlet UIButton *btGo;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imgBg.image = [YLGIFImage imageNamed:@"lg.gif"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //添加广告视图
    isAdCached = NO;
    [self addAdViewBy:@"launchImage"];
}

-(void)viewDidAppear:(BOOL)animated
{
    isAdCached = YES;
}

- (IBAction)goClicked:(id)sender
{
    CGRect rect = _btGo.frame;
    rect.origin.x += [[UIScreen mainScreen]bounds].size.width/1.5;
    [UIView animateWithDuration:1 animations:^{
        [_btGo setFrame:rect];
        _btGo.alpha = 0;
    } completion:^(BOOL finished) {
        [self performSegueWithIdentifier:@"segueToMain" sender:self];
    }];
}




-(void)addAdViewBy:(NSString *)paramName
{
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:@"ad.png"];

    
    PFFile *adImageFile = [PFConfig currentConfig][paramName];
    
    [adImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error && imageData && imageData.length>0) {
            [imageData writeToFile:savedImagePath atomically:YES];
        }
    }];
    
    
    NSData *imageData = [NSData dataWithContentsOfFile:savedImagePath];
    if(imageData && imageData.length>0){
        UIImage *adImage = [UIImage imageWithData:imageData];
        UIImageView *adView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        adView.tag = 999;
        [adView setImage:adImage];
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(closeAdView) userInfo:nil repeats:NO];
        
        [self.view addSubview:adView];
    }
}

-(void)closeAdView
{
    [UIView animateWithDuration:.5 animations:^{
        [self.view viewWithTag:999].alpha = 0;
    } completion:^(BOOL finished) {
        [[self.view viewWithTag:999] removeFromSuperview];
    }];
}

@end
