//
//  IOMReportProtocol.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/22/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PDF_SCALE 1836.0f/1024.0f     //This is the scale of the PDF output views in reference to the normal PDF report views displayed in the presentation.
#define PDF_PADDING 40.0f

@class Scenario;
@protocol IOMReportProtocol <NSObject>

@property (nonatomic, strong) Scenario* scenario;

- (NSArray*)getPDFPageDataForPageHeight:(CGFloat)pageHeight;
- (NSArray*)getPDFSchedulePageDataForPageHeight:(CGFloat)pageHeight andPaddingBetweenViews:(CGFloat)padding;

@end
