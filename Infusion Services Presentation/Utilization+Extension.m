//
//  Utilization+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/5/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "Utilization+Extension.h"

@implementation Utilization (Extension)

- (int)totalPatients{
    return [self.otherIVBiologics intValue] + [self.remicadePatients intValue] + [self.subcutaneousPatients intValue];
}

- (Utilization*)duplicateUtilization
{
    Utilization* newUtil = [NSEntityDescription insertNewObjectForEntityForName:@"Utilization" inManagedObjectContext:self.managedObjectContext];
    
    newUtil.otherIVBiologics = [self.otherIVBiologics copy];
    newUtil.remicadePatients = [self.remicadePatients copy];
    newUtil.simponiAriaPatients = [self.simponiAriaPatients copy];
    newUtil.subcutaneousPatients = [self.subcutaneousPatients copy];
    newUtil.stelaraPatients = [self.stelaraPatients copy];
    
    return newUtil;
}

@end
