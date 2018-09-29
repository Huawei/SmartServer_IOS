//
//  UIScrollView+GetPDF.m
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/2.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "UIWebView+GetPDF.h"

@implementation UIWebView (GetPDF)

- (NSData *)PDFData {
    NSMutableData * pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData( pdfData, self.bounds, nil );
    UIGraphicsBeginPDFPage();
    [self.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIGraphicsEndPDFContext();
    return pdfData;
}

@end
