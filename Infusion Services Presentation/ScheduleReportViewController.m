//
//  ScheduleReportFirstPageViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/24/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "ScheduleReportViewController.h"
#import "GraphWebView.h"
#import "GanttChart.h"
#import "Constants.h"
#import "Scenario+Extension.h"
#import "Presentation+Extension.h"
#import "SolutionData+Extension.h"
#import "SolutionStatistics+Extension.h"
#import "SolutionWidgetInSchedule+Extension.h"
#import "Colors.h"
#import "IOMPDFPage.h"
#import "IOMPDFSchedulePage.h"
#import "IOMPDFSchedulePageNode.h"
#import "GraphLoadQueue.h"
#import "IOMAnalyticsManager.h"
#import "NSString+IOMExtensions.h"

@interface ScheduleReportViewController ()<IOMAnalyticsIdentifiable>
{
    CGFloat _currentGraphOffset;
    CGFloat _originalViewHeight;
    CGFloat _originalContainerHeight;
}

@property (weak, nonatomic) IBOutlet UILabel *scheduleTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *simponiLegendView;
@property (weak, nonatomic) IBOutlet UILabel *exceedsLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *exceedsLimitDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIStackView *additionalSimponiAriaStackView;
@property (weak, nonatomic) IBOutlet UIStackView *additionalRemicadeStackView;
@property (weak, nonatomic) IBOutlet UIStackView *additionalStelaraStackView;
@property (weak, nonatomic) IBOutlet UIStackView *simponiAriaLegendStackView;
@property (weak, nonatomic) IBOutlet UIStackView *stelaraLegendStackView;
@property (weak, nonatomic) IBOutlet UIStackView *additionalRowStackView;

@end

@implementation ScheduleReportViewController
@synthesize scenario = _scenario;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _currentGraphOffset = 0;
    _originalViewHeight = self.view.bounds.size.height;
    _originalContainerHeight = _chartContainerView.bounds.size.height;

    _additionalRemicadeStackView.hidden = !_isFullLoad;
    _additionalSimponiAriaStackView.hidden = !_isFullLoad || !_scenario.presentation.includeSimponiAria;
    _additionalStelaraStackView.hidden = !_isFullLoad || !_scenario.presentation.includeStelara;

    _additionalRowStackView.hidden = !_isFullLoad;

    _stelaraLegendStackView.hidden = !_scenario.presentation.includeStelara;
    _simponiAriaLegendStackView.hidden = !_scenario.presentation.includeSimponiAria;

    [self displayBottomLabelContent];
    [self loadScheduleCharts];
    [self displayExceedsLimitIfNeeded];
    
    if (!_isPDF) {
        //We will not create the charts in view for PDF generation.
        [self createChartsInWebviews];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void)displayBottomLabelContent
{
    [_bottomLabel setText:[NSString stringWithFormat:@"Please see accompanying Indications, Important Safety Information, Dosing and Administration, and full Prescribing Information and Medication Guide for %@.", [NSString humanReadableListFromArray:_scenario.presentation.drugTitlesForPresentationType]]];
}

- (void)displayExceedsLimitIfNeeded
{
    int totalInfusionsPerWeek = [_scenario.solutionData getTotalInfusionsInputPerWeek];
    float totalRemicadePerWeek = [_scenario.solutionData.solutionStatistics totalRemicadePerWeekCurrentLoad];
    float totalOtherPerWeek = [_scenario.solutionData.solutionStatistics totalOtherPerWeek];
    float totalSimponiPerWeek = (([_scenario.presentation includeSimponiAria]) ? [_scenario.solutionData.solutionStatistics totalSimponiPerWeekCurrentLoad] : 0);
    float totalStelaraPerWeek = (([_scenario.presentation includeStelara]) ? [_scenario.solutionData.solutionStatistics totalStelaraPerWeekCurrentLoad] : 0);
    float totalInfusionsInCurrent = totalRemicadePerWeek + totalOtherPerWeek + totalSimponiPerWeek + totalStelaraPerWeek;
    if (totalInfusionsInCurrent < totalInfusionsPerWeek) {
        if (!_isFullLoad) {
            [self displayIfNeededCurrentScheduleWidgetsLessThanScenarioWidgetsWithTotalInfusionsPerWeek:totalInfusionsPerWeek
                                                                             andTotalInfusionsInCurrent:totalInfusionsInCurrent];
        } else {
            [self displayIfNeededFullScheduleWidgetsLessThanScenarioWidgetsWithTotalInfusionsPerWeek:totalInfusionsPerWeek
                                                                             totalInfusionsInCurrent:totalInfusionsInCurrent
                                                                           andTotalWidgetsInFullLoad:[_scenario.solutionData getTotalWidgetsInFullLoadSchedule].intValue];
        }
    } else {
        [_exceedsLimitLabel removeFromSuperview];
        [_exceedsLimitDetailsLabel removeFromSuperview];
    }
}

- (void)loadScheduleCharts
{
    if (_isFullLoad) {
        [_scheduleTypeLabel setText:@"Full Load Schedule"];
    }
    
    NSMutableArray * mutableGanttChartArray = [NSMutableArray array];
    
    //Loop over days, creating a chart for each
    for (int d = 0; d < NUMBER_OF_DAYS; d++) {
        //ignore if there are no chair hours for this day
        if([_scenario getTotalChairHoursForDay:d] <= 0) continue;
        
        //Create gantt chart
        GanttChart * chart = [[GanttChart alloc] initWithDay:d scenario:_scenario isFullLoad:_isFullLoad];
        [mutableGanttChartArray addObject:chart];
    }
    _ganttChartArray = [NSArray arrayWithArray:mutableGanttChartArray];
}

- (void)createChartsInWebviews
{
    int chartCount = [_ganttChartArray count];
    __weak NSArray *weakGanttChartArray = _ganttChartArray;
    
    GraphWebView *graphWebView = (_isFullLoad) ? [GraphWebView getStaticFullScheduleWebView] : [GraphWebView getStaticCurrentScheduleWebView];
    [graphWebView readyForReuse];
    [graphWebView setFrame:_chartContainerView.bounds];
    [_chartContainerView addSubview:graphWebView];
    graphWebView.loadQueue = _graphLoadQueue;
    
    __weak GraphWebView *weakGraphView = graphWebView;
    __weak typeof(self) weakSelf = self;
    
    if (!graphWebView.graphFilesLoaded) {
        
        [graphWebView loadGraphFilesWithCompletion:^{
            int size = 0;
            for (int i = 0; i < chartCount; i++) {
                GanttChart *chart = [weakGanttChartArray objectAtIndex:i];
                NSString * dayString = [chart getNameOfDay];
                NSString * dataString = [chart getJavaScriptDataString];
                
                size = [weakGraphView ganttChartWithData:dataString andDayString:dayString includeSpacing:(i != chartCount - 1)];
                NSLog(@"Size returned: %i", size);
            }
            
            //NSLog(@"size: %i", size);
            [weakGraphView setFrame:CGRectMake(0, 0, weakGraphView.frame.size.width, size)];
            [weakSelf addGraphWebViewToContainerView:weakGraphView];
        }];
        
    } else {
        
        int size = 0;
        for (int i = 0; i < chartCount; i++) {
            GanttChart *chart = [weakGanttChartArray objectAtIndex:i];
            NSString * dayString = [chart getNameOfDay];
            NSString * dataString = [chart getJavaScriptDataString];
            
            size = [weakGraphView ganttChartWithData:dataString andDayString:dayString includeSpacing:(i != chartCount - 1)];
            NSLog(@"Size returned: %i", size);
        }
        
        //NSLog(@"size: %i", size);
        [weakGraphView setFrame:CGRectMake(0, 0, weakGraphView.frame.size.width, size)];
        [weakSelf addGraphWebViewToContainerView:weakGraphView];
        
    }
}

- (void)addGraphWebViewToContainerView:(GraphWebView*)graphWebView
{
    CGFloat heightDiff = (graphWebView.bounds.size.height) - _originalContainerHeight;
    if(heightDiff > 0){
        CGRect frame = self.view.frame;
        frame.size = CGSizeMake(frame.size.width, _originalViewHeight + heightDiff);
        [self.view setFrame:frame];
    }
}

- (void)addImageToContainerView:(UIImage*)image
{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    CGFloat ratio = _chartContainerView.bounds.size.width / imageView.bounds.size.width;
    [imageView setFrame:CGRectMake(0, _currentGraphOffset, ratio * imageView.bounds.size.width, ratio * imageView.bounds.size.height)];
    //NSLog(@"Image View bounds: %@", NSStringFromCGRect(imageView.bounds));
    [_chartContainerView addSubview:imageView];
    
    _currentGraphOffset += imageView.frame.size.height + 20;
}

- (void)resizeViewForContainedGraphs
{
    CGFloat heightDiff = (_currentGraphOffset - 20) - _originalContainerHeight;
    if(heightDiff > 0){
        CGRect frame = self.view.frame;
        frame.size = CGSizeMake(frame.size.width, _originalViewHeight + heightDiff);
        [self.view setFrame:frame];
    }
}

#pragma mark - IOMReportProtocol

- (void)displayIfNeededCurrentScheduleWidgetsLessThanScenarioWidgetsWithTotalInfusionsPerWeek:(int)totalInfusionsPerWeek andTotalInfusionsInCurrent:(int)totalInfusionsInCurrent
{
    float percent = 100.0f; //default, 0 of 0 is 100%
    if (totalInfusionsPerWeek > 0) {    //avoid divide by zero
        float totalInfusionsCurrentLoad = (float)totalInfusionsInCurrent;
        float totalInfusionsInput = (float)totalInfusionsPerWeek;
        percent = 100.0f * (totalInfusionsCurrentLoad / totalInfusionsInput);
    }
    
    if (percent != 100.0f) {
        //Display
        NSString* displayString = nil;
        NSString* drugsString = [[_scenario.presentation drugTitlesForPresentationType] componentsJoinedByString:@" / "];
        displayString = [NSString stringWithFormat:@"Only %i of the %i (%.01f%%) of the infusions could be scheduled due to input constraints (chair hours, staff hours/breaks or\n%@ Other Treatment information).", totalInfusionsInCurrent, totalInfusionsPerWeek, percent, drugsString];
        
        [_exceedsLimitDetailsLabel setText:displayString];
    }
}

- (void)displayIfNeededFullScheduleWidgetsLessThanScenarioWidgetsWithTotalInfusionsPerWeek:(int)totalInfusionsPerWeek totalInfusionsInCurrent:(int)totalInfusionsInCurrent andTotalWidgetsInFullLoad:(int)totalWidgetsInFullLoad
{
    float percent = 100.0f; //default, 0 of 0 is 100%
    if (totalInfusionsPerWeek > 0) {    //avoid divide by zero
        float totalInfusionsCurrentLoad = (float)totalInfusionsInCurrent;
        float totalInfusionsInput = (float)totalInfusionsPerWeek;
        percent = 100.0f * (totalInfusionsCurrentLoad / totalInfusionsInput);
    }
    
    if (percent != 100.0f) {
        NSString * displayString = nil;
        NSString* drugsString = [[_scenario.presentation drugTitlesForPresentationType] componentsJoinedByString:@" / "];
        if (totalWidgetsInFullLoad > 0) {
            if ([_scenario.presentation includeSimponiAria]) {
                displayString = [NSString stringWithFormat:@"Based on the inputs for this scenario, this SOC is currently at capacity for at least 1 of the \"Other Treatments\", however, additional %@ infusions could be added to the schedule.", drugsString];
            } else {
                displayString = [NSString stringWithFormat:@"Based on the inputs for this scenario, this SOC is currently at capacity for at least 1 of the \"Other Treatments\", however, additional %@ infusions could be added to the schedule.", drugsString];
            }
            
        } else {
            if ([_scenario.presentation includeSimponiAria]) {
                displayString = [NSString stringWithFormat:@"No additional %@ infusions can be added to the schedule due to input constraints (chair hours, staff hours/breaks or %@ / Other Treatment information).", drugsString, drugsString];
            } else {
                displayString = [NSString stringWithFormat:@"No additional %@ infusions can be added to the schedule due to input constraints (chair hours, staff hours/breaks or %@ / Other Treatment information).", drugsString, drugsString];
            }
        }
        
        [_exceedsLimitDetailsLabel setText:displayString];
    }
}

-(NSString*)analyticsIdentifier
{
    return @"schedule_report";
}

@end
