//
//  MenuCollectionViewCell.h
//  IceCoolApp
//
//  Created by ice.hu on 15/8/14.
//  Copyright (c) 2015年 medithink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"

@protocol MenuCollectionViewCellDelegate;

@interface MenuCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *lbMenuName;
@property (weak, nonatomic) IBOutlet UILabel *lbMenuDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UIButton *btIcon1;
@property (weak, nonatomic) IBOutlet UIButton *btIcon2;
@property (weak, nonatomic) IBOutlet UIButton *btIcon3;

@property (weak, nonatomic) IBOutlet UILabel *lbCount1;
@property (weak, nonatomic) IBOutlet UILabel *lbCount2;
@property (weak, nonatomic) IBOutlet UILabel *lbCount3;

@property (weak,nonatomic) PFObject *currentObj;
@property (weak,nonatomic) PFObject *relationObj;

@property (nonatomic, assign) id<MenuCollectionViewCellDelegate> delegate;

- (IBAction)addCount:(id)sender;

@end

@protocol MenuCollectionViewCellDelegate
- (void)favButtonClicked:(int)selected obj:(PFObject *)obj;
- (void)viewButtonClicked:(PFObject *)obj;
@end