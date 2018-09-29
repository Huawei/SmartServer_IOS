//
//  HealthMainViewController.m
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/3/12.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HealthMainViewController.h"
#import "HealthEventsViewController.h"
//#import "YYCache.h"

@interface HealthMainViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *topBarScrollView;
@property (strong, nonatomic) UIView *underView;

@property (strong, nonatomic) NSMutableArray *controllersArray;
@property (strong, nonatomic) NSMutableArray *btnArray;
@property (strong, nonatomic) UIButton *curBtn;

@property (copy, nonatomic) NSString *odataid;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *data1Array;
@property (strong, nonatomic) NSMutableArray *data2Array;


@end

@implementation HealthMainViewController

- (NSMutableArray *)controllersArray {
    if (!_controllersArray) {
        _controllersArray = [NSMutableArray array];
    }
    return _controllersArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)data1Array {
    if (!_data1Array) {
        _data1Array = [NSMutableArray array];
    }
    return _data1Array;
}

- (NSMutableArray *)data2Array {
    if (!_data2Array) {
        _data2Array = [NSMutableArray array];
    }
    return _data2Array;
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
    }
    return _topBarScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"currentwarming");
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self cacheDataGet];
    
    UIButton *tempBtn = nil;
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            self.curBtn = btn;
            [btn setTitleColor:SelectApp_tabbar_Style_Color forState:UIControlStateNormal];
            [btn setTitle:LocalString(@"all") forState:UIControlStateNormal];
        } else if (i == 1) {
            [btn setTitleColor:NormalApp_nav_Style_Color forState:UIControlStateNormal];
            [btn setTitle:LocalString(@"critical") forState:UIControlStateNormal];
        } else if (i == 2) {
            [btn setTitleColor:NormalApp_nav_Style_Color forState:UIControlStateNormal];
            [btn setTitle:LocalString(@"major") forState:UIControlStateNormal];
        }
        
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.topBarScrollView addSubview:btn];
        [btn sizeToFit];
        btn.frame = CGRectMake(btn.frame.origin.x, 0, btn.frame.size.width, 42);
        
        btn.tag = i;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            btn.frame = CGRectMake(0, 0,ScreenWidth/3, 50);
            HealthEventsViewController *controller = [HealthEventsViewController new];
//            controller.logServices = self.logServices;
            [self.controllersArray addObject:controller];
        } else if (i == 1) {
            btn.frame = CGRectMake((ScreenWidth)/3, 0,ScreenWidth/3, 50);
            HealthEventsViewController *controller = [HealthEventsViewController new];
//            controller.logServices = self.logServices;
            [self.controllersArray addObject:controller];
            
        } else if (i == 2) {
            btn.frame = CGRectMake(ScreenWidth*2/3, 0,ScreenWidth/3, 50);
            HealthEventsViewController *controller = [HealthEventsViewController new];
//            controller.logServices = self.logServices;
            [self.controllersArray addObject:controller];
            
        }
        if (i == 0) {
            self.underView = [[UIView alloc] initWithFrame:CGRectMake(0, 46.5, ScreenWidth/3, 3.5)];
            [self.topBarScrollView addSubview:self.underView];
            self.underView.backgroundColor = SelectApp_tabbar_Style_Color;
            self.underView.center = CGPointMake(btn.center.x, self.underView.center.y);
        }
        [self.btnArray addObject:btn];
        tempBtn = btn;
    }
    
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 15)];
    line.backgroundColor = NormalApp_Line_Color;
    [self.view addSubview:line];
    
    
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
    self.collectionView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"HealthMainCell"];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self getData];
}

- (void)cacheDataGet {
    NSDictionary *result15 = [[NSUserDefaults standardUserDefaults] objectForKey:@"healthdatacache"];
    if (result15 != nil) {
        NSDictionary *oem = result15[@"Oem"];
        if (oem.isSureDictionary) {
            NSDictionary *huawei = oem[@"Huawei"];
            
            if (huawei.isSureDictionary) {
                [self.dataArray removeAllObjects];
                [self.data1Array removeAllObjects];
                [self.data2Array removeAllObjects];
                
                NSArray *healthEvent = huawei[@"HealthEvent"];
                for (NSDictionary *dic in healthEvent) {
                    [self.dataArray addObject:dic];
                    NSString *severity = dic[@"Severity"];
                    if (severity.isSureString && [severity isEqualToString:@"OK"]) {
                    } else if (severity.isSureString && [severity isEqualToString:@"Warning"]) {
                        [self.data2Array addObject:dic];
                    } else if (severity.isSureString && [severity isEqualToString:@"Critical"]) {
                        [self.data1Array addObject:dic];
                    }
                }
            }
        }
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.controllersArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HealthMainCell" forIndexPath:indexPath];
    
    HealthEventsViewController *controller = self.controllersArray[indexPath.row];
    
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    [cell.contentView addSubview:controller.view];
    switch (indexPath.row) {
        case 0:
            controller.dataArray = self.dataArray;
            break;
        case 1:
            controller.dataArray = self.data1Array;
            break;
        case 2:
            controller.dataArray = self.data2Array;
            break;
       
        default:
            break;
    }
    __weak typeof(self) weakSelf = self;
    controller.didRefreshBlock = ^{
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
    if (self.logServices.length > 0) {
        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [ABNetWorking getWithUrlWithAction:[self.logServices substringFromIndex:1] parameters:nil success:^(NSDictionary *result15) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSArray *Members = result15[@"Members"];
            
            if (Members && [Members isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in Members) {
                    NSString *odata_id = dic[@"@odata.id"];
                    if (odata_id.isSureString && odata_id.length > 0) {
                        
//                        [weakSelf.collectionView reloadData];
                        [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result15) {
                            
                            [[NSUserDefaults standardUserDefaults] setObject:[weakSelf removeNullFromDictionary:result15] forKey:@"healthdatacache"];
                            NSDictionary *oem = result15[@"Oem"];
                            if (oem.isSureDictionary) {
                                NSDictionary *huawei = oem[@"Huawei"];
                                
                                if (huawei.isSureDictionary) {
                                    [weakSelf.dataArray removeAllObjects];
                                    [weakSelf.data1Array removeAllObjects];
                                    [weakSelf.data2Array removeAllObjects];
                                    
                                    NSArray *healthEvent = huawei[@"HealthEvent"];
                                    for (NSDictionary *dic in healthEvent) {
                                        [weakSelf.dataArray addObject:dic];
                                        NSString *severity = dic[@"Severity"];
                                        if (severity.isSureString && [severity isEqualToString:@"OK"]) {
                                        } else if (severity.isSureString && [severity isEqualToString:@"Warning"]) {
                                            [weakSelf.data2Array addObject:dic];
                                        } else if (severity.isSureString && [severity isEqualToString:@"Critical"]) {
                                            [weakSelf.data1Array addObject:dic];
                                        }
                                    }
                                }
                            }
                            [weakSelf.collectionView reloadData];
                            
                        } failure:^(NSError *error) {
                            [weakSelf.collectionView reloadData];
                        }];
                        break;
                    }
                }   
            }
            [weakSelf.collectionView reloadData];

        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.collectionView reloadData];
        }];
    } else {
        
        __weak typeof(self) weakSelf = self;
        [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
            
            NSDictionary *LogServices = result[@"LogServices"];
            if (LogServices.isSureDictionary) {
                weakSelf.logServices = LogServices[@"@odata.id"];
                [weakSelf getData];
            }
        } failure:^(NSError *error) {
            
        }];
        [self.collectionView reloadData];
    }
}


- (NSMutableDictionary *)removeNullFromDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (NSString *strKey in dic.allKeys) {
        NSValue *value = dic[strKey];
        // 删除NSDictionary中的NSNull，再保存进字典
        if ([value isKindOfClass:NSDictionary.class]) {
            mdic[strKey] = [self removeNullFromDictionary:(NSDictionary *)value];
        }
        // 删除NSArray中的NSNull，再保存进字典removeNullFromArray
        else if ([value isKindOfClass:NSArray.class]) {
            mdic[strKey] = [self removeNullFromArray:(NSArray *)value];
        }
        // 剩余的非NSNull类型的数据保存进字典
        else if (![value isKindOfClass:NSNull.class]) {
            mdic[strKey] = dic[strKey];
        }
    }
    return mdic;
}

- (NSMutableArray *)removeNullFromArray:(NSArray *)arr
{
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        NSValue *value = arr[i];
        // 删除NSDictionary中的NSNull，再添加进数组
        if ([value isKindOfClass:NSDictionary.class]) {
            [marr addObject:[self removeNullFromDictionary:(NSDictionary *)value]];
        }
        // 删除NSArray中的NSNull，再添加进数组
        else if ([value isKindOfClass:NSArray.class]) {
            [marr addObject:[self removeNullFromArray:(NSArray *)value]];
        }
        // 剩余的非NSNull类型的数据添加进数组
        else if (![value isKindOfClass:NSNull.class]) {
            [marr addObject:value];
        }
    }
    return marr;
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

