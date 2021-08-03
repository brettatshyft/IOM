//
//  ScenarioWidget.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/8/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SolutionData, SolutionWidgetInSchedule;

@interface ScenarioWidget : NSManagedObject

@property (nonatomic, retain) NSNumber * infusionsPerWeek;
@property (nonatomic, retain) NSNumber * makeAncillary;
@property (nonatomic, retain) NSNumber * makeQHP;
@property (nonatomic, retain) NSNumber * makeStaffAttention;
@property (nonatomic, retain) NSNumber * makeTime;
@property (nonatomic, retain) NSNumber * postAncillary;
@property (nonatomic, retain) NSNumber * postQHP;
@property (nonatomic, retain) NSNumber * postTime;
@property (nonatomic, retain) NSNumber * prepAncillary;
@property (nonatomic, retain) NSNumber * prepQHP;
@property (nonatomic, retain) NSNumber * prepTime;
@property (nonatomic, retain) NSNumber * widgetType;
@property (nonatomic, retain) NSNumber * infusionDist;
@property (nonatomic, retain) SolutionData *solutionData;
@property (nonatomic, retain) NSSet *solutionWidgetsInSchedule;
@end

@interface ScenarioWidget (CoreDataGeneratedAccessors)

- (void)addSolutionWidgetsInScheduleObject:(SolutionWidgetInSchedule *)value;
- (void)removeSolutionWidgetsInScheduleObject:(SolutionWidgetInSchedule *)value;
- (void)addSolutionWidgetsInSchedule:(NSSet *)values;
- (void)removeSolutionWidgetsInSchedule:(NSSet *)values;

@end
