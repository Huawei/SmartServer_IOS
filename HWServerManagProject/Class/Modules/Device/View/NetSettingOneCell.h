//
//  NetSettingOneCell.h
//  HWServerManagProject
//
//  Created by xunruiIOS on 2018/2/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidRefreshHostBlock)(NSDictionary *data, NSString *odata_id);

@interface NetSettingOneCell : UICollectionViewCell

@property (copy, nonatomic) NSString *hostName;
@property (strong, nonatomic) IBOutlet UITextField *inputTF;
@property (copy, nonatomic) NSString *odata_id;

@property (copy, nonatomic) DidRefreshHostBlock didRefreshHostBlock;

@end
