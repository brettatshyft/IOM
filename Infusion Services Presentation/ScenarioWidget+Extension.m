//
//  ScenarioWidget+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/6/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "ScenarioWidget+Extension.h"
#import "WidgetPlaceable.h"
#import "ScenarioStaff.h"
#import "MultiDimensionalArray.h"

@implementation ScenarioWidget (Extension)

- (WidgetPlaceable*)getPlaceableWidgetForDay:(int)day time:(int)time machineIndex:(int)machineIndex withScenarioStaffArray:(MultiDimensionalArray*)scenarioStaffArray andMachinesArray:(MultiDimensionalArray*)machinesArray
{
    
    if(![self isThereTimeInDayForWidgetToFinishAtTime:time]){
        //There is not enough time left in day to fit this widget
        return nil;
    }
    
    NSMutableArray* staffTempHQP = [[NSMutableArray alloc] init];
    NSMutableArray* staffTempAncillary = [[NSMutableArray alloc] init];
    int machineAvailableTime = 0;
    
    for (int i = 0; i < [self totalTime]; i++){
        //Pull out Scenario Staff for each type of staff at this time and day
        ScenarioStaff* qhp = [scenarioStaffArray getObjectAtX:0 Y:day Z:time+i]; //[scenarioStaffArray objectAtDimensions:3, 0, day, time + i, nil];
        ScenarioStaff* ancillary = [scenarioStaffArray getObjectAtX:1 Y:day Z:time+i]; //[scenarioStaffArray objectAtDimensions:3, 1, day, time + i, nil];
        
        //Copy
        ScenarioStaff* newQHP = [qhp copy];
        ScenarioStaff* newAncillary = [ancillary copy];
        
        //Assign to temp arrays
        NSNumber* mTime = [machinesArray getObjectAtX:day Y:time+i Z:machineIndex];
        machineAvailableTime += ((id)mTime != [NSNull null]) ? [mTime intValue] : 0;        //[[machinesArray objectAtDimensions:3, day, time + i, machineIndex, nil] intValue];
        [staffTempHQP addObject:newQHP];
        [staffTempAncillary addObject:newAncillary];
    }
    
    //Check if machine is available for widget's total time
    if (machineAvailableTime < [self totalTime]) {
        //Machine is not available for the full time of the infusion
        return nil;
    }
    
    //Try to place ancillary staff before QHP staff
    int prepStaffType = -1;
    int postStaffType = -1;
    
    //Prep time
    if ([self.prepTime intValue] > 0) {
        //Check if Ancillary is allowed for prep
        if ([self.prepAncillary boolValue] && [self isStaffTypeAbleToProcessStepWithScenarioStaff:staffTempAncillary startTime:0 timeLength:[self.prepTime intValue] andPrimaryFocusNeeded:1]) {
            prepStaffType = StaffTypeAncillary;
        }
        if (prepStaffType == -1 && [self.prepQHP boolValue] && [self isStaffTypeAbleToProcessStepWithScenarioStaff:staffTempHQP startTime:0 timeLength:[self.prepTime intValue] andPrimaryFocusNeeded:1]) {
            prepStaffType = StaffTypeQHP;
        }
        if (prepStaffType == -1) {  //No staff fit
            return nil;
        }
    }
    
    //Make Time
    NSArray* arrayOfStaffAvailable = nil;
    if ([self.makeTime intValue] > 0) {
        arrayOfStaffAvailable = [self isStaffAvailableToProcessMakeForStaff1Availability:staffTempHQP staff2Availability:staffTempAncillary startTime:[self.prepTime intValue] timeLength:[self.makeTime intValue]];
        for (NSNumber* staffType in arrayOfStaffAvailable) {
            if ((id)staffType == [NSNull null] || [staffType integerValue] == -1) {
                //No staff fit
                return nil;
            }
        }
    }
    
    //Post time
    if ([self.postTime intValue] > 0) {
        //Check if Ancillary is allowed for prep
        int startTime = [self.prepTime intValue] + [self.makeTime intValue];
        if ([self.postAncillary boolValue] && [self isStaffTypeAbleToProcessStepWithScenarioStaff:staffTempAncillary startTime:startTime timeLength:[self.postTime intValue] andPrimaryFocusNeeded:1]) {
            postStaffType = StaffTypeAncillary;
        }
        if (postStaffType == -1 && [self.postQHP boolValue] && [self isStaffTypeAbleToProcessStepWithScenarioStaff:staffTempHQP startTime:startTime timeLength:[self.postTime intValue] andPrimaryFocusNeeded:1]) {
            postStaffType = StaffTypeQHP;
        }
        if (postStaffType == -1) {  //No staff fit
            return nil;
        }
    }
    
    
    //Create widgetPlaceable
    WidgetPlaceable* placeable = [[WidgetPlaceable alloc] init];
    placeable.widgetType = [self.widgetType integerValue];
    placeable.prepStaffType = prepStaffType;
    placeable.postStaffType = postStaffType;
    placeable.makeStaffTypes = arrayOfStaffAvailable;
    return placeable;
}

/*  Summary: Returns true if staff is available to process an infusion step
 *  (NSArray*)scenarioStaffArray: Array of staff availability, contains ScenarioStaff objects
 *  (int)startTime: time period in which this step starts (10-minute periods in day, startTime 10 = 100 minutes into day)
 *  (int)timeLength: time it takes to finish the step
 */
- (BOOL)isStaffTypeAbleToProcessStepWithScenarioStaff:(NSArray*)scenarioStaffArray startTime:(int)startTime timeLength:(int)timeLength andPrimaryFocusNeeded:(int)primaryFocusNeeded
{
    int stopTime = startTime + timeLength;
    for (int i = startTime; i < stopTime; i++)
    {
        ScenarioStaff* scenarioStaff = [scenarioStaffArray objectAtIndex:i];
        scenarioStaff.primaryFocus -= primaryFocusNeeded;
        scenarioStaff.chairLimit -= [self.makeStaffAttention floatValue];
        if (scenarioStaff.primaryFocus < 0 || scenarioStaff.chairLimit < 0) {
            return false;
        }
    }
    
    return true;
}

/*
 *  Returns array of staff available over time. (-1 means no staff available)
 */
- (NSArray*)isStaffAvailableToProcessMakeForStaff1Availability:(NSArray*)staff1Availability staff2Availability:(NSArray*)staff2Availability startTime:(int)startTime timeLength:(int)timeLength
{
    NSMutableArray* staffAvailableArray = [[NSMutableArray alloc] init];
    int stopTime = startTime + timeLength;
    for (int i = startTime; i < stopTime; i++) {
        //Check if ancillary is available first
        if ([self.makeAncillary boolValue]) { //Ancillary is allowed for this widget
            ScenarioStaff* sStaff = [staff2Availability objectAtIndex:i];
            if ((sStaff.chairLimit - [self.makeStaffAttention floatValue]) >= 0) {    //staff type(Ancillary) fits
                [staffAvailableArray addObject:[NSNumber numberWithInteger:StaffTypeAncillary]];
                continue;
            }
        }
        
        if ([self.makeQHP boolValue]) {   //QHP is allowed for this widget
            ScenarioStaff* sStaff = [staff1Availability objectAtIndex:i];
            if (sStaff.chairLimit - [self.makeStaffAttention floatValue] >= 0) {
                [staffAvailableArray addObject:[NSNumber numberWithInteger:StaffTypeQHP]];
                continue;
            }
        }
        
        //If execution gets here, could not fit any staff
        [staffAvailableArray addObject:[NSNumber numberWithInt:-1]];
    }
    
    return [NSArray arrayWithArray:staffAvailableArray];
}

/*  Summary: Returns true if the total time of this widget can be finished before the end of the day.
 *  Day is made up of 144 10-minute periods.
 */
- (BOOL)isThereTimeInDayForWidgetToFinishAtTime:(int)time
{
    if  (time + [self totalTime] > 144)
    {
        return NO;
    }
    return YES;
}

- (int)totalTime
{
    return [self.prepTime intValue] + [self.postTime intValue] + [self.makeTime intValue];
}

/*
//Divide total time by 10 because to use 144 10-minute periods throughout the day to determine schedule
- (int)totalTimePeriods
{
    return [self prepTimePeriods] + [self postTimePeriods] + [self makeTimePeriods];
}

- (int)prepTimePeriods
{
    return [self.prepTime intValue]/10;
}

- (int)postTimePeriods
{
    return [self.postTime intValue]/10;
}

- (int)makeTimePeriods
{
    return [self.makeTime intValue]/10;
}
*/

- (int)numberOfSolutionWidgetsInCurrentSchedule
{
    NSPredicate* currentSchedulePred = [NSPredicate predicateWithFormat:@"isFullLoad == NO"];
    NSArray* solutionWidgets = [[self.solutionWidgetsInSchedule allObjects] filteredArrayUsingPredicate:currentSchedulePred];
    return [solutionWidgets count];
}

- (int)numberOfSolutionWidgetsInFullSchedule
{
    NSPredicate* fullSchedulePred = [NSPredicate predicateWithFormat:@"isFullLoad == YES"];
    NSArray* solutionWidgets = [[self.solutionWidgetsInSchedule allObjects] filteredArrayUsingPredicate:fullSchedulePred];
    return [solutionWidgets count];
}



@end
