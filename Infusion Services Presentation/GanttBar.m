//
//  GanttBar.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/24/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "GanttBar.h"

@implementation GanttBar

- (id)init
{
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

- (NSString*)getStatusString
{
    switch (_ganttBarType) {
        case GanttBarTypePrepPost:
            return @"PREPOST";
        case GanttBarTypeSimponi:
            return @"SIMPONI";
        case GanttBarTypeRemicade:
            return @"REMICADE";
        case GanttBarTypeStelara:
            return @"STELARA";
        case GanttBarTypeSubcutaneous:
            return @"SUB";
        case GanttBarTypeAdditionalRemicade:
            return @"ADDREM";
        case GanttBarTypeAdditionalStelara:
            return @"ADDSTEL";
        case GanttBarTypeAdditionalSimponi:
            return @"ADDSIMP";
        case GanttBarTypeOtherIVInfusion:
            return @"OTHER";
    }
    
    return nil;
}

@end
