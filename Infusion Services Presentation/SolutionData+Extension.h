//
//  SolutionData+Extension.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/6/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "SolutionData.h"

#define WEEK_TO_MONTH_MULTIPLIER() (float)(4 + (1.0f/3)) //4.333333...
#define WEEK_TO_YEAR_MULTIPLIER 52
#define SOLUTION_DATA_FINISHED_PROCESSING_NOTIFICATION @"solution_data_finished_processing_notification"
#define SOLUTION_DATA_FAILED_PROCESSING_NOTIFICATION @"solution_data_failed_processing_notification"

typedef NS_ENUM(NSInteger, WidgetType){
    WidgetTypeRemicade2HR,
    WidgetTypeRemicade2_5HR,
    WidgetTypeRemicade3HR,
    WidgetTypeRemicade3_5HR,
    WidgetTypeRemicade4HR,
    WidgetTypeSimponiAria,
    WidgetTypeStelara,
    WidgetTypeOtherInfusionRxA,
    WidgetTypeOtherInfusionRxB,
    WidgetTypeOtherInfusionRxC,
    WidgetTypeOtherInfusionRxD,
    WidgetTypeOtherInfusionRxE,
    WidgetTypeOtherInfusionRxF,
    WidgetTypeOtherInjection1,
    WidgetTypeOtherInjection2,
    WidgetTypeOtherInjection3,
    WidgetTypeOtherInjection4,
    WidgetTypeOtherInjection5
};

@interface SolutionData (Extension)

+ (SolutionData*)getSolutionDataForScenario:(Scenario*)scenario;
+ (void)processSolutionDataForScenario:(Scenario*)scenario;
+ (int)getPeriodForTime:(NSDate*)time;
- (NSNumber*)getTotalWidgetsInFullLoadSchedule;
- (NSInteger)getTotalWidgetsInCurrentSchedule;
- (int)getTotalInfusionsInputPerWeek;

@end
