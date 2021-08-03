//
//  PDFGeneratorViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/30/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphScreenshotQueue.h"
#import <MessageUI/MessageUI.h>

/*
#define PDF_GENERATION_COMPLETED_NOTIFICATION @"pdf_generation_complete_notification"
#define PDF_GENERATION_FAILED_NOTIFICATION @"pdf_generation_failed_notification"
#define PDF_GENERATION_SCENARIO_KEY @"pdf_generation_scenario_key"
#define PDF_GENERATION_PATH_KEY @"pdf_generation_path_key"
*/

@class Scenario;
@interface PDFGeneratorViewController : UIViewController <GraphScreenshotQueueDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) Scenario* scenario;

@end
