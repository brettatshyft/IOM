//
//  IOMPDFSchedulePageNode.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/3/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "IOMPDFSchedulePageNode.h"

@implementation IOMPDFSchedulePageNode

- (id)init
{
    self = [super init];
    if (self != nil) {
        _view = nil;
        _needsToBeCropped = NO;
        _cropBottomY = 0;
        _cropTopY = 0;
        _xOffsetOrigin = 0;
    }
    
    return self;
}

@end
