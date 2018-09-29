//
//  PopTabeleCell.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/8.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "PopTabeleCell.h"

@implementation PopTabeleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didClearAction:(id)sender {
    if (self.didClearBlock) {
        self.didClearBlock(self.curRow);
    }
}

@end
