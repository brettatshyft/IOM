//
//  SolutionData.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/14/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Scenario, ScenarioWidget, SolutionStatistics;

@interface SolutionData : NSManagedObject

@property (nonatomic, retain) Scenario *scenario;
@property (nonatomic, retain) NSSet<ScenarioWidget*> *scenarioWidgets;
@property (nonatomic, retain) SolutionStatistics *solutionStatistics;
@end

@interface SolutionData (CoreDataGeneratedAccessors)

- (void)addScenarioWidgetsObject:(ScenarioWidget *)value;
- (void)removeScenarioWidgetsObject:(ScenarioWidget *)value;
- (void)addScenarioWidgets:(NSSet *)values;
- (void)removeScenarioWidgets:(NSSet *)values;

@end
