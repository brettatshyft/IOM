//
//  IOMParsedAccount.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 1/22/18.
//  Copyright © 2018 Local Wisdom Inc. All rights reserved.
//

#import "IOMParsedAccount.h"

@implementation IOMParsedAccount

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        self.displayname = dictionary[@"displayName"];
        self.jnjId = dictionary[@"jnjId"];
    }

    return self;
}

@end
