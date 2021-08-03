//
//  NSUserDefaults+IOMMyInfoUserDefaults.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 11/2/17.
//  Copyright © 2017 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const IOMMyInfoManagerUserDefaultMyInfo = @"IOMMyInfoManagerUserDefaultEmail";
static NSString * const IOMMyInfoManagerKeyEmail = @"IOMMyInfoManagerKeyEmail";
static NSString * const IOMMyInfoManagerKeyWWID = @"IOMMyInfoManagerKeyWWID";
static NSString * const IOMMyInfoManagerKeyRDT = @"IOMMyInfoManagerKeyRDT";

typedef NS_ENUM(NSInteger, IOMMyInfoDefaults) {
    IOMMyInfoDefaultsEmail,
    IOMMyInfoDefaultsWWID,
    IOMMyInfoDefaultsRDT
};

@interface NSUserDefaults (IOMMyInfoUserDefaults)

+ (NSString *)iom_getMyInfoUserDefaultForType:(IOMMyInfoDefaults)myInfoDefault;
+ (NSDictionary *)iom_getMyInfoUserDefault;
+ (void)iom_setMyInfoUserDefault:(NSDictionary *)myInfoDictionary;
+ (void)iom_setMyInfoUserDefaultWithString:(NSString *)string forType:(IOMMyInfoDefaults)myInfoDefault;

@end
