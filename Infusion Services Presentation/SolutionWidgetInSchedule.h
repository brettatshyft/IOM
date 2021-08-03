//
//  SolutionWidgetInSchedule.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/9/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ScenarioWidget;

@interface SolutionWidgetInSchedule : NSManagedObject

@property (nonatomic, retain) NSNumber * indexNum;
@property (nonatomic, retain) NSNumber * scheduleDay;
@property (nonatomic, retain) NSNumber * scheduleTime;
@property (nonatomic, retain) NSNumber * scheduleMachine;
@property (nonatomic, retain) NSNumber * prepStaffTypeID;
@property (nonatomic, retain) NSNumber * makeStaffTypeID;
@property (nonatomic, retain) NSNumber * postStaffTypeID;
@property (nonatomic, retain) NSNumber * isFullLoad;
@property (nonatomic, retain) NSNumber * widgetType;
@property (nonatomic, retain) ScenarioWidget *scenarioWidget;

@end
