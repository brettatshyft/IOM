//
//  ScenarioReportOverlayViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/27/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownDelegate.h"
#import "GraphScreenshotQueue.h"
#import "GraphLoadQueue.h"

#define SCENARIO_LIST_OPTION_SELECTED_NOTIFICATION @"scenario_list_option_selected_notification"
#define SCENARIO_SELECTED @"scenario_selected"

@class Scenario;
@interface ScenarioReportOverlayViewController : UIViewController <DropdownDelegate, GraphScreenshotQueueDelegate, GraphLoadQueueDelegate>

@property (nonatomic, strong) Scenario* scenario;

@end
