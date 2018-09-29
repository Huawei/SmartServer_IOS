//
//  SysLogModel.h
//  HWServerManagProject
//
//  Created by 陈主祥 on 2018/4/17.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysLogModel : NSObject

@property (assign, nonatomic) BOOL isShowAll;
@property (copy, nonatomic) NSString *Id;
@property (copy, nonatomic) NSString *EventSubject;
@property (copy, nonatomic) NSString *Created;
@property (copy, nonatomic) NSString *Severity;
@property (copy, nonatomic) NSString *Message;
@property (copy, nonatomic) NSString *EventId;
@property (copy, nonatomic) NSString *Status;
@property (copy, nonatomic) NSString *Suggest;

@end
