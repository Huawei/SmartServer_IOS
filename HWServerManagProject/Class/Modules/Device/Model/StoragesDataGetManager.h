//
//  StoragesDataGetManager.h
//  HWServerManagProject
//
//  Created by chenzx on 2018/9/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DidFinishGetStoragesDataBlock)(NSString *string);

@interface StoragesDataGetManager : NSObject

@property (copy, nonatomic) DidFinishGetStoragesDataBlock resultBlock;
@property (assign, nonatomic) NSInteger dataIndex;

- (void)getStoragesData:(DidFinishGetStoragesDataBlock)completeBlock;

@end
