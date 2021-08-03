//
//  ScheduleReportFirstPageViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/24/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOMReportProtocol.h"

#define CHART_SEPARATION 20.0

@class Scenario;
@class GraphLoadQueue;
@interface ScheduleReportViewController : UIViewController <IOMReportProtocol>

@property (nonatomic) BOOL isFullLoad;
@property (nonatomic) BOOL isPDF;
@property (nonatomic, strong) GraphLoadQueue *graphLoadQueue;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *chartContainerView;
@property (nonatomic, strong) NSArray * ganttChartArray;

@end
