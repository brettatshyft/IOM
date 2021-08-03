//
//  NSString+IOMExtensions.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 12/15/17.
//  Copyright © 2017 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IOMExtensions)

- (NSString *)MD5String;
+ (NSString *)humanReadableListFromArray:(NSArray<NSString*>*)array;

@end
