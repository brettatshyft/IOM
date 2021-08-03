//
//  TestReportDisplayViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/22/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Scenario;
@interface TestReportDisplayViewController : UIViewController

@property (nonatomic, strong) Scenario * scenario;
@property (nonatomic) BOOL schedule;
@property (nonatomic) BOOL inSummary;
@property (nonatomic) BOOL outSummary;

@end
