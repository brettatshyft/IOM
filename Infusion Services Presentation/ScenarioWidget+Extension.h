//
//  ScenarioWidget+Extension.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/6/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "ScenarioWidget.h"

@class WidgetPlaceable, MultiDimensionalArray;
@interface ScenarioWidget (Extension)

/*  Returns a WidgetPlaceable object if the scenario widget can fit in the schedule at a given day, time, machine for the specified staff and machine data.
 *  Returns nil if ScenarioWidget cannot fit in the schedule for the given data.
 */
- (WidgetPlaceable*)getPlaceableWidgetForDay:(int)day time:(int)time machineIndex:(int)machineIndex withScenarioStaffArray:(MultiDimensionalArray *)scenarioStaffArray andMachinesArray:(MultiDimensionalArray*)machinesArray;
- (int)totalTime;

- (int)numberOfSolutionWidgetsInCurrentSchedule;
- (int)numberOfSolutionWidgetsInFullSchedule;

@end
