//
//  PowerSwitchMainViewController.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/4/16.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "PowerSwitchMainViewController.h"
#import "PowerSwitchMainOneCell.h"
#import "PowerSwitchMainTwoCell.h"

@interface PowerSwitchMainViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *topBarScrollView;
@property (strong, nonatomic) UIView *underView;

@property (strong, nonatomic) NSMutableArray *btnArray;
@property (strong, nonatomic) UIButton *curBtn;

@end

@implementation PowerSwitchMainViewController


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
        _topBarScrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_topBarScrollView];
        if (@available(iOS 11.0, *)) {
            _topBarScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, ScreenWidth, 0.5)];
        line.backgroundColor = HEXCOLOR(0xd8d8d8);
        [self.view addSubview:line];
    }
    return _topBarScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"devicedetailcontrol");
    
    NSArray *titleArray = @[LocalString(@"devicedetailcontrol"),LocalString(@"powerofftimeout")];
    UIButton *tempBtn = nil;
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((ScreenWidth/2)*i, 0,ScreenWidth/2, 50);
        if (i == 0) {
            self.curBtn = btn;
            [btn setTitleColor:SelectApp_tabbar_Style_Color forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:NormalApp_nav_Style_Color forState:UIControlStateNormal];
            
        }
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.topBarScrollView addSubview:btn];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            self.underView = [[UIView alloc] initWithFrame:CGRectMake(0, 46, ScreenWidth/2, 4)];
            [self.topBarScrollView addSubview:self.underView];
            self.underView.backgroundColor = SelectApp_tabbar_Style_Color;
            self.underView.center = CGPointMake(btn.center.x, self.underView.center.y);
        }
        [self.btnArray addObject:btn];
        tempBtn = btn;
    }
    
    
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
    [self.collectionView registerNib:[UINib nibWithNibName:@"PowerSwitchMainOneCell" bundle:nil] forCellWithReuseIdentifier:@"PowerSwitchMainOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PowerSwitchMainTwoCell" bundle:nil] forCellWithReuseIdentifier:@"PowerSwitchMainTwoCell"];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PowerSwitchMainOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PowerSwitchMainOneCell" forIndexPath:indexPath];
        cell.powerStateStr = self.powerStateStr;
        __weak typeof(self) weakSelf = self;
        cell.didControlCompleteBlock = ^(NSString *powerStateStr) {
            if (weakSelf.didControlMainCompleteBlock) {
                weakSelf.didControlMainCompleteBlock(powerStateStr);
            }
        };
        return cell;

    } else {
        PowerSwitchMainTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PowerSwitchMainTwoCell" forIndexPath:indexPath];
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



@end
