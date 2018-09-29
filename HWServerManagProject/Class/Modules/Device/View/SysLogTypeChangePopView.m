//
//  DeviceDetailChangePopView.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/8.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "SysLogTypeChangePopView.h"
#import "PopTabeleCell.h"

@interface SysLogTypeChangePopView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SysLogTypeChangePopView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
//    self.dataArray = @[@"固定设置",@"自动选择"].mutableCopy;
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 95) style:UITableViewStylePlain];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 55;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 25, 0, 0);
        _tableView.separatorColor = NormalApp_Line_Color;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"PopTabeleCell" bundle:nil] forCellReuseIdentifier:@"PopTabeleCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        
    }
    
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-15, 40)];
    [view addSubview:label];
    label.textColor = NormalApp_TableView_Title_Style_Color;
    label.font = [UIFont systemFontOfSize:15];
    label.text = self.secTitle;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth, 0.5)];
    line.backgroundColor = NormalApp_Line_Color;
    [view addSubview:line];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    view.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, ScreenWidth-25, 40)];
    [view addSubview:label];
    label.textColor = NormalApp_TableView_Title_Style_Color;
    label.font = [UIFont systemFontOfSize:15];
//    label.text = @"暂无可切换设备";
    
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopTabeleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopTabeleCell"];
    cell.clearBtn.hidden = YES;
    
    cell.titleLabel.text = self.dataArray[indexPath.row];
    cell.curRow = indexPath.row;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectSysLogTypeValuBlock) {
        self.didSelectSysLogTypeValuBlock(self.dataArray[indexPath.row]);
    }
    [self removeFromSuperview];
}

- (void)reloadData {
    [self.tableView reloadData];
    if (self.dataArray.count == 0) {
        self.tableView.frame = CGRectMake(0, ScreenHeight - 80, ScreenWidth, 80);
    } else {
        if ((self.dataArray.count*55 + 40) > (ScreenHeight - NavHeight - 100)) {
            self.tableView.frame = CGRectMake(0, 100+NavHeight, ScreenWidth, (ScreenHeight - NavHeight - 100));
        } else {
            self.tableView.frame = CGRectMake(0, ScreenHeight - (self.dataArray.count*55 + 40), ScreenWidth, (self.dataArray.count*55 + 40));
        }
    }
    
}

@end
