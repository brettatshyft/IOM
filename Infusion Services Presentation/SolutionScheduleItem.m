//
//  SolutionScheduleItem.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/10/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "SolutionScheduleItem.h"

@implementation SolutionScheduleItem

- (id)init
{
    self = [super init];
    if (self) {
        _phaseType = PhaseTypeUnassigned;
        _makeStaffAttention = 0;
        _isFullLoad = NO;
    }
    
    return self;
}
@end
