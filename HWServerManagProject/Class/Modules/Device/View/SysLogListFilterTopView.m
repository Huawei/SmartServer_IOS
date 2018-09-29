//
//  GoodsListFilterTopView.m
//  market
//
//  Created by xunruiIOS on 2018/2/2.
//  Copyright © 2018年 xunruiIos. All rights reserved.
//

#import "SysLogListFilterTopView.h"
#import "FilterControl.h"
#import "SysLogTypeChangePopView.h"
#import "AppDelegate.h"
#import "SysLogTimeSelectPopView.h"

@interface SysLogListFilterTopView()<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) SysLogTypeChangePopView *popView;
@property (strong, nonatomic) SysLogTimeSelectPopView *timePopView;
@property (strong, nonatomic) FilterControl *filterControl1;
@property (strong, nonatomic) FilterControl *filterControl2;
@property (strong, nonatomic) FilterControl *filterControl3;
@property (strong, nonatomic) UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation SysLogListFilterTopView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, ScreenWidth, 91);
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = NormalApp_BackgroundColor;
    self.popView = [[NSBundle mainBundle] loadNibNamed:@"SysLogTypeChangePopView" owner:nil options:nil].lastObject;
    self.timePopView = [[NSBundle mainBundle] loadNibNamed:@"SysLogTimeSelectPopView" owner:nil options:nil].lastObject;

    /*
    NSString *tempstr = LocalString(@"laujudge");
    if ([tempstr isEqualToString:@"china"]) {
        self.filterControl1 = [[FilterControl alloc] initWithFrame:CGRectMake(0, 56, (ScreenWidth)/3, 35) withTitle:LocalString(@"system_log_level") withIsArrow:YES];
        self.filterControl2 = [[FilterControl alloc] initWithFrame:CGRectMake((ScreenWidth)/3, 56, (ScreenWidth)/3, 35) withTitle:LocalString(@"system_log_subject") withIsArrow:YES];
        self.filterControl3 = [[FilterControl alloc] initWithFrame:CGRectMake((ScreenWidth)*2/3, 56, (ScreenWidth)/3, 35) withTitle:LocalString(@"system_log_create_date") withIsArrow:YES];
    } else {
        self.filterControl1 = [[FilterControl alloc] initWithFrame:CGRectMake(0, 56, (ScreenWidth)/3 - 18, 35) withTitle:LocalString(@"system_log_level") withIsArrow:YES];
        self.filterControl2 = [[FilterControl alloc] initWithFrame:CGRectMake((ScreenWidth)/3  - 18, 56, (ScreenWidth)/3  - 18, 35) withTitle:LocalString(@"system_log_subject") withIsArrow:YES];
        self.filterControl3 = [[FilterControl alloc] initWithFrame:CGRectMake((ScreenWidth)*2/3 - 36, 56, (ScreenWidth)/3+36, 35) withTitle:LocalString(@"system_log_create_date") withIsArrow:YES];
    }
    
    
    [self.filterControl1 addTarget:self action:@selector(didTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.filterControl2 addTarget:self action:@selector(didTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.filterControl3 addTarget:self action:@selector(didTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:self.filterControl1];
    [self.contentView addSubview:self.filterControl2];
    [self.contentView addSubview:self.filterControl3];
    */
//    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.contentView addSubview:self.searchBtn];
//    self.searchBtn.frame = CGRectMake(ScreenWidth - 60, 0, 50, 50);
//    [self.searchBtn setImage:[UIImage imageNamed:@"one_cellLogSearchicon"] forState:UIControlStateNormal];
    
    self.searchBar.placeholder = LocalString(@"search");
    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
    txfSearchField.textColor = HEXCOLOR(0x25c4a4);
    txfSearchField.layer.cornerRadius = 3;
    txfSearchField.layer.masksToBounds = YES;
    txfSearchField.backgroundColor = HEXCOLOR(0xf7f2f7);
    txfSearchField.font = [UIFont systemFontOfSize:14];
    UIImage* searchBarBg = [self GetImageWithColor:[UIColor whiteColor] andHeight:56];
    [self.searchBar setBackgroundImage:searchBarBg];
    [self.searchBar setBackgroundColor:[UIColor whiteColor]];
    self.searchBar.delegate = self;
//    self.searchBar.showsCancelButton = YES;

}

- (void)setEventSubject:(NSMutableArray *)eventSubject {
    _eventSubject = eventSubject;
}

- (void)didTypeBtnAction:(FilterControl *)btn {
    [self endEditing:YES];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.window addSubview:self.popView];
    if (btn == self.filterControl1) {
        self.popView.secTitle = LocalString(@"system_log_select_level_title");
        self.popView.dataArray = @[LocalString(@"system_log_select_level_critical"),LocalString(@"system_log_select_level_warning"),LocalString(@"system_log_select_level_ok"),LocalString(@"system_log_select_all")].mutableCopy;
        __weak typeof(self) weakSelf = self;
        self.popView.didSelectSysLogTypeValuBlock = ^(NSString *value) {
            if (weakSelf.didSelectSysTypeBlock) {
                weakSelf.didSelectSysTypeBlock(0, value);
            }
            if ([value isEqualToString:LocalString(@"system_log_select_all")]) {
                weakSelf.filterControl1.titleLabel.text = LocalString(@"system_log_level");
            } else {
                weakSelf.filterControl1.titleLabel.text = value;

            }
        };
        
    } else if (btn == self.filterControl2) {
        self.popView.secTitle = LocalString(@"system_log_select_type_title");
        if (self.eventSubject) {
            [self.eventSubject addObject:LocalString(@"system_log_select_all")];
            self.popView.dataArray = self.eventSubject;
        } else {
            self.popView.dataArray = @[LocalString(@"system_log_select_all")].mutableCopy;
        }
        __weak typeof(self) weakSelf = self;
        self.popView.didSelectSysLogTypeValuBlock = ^(NSString *value) {
            if (weakSelf.didSelectSysTypeBlock) {
                weakSelf.didSelectSysTypeBlock(1, value);
            }
            if ([value isEqualToString:LocalString(@"system_log_select_all")]) {
                weakSelf.filterControl2.titleLabel.text = LocalString(@"system_log_subject");
            } else {
                if ([value isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = (NSDictionary *)value;
                    weakSelf.filterControl2.titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"Label"]];
                } else {
                    weakSelf.filterControl2.titleLabel.text = value;

                }
            }
        };
    } else {
        self.popView.secTitle = LocalString(@"system_log_select_create_date_title");
        self.popView.dataArray = @[LocalString(@"system_log_select_create_date_today"),LocalString(@"system_log_select_create_date_seven_days"),LocalString(@"system_log_select_create_date_one_month"),LocalString(@"system_log_select_create_date_range"),LocalString(@"system_log_select_all")].mutableCopy;
        __weak typeof(self) weakSelf = self;
        self.popView.didSelectSysLogTypeValuBlock = ^(NSString *value) {
            
            if ([value isEqualToString:LocalString(@"system_log_select_all")]) {
                weakSelf.filterControl3.titleLabel.text = LocalString(@"system_log_create_date");
                if (weakSelf.didSelectSysTypeBlock) {
                    weakSelf.didSelectSysTypeBlock(2, value);
                }
            } else if ([value isEqualToString:LocalString(@"system_log_select_create_date_range")]) {
                weakSelf.filterControl3.titleLabel.text = LocalString(@"system_log_select_create_date_range");

                [appdelegate.window addSubview:weakSelf.timePopView];
                weakSelf.timePopView.didSelectSysLogTimeBlock = ^(NSString *sTime, NSString *eTime) {
                    if (weakSelf.didSelectSysTypeTimeBlock) {
                        weakSelf.didSelectSysTypeTimeBlock(sTime, eTime);
                    }
                };

            } else {
                weakSelf.filterControl3.titleLabel.text = value;
                if (weakSelf.didSelectSysTypeBlock) {
                    weakSelf.didSelectSysTypeBlock(2, value);
                }
            }
        };
    }
    [self.popView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if (self.didSelectSysTypeBlock) {
        self.didSelectSysTypeBlock(3, searchBar.text);
    }
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height {
    
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
