//
//  HelpDetailViewController.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/5/18.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "HelpDetailViewController.h"

@interface HelpDetailViewController ()

@end

@implementation HelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight)];
    [self.view addSubview:webView];
    if ([self.htmlStr hasPrefix:@"http"]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.htmlStr]];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.htmlStr ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:path];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
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
