//
//  GraphWebView.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/23/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef void (^LoadCompletion)(void);

@class GraphLoadQueue;
@interface GraphWebView : WKWebView <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, weak) GraphLoadQueue *loadQueue;
@property (nonatomic, readonly) BOOL graphFilesLoaded;

+ (GraphWebView*)getStaticView;
+ (GraphWebView*)getStaticCurrentScheduleWebView;
+ (GraphWebView*)getStaticFullScheduleWebView;
-(void)timeToCapacityReportWithVialData:(NSArray<NSNumber*>*)vialData availableCapacity:(NSNumber*)availableCapacity andTotalWidgetsInCurrentSchedule:(NSNumber*)totalWidgetsInCurrentSchedule;
- (void)loadGraphFilesWithCompletion:(LoadCompletion)loadCompletion;
- (void)loadGraphFiles;
- (void)clearView;
- (void)readyForReuse;
- (void)cleanup;
- (void)pieChartPopulationWithBiologic:(int)biologic andNonBiologic:(int)nonBiologic;
- (void)pieChartUtilizationWithSimponiAriaPatients:(int)simponiAriaPatients remicadePatients:(int)remicadePatients stelaraPatients:(int)stelaraPatients subcutaneousPatients:(int)subcutaneousPatients andOtherIVPatients:(int)otherIVPatients;
- (void)lineGraphWithData:(NSArray*)dataArray andInfusionType:(int)type;
- (void)pieChartWithSubcut:(NSInteger)subcut andOther:(NSInteger)other;
- (void)barGraphCapacityUsageWithData:(NSArray*)dataArray largeText:(BOOL)largeText;
- (void)barGraphInfusionsPerWeekWithData:(NSArray*)dataArray andInfusionType:(int)type largeText:(BOOL)largeText;
- (int)ganttChartWithData:(NSString*)dataString andDayString:(NSString*)dayString includeSpacing:(BOOL)includeSpacing;

@end
