//
//  Chair+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/6/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "Chair+Extension.h"
#import "Scenario+Extension.h"
#import "SolutionData+Extension.h"

@implementation Chair (Extension)

+ (Chair*)createChairEntityForScenario:(Scenario*)scenario
{
    int highestDisplayOrder = [self highestDisplayOrderForChairInScenario:scenario] + 1;
    
    Chair* newChair = [NSEntityDescription insertNewObjectForEntityForName:@"Chair" inManagedObjectContext:scenario.managedObjectContext];
    newChair.displayOrder = [NSNumber numberWithInt:highestDisplayOrder];
    [scenario addChairsObject:newChair];
    [newChair setScenario:scenario];
    
    return newChair;
}

+ (int)highestDisplayOrderForChairInScenario:(Scenario*)scenario
{
    //Find chair with highest displayOrder
    int highestDisplayOrder = 0;
    NSSortDescriptor* highestDisplayOrderSort = [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:NO];
    
    NSArray* results = [scenario.chairs sortedArrayUsingDescriptors:@[highestDisplayOrderSort]];
    if(results && results.count > 0){
        Chair* highestChair = [results objectAtIndex:0];
        highestDisplayOrder = [highestChair.displayOrder intValue];
    }
    
    return highestDisplayOrder;
}

- (double)getTotalHoursForDay:(int)day
{
    // 0 - sunday, 1 - monday, 2 - tuesday, 3 - wednesday, 4 - thursday, 5 - friday, 6 - saturday
    double total = 0;
    switch (day) {
        case 0:
            total = [self.endTime0 timeIntervalSinceDate:self.startTime0] / (60.0f * 60.0f);
            break;
        case 1:
            total = [self.endTime1 timeIntervalSinceDate:self.startTime1] / (60.0f * 60.0f);
            break;
        case 2:
            total = [self.endTime2 timeIntervalSinceDate:self.startTime2] / (60.0f * 60.0f);
            break;
        case 3:
            total = [self.endTime3 timeIntervalSinceDate:self.startTime3] / (60.0f * 60.0f);
            break;
        case 4:
            total = [self.endTime4 timeIntervalSinceDate:self.startTime4] / (60.0f * 60.0f);
            break;
        case 5:
            total = [self.endTime5 timeIntervalSinceDate:self.startTime5] / (60.0f * 60.0f);
            break;
        case 6:
            total = [self.endTime6 timeIntervalSinceDate:self.startTime6] / (60.0f * 60.0f);
            break;
            
        default:
            break;
    }
    
    return total;
}

- (Chair*)duplicateChair
{
    Chair* newChair = [NSEntityDescription insertNewObjectForEntityForName:@"Chair" inManagedObjectContext:self.managedObjectContext];
    newChair.displayOrder = [NSNumber numberWithInt:[Chair highestDisplayOrderForChairInScenario:self.scenario] + 1];
    newChair.endTime0 = [self.endTime0 copy];
    newChair.endTime1 = [self.endTime1 copy];
    newChair.endTime2 = [self.endTime2 copy];
    newChair.endTime3 = [self.endTime3 copy];
    newChair.endTime4 = [self.endTime4 copy];
    newChair.endTime5 = [self.endTime5 copy];
    newChair.endTime6 = [self.endTime6 copy];
    newChair.startTime0 = [self.startTime0 copy];
    newChair.startTime1 = [self.startTime1 copy];
    newChair.startTime2 = [self.startTime2 copy];
    newChair.startTime3 = [self.startTime3 copy];
    newChair.startTime4 = [self.startTime4 copy];
    newChair.startTime5 = [self.startTime5 copy];
    newChair.startTime6 = [self.startTime6 copy];
    
    return newChair;
}

- (BOOL)hasHoursOnDay:(int)day
{
    // 0 - sunday, 1 - monday, 2 - tuesday, 3 - wednesday, 4 - thursday, 5 - friday, 6 - saturday
    switch (day) {
        case 0:
            return (self.startTime0 != nil);
        case 1:
            return (self.startTime1 != nil);
        case 2:
            return (self.startTime2 != nil);
        case 3:
            return (self.startTime3 != nil);
        case 4:
            return (self.startTime4 != nil);
        case 5:
            return (self.startTime5 != nil);
        case 6:
            return (self.startTime6 != nil);
        default:
            return NO;
    }
}

/*
 *  Returns the start period for this chair for a day
 *  Start Period = (convert time to minutes)/10
 */
- (int)getStartPeriodForDay:(int)day
{
    NSDate* time = nil;
    switch (day) {
        case 0:
            time = self.startTime0;
            break;
        case 1:
            time = self.startTime1;
            break;
        case 2:
            time = self.startTime2;
            break;
        case 3:
            time = self.startTime3;
            break;
        case 4:
            time = self.startTime4;
            break;
        case 5:
            time = self.startTime5;
            break;
        case 6:
            time = self.startTime6;
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
            time = self.endTime0;
            break;
        case 1:
            time = self.endTime1;
            break;
        case 2:
            time = self.endTime2;
            break;
        case 3:
            time = self.endTime3;
            break;
        case 4:
            time = self.endTime4;
            break;
        case 5:
            time = self.endTime5;
            break;
        case 6:
            time = self.endTime6;
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

@end
