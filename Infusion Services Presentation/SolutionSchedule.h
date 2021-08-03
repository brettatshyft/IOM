//
//  SolutionSchedule.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/13/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Staff+Extension.h"

@class Scenario, SolutionStatistics, MultiDimensionalArray;
@interface SolutionSchedule : NSObject

@property (nonatomic, strong) MultiDimensionalArray* scheduleItems;
@property (nonatomic, strong) Scenario* scenario;
@property (nonatomic) int totalRemicadeInCurrentSchedule;
@property (nonatomic) int totalRemicadeInFullLoad;
@property (nonatomic) int totalInfusion;
@property (nonatomic) int totalInjection;
@property (nonatomic) int totalSimponiAriaInCurrentSchedule;
@property (nonatomic) int totalSimponiAriaInFullSchedule;
@property (nonatomic) int totalStelaraInCurrentSchedule;
@property (nonatomic) int totalStelaraInFullSchedule;

- (id)initWithScenario:(Scenario*)scenario;
- (void)setMachineScheduleInfoForSolutionStatistics:(SolutionStatistics*)solutionStatistics dayStart:(int)dayStart timeStart:(int)timeStart dayStop:(int)dayStop timeStop:(int)timeStop;
- (void)setStaffScheduleInfoForSolutionStatistics:(SolutionStatistics*)solutionStatistics staffType:(StaffType)staffType dayStart:(int)dayStart timeStart:(int)timeStart dayStop:(int)dayStop timeStop:(int)timeStop;

@end
