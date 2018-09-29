//
//  RealTimeStatusMainViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/3/31.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "RealTimeStatusMainViewController.h"
#import "RealTimeStatusViewController.h"

@interface RealTimeStatusMainViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *topBarScrollView;
@property (strong, nonatomic) UIView *underView;

@property (strong, nonatomic) NSMutableArray *controllersArray;
@property (strong, nonatomic) NSMutableArray *btnArray;
@property (strong, nonatomic) UIButton *curBtn;

@property (strong, nonatomic) NSArray *temperatures;

@property (strong, nonatomic) NSMutableArray *healthContentArray;


@end

@implementation RealTimeStatusMainViewController


- (NSMutableArray *)healthContentArray {
    if (!_healthContentArray) {
        _healthContentArray = [NSMutableArray new];
    }
    return _healthContentArray;
}


- (NSMutableArray *)controllersArray {
    if (!_controllersArray) {
        _controllersArray = [NSMutableArray array];
    }
    return _controllersArray;
}


- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (UIScrollView *)topBarScrollView {
    if (!_topBarScrollView) {
        _topBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _topBarScrollView.showsVerticalScrollIndicator = NO;
        _topBarScrollView.showsHorizontalScrollIndicator = NO;
        _topBarScrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_topBarScrollView];
        if (@available(iOS 11.0, *)) {
            _topBarScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth, 0.5)];
        line.backgroundColor = HEXCOLOR(0xd8d8d8);
        [self.view addSubview:line];
    }
    return _topBarScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"devicedetaildashboar");
    self.view.backgroundColor = [UIColor whiteColor];
    [self.healthContentArray addObjectsFromArray:@[@"",@"",@"",@"",@"",@""]];
    UIButton *tempBtn = nil;
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            self.curBtn = btn;
            [btn setTitleColor:SelectApp_tabbar_Style_Color forState:UIControlStateNormal];
            [btn setTitle:LocalString(@"realtimetemp") forState:UIControlStateNormal];
        } else if (i == 1) {
            [btn setTitleColor:NormalApp_nav_Style_Color forState:UIControlStateNormal];
            [btn setTitle:LocalString(@"healthstatus") forState:UIControlStateNormal];
        }
        
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.topBarScrollView addSubview:btn];
        [btn sizeToFit];
        btn.frame = CGRectMake(ScreenWidth*i/2, 0, ScreenWidth/2, 40);
        
        btn.tag = i;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            RealTimeStatusViewController *controller = [RealTimeStatusViewController new];
            [self.controllersArray addObject:controller];
        } else if (i == 1) {
            
            RealTimeStatusViewController *controller = [RealTimeStatusViewController new];
            [self.controllersArray addObject:controller];
            
        }
        
        if (i == 0) {
            self.underView = [[UIView alloc] initWithFrame:CGRectMake(0, 36.5, ScreenWidth/2, 3.5)];
            [self.topBarScrollView addSubview:self.underView];
            self.underView.backgroundColor = SelectApp_tabbar_Style_Color;
            self.underView.center = CGPointMake(btn.center.x, self.underView.center.y);
        }
        [self.btnArray addObject:btn];
        tempBtn = btn;
    }
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight - NavHeight - 40);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - NavHeight - 40) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = HEXCOLOR(0xf1f1f1);
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"RealTimeStatusCell"];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.controllersArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RealTimeStatusCell" forIndexPath:indexPath];
    RealTimeStatusViewController *controller = self.controllersArray[indexPath.row];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    [cell.contentView addSubview:controller.view];
    
    if (indexPath.row == 0) {
        controller.temperatures = self.temperatures;
    } else {
        controller.healthContentArray = self.healthContentArray;
    }
    __weak typeof(self) weakSelf = self;
    controller.didRealTimeStatusBlock = ^{
        [weakSelf getData];
    };
    
    return cell;
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
        NSInteger tempIndex = scrollView.contentOffset.x/ScreenWidth;
        
        [self.curBtn setTitleColor:NormalApp_nav_Style_Color forState:UIControlStateNormal];
        
        UIButton *tempbtn = self.btnArray[tempIndex];
        [tempbtn setTitleColor:SelectApp_tabbar_Style_Color forState:UIControlStateNormal];
        self.curBtn = tempbtn;
        
        self.underView.center = CGPointMake(tempbtn.center.x, self.underView.center.y);
        
    }
}



- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Chassis/%@/Thermal",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result15) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSArray *temperatures = result15[@"Temperatures"];
        if (temperatures.isSureArray) {
            weakSelf.temperatures = temperatures;
        }
        
        NSDictionary *oem = result15[@"Oem"];
        if (oem.isSureDictionary) {
            NSDictionary *huawei = oem[@"Huawei"];
            if (huawei.isSureDictionary) {
                NSDictionary *fanSummary = huawei[@"FanSummary"];
                if (fanSummary.isSureDictionary) {
                    NSDictionary *status = fanSummary[@"Status"];
                    if (status.isSureDictionary) {
                        NSString *healthRollup = status[@"HealthRollup"];
                        if (healthRollup.isSureString) {
                            [weakSelf.healthContentArray replaceObjectAtIndex:0 withObject:healthRollup];
                        }
                    }
                }
                
                
                NSDictionary *temperatureSummary = huawei[@"TemperatureSummary"];
                if (temperatureSummary.isSureDictionary) {
                    NSDictionary *status = temperatureSummary[@"Status"];
                    if (status.isSureDictionary) {
                        NSString *healthRollup = status[@"HealthRollup"];
                        if (healthRollup.isSureString) {
                            [weakSelf.healthContentArray replaceObjectAtIndex:5 withObject:healthRollup];
                        }
                    }
                }
                
            }
        }
        
        [weakSelf.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
    
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Chassis/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result15) {
        
        NSDictionary *oem = result15[@"Oem"];
        if (oem.isSureDictionary) {
            NSDictionary *huawei = oem[@"Huawei"];
            if (huawei.isSureDictionary) {
                
                
                NSDictionary *powerSupplySummary = huawei[@"PowerSupplySummary"];
                if (powerSupplySummary.isSureDictionary) {
                    NSDictionary *status = powerSupplySummary[@"Status"];
                    if (status.isSureDictionary) {
                        NSString *healthRollup = status[@"HealthRollup"];
                        if (healthRollup.isSureString) {
                            [weakSelf.healthContentArray replaceObjectAtIndex:1 withObject:healthRollup];
                        }
                    }
                }
                
                NSDictionary *driveSummary = huawei[@"DriveSummary"];
                if (driveSummary.isSureDictionary) {
                    NSDictionary *status = driveSummary[@"Status"];
                    if (status.isSureDictionary) {
                        NSString *healthRollup = status[@"HealthRollup"];
                        if (healthRollup.isSureString) {
                            [weakSelf.healthContentArray replaceObjectAtIndex:2 withObject:healthRollup];
                        }
                    }
                }
                
                
                
            }
        }
        
        [weakSelf.collectionView reloadData];
        
    } failure:^(NSError *error) {
    }];
    
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        
        NSDictionary *processorSummary = result[@"ProcessorSummary"];
        if (processorSummary.isSureDictionary) {
            NSDictionary *status = processorSummary[@"Status"];
            if (status.isSureDictionary) {
                NSString *healthRollup = status[@"HealthRollup"];
                if (healthRollup.isSureString) {
                    [weakSelf.healthContentArray replaceObjectAtIndex:3 withObject:healthRollup];
                }
            }
        }
        
        NSDictionary *memorySummary = result[@"MemorySummary"];
        if (memorySummary.isSureDictionary) {
            NSDictionary *status = memorySummary[@"Status"];
            if (status.isSureDictionary) {
                NSString *healthRollup = status[@"HealthRollup"];
                if (healthRollup.isSureString) {
                    [weakSelf.healthContentArray replaceObjectAtIndex:4 withObject:healthRollup];
                }
            }
        }
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
