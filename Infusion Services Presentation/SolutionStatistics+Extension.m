 //
//  SolutionStatistics+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/6/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "SolutionStatistics+Extension.h"
#import "Scenario+Extension.h"
#import "SolutionData+Extension.h"
#import "Chair+Extension.h"
#import "SolutionSchedule.h"
#import "RemicadeInfusion+Extension.h"
#import "StelaraInfusion+CoreDataClass.h"
#import "SimponiAriaInfusion+Extension.h"
#import "SolutionWidgetInSchedule+Extension.h"
#import "ScenarioWidget+Extension.h"
#import "OtherInfusion+Extension.h"

@implementation SolutionStatistics (Extension)

+ (SolutionStatistics*)getSolutionStatisticsForScenario:(Scenario*)scenario
{
    if(!scenario) return nil;
    
    SolutionData* solData = [SolutionData getSolutionDataForScenario:scenario];
    SolutionStatistics* solStats = solData.solutionStatistics;
    if(!solStats) {
        solStats = [NSEntityDescription insertNewObjectForEntityForName:@"SolutionStatistics" inManagedObjectContext:scenario.managedObjectContext];
        
        //Set relationship
        [solData setSolutionStatistics:solStats];
        [solStats setSolutionData:solData];
    }
    
    return solStats;
}

+ (void)processSolutionStatisticsForScenario:(Scenario*)scenario
{
    if(!scenario || !scenario.solutionData) return;
    
    //Delete old solution statistics
    SolutionStatistics* solStats = scenario.solutionData.solutionStatistics;
    if(solStats){
        solStats.solutionData = nil;
        scenario.solutionData.solutionStatistics = nil;
        [scenario.managedObjectContext deleteObject:solStats];
        solStats = nil;
    }
    
    //Get number of days with atleast one chair available
    int daysWithAtleastOneChairWithTime = [scenario getDaysWithAtleastOneChairAvailable];  //Values 0-7. If day has at least one chair with a time > 0, inc
    /*for (int i = 0 ; i < 7; i++) {
        for (Chair* chair in scenario.chairs) {
            if ([chair hasHoursOnDay:i]) {
                daysWithAtleastOneChairWithTime++;
                break;
            }
        }
    }*/
    
    //get new solution statistics object
    solStats = [[self class] getSolutionStatisticsForScenario:scenario];
    
    //Create solution schedule helper object
    SolutionSchedule* solSchedule = [[SolutionSchedule alloc] initWithScenario:scenario];
    
    //Set machine schedule info on solution statistics object
    [solSchedule setMachineScheduleInfoForSolutionStatistics:solStats dayStart:0 timeStart:0 dayStop:7 timeStop:0];
    
    //Set staff schedule info on solution statistics object
    //Staff type QHP
    [solSchedule setStaffScheduleInfoForSolutionStatistics:solStats staffType:StaffTypeQHP dayStart:0 timeStart:0 dayStop:7 timeStop:0];
    //Staff type Ancillary
    [solSchedule setStaffScheduleInfoForSolutionStatistics:solStats staffType:StaffTypeAncillary dayStart:0 timeStart:0 dayStop:7 timeStop:0];
    
    //Set properties
    solStats.maxChairsPerStaff = [solStats.solutionData.scenario.maxChairsPerStaff copy];
    solStats.daysWithAtleastOneChairWithTime = [NSNumber numberWithInt:daysWithAtleastOneChairWithTime];
    solStats.totalChairs = [NSNumber numberWithInteger:[scenario.chairs count]];
    
    solStats.totalRemicadeCurrentLoad = [NSNumber numberWithInt:solSchedule.totalRemicadeInCurrentSchedule];
    solStats.totalRemicadeFullLoad = [NSNumber numberWithInt:solSchedule.totalRemicadeInFullLoad];
    solStats.totalSimponiAriaCurrentLoad = [NSNumber numberWithInt:solSchedule.totalSimponiAriaInCurrentSchedule];
    solStats.totalSimponiAriaFullLoad = [NSNumber numberWithInt:solSchedule.totalSimponiAriaInFullSchedule];
    solStats.totalStelaraCurrentLoad = [NSNumber numberWithInt:solSchedule.totalStelaraInCurrentSchedule];
    solStats.totalStelaraFullLoad = [NSNumber numberWithInt:solSchedule.totalStelaraInFullSchedule];
    solStats.totalInfusion = [NSNumber numberWithInt:solSchedule.totalInfusion];
    solStats.totalInjection = [NSNumber numberWithInt:solSchedule.totalInjection];
}

- (float)totalChairHours
{
    return ([self.totalChairTime floatValue] * 10) / 60;
}

- (float)totalChairHoursUsedCurrentLoad
{
    return ([self.totalChairTimeUsedCurrentLoad floatValue] * 10) / 60;
}

- (float)totalChairHoursUsedFullLoad
{
    return ([self.totalChairTimeUsedFullLoad floatValue] * 10) / 60;
}

- (float)totalChairHoursChange
{
    if ([self totalChairHoursUsedCurrentLoad] == 0)
    {
        return 0;
    }
    
    return ([self totalChairHoursUsedFullLoad] - [self totalChairHoursUsedCurrentLoad]) / [self totalChairHoursUsedCurrentLoad];
}

- (float)chairHoursCapacityCurrentLoad
{
    if([self totalChairHours] == 0) {
        return 0;
    }
    
    return [self totalChairHoursUsedCurrentLoad] / [self totalChairHours];
}

- (float)chairHoursCapacityFullLoad
{
    if([self totalChairHours] == 0) {
        return 0;
    }
    
    return [self totalChairHoursUsedFullLoad] / [self totalChairHours];
}

- (int)totalStaffTime
{
    return [self.totalPrimaryFocusOfStaffTypeQHP intValue] + [self.totalPrimaryFocusOfStaffTypeAncillary intValue];
}

- (float)totalStaffHours
{
    return ((float)[self totalStaffTime] *10.0f) /60.0f;
}

- (double)totalStaffHoursUsedCurrentLoad
{
    //BGT TimeUtilized Calculation example:
    //                                              _________________________________
    //Example for Widget 4 hr  = 24 timeticks =    [ 1 | 1 |       19        | 2 | 1 ]
    //                                              `````````````````````````````````
    //BGT TimeUtilized = TotalPrimaryFocus + (MakeStaffAttention * TotalMakeTimeUsed)
    //                 =  (1 + 1 + 2 + 1)  + (     0.25          *       19         )
    //                 =              (5)  + (4.75)
    //
    double maxChairsPerStaff = [self.maxChairsPerStaff doubleValue];
    double makeStaffAttention = (1.0 / maxChairsPerStaff);
    //CALCULATE:dTotalHoursUtilized_CurrentLoad
    //Get TotalStaffTimeUsed based on the TotalStaffAttentionUsed and MakeStaffAttention
    double totalStaffTimeUsed = ([self.totalMakeStaffAttentionUsedOfStaffTypeQHPCurrentLoad doubleValue] + [self.totalMakeStaffAttentionUsedOfStaffTypeQHPCurrentLoad doubleValue]) / makeStaffAttention;
    //Get TotalMakeTimeUsed by taking the TotalStaffTimeUsed and subtracting TotalPrimaryFocusUsed
    double totalMakeTimeUsed = totalStaffTimeUsed - ([self.totalPrimaryFocusUsedOfStaffTypeQHPCurrentLoad intValue] + [self.totalPrimaryFocusUsedOfStaffTypeAncillaryCurrentLoad intValue]);
    //Decision: use BGT TimeUtilized calculation to show the TotalTimeUtilized
    double totalTimeUtilized = ([self.totalPrimaryFocusUsedOfStaffTypeQHPCurrentLoad intValue] + [self.totalPrimaryFocusUsedOfStaffTypeAncillaryCurrentLoad intValue]) + (makeStaffAttention * totalMakeTimeUsed);
    //Decision: make sure the time utilized is not displaying a time greater than that we have available.
    if (totalTimeUtilized > ([self.totalPrimaryFocusUsedOfStaffTypeQHPCurrentLoad intValue] + [self.totalPrimaryFocusUsedOfStaffTypeAncillaryCurrentLoad intValue])) {
        totalTimeUtilized = ([self.totalPrimaryFocusUsedOfStaffTypeQHPCurrentLoad intValue] + [self.totalPrimaryFocusUsedOfStaffTypeAncillaryCurrentLoad intValue]);
    }
    
    //Convert to hours
    double totalHoursUtilized = (totalTimeUtilized * 10.0) / 60.0;
    return  totalHoursUtilized;
}

- (double)totalStaffHoursUsedFullLoad
{
    //BGT TimeUtilized Calculation example:
    //                                              _________________________________
    //Example for Widget 4 hr  = 24 timeticks =    [ 1 | 1 |       19        | 2 | 1 ]
    //                                              `````````````````````````````````
    //BGT TimeUtilized = TotalPrimaryFocus + (MakeStaffAttention * TotalMakeTimeUsed)
    //                 =  (1 + 1 + 2 + 1)  + (     0.25          *       19         )
    //                 =              (5)  + (4.75)
    //
    double makeStaffAttention = 1.0f / [self.maxChairsPerStaff doubleValue];
    //CALCULATE:dTotalHoursUtilized
    //Get TotalStaffTimeUsed based on the TotalStaffAttentionUsed and MakeStaffAttention
    double totalStaffTimeUsed = ([self.totalMakeStaffAttentionUsedOfStaffTypeQHPFullLoad doubleValue] + [self.totalMakeStaffAttentionUsedOfStaffTypeQHPFullLoad doubleValue]) / makeStaffAttention;
    //Get TotalMakeTimeUsed by taking the TotalStaffTimeUsed and subtracting TotalPrimaryFocusUsed
    float totalMakeTimeUsed = totalStaffTimeUsed - ([self.totalPrimaryFocusUsedOfStaffTypeQHPFullLoad doubleValue] + [self.totalPrimaryFocusUsedOfStaffTypeAncillaryFullLoad doubleValue]);
    //Decision: use BGT TimeUtilized calculation to show the TotalTimeUtilized
    float totalTimeUtilized = ([self.totalPrimaryFocusUsedOfStaffTypeQHPFullLoad doubleValue] + [self.totalPrimaryFocusUsedOfStaffTypeAncillaryFullLoad doubleValue]) + (makeStaffAttention * totalMakeTimeUsed);
    //Decision: make sure the time utilized is not displaying a time greater than that we have available.
    if (totalTimeUtilized > ([self.totalPrimaryFocusUsedOfStaffTypeQHPFullLoad doubleValue] + [self.totalPrimaryFocusUsedOfStaffTypeAncillaryFullLoad doubleValue])) {
        totalTimeUtilized = ([self.totalPrimaryFocusUsedOfStaffTypeQHPFullLoad doubleValue] + [self.totalPrimaryFocusUsedOfStaffTypeAncillaryFullLoad doubleValue]);
    }
    
    //Convert to hours
    double totalHoursUtilized = (totalTimeUtilized * 10.0) / 60.0;
    return totalHoursUtilized;
}

- (float)staffHoursCapacityCurrentLoad
{
    if ([self totalStaffHours] == 0) {
        return 0;
    }
    
    return [self totalStaffHoursUsedCurrentLoad] / [self totalStaffHours];
}

- (NSInteger)availableCapacity
{
    // decimal dTotalChairTimeMinutes = objSolStatistics.TotalChairTime * 10;//Time to Minutes
    float totalChairTimeMinutes = ([self totalChairHours] * 60);

    float averageTotalInfusionMinutesPerInfusion = 0;
    for (ScenarioWidget* scenarioWidget in self.solutionData.scenarioWidgets) {
        averageTotalInfusionMinutesPerInfusion += (scenarioWidget.totalTime * 10);
    }

    averageTotalInfusionMinutesPerInfusion /= 13;

    // decimal dTotalChairTimeMinutesUsedInCurrentSchedule = objSolStatistics.TotalChairHoursUsed_CurrentLoad * 60;//Hours to Minutes
    float totalChairTimeMinutesUsedInCurrentSchedule = (self.totalChairHoursUsedCurrentLoad * 60);

    // decimal dTotalChairTimeMinutesNotUsedInCurrentSchedule = dTotalChairTimeMinutes - dTotalChairTimeMinutesUsedInCurrentSchedule;
    float totalChairTimeMinutesNotUsedInCurrentSchedule = totalChairTimeMinutes - totalChairTimeMinutesUsedInCurrentSchedule;

    // decimal dTotalChairTimeMinutesUsedOnlyInFullLoad = (objSolStatistics.TotalChairHoursUsed_FullLoad - objSolStatistics.TotalChairHoursUsed_CurrentLoad) * 60;//Hours to Minutes
    float totalChairTimeMinutesUsedOnlyInFullLoad = ([self totalChairHoursUsedFullLoad] * 60) - ([self totalChairHoursUsedCurrentLoad] * 60);

    // decimal dEfficiency = dTotalChairTimeMinutesUsedOnlyInFullLoad / dTotalChairTimeMinutesNotUsedInCurrentSchedule;
    float efficiency = totalChairTimeMinutesUsedOnlyInFullLoad / totalChairTimeMinutesNotUsedInCurrentSchedule;

    // decimal dAvailableCapacity = dEfficiency * dTotalChairTimeMinutesNotUsedInCurrentSchedule / dAverageTotalInfusionMinutesPerInfusion;
    float availableCapacity = efficiency * totalChairTimeMinutesNotUsedInCurrentSchedule / averageTotalInfusionMinutesPerInfusion;

    return ceil(@((availableCapacity + @(self.solutionData.getTotalWidgetsInCurrentSchedule).floatValue) * WEEK_TO_MONTH_MULTIPLIER()).floatValue);
}

- (NSArray<NSNumber*>*)infusionData
{
    NSDictionary<NSNumber*, NSArray<NSNumber*>*>* rateInfo =
  @{@0 : @[ @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0 ],
    @2 : @[ @0, @2, @4, @7, @9, @11, @13, @15, @17, @20, @22, @24, @26, @28, @30 ],
    @4 : @[ @0, @1, @2, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15 ],
    @6 : @[ @0, @1, @2, @3, @4, @5, @6, @6, @7, @8, @9, @9, @10, @11, @11 ],
    @8 : @[ @0, @1, @1, @2, @3, @3, @4, @4, @5, @5, @6, @6, @7, @7, @8 ],
    @12: @[ @0, @1, @1, @2, @2, @2, @3, @3, @3, @4, @4, @4, @5, @5, @5 ],
    @26: @[ @0, @1, @1, @1, @1, @1, @1, @2, @2, @2, @2, @2, @2, @3, @3 ],
    @52: @[ @0, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @2, @2 ]};

    NSMutableArray<NSNumber*>* infusionData = [@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0), @(0)] mutableCopy];
    for (int i = 0; i < infusionData.count; i++) {
        float newNumberOfInfusions = 0;
        for (OtherInfusion* infusion in self.solutionData.scenario.otherInfusions) {
            newNumberOfInfusions += (infusion.avgNewPatientsPerMonth.floatValue) * rateInfo[infusion.weeksBetween][i].floatValue;
        }
        newNumberOfInfusions += (self.solutionData.scenario.remicadeInfusion.avgNewPatientsPerMonthQ6.floatValue) * rateInfo[@6][i].floatValue;
        newNumberOfInfusions += (self.solutionData.scenario.remicadeInfusion.avgNewPatientsPerMonthQ8.floatValue) * rateInfo[@8][i].floatValue;
        newNumberOfInfusions += (self.solutionData.scenario.stelaraInfusion.avgNewPatientsPerMonth.floatValue) * rateInfo[@6][i].floatValue;
        newNumberOfInfusions += (self.solutionData.scenario.simponiAriaInfusion.avgNewPatientsPerMonth.floatValue) * rateInfo[@6][i].floatValue;

        infusionData[i] = @((newNumberOfInfusions + self.solutionData.solutionStatistics.totalInfusionPerMonthCurrentLoad));
    }

    return infusionData;
}

- (NSInteger)indexOfMonthAvailableCapacityIsExceeded {
    NSArray<NSNumber*>* infusionData = [self infusionData];
    NSInteger availableCapacity = [self availableCapacity];

    for (NSInteger index = 0; index < infusionData.count; index++) {
        NSNumber* capacityAtMonth = infusionData[index];
        if (capacityAtMonth.integerValue >= availableCapacity) {
            return index;
        }
    }

    return -1;
}

- (float)staffHoursCapacityFullLoad
{
    if ([self totalStaffHours] == 0) {
        return 0;
    }
    
    return [self totalStaffHoursUsedFullLoad] / [self totalStaffHours];
}

- (float)totalInfusionPerMonthCurrentLoad
{
    return (self.totalRemicadePerMonthCurrentLoad + self.totalSimponiPerMonthCurrentLoad + self.totalStelaraPerMonthCurrentLoad);
}

- (float)totalInfusionPerMonthChange
{
    return (self.totalRemicadePerMonthChange + self.totalSimponiPerMonthChange + self.totalStelaraPerMonthChange);
}

//REMICADE

- (float)totalRemicadePerWeekCurrentLoad
{
    return [self.totalRemicadeCurrentLoad floatValue];
}

- (float)totalRemicadePerMonthCurrentLoad
{
    return [self totalRemicadePerWeekCurrentLoad] * WEEK_TO_MONTH_MULTIPLIER();
}

- (float)totalRemicadePerYearCurrentLoad
{
    return [self totalRemicadePerWeekCurrentLoad] * WEEK_TO_YEAR_MULTIPLIER;
}

- (float)totalRemicadePerWeekFullLoad
{
    return [self.totalRemicadeFullLoad floatValue];
}

- (float)totalRemicadePerMonthFullLoad
{
    return [self totalRemicadePerWeekFullLoad] * WEEK_TO_MONTH_MULTIPLIER();
}

- (float)totalRemicadePerYearFullLoad
{
    return [self totalRemicadePerWeekFullLoad] * WEEK_TO_YEAR_MULTIPLIER;
}

- (float)totalRemicadePerWeekChange
{
    return ([self totalRemicadePerWeekFullLoad] - [self totalRemicadePerWeekCurrentLoad]);
}

- (float)totalRemicadePerMonthChange
{
    return ([self totalRemicadePerMonthFullLoad] - [self totalRemicadePerMonthCurrentLoad]);
}

- (float)totalRemicadePerYearChange
{
    return ([self totalRemicadePerYearFullLoad] - [self totalRemicadePerYearCurrentLoad]);
}

/// Gets the Difference in the Load divided by CurrentLoad of the SolStatistics.
/// Ex returns are: 0, .5, -1 etc where 1 = 100%</para></summary>
- (float)totalRemicadeChange
{
    if ([self totalRemicadePerWeekCurrentLoad] == 0) {
        return 0;
    }
    return ((float)[self totalRemicadePerWeekChange]) / ((float)[self totalRemicadePerWeekCurrentLoad]);
}

//SIMPONI
- (float)totalSimponiPerWeekCurrentLoad
{
    return [self.totalSimponiAriaCurrentLoad floatValue];
}

- (float)totalSimponiPerMonthCurrentLoad
{
    return [self totalSimponiPerWeekCurrentLoad] * WEEK_TO_MONTH_MULTIPLIER();
}

- (float)totalSimponiPerYearCurrentLoad
{
    return [self totalSimponiPerWeekCurrentLoad] * WEEK_TO_YEAR_MULTIPLIER;
}

- (float)totalSimponiPerWeekFullLoad
{
    return [self.totalSimponiAriaFullLoad floatValue];
}

- (float)totalSimponiPerMonthFullLoad
{
    return [self totalSimponiPerWeekFullLoad] * WEEK_TO_MONTH_MULTIPLIER();
}

- (float)totalSimponiPerYearFullLoad
{
    return [self totalSimponiPerWeekFullLoad] * WEEK_TO_YEAR_MULTIPLIER;
}

- (float)totalSimponiPerWeekChange
{
    return ([self totalSimponiPerWeekFullLoad] - [self totalSimponiPerWeekCurrentLoad]);
}

- (float)totalSimponiPerMonthChange
{
    return ([self totalSimponiPerMonthFullLoad] - [self totalSimponiPerMonthCurrentLoad]);
}

- (float)totalSimponiPerYearChange
{
    return ([self totalSimponiPerYearFullLoad] - [self totalSimponiPerYearCurrentLoad]);
}

/// Gets the Difference in the Load divided by CurrentLoad of the SolStatistics.
/// Ex returns are: 0, .5, -1 etc where 1 = 100%</para></summary>
- (float)totalSimponiChange
{
    if ([self totalSimponiPerWeekCurrentLoad] == 0) {
        return 0;
    }
    return ((float)[self totalSimponiPerWeekChange]) / ((float)[self totalSimponiPerWeekCurrentLoad]);
}

// Stelara

- (float)totalStelaraPerWeekCurrentLoad
{
    return [self.totalStelaraCurrentLoad floatValue];
}

- (float)totalStelaraPerMonthCurrentLoad
{
    return [self totalStelaraPerWeekCurrentLoad] * WEEK_TO_MONTH_MULTIPLIER();
}

- (float)totalStelaraPerYearCurrentLoad
{
    return [self totalStelaraPerWeekCurrentLoad] * WEEK_TO_YEAR_MULTIPLIER;
}

- (float)totalStelaraPerWeekFullLoad
{
    return [self.totalStelaraFullLoad floatValue];
}

- (float)totalStelaraPerMonthFullLoad
{
    return [self totalStelaraPerWeekFullLoad] * WEEK_TO_MONTH_MULTIPLIER();
}

- (float)totalStelaraPerYearFullLoad
{
    return [self totalStelaraPerWeekFullLoad] * WEEK_TO_YEAR_MULTIPLIER;
}

- (float)totalStelaraPerWeekChange
{
    return ([self totalStelaraPerWeekFullLoad] - [self totalStelaraPerWeekCurrentLoad]);
}

- (float)totalStelaraPerMonthChange
{
    return ([self totalStelaraPerMonthFullLoad] - [self totalStelaraPerMonthCurrentLoad]);
}

- (float)totalStelaraPerYearChange
{
    return ([self totalStelaraPerYearFullLoad] - [self totalStelaraPerYearCurrentLoad]);
}

/// Gets the Difference in the Load divided by CurrentLoad of the SolStatistics.
/// Ex returns are: 0, .5, -1 etc where 1 = 100%</para></summary>
- (float)totalStelaraChange
{
    if ([self totalStelaraPerWeekCurrentLoad] == 0) {
        return 0;
    }
    return ((float)[self totalStelaraPerWeekChange]) / ((float)[self totalStelaraPerWeekCurrentLoad]);
}

//OTHER
- (float)totalOtherPerWeek
{
    return [self.totalInfusion floatValue] + [self.totalInjection floatValue];
}

- (float)totalOtherPerMonth
{
    return [self totalOtherPerWeek] * WEEK_TO_MONTH_MULTIPLIER();
}

- (float)totalOtherPerYear
{
    return [self totalOtherPerWeek] * WEEK_TO_YEAR_MULTIPLIER;
}

@end
