//
//  CardViewController.m
//  IceCoolApp
//
//  Created by ice.hu on 15/8/14.
//  Copyright (c) 2015年 medithink. All rights reserved.
//

#import "CardViewController.h"
#import "MenuCollectionViewCell.h"


@interface CardViewController ()<UICollectionViewDataSource,MenuCollectionViewCellDelegate>
{
    NSArray *datasourceArray;
    NSMutableArray *relationArray;
    
    NSTimer *testTimer;
}
@property (weak, nonatomic) IBOutlet UICollectionView *meunCollectionView;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ApplicationDelegate showLoadingHUD:@"加载中..." view:self.view];
    PFQuery *query = [PFQuery queryWithClassName:@"MenuData"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [[ApplicationDelegate HUD]dismiss];
        if (!error) {
            datasourceArray = [NSArray arrayWithArray:objects];
            
            PFQuery *query2 = [PFQuery queryWithClassName:@"MenuFav"];
            [query2 whereKey:@"UserId" equalTo:[PFUser currentUser].objectId];
            [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                relationArray = [[NSArray arrayWithArray:objects]mutableCopy];
                [PFObject pinAllInBackground:objects];
                [_meunCollectionView reloadData];
            }];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(void)viewDidAppear:(BOOL)animated
//{
//    testTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTips) userInfo:nil repeats:YES];
//}
//
//-(void)showTips
//{
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width-100, [[UIScreen mainScreen]bounds].size.height/2, 100, 30)];
//    label.text = @"弹幕测试...";
//    [self.view addSubview:label];
//    
//    [UIView animateWithDuration:1.5 animations:^{
//        CGRect rect = label.frame;
//        rect.origin.y = 0;
//        [label setFrame:rect];
//        label.alpha = 0;
//    } completion:^(BOOL finished) {
//        [label removeFromSuperview];
//    }];
//}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCollectionViewCell *cell = (MenuCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"menuCell" forIndexPath:indexPath];
    
    [self configureCell:cell withIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(MenuCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    cell.delegate = self;
    cell.viewContent.layer.cornerRadius = 10;
    cell.viewContent.layer.masksToBounds = YES;
    
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.layer.shadowRadius = 5;
    cell.layer.shadowOpacity = 0.5;
    
    switch (indexPath.section) {
        case 0:
            cell.imgPic.image =  [UIImage imageNamed:@"shop_dribbble"];
            cell.lbMenuName.text = @"电商App";
            cell.lbMenuDescription.text = @"";
            break;
        case 1:
            cell.imgPic.image =  [UIImage imageNamed:@"trip.jpg"];
            cell.lbMenuName.text = @"旅游App";
            cell.lbMenuDescription.text = @"";
            break;
        case 2:
            cell.imgPic.image =  [UIImage imageNamed:@"girl3.jpg"];
            cell.lbMenuName.text = @"图片App";
            cell.lbMenuDescription.text = @"美女图片瀑布流";
            break;
        case 3:
            cell.imgPic.image =  [UIImage imageNamed:@"flower.jpeg"];
            cell.lbMenuName.text = @"其他App";
            cell.lbMenuDescription.text = @"";
            break;
        default:
            break;
    }
    
    
    if (datasourceArray && [datasourceArray count]>0) {
        PFObject *obj = [datasourceArray objectAtIndex:indexPath.section];
        cell.lbCount1.text = [NSString stringWithFormat:@"%@",obj[@"fav"]];
        cell.lbCount2.text = [NSString stringWithFormat:@"%@",obj[@"view"]];
        cell.lbCount3.text = [NSString stringWithFormat:@"%@",obj[@"like"]];
        cell.currentObj = obj;
        
        cell.btIcon1.selected = NO;
        for (PFObject *rObj in relationArray) {
            if ([rObj[@"MenuId"] isEqualToString:obj.objectId]) {
                cell.btIcon1.selected = YES;
                cell.relationObj = rObj;
            }
        }
    }
    
}

#pragma mark - Cell Delegate

-(void)favButtonClicked:(int)selected obj:(PFObject *)obj{
    if (selected) {
        [relationArray removeObject:obj];
    }
    else{
        [relationArray addObject:obj];
        
        [self addFavAnimation];
    }
    
    [_meunCollectionView reloadData];
}

-(void)viewButtonClicked:(PFObject *)obj{
    switch ([obj[@"menuType"]integerValue]) {
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            [self performSegueWithIdentifier:@"segueToPic" sender:self];
            break;
        case 4:
            
            break;
        default:
            break;
    }
}


#pragma mark - Animation

-(void)addFavAnimation
{
    UIImage *heartImage = [UIImage imageNamed:@"list_icon_loved"];
    UIImageView *imgHeart = [[UIImageView alloc]initWithFrame:
                             CGRectMake(([[UIScreen mainScreen]bounds].size.width-heartImage.size.width)/2,
                                        ([[UIScreen mainScreen]bounds].size.height-heartImage.size.height)/2,
                                        heartImage.size.width,
                                        heartImage.size.height)];
    [imgHeart setImage:heartImage];
    [self.view addSubview:imgHeart];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    imgHeart.transform = transform;
    [UIView animateWithDuration:0.6 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(8.0f, 8.0f);
        imgHeart.transform = transform;
        imgHeart.alpha = 0;
    } completion:^(BOOL finished) {
        [imgHeart removeFromSuperview];
    }];

}

@end
