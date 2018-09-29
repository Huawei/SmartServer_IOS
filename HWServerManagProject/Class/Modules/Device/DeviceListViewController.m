//
//  DeviceListViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/2/4.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "DeviceListViewController.h"
#import "DeviceListCell.h"
#import "DeviceSearchViewController.h"
#import "DeviceDetailViewController.h"
#import "AddDeviceViewController.h"
#import "DeviceModel.h"
#import "HWNavigationController.h"
#import "QRCodeScanVC.h"
#import "FileUtils.h"

@interface DeviceListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) DeviceSearchViewController *searchResultVC;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSIndexPath *editingIndexPath;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSArray *searchArray;
@property (strong, nonatomic) UIDocumentInteractionController *documentController;

@property (copy, nonatomic) NSString *curSearhWord;

@end

@implementation DeviceListViewController {
    NoDeviceView *noDeviceView;

}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - TabHeight) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 67;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"DeviceListCell" bundle:nil] forCellReuseIdentifier:@"DeviceListCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        
    }
    
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
//    [ABNetWorking deleteWithSessionService:^{
//        
//    }];
    
//    if ([HWGlobalData shared].deviceDataArray.count == 0) {
//        noDeviceView.hidden = NO;
//    } else {
//        noDeviceView.hidden = YES;
//    }
    [self showSearhNoData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [ABNetWorking deleteWithSessionService:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LocalString(@"devicemanagement");
    self.automaticallyAdjustsScrollViewInsets = NO;
    noDeviceView = [NoDeviceView createFromBundle];
    [self.view addSubview:noDeviceView];
    noDeviceView.center = self.tableView.center;
    [self.tableView reloadData];
    
    [self createSearch];
    
    UIBarButtonItem *nextbuttonitem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"one_HomeAddBtnicon"] style:UIBarButtonItemStyleDone target:self action:@selector(addtAction)];
    UIBarButtonItem *nextbuttonitem2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"one_navScanIcon"] style:UIBarButtonItemStyleDone target:self action:@selector(scanAction)];
    self.navigationItem.rightBarButtonItems = @[nextbuttonitem,nextbuttonitem2];
    [nextbuttonitem setTintColor:HEXCOLOR(0xffffff)];
    [nextbuttonitem2 setTintColor:HEXCOLOR(0xffffff)];

    [nextbuttonitem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:40],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [nextbuttonitem2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:40],NSFontAttributeName, nil] forState:UIControlStateHighlighted];
    [nextbuttonitem2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:40],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [nextbuttonitem2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:40],NSFontAttributeName, nil] forState:UIControlStateHighlighted];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguageAction) name:@"changeLanguagesNoti" object:nil];
}

- (void)changeLanguageAction {
    self.title = LocalString(@"devicemanagement");
    self.navigationItem.title = LocalString(@"devicemanagement");
    self.searchController.searchBar.placeholder = LocalString(@"search");
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.editingIndexPath) {
        [self configSwipeButtons];
    }
}
- (void)configSwipeButtons {
    // 获取选项按钮的reference
    if (@available(iOS 11.0, *)) {
        
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        for (UIView *subview in self.tableView.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subview.subviews count] >= 2) {
                // 和iOS 10的按钮顺序相反
                UIButton *deleteButton = subview.subviews[1];
                UIButton *editButton = subview.subviews[0];
                [editButton setTitle:@"" forState:UIControlStateNormal];
                [editButton setImage:[UIImage imageNamed:@"one_cellediticon"] forState:UIControlStateNormal];
                [deleteButton setTitle:@"" forState:UIControlStateNormal];
                [deleteButton setImage:[UIImage imageNamed:@"one_celldeleteicon"] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)createSearch {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    if (@available(iOS 11.0, *)) {
        headerView.frame = CGRectMake(0, 0, ScreenWidth, 60);
    } else {
        headerView.frame = CGRectMake(0, 0, ScreenWidth, 48);
    }
    self.tableView.tableHeaderView = headerView;
    headerView.backgroundColor = [UIColor clearColor];
    
    self.searchResultVC = [[DeviceSearchViewController alloc] init];
    self.searchResultVC.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:self.searchResultVC];
    search.delegate = self;
    search.searchResultsUpdater = self;
//    search.hidesNavigationBarDuringPresentation = YES;
    self.searchController = search;
    search.searchBar.placeholder = LocalString(@"search");
    [search.searchBar sizeToFit];
    search.searchBar.placeholder = LocalString(@"search");
    UITextField *txfSearchField = [search.searchBar valueForKey:@"_searchField"];
    txfSearchField.textColor = HEXCOLOR(0x25c4a4);
    txfSearchField.layer.cornerRadius = 3;
    txfSearchField.layer.masksToBounds = YES;
    txfSearchField.backgroundColor = HEXCOLOR(0xf7f2f7);
    txfSearchField.font = [UIFont systemFontOfSize:14];
    UIImage* searchBarBg = [self GetImageWithColor:[UIColor whiteColor] andHeight:56];
    [search.searchBar setBackgroundImage:searchBarBg];
    [search.searchBar setBackgroundColor:[UIColor whiteColor]];
    search.dimsBackgroundDuringPresentation = NO;
    search.searchBar.delegate = self;
    [headerView addSubview:search.searchBar];
    
    self.definesPresentationContext = YES;
    if (@available(iOS 11.0, *)) {
       search.searchBar.frame = CGRectMake(0, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 56);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 56, ScreenWidth, 1)];
        line.backgroundColor = NormalApp_Line_Color;
        [headerView addSubview:line];
    } else {
        search.searchBar.frame = CGRectMake(0, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 47, ScreenWidth, 1)];
        line.backgroundColor = NormalApp_Line_Color;
        [headerView addSubview:line];
    }
    
    
    search.searchResultsController.view.hidden = NO;

    __weak typeof(self) weakSelf = self;
    self.searchResultVC.didSelectWordBlock = ^(NSString *word) {
        weakSelf.searchController.searchBar.text = word;
        weakSelf.curSearhWord = word;
        if (word.length > 0) {
            
            NSString *inputStr = word;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.otherName contains [cd] %@ || SELF.deviceName contains [cd] %@", inputStr,inputStr];
            
            NSArray *filterdArray = [[HWGlobalData shared].deviceDataArray filteredArrayUsingPredicate:predicate];
            
            weakSelf.searchArray = filterdArray;
        } else {
            weakSelf.searchArray = nil;
        }
        [weakSelf.tableView reloadData];
        [weakSelf showSearhNoData];
    };
    
    NSArray *wordarr = [[NSUserDefaults standardUserDefaults] objectForKey:@"historysearhwordkey"];
    if (wordarr && wordarr.count > 0) {
        [self.searchResultVC.wordArray addObjectsFromArray:wordarr];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchArray) {
        return self.searchArray.count;
    }
    return [HWGlobalData shared].deviceDataArray.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LocalString(@"delete");
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    self.editingIndexPath = indexPath;
    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    self.editingIndexPath = nil;
}

//这个方法就是可以自己添加一些侧滑出来的按钮，并执行一些命令和按钮设置
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:LocalString(@"delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if (self.searchArray) {
            if (indexPath.row < self.searchArray.count) {
                DeviceModel *devicemodel = self.searchArray[indexPath.row];
                [[HWGlobalData shared] deleteHistoryDevice:devicemodel];
                [[HWGlobalData shared].deviceDataArray removeObject:devicemodel];
                [[HWGlobalData shared] saveCurAllDevice];
                [tableView reloadData];
                if (self.searchArray.count == 0) {
                    noDeviceView.hidden = NO;
                }
                
                [self searchBarSearchButtonClicked:self.searchController.searchBar];
            }
        } else {
            if (indexPath.row < [HWGlobalData shared].deviceDataArray.count) {
                [[HWGlobalData shared] deleteHistoryDevice:[HWGlobalData shared].deviceDataArray[indexPath.row]];
                [[HWGlobalData shared].deviceDataArray removeObjectAtIndex:indexPath.row];
                [[HWGlobalData shared] saveCurAllDevice];
                [tableView reloadData];
                if ([HWGlobalData shared].deviceDataArray.count == 0) {
                    noDeviceView.hidden = NO;
                }
            }
        }
        
    }];
    
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:LocalString(@"edit") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
        
        
        AddDeviceViewController *vc = [AddDeviceViewController new];
        if (self.searchArray) {
            vc.model = self.searchArray[indexPath.row];
            if (vc.model.isKeepPwd == NO) {
                vc.model.password = @"";
            }

        } else {
            vc.model = [HWGlobalData shared].deviceDataArray[indexPath.row];
            if (vc.model.isKeepPwd == NO) {
                vc.model.password = @"";
            }
        }
        [weakSelf.navigationController pushViewController:vc animated:YES];
        

    }];
    
    action.backgroundColor = RGBCOLOR(250, 76, 106);
    action1.backgroundColor = RGBCOLOR(49, 195, 165);
    return @[action,action1];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceListCell"];
    cell.countLabel.hidden = YES;
    
    if (self.searchArray) {
        DeviceModel *model = self.searchArray[indexPath.row];
        cell.otherNameLabel.text = model.otherName;
        cell.nameLabel.text = model.deviceName;
        
        return cell;
    } else {
        DeviceModel *model = [HWGlobalData shared].deviceDataArray[indexPath.row];
        cell.otherNameLabel.text = model.otherName;
        cell.nameLabel.text = model.deviceName;
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    UIImage *temp = [UIImage imageNamed:@"12333"];
//    
//    NSString *temppath = [FileUtils getDocumentPath];
//    
//    BOOL isTrue = [FileUtils creatFile:[NSString stringWithFormat:@"%@/image.png",temppath] withData:UIImagePNGRepresentation(temp)];
//    if (!isTrue) {
//        return ;
//    }
//    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/image.png",temppath]]];
//    //        self.documentController.UTI = @"com.image.png";
//    [self.documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
//    
//    return;
    if (self.searchArray) {
        [HWGlobalData shared].curDevice = self.searchArray[indexPath.row];
    } else {
        [HWGlobalData shared].curDevice = [HWGlobalData shared].deviceDataArray[indexPath.row];
    }
    
    
    if ([HWGlobalData shared].curDevice.isKeepPwd) {
        DeviceDetailViewController *vc = [DeviceDetailViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalString(@"validation")
                                                                                 message:[HWGlobalData shared].curDevice.otherName
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = LocalString(@"Pleaseenterpassword");
            textField.secureTextEntry = YES;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textF = alertController.textFields.firstObject;
            
//            if ([textF.text isEqualToString:[HWGlobalData shared].curDevice.password]) {
//                DeviceDetailViewController *vc = [DeviceDetailViewController new];
//                [self.navigationController pushViewController:vc animated:YES];
//            } else {
//                [self.tabBarController.view makeToast:LocalString(@"pwdmistake")];
//            }
            if (textF.text.length > 0) {
                [HWGlobalData shared].curDevice.password = textF.text;
                DeviceDetailViewController *vc = [DeviceDetailViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self.tabBarController.view makeToast:LocalString(@"pleaseinputdpwd")];
            }
            
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}

- (void)addtAction {
    AddDeviceViewController *vc = [[AddDeviceViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scanAction {
    
    QRCodeScanVC *vc = [[QRCodeScanVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    searchController.searchResultsController.view.hidden = NO;

   
    
}

//- (void)willPresentSearchController:(UISearchController *)searchController {
//    searchController.searchBar.frame = CGRectMake(0, 0, ScreenWidth, 56);
//}
//- (void)didPresentSearchController:(UISearchController *)searchController {
//    [searchController.searchBar becomeFirstResponder];
//}
//- (void)willDismissSearchController:(UISearchController *)searchController {
//    searchController.searchBar.frame = CGRectMake(15, 0, ScreenWidth-30, 44);
//
//
//}
- (void)didDismissSearchController:(UISearchController *)searchController {

}

- (void)willPresentSearchController:(UISearchController *)searchController {
    UIView *searchBarTextField = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
        UIView *searchBackground = [[searchController.searchBar.subviews.firstObject subviews] objectAtIndex:0];
        searchBackground.alpha = 0;
        
        searchBarTextField = [[searchController.searchBar.subviews.firstObject subviews] objectAtIndex:1];
    } else {
    }
  
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchResultVC dismissViewControllerAnimated:YES completion:nil];
    self.curSearhWord = searchBar.text;
    if (searchBar.text.length > 0) {
        BOOL isHave = NO;
        for (NSString *value in self.searchResultVC.wordArray) {
            if ([value isEqualToString:searchBar.text]) {
                isHave = YES;
                break;
            }
        }
        if (!isHave) {
            [self.searchResultVC.wordArray addObject:searchBar.text];
            [[NSUserDefaults standardUserDefaults] setObject:self.searchResultVC.wordArray forKey:@"historysearhwordkey"];
        }
        
        NSString *inputStr = self.searchController.searchBar.text ;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.otherName contains [cd] %@ || SELF.deviceName contains [cd] %@", inputStr,inputStr];
        
        NSArray *filterdArray = [[HWGlobalData shared].deviceDataArray filteredArrayUsingPredicate:predicate];
        
        self.searchArray = filterdArray;
        
    } else {
        self.searchArray = nil;
    }
    [self.tableView reloadData];
    
    [self showSearhNoData];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.curSearhWord = nil;
    self.searchArray = nil;
    [self showSearhNoData];
    [self.tableView reloadData];
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

- (void)showSearhNoData {
    if (self.searchArray == nil && [HWGlobalData shared].deviceDataArray.count == 0) {
        noDeviceView.hidden = NO;
    } else if (self.searchArray != nil && self.searchArray.count == 0) {
        noDeviceView.hidden = NO;
    } else {
        noDeviceView.hidden = YES;
    }
    [self.view bringSubviewToFront:noDeviceView];
}



@end

