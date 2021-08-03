//
//  IOMMyInfoManager.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 2/12/15.
//  Copyright (c) 2015 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kIOMSyncManagerSaveAllArgumentWWID = @"wwid";
static NSString * const kIOMSyncManagerSaveAllArgumentRDT = @"rdt";
static NSString * const kIOMSyncManagerSaveAllArgumentFilename = @"filename";
static NSString * const kIOMSyncManagerSaveAllArgumentEmail = @"email";

@interface IOMMyInfoManager : NSObject

- (BOOL)checkForMyInfo;
- (void)showMyInfoAlert;

+ (NSString *)email;
+ (NSString *)rdt;
+ (NSString *)wwid;

@end
