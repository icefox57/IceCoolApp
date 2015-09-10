//
//  WaterFlowViewController.h
//  IceCoolApp
//
//  Created by ice.hu on 15/8/19.
//  Copyright (c) 2015年 medithink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"
#import "PSCollectionView.h"
#import "PullPsCollectionView.h"

@interface WaterFlowViewController : UIViewController<PSCollectionViewDelegate,PSCollectionViewDataSource,UIScrollViewDelegate,PullPsCollectionViewDelegate>
@property(nonatomic,retain) PullPsCollectionView *collectionView;
@property(nonatomic,retain)NSMutableArray *items;
-(void)loadDataSource;

@end
