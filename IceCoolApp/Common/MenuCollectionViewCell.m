//
//  MenuCollectionViewCell.m
//  IceCoolApp
//
//  Created by ice.hu on 15/8/14.
//  Copyright (c) 2015年 medithink. All rights reserved.
//

#import "MenuCollectionViewCell.h"

@implementation MenuCollectionViewCell

- (IBAction)addCount:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    int count;
    switch (button.tag) {
        case 1:{
            if (button.selected) {
                [_relationObj deleteEventually];
                
                [_currentObj incrementKey:@"fav" byAmount:@-1];
                int count = [_lbCount1.text intValue];
                _lbCount1.text = [NSString stringWithFormat:@"%d",count-1];
                
                [_delegate favButtonClicked:button.selected obj:_relationObj];
            }
            else{
                PFObject *obj = [PFObject objectWithClassName:@"MenuFav"];
                obj[@"UserId"] = [PFUser currentUser].objectId;
                obj[@"MenuId"] = _currentObj.objectId;
                [obj saveEventually];
                
                [_currentObj incrementKey:@"fav"];
                int count = [_lbCount1.text intValue];
                _lbCount1.text = [NSString stringWithFormat:@"%d",count+1];
                
                [_delegate favButtonClicked:button.selected obj:obj];
            }
            button.selected = !button.selected;
            
            
        }
            break;
        case 2:
            [_currentObj incrementKey:@"view"];
            count = [_lbCount2.text intValue];
            _lbCount2.text = [NSString stringWithFormat:@"%d",count+1];
            
            [_delegate viewButtonClicked:_currentObj];
            break;
        case 3:
            [_currentObj incrementKey:@"like"];
            count = [_lbCount3.text intValue];
            _lbCount3.text = [NSString stringWithFormat:@"%d",count+1];
            break;
        default:
            break;
    }
    [_currentObj saveEventually];
    
}

@end
