//
//  Staff+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/5/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "Staff+Extension.h"
#import "Scenario+Extension.h"
#import "SolutionData+Extension.h"

@implementation Staff (Extension)

+ (Staff*)createStaffEntityForScenario:(Scenario*)scenario
{
    //Find staff with highest displayOrder
    int highestDisplayOrder = [self highestDisplayOrderForStaffInScenario:scenario] + 1;
    
    Staff* newStaff = [NSEntityDescription insertNewObjectForEntityForName:@"Staff" inManagedObjectContext:scenario.managedObjectContext];
    newStaff.displayOrder = [NSNumber numberWithInt:highestDisplayOrder];
    [scenario addStaffObject:newStaff];
    [newStaff setScenario:scenario];
    
    return newStaff;
}

+ (int)highestDisplayOrderForStaffInScenario:(Scenario*)scenario
{
    //Find staff with highest displayOrder
    int highestDisplayOrder = 0;
    NSSortDescriptor* highestDisplayOrderSort = [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:NO];
    
    NSArray* results = [scenario.staff sortedArrayUsingDescriptors:@[highestDisplayOrderSort]];
    if(results && results.count > 0){
        Staff* highestStaff = [results objectAtIndex:0];
        highestDisplayOrder = [highestStaff.displayOrder intValue];
    }
    return highestDisplayOrder;
}

- (double)getTotalHoursForDay:(int)day
{
    //0 - sunday, 1 - monday, 2 - tuesday, 3 - wednesday, 4 - thursday, 5 - friday, 6 - saturday
    float total = 0;
    switch (day) {
        case 0:
            total = ([self.workEndTime0 timeIntervalSinceDate:self.workStartTime0] - [self.breakEndTime0 timeIntervalSinceDate:self.breakStartTime0]) / (60.0 * 60.0);
            break;
        case 1:
            total = ([self.workEndTime1 timeIntervalSinceDate:self.workStartTime1] - [self.breakEndTime1 timeIntervalSinceDate:self.breakStartTime1]) / (60.0 * 60.0);
            break;
        case 2:
            total = ([self.workEndTime2 timeIntervalSinceDate:self.workStartTime2] - [self.breakEndTime2 timeIntervalSinceDate:self.breakStartTime2]) / (60.0 * 60.0);
            break;
        case 3:
            total = ([self.workEndTime3 timeIntervalSinceDate:self.workStartTime3] - [self.breakEndTime3 timeIntervalSinceDate:self.breakStartTime3]) / (60.0 * 60.0);
            break;
        case 4:
            total = ([self.workEndTime4 timeIntervalSinceDate:self.workStartTime4] - [self.breakEndTime4 timeIntervalSinceDate:self.breakStartTime4]) / (60.0 * 60.0);
            break;
        case 5:
            total = ([self.workEndTime5 timeIntervalSinceDate:self.workStartTime5] - [self.breakEndTime5 timeIntervalSinceDate:self.breakStartTime5]) / (60.0 * 60.0);
            break;
        case 6:
            total = ([self.workEndTime6 timeIntervalSinceDate:self.workStartTime6] - [self.breakEndTime6 timeIntervalSinceDate:self.breakStartTime6]) / (60.0 * 60.0);
            break;
            
        default:
            break;
    }
    
    return total;
}

- (Staff*)duplicatedStaff
{
    Staff* newStaff = [NSEntityDescription insertNewObjectForEntityForName:@"Staff" inManagedObjectContext:self.managedObjectContext];
    newStaff.displayOrder = [NSNumber numberWithInt:[Staff highestDisplayOrderForStaffInScenario:self.scenario] + 1];
    newStaff.staffTypeID = [self.staffTypeID copy];
    newStaff.workStartTime0 = [self.workStartTime0 copy];
    newStaff.workStartTime1 = [self.workStartTime1 copy];
    newStaff.workStartTime2 = [self.workStartTime2 copy];
    newStaff.workStartTime3 = [self.workStartTime3 copy];
    newStaff.workStartTime4 = [self.workStartTime4 copy];
    newStaff.workStartTime5 = [self.workStartTime5 copy];
    newStaff.workStartTime6 = [self.workStartTime6 copy];
    newStaff.workEndTime0 = [self.workEndTime0 copy];
    newStaff.workEndTime1 = [self.workEndTime1 copy];
    newStaff.workEndTime2 = [self.workEndTime2 copy];
    newStaff.workEndTime3 = [self.workEndTime3 copy];
    newStaff.workEndTime4 = [self.workEndTime4 copy];
    newStaff.workEndTime5 = [self.workEndTime5 copy];
    newStaff.workEndTime6 = [self.workEndTime6 copy];
    newStaff.breakStartTime0 = [self.breakStartTime0 copy];
    newStaff.breakStartTime1 = [self.breakStartTime1 copy];
    newStaff.breakStartTime2 = [self.breakStartTime2 copy];
    newStaff.breakStartTime3 = [self.breakStartTime3 copy];
    newStaff.breakStartTime4 = [self.breakStartTime4 copy];
    newStaff.breakStartTime5 = [self.breakStartTime5 copy];
    newStaff.breakStartTime6 = [self.breakStartTime6 copy];
    newStaff.breakEndTime0 = [self.breakEndTime0 copy];
    newStaff.breakEndTime1 = [self.breakEndTime1 copy];
    newStaff.breakEndTime2 = [self.breakEndTime2 copy];
    newStaff.breakEndTime3 = [self.breakEndTime3 copy];
    newStaff.breakEndTime4 = [self.breakEndTime4 copy];
    newStaff.breakEndTime5 = [self.breakEndTime5 copy];
    newStaff.breakEndTime6 = [self.breakEndTime6 copy];
    
    return newStaff;
}

/*
 *  Returns the start period for this staff for a day
 *  Start Period = (convert time to minutes)/10
 */
- (int)getStartPeriodForDay:(int)day
{
    NSDate* time = nil;
    switch (day) {
        case 0:
            time = self.workStartTime0;
            break;
        case 1:
            time = self.workStartTime1;
            break;
        case 2:
            time = self.workStartTime2;
            break;
        case 3:
            time = self.workStartTime3;
            break;
        case 4:
            time = self.workStartTime4;
            break;
        case 5:
            time = self.workStartTime5;
            break;
        case 6:
            time = self.workStartTime6;
            break;
            
        default:
            break;
    }
    
    return [SolutionData getPeriodForTime:time];
}

- (int)getEndPeriodForDay:(int)day
{
    NSDate* time = nil;
    switch (day) {
        case 0:
            time = self.workEndTime0;
            break;
        case 1:
            time = self.workEndTime1;
            break;
        case 2:
            time = self.workEndTime2;
            break;
        case 3:
            time = self.workEndTime3;
            break;
        case 4:
            time = self.workEndTime4;
            break;
        case 5:
            time = self.workEndTime5;
            break;
        case 6:
            time = self.workEndTime6;
            break;
            
        default:
            break;
    }
    
    if(!time || (id)time == [NSNull null])
        return 0;
    
    int endPeriod = [SolutionData getPeriodForTime:time];
    
    //We return 24 instead of zero because end time can be at midnight EOD, but not midnight start of day!
    //(Since end time cannot be before or equal to start time)
    if(endPeriod == 0)
        return 24;
    return endPeriod;
}

- (int)getBreakStartPeriodForDay:(int)day
{
    NSDate* time = nil;
    switch (day) {
        case 0:
            time = self.breakStartTime0;
            break;
        case 1:
            time = self.breakStartTime1;
            break;
        case 2:
            time = self.breakStartTime2;
            break;
        case 3:
            time = self.breakStartTime3;
            break;
        case 4:
            time = self.breakStartTime4;
            break;
        case 5:
            time = self.breakStartTime5;
            break;
        case 6:
            time = self.breakStartTime6;
            break;
            
        default:
            break;
    }
    
    return [SolutionData getPeriodForTime:time];
}

- (int)getBreakEndPeriodForDay:(int)day
{
    NSDate* time = nil;
    switch (day) {
        case 0:
            time = self.breakEndTime0;
            break;
        case 1:
            time = self.breakEndTime1;
            break;
        case 2:
            time = self.breakEndTime2;
            break;
        case 3:
            time = self.breakEndTime3;
            break;
        case 4:
            time = self.breakEndTime4;
            break;
        case 5:
            time = self.breakEndTime5;
            break;
        case 6:
            time = self.breakEndTime6;
            break;
            
        default:
            break;
    }
    
    return [SolutionData getPeriodForTime:time];
}



@end
