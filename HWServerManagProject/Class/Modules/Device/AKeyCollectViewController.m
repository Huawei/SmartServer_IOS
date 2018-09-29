//
//  AKeyCollectViewController.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/4/9.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "AKeyCollectViewController.h"
#import "AddListCell.h"
#import "AkeyDocumentsViewController.h"
#import "DLSFTPConnection.h"
#import "DLSFTPFile.h"
#import "DLSFTPDownloadRequest.h"
#import "DLFileSizeFormatter.h"
#import "DLDocumentsDirectoryPath.h"
#import "AppDelegate.h"

@interface AKeyCollectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIButton *submitBtn;

@property (strong, nonatomic) NSTimer *timer;

@property (copy, nonatomic) NSString *port;
@property (copy, nonatomic) NSString *odata_id;


@property (nonatomic, strong) DLSFTPConnection *connection;
@property (nonatomic, strong) DLSFTPRequest *request;
@property (nonatomic, weak) MBProgressHUD *hud;



@end

@implementation AKeyCollectViewController {
    NSInteger timeSp;
    UILabel *alertLabel;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.timerEnable = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    AppDelegate *appdelgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelgate.timerEnable = YES;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"devicedetailcollection");
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = NormalApp_Line_Color;
    [self createBackBtn];
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 36;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.separatorColor = NormalApp_Line_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddListCell" bundle:nil] forCellReuseIdentifier:@"AddListCell"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = HEXCOLOR(0xF1F1F1);
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 110)];
    footerView.backgroundColor = [UIColor clearColor];
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn.frame = CGRectMake(12, 25, ScreenWidth - 24, 40);
    self.submitBtn.backgroundColor = RGBCOLOR(39, 177, 149);
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.submitBtn setTitle:LocalString(@"collectionkeybtn") forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:self.submitBtn];
    self.tableView.tableFooterView = footerView;
    [self.submitBtn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
    
    alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 25, ScreenWidth-24, 40)];
    [footerView addSubview:alertLabel];
    alertLabel.text = LocalString(@"akeycollectalert1");
    alertLabel.font = [UIFont systemFontOfSize:13];
    alertLabel.textColor = RGBCOLOR(39, 177, 149);;
    alertLabel.numberOfLines = 0;
    [alertLabel sizeToFit];
    self.submitBtn.frame = CGRectMake(12, alertLabel.bottom + 10, ScreenWidth - 24, 40);
    
    
    [self.tableView reloadData];

    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@/NetworkProtocol",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        NSDictionary *SSH = result[@"SSH"];
        if (SSH.isSureDictionary) {
            NSString *port = SSH[@"Port"];
            if (![port isKindOfClass:[NSNull class]]) {
                weakSelf.port = port;
                
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-30, 50)];
    label.text = LocalString(@"Storagedirectory");
    label.textColor = NormalApp_TableView_Title_Style_Color;
    label.font = [UIFont systemFontOfSize:14];
    [secView addSubview:label];
    return secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    secView.backgroundColor = [UIColor clearColor];
    return secView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddListCell"];
    cell.leftLabel.text = LocalString(@"path");
    cell.contentLabel.text = LocalString(@"sandbox");
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AkeyDocumentsViewController *vc = [AkeyDocumentsViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)createBackBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (@available(iOS 11.0, *)) {
        btn.frame = CGRectMake(0,0, 60, 44);
    } else {
        btn.frame = CGRectMake(0,0, 70, 44);
    }
    [btn setImage:[UIImage imageNamed:@"one_navBackicon"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:LocalString(@"back") forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *nextbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = nextbuttonitem;
    [nextbuttonitem setTintColor:HEXCOLOR(0xffffff)];
    
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collectAction {
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.label.text = LocalString(@"packaging");
    
    timeSp = [[NSDate date] timeIntervalSince1970];
    BLLog(@"timeSp:%ld",timeSp);
    NSString *content = [NSString stringWithFormat:@"/tmp/%ld.tar.gz",timeSp];//[NSString stringWithFormat:@"sftp://%@:%@@%@/usr/%ld.tar.gz",[HWGlobalData shared].curDevice.account,[HWGlobalData shared].curDevice.password,[HWGlobalData shared].curDevice.deviceName,timeinte];
    __weak typeof(self) weakSelf = self;
    [ABNetWorking postWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Managers/%@/Actions/Oem/Huawei/Manager.Dump",[HWGlobalData shared].curDevice.curServiceItem] parameters:@{@"Type":@"URI",@"Content":content} success:^(NSDictionary *result) {
        BLLog(@"%@",result);
//        [weakSelf getStatusAction];
        
        NSString *odata_id = result[@"@odata.id"];
        if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
            weakSelf.odata_id = odata_id;
            if (weakSelf.timer == nil) {
                weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:weakSelf selector:@selector(getTaskPercentageAction) userInfo:nil repeats:YES];
            } else {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }
            
        } else {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }

        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

    }];
    
}

- (void)getTaskPercentageAction {
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[self.odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
        
        BLLog(@"%@",result14);
        NSString *TaskState = result14[@"TaskState"];
        if (TaskState.isSureString && [TaskState isEqualToString:@"Completed"]) {
            if (weakSelf.timer) {
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }
            
            BLLog(@"任务进度完成。。。。。。。。。。。。。。。。。");
//            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            
            [weakSelf downloadFile];
            
        } else if (TaskState.isSureString && [TaskState isEqualToString:@"Running"]) {
        } else {
            if (weakSelf.timer) {
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }
            BLLog(@"任务进度异常。。。。。。。。。。。。。。。。。");
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }
        
        
        
    } failure:^(NSError *error) {
        if (weakSelf.timer) {
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
        }
        BLLog(@"任务进度异常。。。。。。。。。。。。。。。。。");
[MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
}



- (void)downloadFile {
    
    self.hud.label.text = LocalString(@"downloading");

    __weak typeof(self) weakSelf = self;
    DLSFTPConnection *connection = [[DLSFTPConnection alloc] initWithHostname:[HWGlobalData shared].curDevice.deviceName
                                                                         port:self.port.integerValue
                                                                     username:[HWGlobalData shared].curDevice.account
                                                                     password:[HWGlobalData shared].curDevice.password];
    self.connection = connection;
    DLSFTPClientSuccessBlock successBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf startDownload];
        });
    };
    
    DLSFTPClientFailureBlock failureBlock = ^(NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            weakSelf.connection = nil;
            // login failure
            NSString *title = [NSString stringWithFormat:@"%@ Error: %ld", error.domain, (long)error.code];
           
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            
           
            [alertView addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:nil]];

            [weakSelf.navigationController presentViewController:alertView animated:YES completion:nil];
        });
    };
    
    [connection connectWithSuccessBlock:successBlock
                           failureBlock:failureBlock];
}


- (void)startDownload {
  
    __weak typeof(self) weakSelf = self;
   
    __block UIBackgroundTaskIdentifier taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [weakSelf.request cancel];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    DLSFTPClientProgressBlock progressBlock = ^void(unsigned long long bytesReceived, unsigned long long bytesTotal) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            static DLFileSizeFormatter *formatter = nil;
//            if (formatter == nil) {
//                formatter = [[DLFileSizeFormatter alloc] init];
//            }
//            NSString *receivedString = [formatter stringFromSize:bytesReceived];
//            NSString *totalString = [formatter stringFromSize:bytesTotal];
            
        });
    };
    
    DLSFTPClientFileTransferSuccessBlock successBlock = ^(DLSFTPFile *file, NSDate *startTime, NSDate *finishTime) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            
            NSTimeInterval duration = round([finishTime timeIntervalSinceDate:startTime]);
            DLFileSizeFormatter *formatter = [[DLFileSizeFormatter alloc] init];
            unsigned long long rate = (file.attributes.fileSize / duration);
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:LocalString(@"downloadcomplete") message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:LocalString(@"share") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *localPath = [DLDocumentsDirectoryPath() stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.tar.gz",timeSp]];
                UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:localPath]];
                documentController.UTI = @"com.report.tar.gz";
                [documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:nil]];
            
            [weakSelf.navigationController presentViewController:alertView animated:YES completion:nil];
            [[UIApplication sharedApplication] endBackgroundTask:taskIdentifier];
        });
    };
    
    DLSFTPClientFailureBlock failureBlock = ^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSString *errorString = [NSString stringWithFormat:@"Error %ld", (long)error.code];

            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:errorString message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:LocalString(@"sure") style:UIAlertActionStyleDefault handler:nil]];
            
            [weakSelf.navigationController presentViewController:alertView animated:YES completion:nil];
            [[UIApplication sharedApplication] endBackgroundTask:taskIdentifier];
            [[UIApplication sharedApplication] endBackgroundTask:taskIdentifier];
        });
    };
    
    NSString *remotePath = [NSString stringWithFormat:@"/tmp/%ld.tar.gz",timeSp];
    NSString *localPath = [DLDocumentsDirectoryPath() stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.tar.gz",timeSp]];
    BLLog(@"localPath-----------%@",localPath);
    
    self.request = [[DLSFTPDownloadRequest alloc] initWithRemotePath:remotePath
                                                           localPath:localPath
                                                              resume:NO
                                                        successBlock:successBlock
                                                        failureBlock:failureBlock
                                                       progressBlock:progressBlock];
    [self.connection submitRequest:self.request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    BLLog(@"AKeyCollectViewController dealloc");
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
