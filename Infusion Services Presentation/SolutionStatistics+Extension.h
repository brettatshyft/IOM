//
//  SolutionStatistics+Extension.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/6/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "SolutionStatistics.h"

@class Scenario;
@interface SolutionStatistics (Extension)

- (NSInteger)availableCapacity;
- (NSArray<NSNumber*>*)infusionData;
- (NSInteger)indexOfMonthAvailableCapacityIsExceeded;

+ (void)processSolutionStatisticsForScenario:(Scenario*)scenario;

- (float)totalChairHours;
- (float)totalChairHoursUsedCurrentLoad;
- (float)totalChairHoursUsedFullLoad;
- (float)totalChairHoursChange;
- (float)chairHoursCapacityCurrentLoad;
- (float)chairHoursCapacityFullLoad;

- (int)totalStaffTime;
- (float)totalStaffHours;
- (double)totalStaffHoursUsedCurrentLoad;
- (double)totalStaffHoursUsedFullLoad;
- (float)staffHoursCapacityCurrentLoad;
- (float)staffHoursCapacityFullLoad;

- (float)totalInfusionPerMonthCurrentLoad;
- (float)totalInfusionPerMonthChange;

- (float)totalRemicadePerWeekCurrentLoad;
- (float)totalRemicadePerMonthCurrentLoad;
- (float)totalRemicadePerYearCurrentLoad;
- (float)totalRemicadePerWeekFullLoad;
- (float)totalRemicadePerMonthFullLoad;
- (float)totalRemicadePerYearFullLoad;
- (float)totalRemicadePerWeekChange;
- (float)totalRemicadePerMonthChange;
- (float)totalRemicadePerYearChange;
- (float)totalRemicadeChange;

- (float)totalSimponiPerWeekCurrentLoad;
- (float)totalSimponiPerMonthCurrentLoad;
- (float)totalSimponiPerYearCurrentLoad;
- (float)totalSimponiPerWeekFullLoad;
- (float)totalSimponiPerMonthFullLoad;
- (float)totalSimponiPerYearFullLoad;
- (float)totalSimponiPerWeekChange;
- (float)totalSimponiPerMonthChange;
- (float)totalSimponiPerYearChange;
- (float)totalSimponiChange;

- (float)totalStelaraPerWeekCurrentLoad;
- (float)totalStelaraPerMonthCurrentLoad;
- (float)totalStelaraPerYearCurrentLoad;
- (float)totalStelaraPerWeekFullLoad;
- (float)totalStelaraPerMonthFullLoad;
- (float)totalStelaraPerYearFullLoad;
- (float)totalStelaraPerWeekChange;
- (float)totalStelaraPerMonthChange;
- (float)totalStelaraPerYearChange;
- (float)totalStelaraChange;

- (float)totalOtherPerWeek;
- (float)totalOtherPerMonth;
- (float)totalOtherPerYear;

@end
