//
//  NSUserDefaults+IOMMyInfoUserDefaults.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 11/2/17.
//  Copyright © 2017 Local Wisdom Inc. All rights reserved.
//

#import "NSUserDefaults+IOMMyInfoUserDefaults.h"

@implementation NSUserDefaults (IOMMyInfoUserDefaults)

+ (NSDictionary *)iom_getMyInfoUserDefault
{
    NSDictionary *myInfoUserDefault = [[NSUserDefaults standardUserDefaults] objectForKey:IOMMyInfoManagerUserDefaultMyInfo];

    if (!myInfoUserDefault)
    {
        myInfoUserDefault = [[NSDictionary alloc] init];
    }

    return myInfoUserDefault;
}

+ (void)iom_setMyInfoUserDefault:(NSDictionary *)myInfoDictionary
{
    [[NSUserDefaults standardUserDefaults] setObject:myInfoDictionary forKey:IOMMyInfoManagerUserDefaultMyInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)iom_getMyInfoUserDefaultForType:(IOMMyInfoDefaults)myInfoDefault
{
    NSDictionary * myInfoUserDefaults = [NSUserDefaults iom_getMyInfoUserDefault];
    NSString * myInfoUserDefault = [myInfoUserDefaults objectForKey:[NSUserDefaults iom_keyForMyInfoDefault:myInfoDefault]];
    return myInfoUserDefault;
}

+ (void)iom_setMyInfoUserDefaultWithString:(NSString *)string forType:(IOMMyInfoDefaults)myInfoDefault
{
    NSMutableDictionary * myInfoUserDefaults = [[NSUserDefaults iom_getMyInfoUserDefault] mutableCopy];
    [myInfoUserDefaults setObject:string forKey:[NSUserDefaults iom_keyForMyInfoDefault:myInfoDefault]];
    [NSUserDefaults iom_setMyInfoUserDefault:myInfoUserDefaults];
}

+ (NSString *)iom_keyForMyInfoDefault:(IOMMyInfoDefaults)myInfoDefault
{
    switch (myInfoDefault) {
        case IOMMyInfoDefaultsEmail:
            return IOMMyInfoManagerKeyEmail;
            break;
        case IOMMyInfoDefaultsWWID:
            return IOMMyInfoManagerKeyWWID;
            break;
        case IOMMyInfoDefaultsRDT:
            return IOMMyInfoManagerKeyRDT;
            break;
        default:
            return @"";
            break;
    }
}

@end
