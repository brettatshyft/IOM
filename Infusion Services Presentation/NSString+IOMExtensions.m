//
//  NSString+IOMExtensions.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 12/15/17.
//  Copyright © 2017 Local Wisdom Inc. All rights reserved.
//

#import "NSString+IOMExtensions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (IOMExtensions)

- (NSString *)MD5String {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );

    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)humanReadableListFromArray:(NSArray<NSString*>*)array {
    if (array.count == 0) return @"";
    if (array.count == 1) return array[0];
    if (array.count == 2) return [array componentsJoinedByString:@" and "];
    NSArray *firstItems = [array subarrayWithRange:NSMakeRange(0, array.count-1)];
    NSString *lastItem = [array lastObject];
    return [NSString stringWithFormat:@"%@, and %@", [firstItems componentsJoinedByString:@", "], lastItem];
}

@end
