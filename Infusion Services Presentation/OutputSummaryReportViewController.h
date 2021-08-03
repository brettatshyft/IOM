//
//  OutputSummaryReportViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/23/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOMReportProtocol.h"

@class GraphScreenshotQueue;
@interface OutputSummaryReportViewController : UIViewController <IOMReportProtocol>

@property (nonatomic, strong) GraphScreenshotQueue* screenshotQueue;
@property (nonatomic) BOOL isPDF;

@end
