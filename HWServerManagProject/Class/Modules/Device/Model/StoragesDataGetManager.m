//
//  StoragesDataGetManager.m
//  HWServerManagProject
//
//  Created by chenzx on 2018/9/6.
//  Copyright © 2018年 陈主祥. All rights reserved.
//

#import "StoragesDataGetManager.h"

@interface StoragesDataGetManager()

@property (strong, nonatomic) NSArray *storagesMembers;

@end

@implementation StoragesDataGetManager

- (void)getStoragesData:(DidFinishGetStoragesDataBlock)completeBlock {
    self.resultBlock = completeBlock;
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[NSString stringWithFormat:@"redfish/v1/Systems/%@/Storages",[HWGlobalData shared].curDevice.curServiceItem] parameters:nil success:^(NSDictionary *result) {
        
        NSArray *Members = result[@"Members"];
        
        if (Members && [Members isKindOfClass:[NSArray class]] && Members.count > 0) {
            NSMutableString *tempstr1 = [NSMutableString new];
            [tempstr1 appendFormat:@"<div><h3>%@</h3>",LocalString(@"reportstorage")];
            weakSelf.dataIndex = 0;
            weakSelf.storagesMembers = Members;
            [weakSelf getStoragesDataIndex:Members contentString:tempstr1 withIndex:weakSelf.dataIndex];
            
        } else {
            
            completeBlock(@"");
        }
        
    } failure:^(NSError *error) {
        completeBlock(nil);
    }];
}


- (void)getStoragesDataIndex:(NSArray *)members contentString:(NSMutableString *)tempstr1 withIndex:(NSInteger)index{
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = members[index];
    NSString *odata_id = dic[@"@odata.id"];
    if (odata_id && [odata_id isKindOfClass:[NSString class]] && odata_id.length > 0) {
        
        [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result14) {
            
            [tempstr1 appendFormat:@"<table>"];
            
            NSArray *StorageControllers = result14[@"StorageControllers"];
            NSDictionary *StorageController = nil;
            if (StorageControllers.isSureArray && StorageControllers.count > 0) {
                StorageController = [StorageControllers firstObject];
                
                NSDictionary *status = StorageController[@"Status"];
                if (status.isSureDictionary) {
                    NSString *health = status[@"Health"];
                    if (health.isSureString) {
                        if ([health isEqualToString:@"OK"]) {
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",StorageController[@"Name"],LocalString(@"ok")];
                            
                        } else  if ([health isEqualToString:@"Warning"]) {
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",StorageController[@"Name"],LocalString(@"warning")];
                            
                        } else {
                            [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",StorageController[@"Name"],LocalString(@"critical")];
                        }
                    }
                } else {
                    [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",StorageController[@"Name"],@""];
                }
                
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_name"),StorageController[@"Model"]];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_power_label_firmware_version"),StorageController[@"FirmwareVersion"]];
                
                NSString *RAIDtempstr = @"";
                NSDictionary *Oem = StorageController[@"Oem"];
                if (Oem.isSureDictionary) {
                    NSDictionary *Huawei = Oem[@"Huawei"];
                    if (Huawei.isSureDictionary) {
                        NSArray *SupportedRAIDLevels = Huawei[@"SupportedRAIDLevels"];
                        if (SupportedRAIDLevels.isSureArray) {
                            NSMutableString *str = [NSMutableString new];
                            for (NSString *item in SupportedRAIDLevels) {
                                [str appendFormat:@"%@,",[item stringByReplacingOccurrencesOfString:@"RAID" withString:@""]];
                            }
                            if (str.length > 0) {
                                [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
                                RAIDtempstr = [NSString stringWithFormat:@"RAID(%@) ",str];
                            } else {
                                RAIDtempstr = [NSString stringWithFormat:@"-"];
                            }
                            
                        }
                    }
                }
                
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_support_raid_level"),RAIDtempstr];
                
                NSString *ConfigurationVersion = @"";
                NSString *MemorySizeMiB = @"";
                NSString *SASAddress = @"";
                NSString *MinMaxStripeSizeBytes = @"";
                NSString *MaintainPDFailHistoryState = @"";
                NSString *CopyBackStateState = @"";
                NSString *SmarterCopyBackStateState = @"";
                NSString *JBODStateState = @"";
                NSString *CapacitanceName = @"";
                NSString *CapacitanceStatus = @"";
                NSDictionary *oem = StorageController[@"Oem"];
                if (oem.isSureDictionary) {
                    NSDictionary *huawei = oem[@"Huawei"];
                    if (huawei.isSureDictionary) {
                        
                        ConfigurationVersion = huawei[@"ConfigurationVersion"];
                        MemorySizeMiB = [NSString stringWithFormat:@"%@MB",huawei[@"MemorySizeMiB"]];
                        SASAddress = [NSString stringWithFormat:@"%@",huawei[@"SASAddress"]];
                        
                        NSString *MaxStripeSizeBytes = [NSString stringWithFormat:@"%@",huawei[@"MaxStripeSizeBytes"]];
                        NSString *MinStripeSizeBytes = [NSString stringWithFormat:@"%@",huawei[@"MinStripeSizeBytes"]];
                        
                        MinMaxStripeSizeBytes = [NSString stringWithFormat:@"%@-%@",MinStripeSizeBytes.toMemoryBString,MaxStripeSizeBytes.toMemoryBString];
                        
                        NSString *MaintainPDFailHistory = huawei[@"MaintainPDFailHistory"];
                        if (MaintainPDFailHistory && ![MaintainPDFailHistory isKindOfClass:[NSNull class]]) {
                            if (MaintainPDFailHistory.integerValue == 1) {
                                MaintainPDFailHistoryState = LocalString(@"resource_state_enabled");
                            } else {
                                MaintainPDFailHistoryState = LocalString(@"resource_state_disabled");
                            }
                        }
                        
                        NSString *CopyBackState = huawei[@"CopyBackState"];
                        if (CopyBackState && ![CopyBackState isKindOfClass:[NSNull class]]) {
                            
                            if (CopyBackState.integerValue == 1) {
                                CopyBackStateState = LocalString(@"resource_state_enabled");
                            } else {
                                CopyBackStateState = LocalString(@"resource_state_disabled");
                            }
                        }
                        
                        NSString *SmarterCopyBackState = huawei[@"SmarterCopyBackState"];
                        if (SmarterCopyBackState && ![SmarterCopyBackState isKindOfClass:[NSNull class]]) {
                            if (SmarterCopyBackState.integerValue == 1) {
                                SmarterCopyBackStateState = LocalString(@"resource_state_enabled");
                            } else {
                                SmarterCopyBackStateState = LocalString(@"resource_state_disabled");
                            }
                        }
                        
                        
                        NSString *JBODState = huawei[@"JBODState"];
                        if (JBODState && ![JBODState isKindOfClass:[NSNull class]]) {
                            
                            if (JBODState.integerValue == 1) {
                                JBODStateState = LocalString(@"resource_state_enabled");
                            } else {
                                JBODStateState = LocalString(@"resource_state_disabled");
                            }
                        }
                        
                        NSString *capacitanceName = huawei[@"CapacitanceName"];
                        if (capacitanceName && ![capacitanceName isKindOfClass:[NSNull class]]) {
                            CapacitanceName = capacitanceName;
                        }
                        
                        NSDictionary *capacitanceStatus = huawei[@"CapacitanceStatus"];
                        if (capacitanceStatus.isSureDictionary) {
                            NSString *health = capacitanceStatus[@"Health"];
                            if (health.isSureString) {
                                if ([health isEqualToString:@"OK"]) {
                                    CapacitanceStatus = LocalString(@"ok");
                                } else  if ([health isEqualToString:@"Warning"]) {
                                    CapacitanceStatus = LocalString(@"warning");
                                } else {
                                    CapacitanceStatus = LocalString(@"critical");
                                }
                            }
                        }
                    }
                }
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_configure_version"),ConfigurationVersion];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_memory_size_MB"),MemorySizeMiB];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@GB</td></tr>",LocalString(@"hardware_storage_label_speed"),StorageController[@"SpeedGbps"]];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_sas_addr"),SASAddress];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_stripe_range"),MinMaxStripeSizeBytes];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_maintain_pd_fail_history"),MaintainPDFailHistoryState];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_copy_back_state"),CopyBackStateState];
                
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_smart_copy_back_state"),SmarterCopyBackStateState];
                
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_JOBD_state"),JBODStateState];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_bbu_name"),CapacitanceName];
                [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"hardware_storage_label_bbu_state"),CapacitanceStatus];
            }
            
            [tempstr1 appendString:@"</table>"];
            
            //逻辑盘列表
            NSDictionary *volumes = result14[@"Volumes"];
            NSArray *drives = result14[@"Drives"];
            if (volumes.isSureDictionary) {
                NSString *volumesId = volumes[@"@odata.id"];
                if (volumesId.isSureString && volumesId.length > 0) {
                    [weakSelf getStoragesLogicalDisk:volumesId contentString:tempstr1 drives:drives];
                } else {
                    //物理盘列表
                    [weakSelf getDrives:drives contentString:tempstr1];
                }
            } else {
                //物理盘列表
                [weakSelf getDrives:drives contentString:tempstr1];
            }
            
            
            

            
        } failure:^(NSError *error) {
            
            weakSelf.resultBlock(nil);
            
        }];
    } else {
        
        weakSelf.resultBlock(@"");
    }
}


- (void)getStoragesLogicalDisk:(NSString *)volumesId contentString:(NSMutableString *)tempstr1 drives:(NSArray *)drives {
    
    __weak typeof(self) weakSelf = self;
    [ABNetWorking getWithUrlWithAction:[volumesId substringFromIndex:1] parameters:nil success:^(NSDictionary *result) {
        NSArray *Members = result[@"Members"];
        if (Members && [Members isKindOfClass:[NSArray class]]) {
            if (Members.count > 0) {
                [weakSelf getVolumesWithArray:Members withIndex:0 contentString:tempstr1 drives:drives];
            } else {
                //物理盘列表
                [weakSelf getDrives:drives contentString:tempstr1];
            }
            
        } else {
            //物理盘列表
            [weakSelf getDrives:drives contentString:tempstr1];
        }
        
    } failure:^(NSError *error) {
        weakSelf.resultBlock(nil);
    }];
}

- (void)getVolumesWithArray:(NSArray *)members withIndex:(NSInteger)index contentString:(NSMutableString *)tempstr1 drives:(NSArray *)drives {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = members[index];
    NSString *odata_id = dic[@"@odata.id"];
    
    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result15) {
        
        NSDictionary *oem = result15[@"Oem"];
        NSDictionary *huawei = oem[@"Huawei"];
        
        [tempstr1 appendFormat:@"<table>"];
        
        NSDictionary *status = result15[@"Status"];
        NSString *logical_drive_state = @"";
        if (status.isSureDictionary) {
            NSString *state = status[@"State"];
            if (state.isSureString && [state isEqualToString:@"Enabled"]) {
                logical_drive_state = LocalString(@"logical_drive_state_enabled");
            } else if (state.isSureString && [state isEqualToString:@"Offline"]) {
                logical_drive_state = LocalString(@"logical_drive_state_offline");
            } else if (state.isSureString && [state isEqualToString:@"Degraded"]) {
                logical_drive_state = LocalString(@"logical_drive_state_degraded");
            }
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result15[@"Id"],logical_drive_state];
        
        NSString *str1 = huawei[@"VolumeName"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_volume_name"),str1.objectWitNoNull];

        NSString *str2 = huawei[@"VolumeRaidLevel"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_raid_level"),str2.objectWitNoNull];
        
        NSString *str3 = result15[@"CapacityBytes"];
        if (str3.integerValue < 1024) {
            str3 = [NSString stringWithFormat:@"%@B",str3];
            if (str3.length == 1) {
                str3 = @"";
            }
        } else if ((str3.integerValue/1024) < 1024) {
            str3 = [NSString stringWithFormat:@"%.2fKB",str3.integerValue/1024.0];
        } else if ((str3.integerValue/1024/1024) < 1024) {
            str3 = [NSString stringWithFormat:@"%.2fMB",str3.integerValue/1024/1024.0];
        } else if ((str3.integerValue/1024/1024/1024) < 1024) {
            str3 = [NSString stringWithFormat:@"%.2fGB",str3.integerValue/1024/1024/1024.0];
        } else {
            str3 = [NSString stringWithFormat:@"%.2fTB",str3.integerValue/1024/1024/1024/1024.0];
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_capacity"),str3];
        
        NSString *str4 = [NSString stringWithFormat:@"%@",result15[@"OptimumIOSizeBytes"]];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_strip_size"),str4.toMemoryBString];
        
        NSString *str5 = huawei[@"SSDCachingEnable"];
        if (str5.integerValue == 0) {
            str5 = LocalString(@"Disable");
        } else if (str5.integerValue == 1) {
            str5 = LocalString(@"Enable");
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_sscd_caching"),str5];
        
        NSString *str6 = huawei[@"DefaultReadPolicy"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_default_read_policy"),str6.objectWitNoNull];
        
        NSString *str7 = huawei[@"CurrentReadPolicy"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_current_read_policy"),str7.objectWitNoNull];
        
        NSString *str8 = huawei[@"DefaultWritePolicy"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_default_write_policy"),str8.objectWitNoNull];
        
        NSString *str9 = huawei[@"CurrentWritePolicy"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_current_write_policy"),str9.objectWitNoNull];
        
        NSString *str10 = huawei[@"DefaultCachePolicy"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_default_io_policy"),str10.objectWitNoNull];
        
        NSString *str11 = huawei[@"CurrentCachePolicy"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_current_io_policy"),str11.objectWitNoNull];
        
        NSString *str12 = huawei[@"DriveCachePolicy"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_disk_cache_policy"),str12.objectWitNoNull];
        
        NSString *str13 = huawei[@"AccessPolicy"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_access_policy"),str13.objectWitNoNull];
        
        NSString *str14 = huawei[@"InitializationMode"];
        if (str14.isSureString && [str14 isEqualToString:@"UnInit"]) {
            str14 = LocalString(@"logical_drive_im_UnInit");
        } else if (str14.isSureString && [str14 isEqualToString:@"QuickInit"]) {
            str14 = LocalString(@"logical_drive_im_QuickInit");
        } else if (str14.isSureString && [str14 isEqualToString:@"FullInit"]) {
            str14 = LocalString(@"logical_drive_im_FullInit");
        } else {
            str14 = @"N/A";
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_init_state"),str14];
        
        NSString *str15 = huawei[@"BGIEnable"];
        if (str15.integerValue == 0) {
            str15 = LocalString(@"Disable");
        } else if (str15.integerValue == 1) {
            str15 = LocalString(@"Enable");
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_bgi_enabled"),str15];

        NSString *str16 = huawei[@"SSDCachecadeVolume"];
        if (str16.integerValue == 0) {
            str16 = LocalString(@"no");
        } else if (str16.integerValue == 1) {
            str16 = LocalString(@"yes");
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_l2_cache"),str16];
        
        NSString *str17 = huawei[@"ConsistencyCheck"];
        if (str17.integerValue == 0) {
            str17 = LocalString(@"Stopped");
        } else if (str17.integerValue == 1) {
            str17 = LocalString(@"Enable");
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_consistency_check"),str17];
        
        NSString *str18 = huawei[@"BootEnable"];
        if (str18.integerValue == 0) {
            str18 = LocalString(@"no");
        } else if (str18.integerValue == 1) {
            str18 = LocalString(@"yes");
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"logical_label_boot_disk"),str18];
        
        
        [tempstr1 appendString:@"</table>"];

        if (index+1 == members.count) {
            //物理盘列表
            [weakSelf getDrives:drives contentString:tempstr1];
        } else {
            [weakSelf getVolumesWithArray:members withIndex:index+1 contentString:tempstr1 drives:drives];
        }
        
    } failure:^(NSError *error) {
        weakSelf.resultBlock(nil);
    }];
}

- (void)getDrives:(NSArray *)drives contentString:(NSMutableString *)tempstr1{
    
    if (drives.isSureArray && drives.count > 0) {
        [self getDrivesWithArray:drives withIndex:0 contentString:tempstr1];
    } else {
        
        if (self.dataIndex+1 == self.storagesMembers.count) {
            [tempstr1 appendString:@"</div>"];
            if (self.resultBlock) {
                self.resultBlock(tempstr1);
            }
            
        } else {
            //下一个存储
            self.dataIndex++;
            [self getStoragesDataIndex:self.storagesMembers contentString:tempstr1 withIndex:self.dataIndex];
        }
    }
    
}


- (void)getDrivesWithArray:(NSArray *)drives withIndex:(NSInteger)index contentString:(NSMutableString *)tempstr1 {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = drives[index];
    NSString *odata_id = dic[@"@odata.id"];
    
    [ABNetWorking getWithUrlWithAction:[odata_id substringFromIndex:1] parameters:nil success:^(NSDictionary *result16) {
        
        NSDictionary *oem = result16[@"Oem"];
        NSDictionary *huawei = oem[@"Huawei"];
        
        [tempstr1 appendFormat:@"<table>"];
        
        NSDictionary *status = result16[@"Status"];
        NSString *healthstr = @"";
        if (status.isSureDictionary) {
            NSString *health = status[@"Health"];
            if (health.isSureString && [health isEqualToString:@"OK"]) {
                healthstr = LocalString(@"ok");
            } else if (health.isSureString && [health isEqualToString:@"Warning"]) {
                healthstr = LocalString(@"warning");
            }  else if (health.isSureString && [health isEqualToString:@"Critical"]) {
                healthstr = LocalString(@"critical");
            }
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",result16[@"Name"],healthstr];
        
        NSString *str0 = result16[@"Protocol"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_protocol"),str0.objectWitNoNull];
        
        NSString *str1 = result16[@"Manufacturer"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_manufacturer"),str1.objectWitNoNull];
        
        NSString *str2 = result16[@"Model"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_model"),str2.objectWitNoNull];
        
        NSString *str3 = result16[@"SerialNumber"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_sn"),str3.objectWitNoNull];
        
        NSString *str4 = result16[@"Revision"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_revision"),str4.objectWitNoNull];
        
        NSString *str5 = result16[@"MediaType"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_media"),str5.objectWitNoNull];
        
        NSString *str6 = huawei[@"TemperatureCelsius"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_temperature"),[NSString stringWithFormat:@"%@℃",str6]];
        
        NSString *str7 = huawei[@"FirmwareStatus"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_fw_status"),str7.objectWitNoNull];
        
        NSArray *array8 = huawei[@"SASAddress"];
        NSString *str8 = @"";
        if (array8.isSureArray && array8.count > 0) {
            str8 = [NSString stringWithFormat:@"%@",array8[0]];
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_sas0"),str8.objectWitNoNull];
        
        NSArray *array9 = huawei[@"SASAddress"];
        NSString *str9 = @"";
        if (array9.isSureArray && array9.count > 1) {
            str9 = [NSString stringWithFormat:@"%@",array9[1]];
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_sas1"),str9.objectWitNoNull];
        
        NSString *str10 = result16[@"CapacityBytes"];
        if (str10.integerValue < 1024) {
            str10 = [NSString stringWithFormat:@"%@B",str10];
            if (str10.length == 1) {
                str10 = @"";
            }
        } else if ((str10.integerValue/1024) < 1024) {
            str10 = [NSString stringWithFormat:@"%.2fKB",str10.integerValue/1024.0];
        } else if ((str10.integerValue/1024/1024) < 1024) {
            str10 = [NSString stringWithFormat:@"%.2fMB",str10.integerValue/1024/1024.0];
        } else if ((str10.integerValue/1024/1024/1024) < 1024) {
            str10 = [NSString stringWithFormat:@"%.2fGB",str10.integerValue/1024/1024/1024.0];
        } else {
            str10 = [NSString stringWithFormat:@"%.2fTB",str10.integerValue/1024/1024/1024/1024.0];
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_capacity"),str10];
        
        NSString *str11 = result16[@"CapableSpeedGbs"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@Gbps</td></tr>",LocalString(@"drive_label_capable_speed_gbs"),str11];
        
        NSString *str12 = result16[@"NegotiatedSpeedGbs"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@Gbps</td></tr>",LocalString(@"drive_label_negotiated_speed_gbs"),str12];
        
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_power_state"),@""];
        
        NSString *str14 = result16[@"HotspareType"];
        if (str14.isSureString && [str14 isEqualToString:@"None"]) {
            str14 = LocalString(@"drive_hotspare_none");
        } else if (str14.isSureString && [str14 isEqualToString:@"Global"]) {
            str14 = LocalString(@"drive_hotspare_global");
        } else if (str14.isSureString && [str14 isEqualToString:@"Dedicated"]) {
            str14 = LocalString(@"drive_hotspare_dedicated");
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_hotspare_type"),str14.objectWitNoNull];
        
        NSString *str15 = huawei[@"RebuildState"];
        if (str15.isSureString && [str15 isEqualToString:@"DoneOrNotRebuilt"]) {
            str15 = LocalString(@"drive_rebuild_state_done_or_not_rebuilt");
        } else if (str15.isSureString && [str15 isEqualToString:@"Rebuilding"]) {
            str15 = LocalString(@"drive_rebuild_state_building");
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_rebuild_state"),str15.objectWitNoNull];
        
        NSString *str16 = huawei[@"PatrolState"];
        if (str16.isSureString && [str16 isEqualToString:@"DoneOrNotPatrolled"]) {
            str16 = LocalString(@"drive_patroll_state_done_or_not_patrolled");
        } else if (str16.isSureString && [str16 isEqualToString:@"Patrolling"]) {
            str16 = LocalString(@"drive_patroll_state_patrolling");
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_patrol_state"),str16.objectWitNoNull];
        
        NSString *str17 = result16[@"IndicatorLED"];
        if (str17.isSureString && [str17 isEqualToString:@"Off"]) {
            str17 = LocalString(@"drive_indicator_led_off");
        } else if (str17.isSureString && [str17 isEqualToString:@"Blinking"]) {
            str17 = LocalString(@"drive_indicator_led_blinking");
        }
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@</td></tr>",LocalString(@"drive_label_indicator_led"),str17.objectWitNoNull];
        
        NSString *str18 = huawei[@"HoursOfPoweredUp"];
        [tempstr1 appendFormat:@"<tr><td>%@</td><td>%@h</td></tr>",LocalString(@"drive_label_power_on_hours"),str18.objectWitNoNull];
        
        [tempstr1 appendString:@"</table>"];
        
        if (index+1 == drives.count) {
            //当前存储物理盘获取完毕
            
            if (weakSelf.dataIndex+1 == weakSelf.storagesMembers.count) {
                [tempstr1 appendString:@"</div>"];
                if (weakSelf.resultBlock) {
                    weakSelf.resultBlock(tempstr1);
                }
                
            } else {
                //下一个存储
                weakSelf.dataIndex++;
                [weakSelf getStoragesDataIndex:weakSelf.storagesMembers contentString:tempstr1 withIndex:weakSelf.dataIndex];
            }
            
        } else {
            [weakSelf getDrivesWithArray:drives withIndex:index+1 contentString:tempstr1];
        }
        
    } failure:^(NSError *error) {
        weakSelf.resultBlock(nil);
    }];
}


@end
