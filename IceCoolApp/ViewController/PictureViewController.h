//
//  PictureViewController.h
//  IceCoolApp
//
//  Created by ice.hu on 15/9/10.
//  Copyright (c) 2015年 medithink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"

@interface PictureViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *picCollectionView;

- (IBAction)goBack:(id)sender;

@end
