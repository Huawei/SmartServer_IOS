//
//  NetSettingViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/5.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "NetSettingViewController.h"
#import "NetSettingOneCell.h"
#import "NetSettingTwoCell.h"
#import "NetSettingThreeCell.h"
#import "NetSettingFourCell.h"
#import "NetSettingFiveCell.h"
#import "NetTimeAreaChangePopView.h"

@interface NetSettingViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *topBarScrollView;
@property (strong, nonatomic) UIView *underView;
@property (strong, nonatomic) NetTimeAreaChangePopView *netTimeAreaChangePopView;

@property (strong, nonatomic) NSMutableArray *btnArray;
@property (strong, nonatomic) UIButton *curBtn;

@property (strong, nonatomic) NSDictionary *dataDic;

@property (copy, nonatomic) NSString *dateTimeLocalOffset;//时区

@property (copy, nonatomic) NSString *odata_id;


@end

@implementation NetSettingViewController


- (NetTimeAreaChangePopView *)netTimeAreaChangePopView {
    if (!_netTimeAreaChangePopView) {
        _netTimeAreaChangePopView = [[[NSBundle mainBundle] loadNibNamed:@"NetTimeAreaChangePopView" owner:nil options:nil] lastObject];
        __weak typeof(self) weakSelf = self;
        
        _netTimeAreaChangePopView.didSelectTimeAreaBlock = ^(NSString *value, NSInteger popRow) {
            if (popRow == 1) {
                weakSelf.dateTimeLocalOffset = value;
                [weakSelf.collectionView reloadData];
            } else {
                if ([value hasPrefix:@"GMT"]) {
//                    NSArray *arr = [weakSelf.dateTimeLocalOffset componentsSeparatedByString:@"-"];
//                    if (arr.count == 2) {
//                        weakSelf.dateTimeLocalOffset = [NSString stringWithFormat:@"%@-%@",value,arr[1]];
//                        [weakSelf.collectionView reloadData];
//                    } else if (arr.count == 1) {
                    if ([weakSelf.dateTimeLocalOffset hasPrefix:@"GMT"]) {
                        
                    } else {
                        weakSelf.dateTimeLocalOffset = [NSString stringWithFormat:@"%@",value];
                        [weakSelf.collectionView reloadData];
                    }
                    
//                    }
                } else {
                    NSArray *arr = [weakSelf.dateTimeLocalOffset componentsSeparatedByString:@"/"];
                    if (arr.count == 2) {
                        weakSelf.dateTimeLocalOffset = [NSString stringWithFormat:@"%@/%@",value,arr[1]];
                        [weakSelf.collectionView reloadData];
                    } else {
                        weakSelf.dateTimeLocalOffset = [NSString stringWithFormat:@"%@/",value];
                        [weakSelf.collectionView reloadData];
                    }
                }
                
            }
        };
    }
    return _netTimeAreaChangePopView;
}

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (UIScrollView *)topBarScrollView {
    if (!_topBarScrollView) {
        _topBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _topBarScrollView.showsVerticalScrollIndicator = NO;
        _topBarScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_topBarScrollView];
        if (@available(iOS 11.0, *)) {
            _topBarScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth, 0.5)];
//        line.backgroundColor = HEXCOLOR(0xd8d8d8);
//        [self.view addSubview:line];
    }
    return _topBarScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"netset");
    NSArray *titleArray = @[LocalString(@"hostname"),LocalString(@"port"),LocalString(@"network"),LocalString(@"vlan"),LocalString(@"timezone")];
    UIButton *tempBtn = nil;
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((ScreenWidth/5)*i, 0,ScreenWidth, 50);
        if (i == 0) {
            self.curBtn = btn;
            [btn setTitleColor:SelectApp_tabbar_Style_Color forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:NormalApp_nav_Style_Color forState:UIControlStateNormal];
            
        }
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.topBarScrollView addSubview:btn];
        [btn sizeToFit];
        if (tempBtn == nil) {
            btn.frame = CGRectMake(0, 0,btn.width + 30, 50);
        } else {
            btn.frame = CGRectMake(tempBtn.right, 0,btn.width + 30, 50);
        }

        btn.tag = i;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            self.underView = [[UIView alloc] initWithFrame:CGRectMake(0, 46.5, 45, 3.5)];
            [self.topBarScrollView addSubview:self.underView];
            self.underView.backgroundColor = SelectApp_tabbar_Style_Color;
            self.underView.center = CGPointMake(btn.center.x, self.underView.center.y);
        }
        [self.btnArray addObject:btn];
        tempBtn = btn;
        btn.tag = i;
    }
    if (tempBtn.right < ScreenWidth) {
        for (UIButton *btn in self.btnArray) {
            btn.frame = CGRectMake((ScreenWidth/5)*btn.tag, 0,ScreenWidth/5, 50);
        }
    }
    
    self.topBarScrollView.contentSize = CGSizeMake(tempBtn.right, 50);
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight - NavHeight - 50);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight - NavHeight - 50) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = NormalApp_BackgroundColor;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NetSettingOneCell" bundle:nil] forCellWithReuseIdentifier:@"NetSettingOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NetSettingTwoCell" bundle:nil] forCellWithReuseIdentifier:@"NetSettingTwoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NetSettingThreeCell" bundle:nil] forCellWithReuseIdentifier:@"NetSettingThreeCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NetSettingFourCell" bundle:nil] forCellWithReuseIdentifier:@"NetSettingFourCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NetSettingFiveCell" bundle:nil] forCellWithReuseIdentifier:@"NetSettingFiveCell"];

    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    

    //数据
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NetSettingOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NetSettingOneCell" forIndexPath:indexPath];
        if (cell.hostName == nil) {
            if (self.dataDic) {
                cell.hostName = [NSString stringWithFormat:@"%@",self.dataDic[@"HostName"]];
            } else {
                cell.hostName = @"";
            }
        }
        
        cell.odata_id = self.odata_id;
        __weak typeof(self) weakSelf = self;
        cell.didRefreshHostBlock = ^(NSDictionary *data, NSString *odata_id) {
            weakSelf.odata_id = odata_id;
            weakSelf.dataDic = data;
        };
        return cell;
    } else if (indexPath.row == 1){
        NetSettingTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NetSettingTwoCell" forIndexPath:indexPath];
        cell.controller = self;
        if (cell.dataDic == nil) {
            cell.dataDic = self.dataDic;
        }
        
        cell.odata_id = self.odata_id;
        __weak typeof(self) weakSelf = self;
        cell.didRefreshNetPortBlock = ^(NSDictionary *data, NSString *odata_id) {
            weakSelf.dataDic = data;
            weakSelf.odata_id = odata_id;
        };
        return cell;
    } else if (indexPath.row == 2){
        NetSettingThreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NetSettingThreeCell" forIndexPath:indexPath];
        cell.controller = self;
        if (cell.dataDic == nil) {
            cell.dataDic = self.dataDic;
        }
        
        cell.odata_id = self.odata_id;
        __weak typeof(self) weakSelf = self;
        cell.didRefreshNetBlock = ^(NSDictionary *data, NSString *odata_id) {
            weakSelf.dataDic = data;
            weakSelf.odata_id = odata_id;
        };
        
        cell.didGetHostNameBlock = ^NSString *{
            NSString *hostname = weakSelf.dataDic[@"HostName"];
            return hostname;
        };
        
        return cell;
    } else if (indexPath.row == 3){
        NetSettingFourCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NetSettingFourCell" forIndexPath:indexPath];
        if (cell.dataDic == nil) {
            cell.dataDic = self.dataDic;
        }
        
        cell.odata_id = self.odata_id;
        __weak typeof(self) weakSelf = self;
        cell.didRefreshVlanBlock = ^(NSDictionary *data, NSString *odata_id) {
            weakSelf.dataDic = data;
            weakSelf.odata_id = odata_id;
        };
        return cell;
    } else {
        NetSettingFiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NetSettingFiveCell" forIndexPath:indexPath];
        cell.dateTimeLocalOffset = self.dateTimeLocalOffset;
        
        __weak typeof(self) weakSelf = self;
        cell.didPopAreaTimeBlock = ^(NSInteger row, NSDictionary *dataDic) {
            weakSelf.netTimeAreaChangePopView.popRow = row;
            [weakSelf.navigationController.view addSubview:weakSelf.netTimeAreaChangePopView];
            weakSelf.netTimeAreaChangePopView.dataDic = dataDic;
            [weakSelf.netTimeAreaChangePopView reloadData];
        };
        cell.didRefreshAreaTimeBlock = ^(NSDictionary *dataDic, NSString *dateTimeLocalOffset) {
            weakSelf.dateTimeLocalOffset = dateTimeLocalOffset;
        };
        return cell;
    }
    
}


- (void)topBtnClick:(UIButton *)btn {
    [self.curBtn setTitleColor:NormalApp_nav_Style_Color forState:UIControlStateNormal];
    
    [btn setTitleColor:SelectApp_tabbar_Style_Color forState:UIControlStateNormal];
    self.curBtn = btn;
    
    [self.collectionView setContentOffset:CGPointMake(btn.tag*ScreenWidth, 0) animated:NO];
    
    self.underView.center = CGPointMake(btn.center.x, self.underView.center.y);
    
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        NSInteger tempIndex = scrollView.contentOffset.x/ScreenWidth;//(105/SCREEN_WIDTH)*self.collectionView.contentOffset.x + 85/2.0;
        
        [self.curBtn setTitleColor:NormalApp_nav_Style_Color forState:UIControlStateNormal];
        
        UIButton *tempbtn = self.btnArray[tempIndex];
        [tempbtn setTitleColor:SelectApp_tabbar_Style_Color forState:UIControlStateNormal];
        self.curBtn = tempbtn;
        
        self.underView.center = CGPointMake(tempbtn.center.x, self.underView.center.y);
        if (tempIndex == 4) {
            [self getDataTwo];
        } else {
            [self getDataOne];
        }
    }
    [self.view endEditing:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getData {
    
    
    [self getDataOne];
    [self getDataTwo];
}

- (void)getDataOne {
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@/EthernetInterfaces",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSArray *Members = result[@"Members"];
        
        if (Members && [Members isKindOfClass:[NSArray class]]) {
            
            
            for (NSDictionary *dic in Members) {
                NSString *odata_id = dic[@"@odata.id"];
                if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
                    weakSelf.odata_id = odata_id;
                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
                        weakSelf.dataDic = result14;
                        [weakSelf.collectionView reloadData];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    break;
                }
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

- (void)getDataTwo {
    __weak typeof(self) weakSelf = self;
    //时区
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        NSString *DateTimeLocalOffset = result[@"DateTimeLocalOffset"];
        if (DateTimeLocalOffset.isSureString) {
            weakSelf.dateTimeLocalOffset = DateTimeLocalOffset;
            [weakSelf.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
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
