//
//  HardwareInfoViewController.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HardwareInfoViewController.h"
#import "HardwareInfoOneCell.h"
#import "HardwareInfoTwoCell.h"
#import "HardwareInfoThreeCell.h"
#import "HardwareInfoFiveCell.h"
#import "HardwareInfoFourCell.h"
#import "LogicalDiskViewController.h"
#import "PhysicalDiskViewController.h"

@interface HardwareInfoViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *topBarScrollView;
@property (strong, nonatomic) UIView *underView;

@property (strong, nonatomic) NSMutableArray *btnArray;
@property (strong, nonatomic) NSMutableArray *labelArray;
@property (strong, nonatomic) UIButton *curBtn;
@property (strong, nonatomic) UILabel *curLabel;


//@property (strong, nonatomic) NSMutableArray *memoryArray;
@property (strong, nonatomic) NSMutableArray *cpuArray;
@property (strong, nonatomic) NSMutableArray *powerArray;
@property (strong, nonatomic) NSMutableArray *netcardArray;
@property (strong, nonatomic) NSMutableArray *storageArray;



@end

@implementation HardwareInfoViewController

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

//- (NSMutableArray *)memoryArray {
//    if (!_memoryArray) {
//        _memoryArray = [NSMutableArray array];
//    }
//    return _memoryArray;
//}

- (NSMutableArray *)cpuArray {
    if (!_cpuArray) {
        _cpuArray = [NSMutableArray array];
    }
    return _cpuArray;
}

- (NSMutableArray *)powerArray {
    if (!_powerArray) {
        _powerArray = [NSMutableArray array];
    }
    return _powerArray;
}

- (NSMutableArray *)netcardArray {
    if (!_netcardArray) {
        _netcardArray = [NSMutableArray array];
    }
    return _netcardArray;
}

- (NSMutableArray *)storageArray {
    if (!_storageArray) {
        _storageArray = [NSMutableArray array];
    }
    return _storageArray;
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
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
        
    }
    return _topBarScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"devicedetailhardware");
    
    NSArray *titleArray = @[LocalString(@"healthmemory"),LocalString(@"healthcpu"),LocalString(@"healthsupply"),LocalString(@"hardwarenic"),LocalString(@"reportstorage")];
    
    UIButton *tempBtn = nil;
    for (int i = 0; i < 5; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((ScreenWidth/5)*i, 0,ScreenWidth, 50);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btn.center.x + 18, 16, 20, 11)];
        label.font = [UIFont systemFontOfSize:11];
        
        if (i == 0) {
            self.curBtn = btn;
            [btn setTitleColor:SelectApp_tabbar_Style_Color forState:UIControlStateNormal];
            self.curLabel = label;
            label.textColor = SelectApp_tabbar_Style_Color;
        } else {
            [btn setTitleColor:NormalApp_nav_Style_Color forState:UIControlStateNormal];
            label.textColor = NormalApp_nav_Style_Color;
        }
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.topBarScrollView addSubview:btn];
        [self.topBarScrollView addSubview:label];
        
        [btn sizeToFit];
        if (tempBtn == nil) {
            btn.frame = CGRectMake(0, 0,btn.width + 30, 50);
        } else {
            btn.frame = CGRectMake(tempBtn.right, 0,btn.width + 30, 50);
        }
        label.frame = CGRectMake(btn.right - 12, 16, 20, 11);

        btn.tag = i;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
       
        if (i == 0) {
            self.underView = [[UIView alloc] initWithFrame:CGRectMake(0, 46.5, 30, 3.5)];
            [self.topBarScrollView addSubview:self.underView];
            self.underView.backgroundColor = SelectApp_tabbar_Style_Color;
            self.underView.center = CGPointMake(btn.center.x, self.underView.center.y);
        }
        [self.btnArray addObject:btn];
        tempBtn = btn;
        [self.labelArray addObject:label];
        
        
    }
    
    if (tempBtn.right < ScreenWidth) {
        for (NSInteger i = 0; i < self.btnArray.count; i++) {
            UIButton *btn = self.btnArray[i];
            UILabel *label = self.labelArray[i];
            btn.frame = CGRectMake((ScreenWidth/5)*btn.tag, 0,ScreenWidth/5, 50);
            label.frame = CGRectMake(btn.center.x + 18, 16, 20, 11);
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
    self.collectionView.backgroundColor = HEXCOLOR(0xf1f1f1);
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HardwareInfoOneCell" bundle:nil] forCellWithReuseIdentifier:@"HardwareInfoOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HardwareInfoTwoCell" bundle:nil] forCellWithReuseIdentifier:@"HardwareInfoTwoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HardwareInfoThreeCell" bundle:nil] forCellWithReuseIdentifier:@"HardwareInfoThreeCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HardwareInfoFiveCell" bundle:nil] forCellWithReuseIdentifier:@"HardwareInfoFiveCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HardwareInfoFourCell" bundle:nil] forCellWithReuseIdentifier:@"HardwareInfoFourCell"];

    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        HardwareInfoOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HardwareInfoOneCell" forIndexPath:indexPath];
//        if (cell.dataArray == nil) {
//            cell.dataArray = self.memoryArray;
//        }
        cell.didHardwareInfoOneBlock = ^(NSString *count) {
            if (count.integerValue > 0) {
                UILabel *label = weakSelf.labelArray[0];
                label.text = [NSString stringWithFormat:@"%@",count];
            } else {
                UILabel *label = weakSelf.labelArray[0];
                label.text = @"";
            }
        };
        
        return cell;
    } else if (indexPath.row == 1) {
        HardwareInfoTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HardwareInfoTwoCell" forIndexPath:indexPath];
        
        cell.didHardwareInfoTwoBlock = ^(NSString *count) {
            if (count.integerValue > 0) {
                UILabel *label = weakSelf.labelArray[1];
                label.text = [NSString stringWithFormat:@"%@",count];
            } else {
                UILabel *label = weakSelf.labelArray[1];
                label.text = @"";
            }
        };
        return cell;
    } else if (indexPath.row == 2) {
        HardwareInfoThreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HardwareInfoThreeCell" forIndexPath:indexPath];
        
        cell.didHardwareInfoThreeBlock = ^(NSString *count) {
            if (count.integerValue > 0) {
                UILabel *label = weakSelf.labelArray[2];
                label.text = [NSString stringWithFormat:@"%@",count];
            } else {
                UILabel *label = weakSelf.labelArray[2];
                label.text = @"";
            }
        };
        return cell;
    } else if (indexPath.row == 3) {
        HardwareInfoFourCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HardwareInfoFourCell" forIndexPath:indexPath];
        cell.controller = self;
        
        cell.didHardwareInfoFourBlock = ^(NSString *count) {
            if (count.integerValue > 0) {
                UILabel *label = weakSelf.labelArray[3];
                label.text = [NSString stringWithFormat:@"%@",count];
            } else {
                UILabel *label = weakSelf.labelArray[3];
                label.text = @"";
            }
        };
        return cell;
    } else {
        HardwareInfoFiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HardwareInfoFiveCell" forIndexPath:indexPath];
        
        cell.didHardwareInfoFiveBlock = ^(NSString *count) {
            if (count.integerValue > 0) {
                UILabel *label = weakSelf.labelArray[4];
                label.text = [NSString stringWithFormat:@"%@",count];
            } else {
                UILabel *label = weakSelf.labelArray[4];
                label.text = @"";
            }
        };
        
        cell.didHardwareDriveBlock = ^(NSDictionary *value) {
            
            NSArray *drives = value[@"Drives"];
            PhysicalDiskViewController *vc = [PhysicalDiskViewController new];
            if (drives.isSureArray) {
                vc.drives = drives;
            }
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        cell.didHardwareLogicalDriveBlock = ^(NSDictionary *value) {
            
            NSDictionary *volumes = value[@"Volumes"];
            
            LogicalDiskViewController *vc = [LogicalDiskViewController new];
            if (volumes.isSureDictionary) {
                vc.volumes_odataId = volumes[@"@odata.id"];
            }
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
    }
   
}


- (void)topBtnClick:(UIButton *)btn {
    [self.curBtn setTitleColor:NormalApp_nav_Style_Color forState:UIControlStateNormal];
    [btn setTitleColor:SelectApp_tabbar_Style_Color forState:UIControlStateNormal];
    self.curBtn = btn;
    self.curLabel.textColor = NormalApp_nav_Style_Color;
    self.curLabel = self.labelArray[btn.tag];
    self.curLabel.textColor = SelectApp_tabbar_Style_Color;

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
        self.curLabel.textColor = NormalApp_nav_Style_Color;
        self.curLabel = self.labelArray[self.curBtn.tag];
        self.curLabel.textColor = SelectApp_tabbar_Style_Color;
        self.underView.center = CGPointMake(tempbtn.center.x, self.underView.center.y);
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    
    //cpu
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@/Processors",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        
        NSArray *Members = result[@"Members"];
        
        if (Members && [Members isKindOfClass:[NSArray class]]) {
            if (Members.count > 0) {
                UILabel *label = weakSelf.labelArray[1];
                label.text = [NSString stringWithFormat:@"%ld",Members.count];
            } else {
                UILabel *label = weakSelf.labelArray[1];
                label.text = @"";
            }
            
//            [weakSelf.cpuArray removeAllObjects];
//            for (NSDictionary *dic in Members) {
//                NSString *odata_id = dic[@"@odata.id"];
//                if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
//
//                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
//
//                        [weakSelf.cpuArray addObject:result14];
//                        if (weakSelf.cpuArray.count == Members.count) {
//                            [weakSelf.collectionView reloadData];
//                        }
//
//
//                    } failure:^(NSError *error) {
//                        [weakSelf.collectionView reloadData];
//                    }];
//                } else {
//                    UILabel *label = weakSelf.labelArray[1];
//                    label.text = @"";
//                }
//            }
        }
        
    } failure:^(NSError *error) {
//        [weakSelf.collectionView reloadData];
    }];
    
    //电源
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Chassis/%@/Power",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {

            NSArray *PowerSupplies = result[@"PowerSupplies"];
            if (PowerSupplies && [PowerSupplies isKindOfClass:[NSArray class]]) {
               
                [weakSelf.powerArray removeAllObjects];
                
                for (NSDictionary *data in PowerSupplies) {
                    NSDictionary *status = data[@"Status"];
                    if (status.isSureDictionary) {
                        NSString *state = status[@"State"];
                        if (state.isSureString && [state isEqualToString:@"Enabled"]) {
                            [weakSelf.powerArray addObject:data];
                        } else if (state.isSureString && [state isEqualToString:@"Disabled"]) {
                            [weakSelf.powerArray addObject:data];
                        } else if (state.isSureString && [state isEqualToString:@"Absent"]) {
                        }
                    }
                }
                
                if (weakSelf.powerArray.count > 0) {
                    UILabel *label = weakSelf.labelArray[2];
                    label.text = [NSString stringWithFormat:@"%ld",weakSelf.powerArray.count];
                } else {
                    UILabel *label = weakSelf.labelArray[2];
                    label.text = @"";
                }
                
//                [weakSelf.collectionView reloadData];
                
            }
        
    } failure:^(NSError *error) {
//        [weakSelf.collectionView reloadData];
    }];
    
    //网卡
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Chassis/%@/NetworkAdapters",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        
        NSArray *Members = result[@"Members"];
        
        if (Members && [Members isKindOfClass:[NSArray class]]) {
            if (Members.count > 0) {
                UILabel *label = weakSelf.labelArray[3];
                label.text = [NSString stringWithFormat:@"%ld",Members.count];
            } else {
                UILabel *label = weakSelf.labelArray[3];
                label.text = @"";
            }
//            [weakSelf.netcardArray removeAllObjects];
//            for (NSDictionary *dic in Members) {
//                NSString *odata_id = dic[@"@odata.id"];
//                if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
//
//                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
//
//                        [weakSelf.netcardArray addObject:result14];
//                        if (weakSelf.netcardArray.count == Members.count) {
//                            [weakSelf.collectionView reloadData];
//                        }
//
//
//                    } failure:^(NSError *error) {
//                        [weakSelf.collectionView reloadData];
//                    }];
//                } else {
//                    UILabel *label = weakSelf.labelArray[1];
//                    label.text = @"";
//                }
//            }
        }
        
    } failure:^(NSError *error) {
//        [weakSelf.collectionView reloadData];
    }];
    
    
    //存储
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@/Storages",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        
        NSArray *Members = result[@"Members"];
        
        if (Members && [Members isKindOfClass:[NSArray class]]) {
            if (Members.count > 0) {
                UILabel *label = weakSelf.labelArray[4];
                label.text = [NSString stringWithFormat:@"%ld",Members.count];
            } else {
                UILabel *label = weakSelf.labelArray[4];
                label.text = @"";
            }
            
//            [weakSelf.storageArray removeAllObjects];
//            for (NSDictionary *dic in Members) {
//                NSString *odata_id = dic[@"@odata.id"];
//                if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
//                    
//                    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
//                        
//                        [weakSelf.storageArray addObject:result14];
//                        if (weakSelf.storageArray.count == Members.count) {
//                            [weakSelf.collectionView reloadData];
//                        }
//                        
//                        
//                    } failure:^(NSError *error) {
//                        [weakSelf.collectionView reloadData];
//                    }];
//                } else {
//                    UILabel *label = weakSelf.labelArray[1];
//                    label.text = @"";
//                }
//            }
        }
        
    } failure:^(NSError *error) {
//        [weakSelf.collectionView reloadData];
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
