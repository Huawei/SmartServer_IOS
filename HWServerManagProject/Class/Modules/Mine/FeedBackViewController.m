//
//  FeedBackViewController.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/5/22.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "FeedBackViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import <MessageUI/MessageUI.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import "RefreshLogManager.h"
#import "ZZYPhotoHelper.h"

@interface FeedBackViewController ()<UITextFieldDelegate,UITextViewDelegate,SKPSMTPMessageDelegate>

@property (strong, nonatomic) UIButton *submitBtn;
@property (strong, nonatomic) UITextField *nameTF;
@property (strong, nonatomic) UITextField *emailTF;
@property (strong, nonatomic) UITextView *markTV;
@property (strong, nonatomic) SKPSMTPMessage *sKPSMTPMessage;
@property (strong, nonatomic) UISwitch *uploadSwitch;
@property (strong, nonatomic) UIButton *addBtn;
@property (strong, nonatomic) UIImageView *icon1IMV;
@property (strong, nonatomic) UIImageView *icon2IMV;
@property (strong, nonatomic) UIButton *icon1DelBtn;
@property (strong, nonatomic) UIButton *icon2DelBtn;


@end

@implementation FeedBackViewController

- (UIImageView *)icon1IMV {
    if (!_icon1IMV) {
        _icon1IMV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 212, 50, 50)];
        _icon1IMV.hidden = YES;
    }
    return _icon1IMV;
}

- (UIImageView *)icon2IMV {
    if (!_icon2IMV) {
        _icon2IMV = [[UIImageView alloc] initWithFrame:CGRectMake(80, 212, 50, 50)];
        _icon2IMV.hidden = YES;
    }
    return _icon2IMV;
}

- (UIButton *)icon1DelBtn {
    if (!_icon1DelBtn) {
        _icon1DelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _icon1DelBtn.frame = CGRectMake(0, 0, 15, 15);
        _icon1DelBtn.center = CGPointMake(self.icon1IMV.frame.origin.x, self.icon1IMV.frame.origin.y);
        [_icon1DelBtn setImage:[UIImage imageNamed:@"one_delete_image"] forState:UIControlStateNormal];
        _icon1DelBtn.hidden = YES;
        [_icon1DelBtn addTarget:self action:@selector(delImageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _icon1DelBtn;
}

- (UIButton *)icon2DelBtn {
    if (!_icon2DelBtn) {
        _icon2DelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _icon2DelBtn.frame = CGRectMake(0, 0, 15, 15);
        _icon2DelBtn.center = CGPointMake(self.icon2IMV.frame.origin.x, self.icon2IMV.frame.origin.y);
        [_icon2DelBtn setImage:[UIImage imageNamed:@"one_delete_image"] forState:UIControlStateNormal];
        _icon2DelBtn.hidden = YES;
        [_icon2DelBtn addTarget:self action:@selector(delImageAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _icon2DelBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"feedback");
    self.view.backgroundColor = NormalApp_Line_Color;
    
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight)];
    [self.view addSubview:scrollV];
    
    
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 50)];
    label.text = LocalString(@"feedback");
    label.textColor = NormalApp_TableView_Title_Style_Color;
    label.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label];
    [scrollV addSubview:secView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 400)];
    contentView.backgroundColor = [UIColor whiteColor];
    [scrollV addSubview:contentView];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, ScreenWidth, 0.5)];
    line1.backgroundColor = NormalApp_Line_Color;
    [contentView addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 99.5, ScreenWidth, 0.5)];
    line2.backgroundColor = NormalApp_Line_Color;
    [contentView addSubview:line2];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 169.5, ScreenWidth, 0.5)];
    line3.backgroundColor = NormalApp_Line_Color;
    [contentView addSubview:line3];
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, 269.5, ScreenWidth, 0.5)];
    line4.backgroundColor = NormalApp_Line_Color;
    [contentView addSubview:line4];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 50)];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = LocalString(@"feedbackname");
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, ScreenWidth-30, 50)];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = LocalString(@"feedbackemail");
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, ScreenWidth-30, 50)];
    label3.backgroundColor = [UIColor clearColor];
    label3.text = LocalString(@"UploadLog(Optional)");
    label3.textColor = [UIColor blackColor];
    label3.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:label3];
    
    UILabel *label33 = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, ScreenWidth-30, 20)];
    label33.backgroundColor = [UIColor clearColor];
    label33.text = LocalString(@"UploadLogdes");
    label33.textColor = [UIColor lightGrayColor];
    label33.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:label33];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, ScreenWidth-30, 50)];
    label4.backgroundColor = [UIColor clearColor];
    label4.text = LocalString(@"UploadPicture(Optional)");
    label4.textColor = [UIColor blackColor];
    label4.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:label4];
    
    self.uploadSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth - 66, 109, 51, 31)];
    [self.uploadSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:self.uploadSwitch];
    self.uploadSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(20, 212, 50, 50);
    [self.addBtn setImage:[UIImage imageNamed:@"schuan"] forState:UIControlStateNormal];
    [contentView addSubview:self.addBtn];
    [self.addBtn addTarget:self action:@selector(didSelectPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.icon1IMV];
    [contentView addSubview:self.icon2IMV];
    [contentView addSubview:self.icon1DelBtn];
    [contentView addSubview:self.icon2DelBtn];

    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, ScreenWidth - 100 - 20, 30)];
    self.nameTF.delegate = self;
    self.nameTF.borderStyle = UITextBorderStyleNone;
    self.nameTF.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:self.nameTF];
    self.nameTF.returnKeyType = UIReturnKeyDone;
    
    self.emailTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 60, ScreenWidth - 100 - 20, 30)];
    self.emailTF.delegate = self;
    self.emailTF.borderStyle = UITextBorderStyleNone;
    self.emailTF.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:self.emailTF];
    self.emailTF.returnKeyType = UIReturnKeyDone;

    self.markTV = [[UITextView alloc] initWithFrame:CGRectMake(14, 270, ScreenWidth - 28, 130)];
    self.markTV.delegate = self;
    self.markTV.font = [UIFont systemFontOfSize:14];
    self.markTV.placeholder = LocalString(@"feedbackmark");
    [contentView addSubview:self.markTV];
    self.markTV.returnKeyType = UIReturnKeyDone;
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.frame = CGRectMake(12, 320+170, ScreenWidth - 24, 40);
    self.submitBtn.backgroundColor = RGBCOLOR(39, 177, 149);
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.submitBtn setTitle:LocalString(@"submit") forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scrollV addSubview:self.submitBtn];
    [self.submitBtn addTarget:self action:@selector(sumitAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *markLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, contentView.bottom, ScreenWidth-40, 20)];
    [scrollV addSubview:markLabel];
    markLabel.font = [UIFont systemFontOfSize:12];
    [markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@460);
        make.width.mas_equalTo(ScreenWidth-40);
    }];
    markLabel.numberOfLines = 0;
    markLabel.textColor = [UIColor lightGrayColor];
    markLabel.text = LocalString(@"feedback_hint_privacy");
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(markLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(ScreenWidth-24);
        make.bottom.equalTo(@(-20));

    }];
    
    scrollV.contentSize = CGSizeMake(ScreenWidth, self.submitBtn.bottom + 20);
}

- (void)switchAction:(UISwitch *)sender {
    
}

- (void)delImageAction:(UIButton *)btn {
    if (btn == self.icon1DelBtn) {
        if (self.icon2IMV.image != nil) {
            self.icon1IMV.image = self.icon2IMV.image;
            self.icon2IMV.image = nil;
            self.icon2DelBtn.hidden = YES;
            self.icon2IMV.hidden = YES;
            self.addBtn.frame = CGRectMake(80, 212, 50, 50);
            self.addBtn.hidden = NO;
        } else {
            self.icon1IMV.image = nil;
            self.icon1IMV.hidden = YES;
            self.icon1DelBtn.hidden = YES;
            self.addBtn.frame = CGRectMake(20, 212, 50, 50);

        }
    } else if (btn == self.icon2DelBtn) {
        self.icon2IMV.image = nil;
        self.icon2DelBtn.hidden = YES;
        self.icon2IMV.hidden = YES;
        self.addBtn.frame = CGRectMake(80, 212, 50, 50);
        self.addBtn.hidden = NO;
    }
}

- (void)didSelectPhotoAction {
    
    [[ZZYPhotoHelper shareHelper] showImageViewSelcteWithResultBlock:^(id data) {
        
        if (self.icon1IMV.image == nil) {
            self.icon1IMV.image = data;
            self.icon1IMV.hidden = NO;
            self.icon2IMV.hidden = YES;
            self.icon1DelBtn.hidden = NO;
            self.icon2DelBtn.hidden = YES;
            self.addBtn.frame = CGRectMake(80, 212, 50, 50);
            self.addBtn.hidden = NO;
        } else {
            self.icon2IMV.image = data;
            self.icon1IMV.hidden = NO;
            self.icon2IMV.hidden = NO;
            self.icon1DelBtn.hidden = NO;
            self.icon2DelBtn.hidden = NO;
            self.addBtn.hidden = YES;
            self.addBtn.frame = CGRectMake(140, 212, 50, 50);
        }
    }];
}

- (void)sumitAction {
    
    if (self.nameTF.text.length == 0) {
        [self.view makeToast:LocalString(@"pleaseinputyourname") duration:2 position:CSToastPositionCenter];
        return;
    }
    if (self.nameTF.text.length > 48) {
        [self.view makeToast:LocalString(@"fbinputyournamelength") duration:2 position:CSToastPositionCenter];
        return;
    }
    
    
    if (self.emailTF.text.length == 0) {
        [self.view makeToast:LocalString(@"pleaseinputyouremail") duration:2 position:CSToastPositionCenter];
        return;
    }
    if (self.emailTF.text.length > 48) {
        [self.view makeToast:LocalString(@"fbemaillength") duration:2 position:CSToastPositionCenter];
        return;
    }
    
    if (![self isValidateEmail:self.emailTF.text]) {
        [self.view makeToast:LocalString(@"youremailerror") duration:2 position:CSToastPositionCenter];
        return;
    }

    self.sKPSMTPMessage = nil;
    SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
    testMsg.fromEmail = @"xxxxxx@163.com";
    testMsg.toEmail =@"xxxxxx@huawei.com";
    testMsg.relayHost = @"smtp.163.com";
    testMsg.requiresAuth = YES;
    testMsg.login = @"xxxxxx@163.com";
    testMsg.pass = @"xxxxxx";// 
    testMsg.subject = @"用户反馈";
    testMsg.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!

    testMsg.delegate = self;
    
    NSString *messagekey = [NSString stringWithFormat:@"用户名称：%@\n用户邮箱：%@\n反馈内容：%@",self.nameTF.text,self.emailTF.text,self.markTV.text];
    
    
    NSDictionary *imagePart1 = nil;
    NSDictionary *imagePart2 = nil;

    if (self.icon1IMV.image) {
        NSData *imgData1 = UIImageJPEGRepresentation(self.icon1IMV.image, 0.5);
        imagePart1 = [NSDictionary dictionaryWithObjectsAndKeys:@"image/jpg;\r\n\tx-unix-mode=0644;\r\n\tname=\"image1.jpg\"",kSKPSMTPPartContentTypeKey,
                      @"attachment;\r\n\tfilename=\"image2.jpg\"",kSKPSMTPPartContentDispositionKey,[imgData1 encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
    }
    if (self.icon2IMV.image) {
        NSData *imgData2 = UIImageJPEGRepresentation(self.icon2IMV.image, 0.5);
        imagePart2 = [NSDictionary dictionaryWithObjectsAndKeys:@"image/jpg;\r\n\tx-unix-mode=0644;\r\n\tname=\"test.jpg\"",kSKPSMTPPartContentTypeKey,
                      @"attachment;\r\n\tfilename=\"test.jpg\"",kSKPSMTPPartContentDispositionKey,[imgData2 encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
        
    }
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,messagekey,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    NSString *vcfPath = [RefreshLogManager getToDayLogPath];
    NSData *vcfData = nil;
    NSString *filename = @"log.txt";
    if (vcfPath != nil && self.uploadSwitch.on) {
        vcfData = [NSData dataWithContentsOfFile:vcfPath];
        NSArray *arr = [vcfPath componentsSeparatedByString:@"/"];
        if (arr.count > 0) {
            filename = [arr lastObject];
        }
        NSString *key1 = [NSString stringWithFormat:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"%@\"",filename];
        NSString *key2 = [NSString stringWithFormat:@"attachment;\r\n\tfilename=\"%@\"",filename];
        NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:key1,kSKPSMTPPartContentTypeKey,
                                 key2,kSKPSMTPPartContentDispositionKey,[vcfData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
        if (imagePart2) {
            testMsg.parts = [NSArray arrayWithObjects:plainPart,vcfPart,imagePart1,imagePart2,nil];
        } else if (imagePart2) {
            testMsg.parts = [NSArray arrayWithObjects:plainPart,vcfPart,imagePart1,nil];
        } else {
            testMsg.parts = [NSArray arrayWithObjects:plainPart,vcfPart,nil];
        }

    } else {
        if (imagePart2) {
            testMsg.parts = [NSArray arrayWithObjects:plainPart,imagePart1,imagePart2,nil];
        } else if (imagePart2) {
            testMsg.parts = [NSArray arrayWithObjects:plainPart,imagePart1,nil];
        } else {
            testMsg.parts = [NSArray arrayWithObjects:plainPart,nil];
        }
    }
    
    
    
    
    [testMsg send];
    self.sKPSMTPMessage = testMsg;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];


}

//SKPSMTPMessage代理，可以获知成功/失败进行后续步骤处理
-(void)messageSent:(SKPSMTPMessage *)message{
    BLLog(@"%@", message);
    [self.view makeToast:LocalString(@"emailsendsuccess")];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    [self.view makeToast:[NSString stringWithFormat:@"message - %@\nerror - %@", message, error]];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
    }
    return YES;
}

- (BOOL)isValidateEmail:(NSString *)email {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isemail=[emailTest evaluateWithObject:email];
    return isemail;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
