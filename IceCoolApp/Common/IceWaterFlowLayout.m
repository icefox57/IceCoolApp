//
//  IceWaterFlowLayout.m
//  IceCoolApp
//
//  Created by ice.hu on 15/9/10.
//  Copyright (c) 2015年 medithink. All rights reserved.
//

#import "IceWaterFlowLayout.h"

#define column 2
#define xoffset 10
#define yoffset 10

@implementation IceWaterFlowLayout

-(void)prepareLayout
{
    [super prepareLayout];
    
    self.itemWidth = ([[UIScreen mainScreen]bounds].size.width-(column+1)*xoffset)/column;
    
    self.sectionInset= UIEdgeInsetsMake(10,10,10,10);
    
    self.delegate = (id <WaterFLayoutDelegate> )self.collectionView.delegate;
    
    CGSize size = self.collectionView.frame.size;
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    _center = CGPointMake(size.width /2.0, size.height / 2.0);
    _radius = MIN(size.width, size.height) /2.5;
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake([[UIScreen mainScreen]bounds].size.width, (leftY>rightY?leftY:rightY));
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath  withIndex:(NSInteger)index
{
    CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    
//    NSLog(@"%@",NSStringFromCGSize(itemSize));
    
    
    CGFloat itemHeight = floorf(itemSize.height *self.itemWidth / itemSize.width);
    
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    index+=1;
    
    if (index%2==0)
    {
        x+=(self.itemWidth+self.sectionInset.left);
        rightY+=self.sectionInset.top;
        attributes.frame = CGRectMake(x, rightY, self.itemWidth, itemHeight);
        rightY+=itemHeight;
        
    }else
    {
        x=self.sectionInset.left;
        leftY+=self.sectionInset.top;
        attributes.frame = CGRectMake(x, leftY, self.itemWidth, itemHeight);
        leftY+=itemHeight;
    }
    
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    x=0;
    leftY=0;
    rightY=0;
    
    NSMutableArray* attributes = [NSMutableArray array];
    
    for (NSInteger i=0 ; i <self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath withIndex:i]];
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = CGPointMake(_center.x,_center.y);
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = CGPointMake(_center.x,_center.y);
    attributes.transform3D = CATransform3DMakeScale(0.1, 0.1,1.0);
    return attributes;
}

@end
