//
//  SolutionData+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/6/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "SolutionData+Extension.h"
#import "Scenario+Extension.h"
#import "ScenarioWidget+Extension.h"
#import "RemicadeInfusion+Extension.h"
#import "SimponiAriaInfusion+Extension.h"
#import "OtherInfusion+Extension.h"
#import "OtherInjection+Extension.h"
#import "Staff+Extension.h"
#import "Chair+Extension.h"
#import "SolutionWidgetInSchedule+Extension.h"
#import "SolutionStatistics+Extension.h"
#import "WidgetPlaceable.h"
#import "ScenarioStaff.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Presentation+Extension.h"
#import "MultiDimensionalArray.h"
#import "StelaraInfusion+CoreDataProperties.h"
#import "StelaraInfusion+CoreDataClass.h"

@implementation SolutionData (Extension)

+ (SolutionData*)getSolutionDataForScenario:(Scenario*)scenario
{
    if(!scenario) return nil;
    
    if(!scenario.solutionData){
        SolutionData* solutionData = [NSEntityDescription insertNewObjectForEntityForName:@"SolutionData" inManagedObjectContext:scenario.managedObjectContext];
        
        [scenario setSolutionData:solutionData];
        [solutionData setScenario:scenario];
    }
    
    return scenario.solutionData;
}

+ (void)processSolutionDataForScenario:(Scenario*)scenario
{
    if(!scenario)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SOLUTION_DATA_FAILED_PROCESSING_NOTIFICATION object:nil];
        });
        return;
    }
    
    NSError *error = nil;
    if (![scenario.managedObjectContext obtainPermanentIDsForObjects:@[scenario] error:&error]) {
        NSLog(@"Could not obtain permanent ID for scenario!: Error: %@", error);
    }
    
    NSManagedObjectID *scenarioID = [scenario objectID];
    
    //Process in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
 
            AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *tmpContext = [[NSManagedObjectContext alloc] init];
            [tmpContext setPersistentStoreCoordinator:[appDelegate persistentStoreCoordinator]];
            [tmpContext setUndoManager:nil];
             
            Scenario* scenarioFromID = (Scenario*)[tmpContext objectWithID:scenarioID];
            if(scenarioFromID && (id)scenarioFromID != [NSNull null]) {
                
                //Delete old solution data
                if (scenarioFromID.solutionData) {
                    [scenarioFromID.managedObjectContext deleteObject:scenarioFromID.solutionData];
                    scenarioFromID.solutionData = nil;
                }
                
                NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
                SolutionData* solData = [SolutionData getSolutionDataForScenario:scenarioFromID];
                [solData processSolutions];
                [SolutionStatistics processSolutionStatisticsForScenario:scenarioFromID];
                NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
                
                NSLog(@"Solution Background process time ms: %f", (end - start) * 1000);
                
                scenarioFromID.solutionDataNeedsToBeProcessed = @NO;
                
                NSError *error = nil;
                if (![tmpContext save:&error]) {
                    NSLog(@"FAILED TO SAVE SOLUTION DATA AFTER PROCESSING! Error: %@", error);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:SOLUTION_DATA_FAILED_PROCESSING_NOTIFICATION object:nil];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:SOLUTION_DATA_FINISHED_PROCESSING_NOTIFICATION object:nil];
                    });
                }
            }
        }
        
    });
}

- (void)processSolutions
{
    @autoreleasepool {
        [self regenerateScenarioWidgets];
    }
    
    //Filter down to scenario widgets that have a numberPerWeek > 0
    NSMutableArray* arrayOfScenarioWidgets = [[NSMutableArray alloc] init];
    //Collect total number of infusions per week across all widgets
    int totalWidgetInfusions = 0;
    
    //Count total widget infusions & ignore widgets without any infusions
    for (ScenarioWidget *scenarioWidget in [self getScenarioWidgetsOrdered]) {
        int infusionsPerWeek = [scenarioWidget.infusionsPerWeek intValue];
        if(infusionsPerWeek > 0){
            totalWidgetInfusions += infusionsPerWeek;
            [arrayOfScenarioWidgets addObject:scenarioWidget];
        }
    }
    //Set infusion dist for all scenario widgets (infusionsPerWeek/totalWidgetInfusions)
    for (ScenarioWidget* scenarioWidget in arrayOfScenarioWidgets) {
        scenarioWidget.infusionDist = [NSNumber numberWithDouble:[scenarioWidget.infusionsPerWeek doubleValue] / (double)totalWidgetInfusions];
    }
    
    //Start algorithm
    [self startAlgorithmWithTotalWidgetInfusions:totalWidgetInfusions andScenarioWidgets:[NSArray arrayWithArray:arrayOfScenarioWidgets]];
}

- (void)regenerateScenarioWidgets
{
    //Delete all scenario widgets
    for (ScenarioWidget* scenarioWidget in self.scenarioWidgets) {
        [self.managedObjectContext deleteObject:scenarioWidget];
    }
    
    //get MakeStaffAttention and format to 2 decimals. MakeStaffAttention = inverse of MaxChairsPerStaff
    NSNumber* maxChairsPerStaff = self.scenario.maxChairsPerStaff;
    float fMakeStaffAttention = 1.0f / [maxChairsPerStaff floatValue];
    
    fMakeStaffAttention = [[NSNumber numberWithFloat:[[NSString stringWithFormat:@"%.2f", fMakeStaffAttention] floatValue]] floatValue];
    
    [self insertWidgetsRemicadeWithMakeStaffAttention:fMakeStaffAttention];
    if (self.scenario.presentation.includeStelara) {
        [self insertWidgetsStelaraWithMakeStaffAttention:fMakeStaffAttention];
    }
    if([self.scenario.presentation includeSimponiAria]) {
        [self insertWidgetSimponiAriaWithMakeStaffAttention:fMakeStaffAttention];
    }
    [self insertWidgetsOtherInfusionsWithMakeStaffAttention:fMakeStaffAttention];
    [self insertWidgetsOtherInjectionsWithMakeStaffAttention:fMakeStaffAttention];
}

- (void)insertWidgetsRemicadeWithMakeStaffAttention:(float)makeStaffAttention
{
    //Get remicade infusion associated with the scenario this SolutionDataObject belongs to.
    RemicadeInfusion* remicadeInfusion = self.scenario.remicadeInfusion;
    
    //Get remicade infusions per month
    int remicadeInfusionsPerMonth = [remicadeInfusion.avgInfusionsPerMonth intValue];
    
    //Get make times for remicade infusion inputs
    int iMakeTime_2hr = [remicadeInfusion infusionMakeTime2HR];
    int iMakeTime_25hr = [remicadeInfusion infusionMakeTime2_5HR];
    int iMakeTime_3hr = [remicadeInfusion infusionMakeTime3HR];
    int iMakeTime_35hr = [remicadeInfusion infusionMakeTime3_5HR];
    int iMakeTime_4hr = [remicadeInfusion infusionMakeTime4HR];
    
    int iRemicadePercent_2hr = [remicadeInfusion.percent2hr intValue];
    int iRemicadePercent_25hr = [remicadeInfusion.percent2_5hr intValue];
    int iRemicadePercent_3hr = [remicadeInfusion.percent3hr intValue];
    int iRemicadePercent_35hr = [remicadeInfusion.percent3_5hr intValue];
    int iRemicadePercent_4hr = [remicadeInfusion.percent4hr intValue];
    
    //Insert remicade widgets of each type (2, 2.5, 3, 3.5, and 4 hr variations)
    [self insertNewRemicadeWidgetWithRemicadeInfusionData:remicadeInfusion widgetType:WidgetTypeRemicade2HR makeTime:iMakeTime_2hr remicadePercent:iRemicadePercent_2hr infusionPerMonth:remicadeInfusionsPerMonth andMakeStaffAttention:makeStaffAttention];
    [self insertNewRemicadeWidgetWithRemicadeInfusionData:remicadeInfusion widgetType:WidgetTypeRemicade2_5HR makeTime:iMakeTime_25hr remicadePercent:iRemicadePercent_25hr infusionPerMonth:remicadeInfusionsPerMonth andMakeStaffAttention:makeStaffAttention];
    [self insertNewRemicadeWidgetWithRemicadeInfusionData:remicadeInfusion widgetType:WidgetTypeRemicade3HR makeTime:iMakeTime_3hr remicadePercent:iRemicadePercent_3hr infusionPerMonth:remicadeInfusionsPerMonth andMakeStaffAttention:makeStaffAttention];
    [self insertNewRemicadeWidgetWithRemicadeInfusionData:remicadeInfusion widgetType:WidgetTypeRemicade3_5HR makeTime:iMakeTime_35hr remicadePercent:iRemicadePercent_35hr infusionPerMonth:remicadeInfusionsPerMonth andMakeStaffAttention:makeStaffAttention];
    [self insertNewRemicadeWidgetWithRemicadeInfusionData:remicadeInfusion widgetType:WidgetTypeRemicade4HR makeTime:iMakeTime_4hr remicadePercent:iRemicadePercent_4hr infusionPerMonth:remicadeInfusionsPerMonth andMakeStaffAttention:makeStaffAttention];
    
}

- (void)insertNewRemicadeWidgetWithRemicadeInfusionData:(RemicadeInfusion*)remicadeInfusion widgetType:(WidgetType)widgetType makeTime:(int)makeTime remicadePercent:(int)remicadePercent infusionPerMonth:(int)infusionsPerMonth andMakeStaffAttention:(float)makeStaffAttention
{
    //get number per month of widget type taking percents into consideration
    int iWidgetCountPerMonth = [remicadeInfusion numberPerMonth:infusionsPerMonth byPercentage:remicadePercent];
    
    //convert widget count per month to per week
    int iWidgetCountPerWeek = [self convertInfusionsPerMonthToPerWeek:iWidgetCountPerMonth];
    
    //create remicade widget
    ScenarioWidget* widget = [NSEntityDescription insertNewObjectForEntityForName:@"ScenarioWidget" inManagedObjectContext:self.managedObjectContext];
    widget.widgetType = [NSNumber numberWithInteger:widgetType];    //Widget type
    widget.infusionsPerWeek = [NSNumber numberWithInt:iWidgetCountPerWeek];     //infusions per week
    widget.makeStaffAttention = [NSNumber numberWithFloat:makeStaffAttention];      //make staff attention
    widget.prepTime = [remicadeInfusion.prepTime copy];    //prep time from remicade inputs
    widget.prepQHP = @YES; //QHP can perform prep, ALWAYS TRUE
    widget.prepAncillary = [remicadeInfusion.prepAncillary copy];  //Ancillary can perform prep, comes from remicade inputs
    widget.makeTime = [NSNumber numberWithInt:makeTime];    //make time
    widget.makeQHP = @YES; //QHP can perform infusion, ALWAYS TRUE
    widget.makeAncillary = @YES;   //Ancillary can perform infusion, ALWAYS TRUE
    widget.postTime = [remicadeInfusion.postTime copy];    //post time from remicade inputs
    widget.postQHP = @YES; //QHP can perform post cleanup, ALWAYS TRUE
    widget.postAncillary = [remicadeInfusion.postAncillary copy];  //ancillary can perform post cleanup, comes from remicade inputs
    
    [self addScenarioWidgetsObject:widget];
    [widget setSolutionData:self];
}

- (void)insertWidgetSimponiAriaWithMakeStaffAttention:(float)makeStaffAttention
{
    
    SimponiAriaInfusion* simponiAriaInfusion = self.scenario.simponiAriaInfusion;
    
    int infusionsPerWeek = [self convertInfusionsPerMonthToPerWeek:[simponiAriaInfusion.avgInfusionsPerMonth intValue]];
    
    ScenarioWidget* widget = [NSEntityDescription insertNewObjectForEntityForName:@"ScenarioWidget" inManagedObjectContext:self.managedObjectContext];
    widget.widgetType = [NSNumber numberWithInteger:WidgetTypeSimponiAria];
    widget.infusionsPerWeek = [NSNumber numberWithInt:infusionsPerWeek];
    widget.makeStaffAttention = [NSNumber numberWithFloat:makeStaffAttention];
    widget.prepTime = [simponiAriaInfusion.prepTime copy];
    widget.prepQHP = @YES;
    widget.prepAncillary = [simponiAriaInfusion.prepAncillary copy];
    widget.makeTime = [simponiAriaInfusion.infusionAdminTime copy];
    widget.makeQHP = @YES;
    widget.makeAncillary = @YES;
    widget.postTime = [simponiAriaInfusion.postTime copy];
    widget.postQHP = @YES;
    widget.postAncillary = [simponiAriaInfusion.postAncillary copy];
    
    [self addScenarioWidgetsObject:widget];
    [widget setSolutionData:self];
}

- (void)insertWidgetsStelaraWithMakeStaffAttention:(float)makeStaffAttention
{
    
    StelaraInfusion* stelaraInfusion = self.scenario.stelaraInfusion;
    
    int infusionsPerWeek = [self convertInfusionsPerMonthToPerWeek:[stelaraInfusion.avgInfusionsPerMonth intValue]];
    
    ScenarioWidget* widget = [NSEntityDescription insertNewObjectForEntityForName:@"ScenarioWidget" inManagedObjectContext:self.managedObjectContext];
    widget.widgetType = [NSNumber numberWithInteger:WidgetTypeStelara];
    widget.infusionsPerWeek = [NSNumber numberWithInt:infusionsPerWeek];
    widget.makeStaffAttention = [NSNumber numberWithFloat:makeStaffAttention];
    widget.prepTime = [stelaraInfusion.prepTime copy];
    widget.prepQHP = @YES;
    widget.prepAncillary = [stelaraInfusion.prepAncillary copy];
    widget.makeTime = [stelaraInfusion.infusionAdminTime copy];
    widget.makeQHP = @YES;
    widget.makeAncillary = @YES;
    widget.postTime = [stelaraInfusion.postTime copy];
    widget.postQHP = @YES;
    widget.postAncillary = [stelaraInfusion.postAncillary copy];
    
    [self addScenarioWidgetsObject:widget];
    [widget setSolutionData:self];
}

- (void)insertWidgetsOtherInfusionsWithMakeStaffAttention:(float)makeStaffAttention
{
    //Get remicade infusion associated with the scenario this SolutionDataObject belongs to.
    RemicadeInfusion* remicadeInfusion = self.scenario.remicadeInfusion;
    
    //iterate over all other infusion inputs
    for (OtherInfusion* otherInfusion in self.scenario.otherInfusions) {
        WidgetType widgetType = [self getWidgetTypeForOtherInfusionType:[otherInfusion.otherInfusionTypeID integerValue]];
        int infusionsPerWeek = [self convertInfusionsPerMonthToPerWeek:[otherInfusion.treatmentsPerMonth intValue]];
        
        /*  SPECIAL INFUSION INSTRUCTIONS
         *  All Infusions will get their PrepStaff# and PostStaff# from remicade inputs
         */
        BOOL bPrepQHP = YES;     //ALWAYS TRUE
        BOOL bPostQHP = YES;     //ALWAYS TRUE
        BOOL bPrepAncillary = [remicadeInfusion.prepAncillary boolValue];  //From remicade inputs
        BOOL bPostAncillary = [remicadeInfusion.postAncillary boolValue];  //From remicade inputs
        
        //CREATE scenario widget for other infusion
        ScenarioWidget * widget = [NSEntityDescription insertNewObjectForEntityForName:@"ScenarioWidget" inManagedObjectContext:self.managedObjectContext];
        widget.widgetType = [NSNumber numberWithInteger:widgetType];    //widget type
        widget.infusionsPerWeek = [NSNumber numberWithInt:infusionsPerWeek];    //infusions per week
        widget.makeStaffAttention = [NSNumber numberWithFloat:makeStaffAttention];  //make staff attention
        widget.prepTime = [otherInfusion.prepTime copy];       //prep time from other infusioninputs
        widget.prepQHP = [NSNumber numberWithBool:bPrepQHP];    //QHP can perform prep, ALWAYS TRUE
        widget.prepAncillary = [NSNumber numberWithBool:bPrepAncillary]; //Ancillary can perform prep, comes from remicade inputs
        widget.makeTime = [otherInfusion.infusionTime copy];   //make time, from other infusion inputs
        widget.makeQHP = [NSNumber numberWithBool:YES]; //QHP can perform infusion, ALWAYS TRUE
        widget.makeAncillary = [NSNumber numberWithBool:YES];   //Ancillary can perform infusion, ALWAYS TRUE
        widget.postTime = [otherInfusion.postTime copy];   //post time from other infusion inputs
        widget.postQHP = [NSNumber numberWithBool:bPostQHP];   //QHP can perform post cleanup, ALWAYS TRUE
        widget.postAncillary = [NSNumber numberWithBool:bPostAncillary];    //ancillary can perform post cleanup, comes from remicade inputs
        
        [self addScenarioWidgetsObject:widget];
        [widget setSolutionData:self];
    }
}

- (void)insertWidgetsOtherInjectionsWithMakeStaffAttention:(float)makeStaffAttention
{
    
    // iterate over all other injection inputs
    for (OtherInjection* otherInjection in self.scenario.otherInjections) {
        WidgetType widgetType = [self getWidgetTypeForOtherInjectionType:[otherInjection.otherInjectionTypeID integerValue]];
        int infusionsPerWeek = [self convertInfusionsPerMonthToPerWeek:[otherInjection.treatmentsPerMonth intValue]];
        
        /*  SPECIAL INJECTION INSTRUCTIONS
         *  Prep, Post, and Make times are hard coded, not from user input
         *  Only PrepQHP should be true
         */
        BOOL bPrepQHP = YES;
        BOOL bPrepAncillary = NO;
        BOOL bPostQHP = NO;
        BOOL bPostAncillary = NO;
        
        //Get hardcoded times for injection types
        int prepTime = [OtherInjection getPrepTimeForOtherInjectionType:[otherInjection.otherInjectionTypeID integerValue]];
        int postTime = [OtherInjection getPostTimeForOtherInjectionType:[otherInjection.otherInjectionTypeID integerValue]];
        int makeTime = [OtherInjection getInfusionTimeForOtherInjectionType:[otherInjection.otherInjectionTypeID integerValue]];
        //CREATE scenario widget for other injection
        ScenarioWidget * widget = [NSEntityDescription insertNewObjectForEntityForName:@"ScenarioWidget" inManagedObjectContext:self.managedObjectContext];
        widget.widgetType = [NSNumber numberWithInteger:widgetType];    //widget type
        widget.infusionsPerWeek = [NSNumber numberWithInt:infusionsPerWeek];    //infusions per week
        widget.makeStaffAttention = [NSNumber numberWithFloat:makeStaffAttention];  //make staff attention
        widget.prepTime = [NSNumber numberWithInt:prepTime];    //prep time, hard coded in constants.h
        widget.prepQHP = [NSNumber numberWithBool:bPrepQHP];        //prep can be performed by QHP
        widget.prepAncillary = [NSNumber numberWithBool:bPrepAncillary];    //prep can be performed by ancillary
        widget.makeTime = [NSNumber numberWithInt:makeTime];    //make time, hard coded in constants.h
        widget.makeQHP = [NSNumber numberWithBool:YES]; //QHP can perform infusion, ALWAYS TRUE
        widget.makeAncillary = [NSNumber numberWithBool:YES];   //Ancillary can perform infusion, ALWAYS TRUE
        widget.postTime = [NSNumber numberWithInt:postTime];    //post time, hard coded in constants.h
        widget.postQHP = [NSNumber numberWithBool:bPostQHP];    //post can be performed by QHP
        widget.postAncillary = [NSNumber numberWithBool:bPostAncillary];    //post can be perfomed by ancillary
        
        [self addScenarioWidgetsObject:widget];
        [widget setSolutionData:self];
    }
}

- (int)convertInfusionsPerMonthToPerWeek:(int)infusionsPerMonth
{
    if (infusionsPerMonth == 0) return 0;
    
    float fInfusionsPerMonth = (float)infusionsPerMonth;
    float fWeekToMonth = WEEK_TO_MONTH_MULTIPLIER();
    float fInfusionsPerWeek = fInfusionsPerMonth / fWeekToMonth;
    
    
    return (int)MAX(1, roundf(fInfusionsPerWeek));
}

- (WidgetType)getWidgetTypeForOtherInfusionType:(OtherInfusionType)otherInfusionType
{
    switch (otherInfusionType) {
        case OtherInfusionTypeRxA:
            return WidgetTypeOtherInfusionRxA;
        case OtherInfusionTypeRxB:
            return WidgetTypeOtherInfusionRxB;
        case OtherInfusionTypeRxC:
            return WidgetTypeOtherInfusionRxC;
        case OtherInfusionTypeRxD:
            return WidgetTypeOtherInfusionRxD;
        case OtherInfusionTypeRxE:
            return WidgetTypeOtherInfusionRxE;
        case OtherInfusionTypeRxF:
            return WidgetTypeOtherInfusionRxF;
        default:
            //NSAssert(false, @"End of switch in [SolutionData getWidgetTypeForOtherInfusionType:]. SHOULD NOT HAPPEN!");
            NSLog(@"End of switch in [SolutionData getWidgetTypeForOtherInfusionType:]. SHOULD NOT HAPPEN!");
            return -1;  //This should not happen!
    }
}

- (WidgetType)getWidgetTypeForOtherInjectionType:(OtherInjectionType)otherInjectionType
{
    switch (otherInjectionType) {
        case OtherInjectionType1:
            return WidgetTypeOtherInjection1;
        case OtherInjectionType2:
            return WidgetTypeOtherInjection2;
        case OtherInjectionType3:
            return WidgetTypeOtherInjection3;
        case OtherInjectionType4:
            return WidgetTypeOtherInjection4;
        case OtherInjectionType5:
            return WidgetTypeOtherInjection5;
        default:
            //NSAssert(false, @"End of switch in [SolutionData getWidgetTypeForOtherInjectionType:]. SHOULD NOT HAPPEN!");
            NSLog(@"End of switch in [SolutionData getWidgetTypeForOtherInjectionType:]. SHOULD NOT HAPPEN!");
            return -1;  //This should not happen!
    }
}

- (void)startAlgorithmWithTotalWidgetInfusions:(int)iTotalWidgetInfusions andScenarioWidgets:(NSArray*)scenarioWidgetsArray
{
    int totalSolWidgets = 0; //will keep a running count of the total amount of SolWidgets we place in current schedule
    int totalSolFullWidgets = 0; //will keep a running count of the total amount of SolWidgets we place in full schedule
    
    //Get staff 3d array...
    MultiDimensionalArray *scenarioStaffArray = [self.scenario getScenarioStaffArray];
    //NSMutableDictionary* scenarioStaffArray = [self.scenario getScenarioStaffArray];
    
    //get chairs 3d array...
    MultiDimensionalArray *machinesArray = [self.scenario getMachineArray];
    //NSMutableDictionary* machinesArray = [self.scenario getMachineArray];
    
    int numberOfChairs = [self.scenario.chairs count];
    
    for (int d = 0; d < NUMBER_OF_DAYS; d++ )         //Days of week 0-6
    {
        for (int m = 0; m < numberOfChairs; m++)          //number of chairs
        {
            for (int t = 0; t < NUMBER_OF_TEN_MINUTE_PERIODS_IN_DAY; t = t * 1)    //Number of 10 minute periods in each day, increment is dependent and set inside loop
            {
                
                //Walk through all Scenario widgets, if one can fit, add it to array of placeable widgets
                NSMutableArray* arrayPlaceableWidgets = [[NSMutableArray alloc] init];
                
                NSNumber* obj = [machinesArray getObjectAtX:d Y:t Z:m];    //[machinesArray objectAtDimensions:3, d, t, m, nil]
                if((id)obj != [NSNull null] && [obj intValue] == 1) //machine available here
                {
                    for (int w = 0; w < [scenarioWidgetsArray count]; w++)  //walk through all widgets
                    {
                        ScenarioWidget* widget = [scenarioWidgetsArray objectAtIndex:w];
                        
                        if([widget.infusionsPerWeek intValue] - [widget numberOfSolutionWidgetsInCurrentSchedule] > 0) //We have more widgets of the type to place
                        {
                            //Check if widget fits
                            @autoreleasepool {
                                WidgetPlaceable* placeable = [widget getPlaceableWidgetForDay:d time:t machineIndex:m withScenarioStaffArray:scenarioStaffArray andMachinesArray:machinesArray];
                                if (placeable) {
                                    placeable.scenarioWidget = widget;
                                    [arrayPlaceableWidgets addObject:placeable];
                                }
                            }
                            
                        }
                    }
                }
                
                if([arrayPlaceableWidgets count] == 0)  //no widget was made because 1.) no machine; 2.) Widgets could not fit in time frame
                {
                    t++;    //normal increment
                }
                else    //widgets can fit in this slot, and their info is stored in arrayPlaceableWidgets
                    //Walk through widgets and place the optimal one in our schedule
                {
                    @autoreleasepool {
                        //Get optimal widget
                        WidgetPlaceable* optimalWidget = [self findOptimalPlaceableWidgetForPlaceables:arrayPlaceableWidgets andScenarioWidgets:scenarioWidgetsArray];
                        
                        //Place optimal widget in our schedule
                        ScenarioWidget* widget = optimalWidget.scenarioWidget;
                        [self placeScenarioWidget:widget inScheduleForDay:d time:t machineIndex:m optimalWidgetPlaceable:optimalWidget andIsFullSchedule:NO];
                        
                        //update solution Arrays
                        [self updateSolutionArraysForDay:d time:t machinIndex:m scenarioWidget:widget placeableWidget:optimalWidget staffAvailabilityArray:scenarioStaffArray andMachineAvailabilityArray:machinesArray];
                        
                        //inc time by the total time of our optimal widget
                        t += [widget totalTime];
                        //inc number of widgets placed in schedule
                        totalSolWidgets++;
                    }
                    
                    if(totalSolWidgets == iTotalWidgetInfusions)
                    {
                        //We are done processing all widgets for the current schedule
                        //Set local loop counters past their max values to stop processing.
                        t = 1000;
                        d = 1000;
                        m = 1000;
                    }
                }
            }// End of t - time loop
        }// End of m - machine loop
    }// End of d - day loop
    
    //Process the full schedule
    for (int d = 0; d < NUMBER_OF_DAYS; d++ )         //Days of week 0-6
    {
        for (int m = 0; m < numberOfChairs; m++)          //number of chairs
        {
            for (int t = 0; t < NUMBER_OF_TEN_MINUTE_PERIODS_IN_DAY; t = t * 1)    //Number of 10 minute periods in each day, increment is dependent and set inside loop
            {
                //Walk through all Scenario widgets, if one can fit, add it to array of placeable widgets
                NSMutableArray* arrayPlaceableWidgets = [[NSMutableArray alloc] init];
                
                NSNumber* obj = [machinesArray getObjectAtX:d Y:t Z:m];        //[machinesArray objectAtDimensions:3, d, t, m, nil]
                if((id)obj != [NSNull null] && [obj intValue] == 1) //machine available here
                {
                    for (int w = 0; w < [scenarioWidgetsArray count]; w++)  //walk through all widgets
                    {
                        ScenarioWidget* widget = [scenarioWidgetsArray objectAtIndex:w];
                        if(widget.infusionsPerWeek > 0 &&
                           ([widget.widgetType integerValue] == WidgetTypeRemicade2HR ||
                            [widget.widgetType integerValue] == WidgetTypeRemicade2_5HR ||
                            [widget.widgetType integerValue] == WidgetTypeRemicade3HR ||
                            [widget.widgetType integerValue] == WidgetTypeRemicade3_5HR ||
                            [widget.widgetType integerValue] == WidgetTypeRemicade4HR ||
                            [widget.widgetType integerValue] == WidgetTypeSimponiAria ||
                            [widget.widgetType integerValue] == WidgetTypeStelara))
                        {   //This is a remicade or simponi widget and was in the original schedule
                            //Check if widget fits
                            
                            @autoreleasepool {
                                WidgetPlaceable* placeable = [widget getPlaceableWidgetForDay:d time:t machineIndex:m withScenarioStaffArray:scenarioStaffArray andMachinesArray:machinesArray];
                                if (placeable) {
                                    placeable.scenarioWidget = widget;
                                    [arrayPlaceableWidgets addObject:placeable];
                                }
                            }
                            
                        }
                    }
                }
                
                if([arrayPlaceableWidgets count] == 0)  //no widget was made because 1.) no machine; 2.) Widgets could not fit in time frame
                {
                    t++;    //normal increment
                }
                else    //widgets can fit in this slot, and their info is stored in arrayPlaceableWidgets
                    //Walk through widgets and place the optimal one in our schedule
                {
                    @autoreleasepool {
                        //Get optimal widget
                        WidgetPlaceable* optimalWidget = [self findFullScheduleOptimalPlaceableWidgetForPlaceables:arrayPlaceableWidgets andScenarioWidgets:scenarioWidgetsArray];
                        
                        //Place optimal widget in our schedule
                        ScenarioWidget* widget = optimalWidget.scenarioWidget;
                        [self placeScenarioWidget:widget inScheduleForDay:d time:t machineIndex:m optimalWidgetPlaceable:optimalWidget andIsFullSchedule:YES];
                        
                        //update solution Arrays
                        [self updateSolutionArraysForDay:d time:t machinIndex:m scenarioWidget:widget placeableWidget:optimalWidget staffAvailabilityArray:scenarioStaffArray andMachineAvailabilityArray:machinesArray];
                        
                        //inc time by the total time of our optimal widget
                        t += [widget totalTime];
                        //inc number of widgets placed in schedule
                        totalSolFullWidgets++;
                    }
                    
                }
                
            }// End of t - time loop
        }// End of m - machine loop
    }// End of d - day loop
}

- (WidgetPlaceable*)findOptimalPlaceableWidgetForPlaceables:(NSArray*)placeableWidgetsArray andScenarioWidgets:(NSArray*)scenarioWidgetsArray
{
    int totalInSchedule = 0;
    //double tempSolWidgetInfusionDistribution[[scenarioWidgetsArray count]];
    //double scores[[placeableWidgetsArray count]];
    
    for (ScenarioWidget* scenarioWidget in scenarioWidgetsArray) {  //walk through all widgets
        //count number of widgets in schedule
        totalInSchedule += [scenarioWidget numberOfSolutionWidgetsInCurrentSchedule];
    }
    totalInSchedule++;  //because we are faking that we are adding another widget
    
    //Calculate score if we place each widget in schedule
    for (int p = 0; p < [placeableWidgetsArray count]; p++)
    {   //walk through all placeable widgets
        
        //scores[p] = 0;  //set initial score to 0
        WidgetPlaceable* placeable = [placeableWidgetsArray objectAtIndex:p];
        //set initial store to 0
        placeable.score = 0;
        
        for (int i = 0; i < [scenarioWidgetsArray count]; i++)
        {    //walk through all scenario widgets
            ScenarioWidget* widget = [scenarioWidgetsArray objectAtIndex:i];
            double tempWidgetInfusionDistribution = 0;
            if (placeable.scenarioWidget != widget)
            {
                tempWidgetInfusionDistribution = (double)([widget numberOfSolutionWidgetsInCurrentSchedule]) / totalInSchedule;
            }
            else
            {
                tempWidgetInfusionDistribution = (double)([widget numberOfSolutionWidgetsInCurrentSchedule] + 1) / totalInSchedule;
            }
            
            //add to score
            double val = (double)([widget.infusionDist doubleValue] - tempWidgetInfusionDistribution);
            placeable.score += pow(val, 2);
        }
    }
    
    
    //step 1:
    //Separate placeable widgets into infusions and injections
    NSMutableArray * placeableInfusions = [NSMutableArray array];
    NSMutableArray * placeableInjections = [NSMutableArray array];
    NSMutableArray * optimalChoices = nil;
    for (WidgetPlaceable* placeable in placeableWidgetsArray)
    {   //scores length is equal to [placeableWidgetsArray count]
        if (placeable.widgetType == WidgetTypeOtherInjection1 || placeable.widgetType == WidgetTypeOtherInjection2 ||
            placeable.widgetType == WidgetTypeOtherInjection3 || placeable.widgetType == WidgetTypeOtherInjection4 ||
            placeable.widgetType == WidgetTypeOtherInjection5)
        {
            [placeableInjections addObject:placeable];
        }
        else
        {
            [placeableInfusions addObject:placeable];
        }
    }
    
    //Step 2:
    //If there are any infusions, ignore injections
    if ([placeableInfusions count] > 0)
    {
        optimalChoices = placeableInfusions;
    }
    else
    {
        optimalChoices = placeableInjections;
    }
    
    //Step 3:
    //Remove placeables from optimalChoices unless they have the lowest score
    if ([optimalChoices count] > 1)
    {
        NSSortDescriptor* scoreSort = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:YES];
        [optimalChoices sortUsingDescriptors:@[scoreSort]];
        
        double lowestScore = ((WidgetPlaceable*)[optimalChoices objectAtIndex:0]).score;
        
        //remove all optimal widgets that do not have the lowest score
        for (int i = [optimalChoices count] - 1; i >= 0; i--) {
            WidgetPlaceable* placeable = [optimalChoices objectAtIndex:i];
            if (placeable.score != lowestScore) {
                [optimalChoices removeObjectAtIndex:i];
            }
        }
    }
    
    //Step 4:
    //Weight times
    if([optimalChoices count] > 1)
    {
        WidgetPlaceable* placeable = [optimalChoices objectAtIndex:0];
        ScenarioWidget* widget = placeable.scenarioWidget;
        int longestTime = [widget totalTime];
        
        //Find longest widget time
        for (int i = 0; i < [optimalChoices count]; i++) {
            WidgetPlaceable* placeable = [optimalChoices objectAtIndex:i];
            ScenarioWidget* widget = placeable.scenarioWidget;
            int timeTemp = [widget totalTime];
            if(timeTemp > longestTime) {
                longestTime = timeTemp;
            }
        }
        
        //return first found with longest time
        for (int i = 0; i < [optimalChoices count]; i++) {
            WidgetPlaceable* placeable = [optimalChoices objectAtIndex:i];
            ScenarioWidget* widget = placeable.scenarioWidget;
            int timeTemp = [widget totalTime];
            
            if(timeTemp == longestTime) {
                return placeable;
            }
        }
    }
    
    //return first in array
    return [optimalChoices objectAtIndex:0];
}

- (WidgetPlaceable*)findFullScheduleOptimalPlaceableWidgetForPlaceables:(NSArray*)placeableWidgetsArray andScenarioWidgets:(NSArray*)scenarioWidgetsArray
{
    BOOL simponiHasDistribution = ([self.scenario.presentation includeSimponiAria] && [self.scenario.simponiAriaInfusion.avgInfusionsPerMonth intValue] > 0);
    double simponiAriaInfusionsInFullScheduleDistribution = (simponiHasDistribution) ? 0.5 : 0.0;
    
    BOOL stelaraHasDistribution = ([self.scenario.presentation includeStelara] && [self.scenario.stelaraInfusion.avgInfusionsPerMonth intValue] > 0);
    double stelaraInfusionsInFullScheduleDistribution = (stelaraHasDistribution) ? 0.5 : 0.0;
    
    double remicadeDistributionFactor = (simponiHasDistribution) ? 0.5 : 1.0;
    double rem2HrInfusionsInFullScheduleDistribution = ([self.scenario.remicadeInfusion.percent2hr doubleValue] / 100.0) * remicadeDistributionFactor;
    double rem25HrInfusionsInFullScheduleDistribution = ([self.scenario.remicadeInfusion.percent2_5hr doubleValue] / 100.0) * remicadeDistributionFactor;
    double rem3HrInfusionsInFullScheduleDistribution = ([self.scenario.remicadeInfusion.percent3hr doubleValue] / 100.0) * remicadeDistributionFactor;
    double rem35HrInfusionsInFullScheduleDistribution = ([self.scenario.remicadeInfusion.percent3_5hr doubleValue] / 100.0) * remicadeDistributionFactor;
    double rem4HrInfusionsInFullScheduleDistribution = ([self.scenario.remicadeInfusion.percent4hr doubleValue] / 100.0) * remicadeDistributionFactor;
    
    //int numOfTypeOfRemInfusions = 0;
    //Filter out the allowed infusions for full schedule from Scenario Widgets
    //Only remicade and simponi are allowed
    
    NSMutableArray *arrayOfAllowedFullScheduleInfusions = [NSMutableArray array];
    for (ScenarioWidget* widget in scenarioWidgetsArray)
    {
        if (widget.infusionsPerWeek > 0 &&
            ([widget.widgetType integerValue] == WidgetTypeRemicade2HR ||
             [widget.widgetType integerValue] == WidgetTypeRemicade2_5HR ||
             [widget.widgetType integerValue] == WidgetTypeRemicade3HR ||
             [widget.widgetType integerValue] == WidgetTypeRemicade3_5HR ||
             [widget.widgetType integerValue] == WidgetTypeRemicade4HR ||
             [widget.widgetType integerValue] == WidgetTypeSimponiAria||
             [widget.widgetType integerValue] == WidgetTypeStelara)
            )
        {   //we have a remicade infusion or simponi infusion to add to add
            //numOfTypeOfRemInfusions++;   //increment total
            [arrayOfAllowedFullScheduleInfusions addObject:widget];
        }
    }
    
    int numberOfAllowedFullScheduleInfusions = [arrayOfAllowedFullScheduleInfusions count];
    
    double aSelectedInfusionsInFullScheduleDistribution[numberOfAllowedFullScheduleInfusions];
    for (int i = 0; i < numberOfAllowedFullScheduleInfusions; i++) {
        ScenarioWidget* widget = [arrayOfAllowedFullScheduleInfusions objectAtIndex:i];
        double dist = 0;
        switch ([widget.widgetType integerValue]) {
            case WidgetTypeRemicade2HR:
                dist = rem2HrInfusionsInFullScheduleDistribution;
                break;
            case WidgetTypeRemicade2_5HR:
                dist = rem25HrInfusionsInFullScheduleDistribution;
                break;
            case WidgetTypeRemicade3HR:
                dist = rem3HrInfusionsInFullScheduleDistribution;
                break;
            case WidgetTypeRemicade3_5HR:
                dist = rem35HrInfusionsInFullScheduleDistribution;
                break;
            case WidgetTypeRemicade4HR:
                dist = rem4HrInfusionsInFullScheduleDistribution;
                break;
            case WidgetTypeSimponiAria:
                dist = simponiAriaInfusionsInFullScheduleDistribution;
                break;
            case WidgetTypeStelara:
                dist = stelaraInfusionsInFullScheduleDistribution;
        }
        aSelectedInfusionsInFullScheduleDistribution[i] = dist;
    }
    
    int totalInFullSchedule = 0;  //Will hold the total additional widgets we fit in FullSchedule
    
    for (int i = 0; i < numberOfAllowedFullScheduleInfusions; i++)
    {
        ScenarioWidget* widget = [arrayOfAllowedFullScheduleInfusions objectAtIndex:i];
        totalInFullSchedule += [widget numberOfSolutionWidgetsInFullSchedule];
    }
    
    totalInFullSchedule++;  //inc 1 more, because we are faking that we are adding another widget
    
    for (int p = 0; p < [placeableWidgetsArray count]; p++) //walk through all placeable widgets
    {
        WidgetPlaceable* placeable = [placeableWidgetsArray objectAtIndex:p];
        //set initial store to 0
        placeable.score = 0;
        for (int i = 0; i < numberOfAllowedFullScheduleInfusions; i++) {
            ScenarioWidget* widget = [arrayOfAllowedFullScheduleInfusions objectAtIndex:i];
            double tempWidgetInfusionDistribution = 0;
            if (placeable.scenarioWidget != widget)
            {
                tempWidgetInfusionDistribution = ((double)[widget numberOfSolutionWidgetsInFullSchedule]) / totalInFullSchedule;
            }
            else
            {
                tempWidgetInfusionDistribution = ((double)[widget numberOfSolutionWidgetsInFullSchedule] + 1) / totalInFullSchedule;
            }
            
            placeable.score += pow(aSelectedInfusionsInFullScheduleDistribution[i] - tempWidgetInfusionDistribution, 2);
        }
    }
    
    NSSortDescriptor* minScoreSort = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:YES];
    NSArray* sortedPlaceables = [placeableWidgetsArray sortedArrayUsingDescriptors:@[minScoreSort]];
    
    return [sortedPlaceables objectAtIndex:0];
}

- (void)placeScenarioWidget:(ScenarioWidget*)scenarioWidget inScheduleForDay:(int)day time:(int)time machineIndex:(int)machineIndex optimalWidgetPlaceable:(WidgetPlaceable*)widgetPlaceable andIsFullSchedule:(BOOL)isFullSchedule
{
    int index = [[scenarioWidget.solutionData.scenario getAllSolutionWidgetsInSchedule] count] + 1;
    
    SolutionWidgetInSchedule* solutionWidget = [NSEntityDescription insertNewObjectForEntityForName:@"SolutionWidgetInSchedule" inManagedObjectContext:self.managedObjectContext];
    solutionWidget.widgetType = scenarioWidget.widgetType;
    solutionWidget.indexNum = [NSNumber numberWithInt:index];
    solutionWidget.scheduleDay = [NSNumber numberWithInt:day];
    solutionWidget.scheduleTime = [NSNumber numberWithInt:time];
    solutionWidget.scheduleMachine = [NSNumber numberWithInt:machineIndex];
    solutionWidget.prepStaffTypeID = [NSNumber numberWithInt:widgetPlaceable.prepStaffType];
    solutionWidget.makeStaffTypeID = [NSNumber numberWithInt:999];
    solutionWidget.postStaffTypeID = [NSNumber numberWithInt:widgetPlaceable.postStaffType];
    solutionWidget.isFullLoad = [NSNumber numberWithBool:isFullSchedule];
    solutionWidget.scenarioWidget = scenarioWidget;
    [scenarioWidget addSolutionWidgetsInScheduleObject:solutionWidget];
}

- (void)updateSolutionArraysForDay:(int)day time:(int)time machinIndex:(int)machineIndex scenarioWidget:(ScenarioWidget*)scenarioWidget placeableWidget:(WidgetPlaceable*)placeableWidget staffAvailabilityArray:(MultiDimensionalArray*)staffAvailabilityArray andMachineAvailabilityArray:(MultiDimensionalArray*)machineAvailabilityArray
{
    for (int i = 0; i < [scenarioWidget totalTime]; i++)
    {
        //Clear machine availability at this day, time, and machine index
        [machineAvailabilityArray removeObjectAtX:day Y:time + i Z:machineIndex];       //[machineAvailabilityArray removeObjectAtDimensions:3, day, time + i, machineIndex, nil];
        
        if (i < [scenarioWidget.prepTime intValue]) //Prep
        {
            int staffTypeIndex = (placeableWidget.prepStaffType == StaffTypeQHP) ? 0 : 1;
            ScenarioStaff *sstaff = [staffAvailabilityArray getObjectAtX:staffTypeIndex Y:day Z:time+i];        //[staffAvailabilityArray objectAtDimensions:3, staffTypeIndex, day, time+i, nil];
            sstaff.primaryFocus--;
            sstaff.chairLimit -= [scenarioWidget.makeStaffAttention floatValue];
        }
        else if (i < [scenarioWidget.prepTime intValue] + [scenarioWidget.makeTime intValue]) //makeTime
        {
            int makeStaffTypeID = i - ([scenarioWidget.prepTime intValue]);
            int staffTypeID = [[placeableWidget.makeStaffTypes objectAtIndex:makeStaffTypeID] intValue];
            int staffTypeIndex = (staffTypeID == StaffTypeQHP) ? 0 : 1;
            ScenarioStaff *sstaff = [staffAvailabilityArray getObjectAtX:staffTypeIndex Y:day Z:time+i];        //[staffAvailabilityArray objectAtDimensions:3, staffTypeIndex, day, time+i, nil];
            sstaff.chairLimit -= [scenarioWidget.makeStaffAttention floatValue];
        }
        else
        {
            int staffTypeIndex = (placeableWidget.postStaffType == StaffTypeQHP) ? 0 : 1;
            ScenarioStaff *sstaff = [staffAvailabilityArray getObjectAtX:staffTypeIndex Y:day Z:time+i];        //[staffAvailabilityArray objectAtDimensions:3, staffTypeIndex, day, time+i, nil];
            sstaff.primaryFocus--;
            sstaff.chairLimit -= [scenarioWidget.makeStaffAttention floatValue];
        }
    }
}

- (NSArray*)getScenarioWidgetsOrdered
{
    NSArray* scenarioWidgets = [self.scenarioWidgets allObjects];
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"widgetType" ascending:YES];
    return [scenarioWidgets sortedArrayUsingDescriptors:@[sort]];
}

+ (int)getPeriodForTime:(NSDate*)time
{
    if(!time || (id)time == [NSNull null]) return 0;
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:time];
    int hour = [components hour];
    int minute = [components minute];
    
    return ((hour*60) + minute)/10;
}

- (NSNumber*)getTotalWidgetsInFullLoadSchedule
{
    int total = 0;
    for (ScenarioWidget *widget in self.scenarioWidgets) {
        total += [widget numberOfSolutionWidgetsInFullSchedule];
    }
    
    return @(total);
}

- (NSInteger)getTotalWidgetsInCurrentSchedule
{
    NSInteger total = 0;
    for (ScenarioWidget *widget in self.scenarioWidgets) {
        total += [widget numberOfSolutionWidgetsInCurrentSchedule];
    }
    
    return total;
}

- (int)getTotalInfusionsInputPerWeek
{
    int total = 0;
    for (ScenarioWidget *widget in self.scenarioWidgets) {
        total += [[widget infusionsPerWeek] intValue];
    }
    return total;
}

@end
