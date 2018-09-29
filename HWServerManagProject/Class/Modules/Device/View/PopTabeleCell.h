//
//  PopTabeleCell.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/8.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidClearBlock)(NSInteger row);

@interface PopTabeleCell : UITableViewCell

@property (assign, nonatomic) NSInteger curRow;
@property (copy, nonatomic) DidClearBlock didClearBlock;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@end
