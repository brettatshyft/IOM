//
//  WidgetPlaceable.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/8/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SolutionData+Extension.h"
#import "Staff+Extension.h"

@class ScenarioWidget;
@interface WidgetPlaceable : NSObject

@property (nonatomic, strong) ScenarioWidget* scenarioWidget;
@property (nonatomic) WidgetType widgetType;
@property (nonatomic) StaffType prepStaffType;
@property (nonatomic, strong) NSArray * makeStaffTypes;
@property (nonatomic) StaffType postStaffType;
@property (nonatomic) double score;

- (id)init;

@end
