//
//  ScenarioStaff.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/7/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "ScenarioStaff.h"

@implementation ScenarioStaff

- (id)init
{
    self = [super init];
    if (self) {
        _primaryFocus = 0;
        _chairLimit = 0;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    //Create new
    ScenarioStaff* copyObject = [[[self class] alloc] init];
    
    if (copyObject) {
        copyObject.primaryFocus = self.primaryFocus;
        copyObject.chairLimit = self.chairLimit;
    }
    
    return copyObject;
}

@end
