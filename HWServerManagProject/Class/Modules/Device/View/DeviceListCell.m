//
//  DeviceListCell.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/4.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "DeviceListCell.h"

@implementation DeviceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.countLabel.layer.cornerRadius = 10;
    self.countLabel.layer.masksToBounds = YES;
    
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //遍历子视图，找出左滑按钮
    
    for (UIView *subView in self.subviews)
        
    {
        
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
            
        {
            
            for (UIButton *btn in subView.subviews) {
                
                if ([btn isKindOfClass:[UIButton class]]) {
                    
                    //更改左滑标签按钮样式
                    
                    if ([btn.titleLabel.text isEqualToString:@"编辑"]) {
                        
                        [btn setTitle:@"" forState:UIControlStateNormal];
                        
                        [btn setImage:[UIImage imageNamed:@"one_cellediticon"] forState:UIControlStateNormal];
                        
                        
                    }else if([btn.titleLabel.text isEqualToString:@"删除"]){
                        
                        //更改左滑详情按钮样式
                        [btn setTitle:@"" forState:UIControlStateNormal];
                        
                        [btn setImage:[UIImage imageNamed:@"one_celldeleteicon"] forState:UIControlStateNormal];
                        
                        
                    }
                }
            }
        }
    }
}
                    
             

@end
