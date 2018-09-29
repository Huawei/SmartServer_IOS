//
//  ReportShowViewController.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/1.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "ReportShowViewController.h"
#import "UIWebView+GetPDF.h"
#import "FileUtils.h"

@interface ReportShowViewController ()<UIWebViewDelegate,UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) UIActivityViewController *activityVC;
@property (strong, nonatomic) UIDocumentInteractionController *documentController;

@end

@implementation ReportShowViewController {
    UIWebView *tempWebView;
    BOOL isFinishLoad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"report");
    self.view.backgroundColor = NormalApp_Line_Color;
    isFinishLoad = NO;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (@available(iOS 11.0, *)) {
        btn.frame = CGRectMake(0,0, 35, 44);
    } else {
        btn.frame = CGRectMake(0,0, 44, 44);
    }
    [btn setImage:[UIImage imageNamed:@"one_deviceReportShareIcon"] forState:UIControlStateNormal];
    UIBarButtonItem *nextbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem = nextbuttonitem;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight)];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.webView loadHTMLString:self.contentStr baseURL:nil];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    tempWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, webView.scrollView.contentSize.height)];
    [self.view addSubview:tempWebView];
    [self.view sendSubviewToBack:tempWebView];
    tempWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    [tempWebView loadHTMLString:self.contentStr baseURL:nil];
    
    isFinishLoad = YES;

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)shareAction {
    self.documentController = nil;
    self.activityVC = nil;
    if (!isFinishLoad) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    //显示弹出框列表选择
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:LocalString(@"sharefiletype") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:LocalString(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:LocalString(@"sharetypeimage") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        UIImage *temp = [self captureScrollView:tempWebView];
        
//        NSString *textToShare = LocalString(@"report");
//        //分享的图片
//        UIImage *imageToShare = temp;
//        //分享的url
////            NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];
//        //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
//        NSArray *activityItems = @[textToShare,imageToShare];
//        weakSelf.activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
////        weakSelf.activityVC = activityVC;
//        //不出现在活动项目
//        weakSelf.activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
//        [weakSelf presentViewController:weakSelf.activityVC animated:YES completion:nil];
//        // 分享之后的回调
//        weakSelf.activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
//            if (completed) {
//
//            } else  {
//
//            }
//        };
        
        NSString *temppath = [FileUtils getDocumentPath];
        
        BOOL isTrue = [FileUtils creatFile:[NSString stringWithFormat:@"%@/image.png",temppath] withData:UIImagePNGRepresentation(temp)];
        if (!isTrue) {
            return ;
        }
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/image.png",temppath]]];
        self.documentController.delegate = self;
//        self.documentController.UTI = @"com.image.png";
        [self.documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
//        [self.documentController presentPreviewAnimated:YES];

//        [self.documentController presentOpenInMenuFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES]
//    }
    }];
    UIAlertAction* pdfAction = [UIAlertAction actionWithTitle:@"PDF" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSData *data = [tempWebView PDFData];
        if (data) {
            
            NSString *temppath = [FileUtils getDocumentPath];
            
            BOOL isTrue = [FileUtils creatFile:[NSString stringWithFormat:@"%@/report.pdf",temppath] withData:data];
            if (!isTrue) {
                return ;
            }
            self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/report.pdf",temppath]]];
//            documentController.UTI = @"com.report.pdf";
            [self.documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        }

    }];
    [alert addAction:imageAction];
    [alert addAction:pdfAction];

    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}
- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller {
    return self.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    return self.view.frame;
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
    
}

- (UIImage *)captureScrollView:(UIWebView *)webView {
    CGFloat scale = 2;//[UIScreen mainScreen].scale;
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(webView.scrollView.contentSize, NO, scale);//原图
    [webView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        NSString *textToShare = LocalString(@"report");
        //分享的图片
        UIImage *imageToShare = image;
        //分享的url
        //    NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];
        //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
        NSArray *activityItems = @[textToShare,imageToShare];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        //不出现在活动项目
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
        [self presentViewController:activityVC animated:YES completion:nil];
        // 分享之后的回调
        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (completed) {
                BLLog(@"completed");
                //分享 成功
            } else  {
                NSLog(@"cancled");
                //分享 取消
            }
        };

        
    }
    
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
