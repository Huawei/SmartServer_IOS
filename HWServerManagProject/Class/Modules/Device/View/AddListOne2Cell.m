//
//  AddListOneCell.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "AddListOne2Cell.h"

@implementation AddListOne2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.inputTF addTarget:self action:@selector(textTFDidChangeText:) forControlEvents:UIControlEventEditingChanged];
    [self.eyeBtn setImage:[UIImage imageNamed:@"eyebtnselect"] forState:UIControlStateNormal];
    [self.eyeBtn setImage:[UIImage imageNamed:@"eyebtnselect"] forState:UIControlStateHighlighted];
    [self.eyeBtn setImage:[UIImage imageNamed:@"eyebtnnormal"] forState:UIControlStateSelected];
    [self.eyeBtn setImage:[UIImage imageNamed:@"eyebtnnormal"] forState:UIControlStateSelected|UIControlStateHighlighted];
    self.inputTF.secureTextEntry = YES;
    self.eyeBtn.selected = NO;
}

- (IBAction)showhideAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.inputTF.secureTextEntry = !sender.selected;
//    if (sender.selected) {
//        self.inputTF.secureTextEntry = NO;
//    } else {
//        self.inputTF.secureTextEntry = YES;
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (!self.isNumTask) {
        return YES;
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:LOGINNUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
    
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (self.didSureInputBlock) {
//        self.didSureInputBlock(textField.text);
//    }
//}

- (void)textTFDidChangeText:(UITextField *)textField {
    if (self.didSureInputBlock) {
        self.didSureInputBlock(textField.text);
    }
}

@end
