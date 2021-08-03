//
//  ScenarioReportOverlayViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/27/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "ScenarioReportOverlayViewController.h"
#import "Scenario+Extension.h"
#import "SolutionData+Extension.h"
#import "Presentation+Extension.h"
#import "InputSummaryReportViewController.h"
#import "ScheduleReportViewController.h"
#import "OutputSummaryReportViewController.h"
#import "DropdownController.h"
#import "DropdownDataSource.h"
#import "GraphWebView.h"
#import "IOMAnalyticsManager.h"

@interface ScenarioReportOverlayViewController ()<IOMAnalyticsIdentifiable>{
    InputSummaryReportViewController* _inputSummaryViewController;
    OutputSummaryReportViewController* _outputSummaryViewController;
    ScheduleReportViewController* _currentLoadScheduleViewController;
    ScheduleReportViewController* _fullLoadScheduleViewController;
    
    UIPopoverController *_scenarioListDropdownController;
    DropdownDataSource *_scenarioListDataSource;
    BOOL _resultsAreDisplayed;
    
    GraphScreenshotQueue * _screenshotQueue;
    GraphLoadQueue * _graphLoadQueue;
}

@property (nonatomic, weak) IBOutlet UILabel *scenarioLabel;
@property (nonatomic, weak) IBOutlet UIButton *inputsButton;
@property (nonatomic, weak) IBOutlet UIButton *currentLoadButton;
@property (nonatomic, weak) IBOutlet UIButton *fullLoadButton;
@property (nonatomic, weak) IBOutlet UIButton *reportButton;
@property (nonatomic, weak) IBOutlet UIButton *scenarioListButton;
@property (nonatomic, weak) IBOutlet UIScrollView *reportScrollView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ScenarioReportOverlayViewController

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
    // Do any additional setup after loading the view from its nib
    
    [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
    [self.navigationController setNavigationBarHidden:NO];
    
    [_scenarioLabel setText:[NSString stringWithFormat:@"%@", _scenario.name]];
    
    [self createScenarioDropdownDataSource];
    
    //Register for solution data finished processing notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(solutionDataDidFinishProcessingNotification:) name:SOLUTION_DATA_FINISHED_PROCESSING_NOTIFICATION object:nil];
    
    if (!_scenario.solutionData || [_scenario.solutionDataNeedsToBeProcessed boolValue]) {
        //Show activity indicator
        [_activityIndicatorView startAnimating];
    }
    
    //Check and load result data
    [self checkAndLoadResultData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_screenshotQueue clearQueue];
    _screenshotQueue = nil;
    [_graphLoadQueue clearQueue];
    _graphLoadQueue = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    _inputSummaryViewController = nil;
    _outputSummaryViewController = nil;
    _currentLoadScheduleViewController = nil;
    _fullLoadScheduleViewController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkAndLoadResultData
{
    if (_scenario.solutionData && ![_scenario.solutionDataNeedsToBeProcessed boolValue]) {
        //Hide activity indicator
        [_activityIndicatorView stopAnimating];
        [_activityIndicatorView setHidden:YES];
        
        _screenshotQueue = [[GraphScreenshotQueue alloc] init];
        [_screenshotQueue setDelegate:self];
        
        _graphLoadQueue = [[GraphLoadQueue alloc] init];
        [_graphLoadQueue setDelegate:self];
        
        //Load the reports
        [self loadReports];
        //display reports in scroll view
        [self displayReports];
        
        [_screenshotQueue startProcessing];
        [_graphLoadQueue startLoadingGraphs];
        
        //[self performSelector:@selector(repositionSubviews) withObject:nil afterDelay:5];
    }
}

- (void)createScenarioDropdownDataSource
{
    if([_scenario.presentation.scenarios count] == 0) {
        [_scenarioListButton setHidden:YES];
        return;
    }
    
    NSSortDescriptor * nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray* scenarios = [[_scenario.presentation.scenarios allObjects] sortedArrayUsingDescriptors:@[nameSort]];
    NSMutableArray* scenarioOptionsArray = [NSMutableArray array];
    for (int i = 0; i < [scenarios count]; i++) {
        Scenario *scenario = [scenarios objectAtIndex:i];
        [scenarioOptionsArray addObject:[NSString stringWithFormat:@"%@", scenario.name]];
    }
    
    _scenarioListDataSource = [[DropdownDataSource alloc] initWithItems:scenarioOptionsArray andTitleForItemBlock:^NSString *(id item){
        return item;
    }];
}

- (void)loadReports
{
    //Create the reports
    
    //Input summary
    _inputSummaryViewController = [[InputSummaryReportViewController alloc] init];
    _inputSummaryViewController.scenario = _scenario;
    
    //Report summary
    _outputSummaryViewController = [[OutputSummaryReportViewController alloc] init];
    _outputSummaryViewController.screenshotQueue = _screenshotQueue;
    _outputSummaryViewController.scenario = _scenario;
    
    //Current Schedule
    _currentLoadScheduleViewController = [[ScheduleReportViewController alloc] init];
    _currentLoadScheduleViewController.graphLoadQueue = _graphLoadQueue;
    _currentLoadScheduleViewController.scenario = _scenario;
    _currentLoadScheduleViewController.isFullLoad = NO;
    
    _fullLoadScheduleViewController = [[ScheduleReportViewController alloc] init];
    _fullLoadScheduleViewController.graphLoadQueue = _graphLoadQueue;
    _fullLoadScheduleViewController.scenario = _scenario;
    _fullLoadScheduleViewController.isFullLoad = YES;
}

- (void)displayReports
{
    //Add reports to scrollview
    [_reportScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Add input summary
    UIView* inputView = _inputSummaryViewController.view;
    [_reportScrollView addSubview:inputView];
    
    //add current schedule
    UIView* currentScheduleView = _currentLoadScheduleViewController.view;
    [_reportScrollView addSubview:currentScheduleView];
    
    //add full schedule
    UIView* fullScheduleView = _fullLoadScheduleViewController.view;
    [_reportScrollView addSubview:fullScheduleView];
    
    //add report summary
    UIView* reportView = _outputSummaryViewController.view;
    [_reportScrollView addSubview:reportView];
    
    //Set positions of views
    [self repositionSubviews];
    
    _resultsAreDisplayed = YES;
}

- (void)scrollToY:(CGFloat)y
{
    [_reportScrollView setContentOffset:CGPointMake(0, y) animated:YES];
}

#pragma mark - IBActions
- (IBAction)inputsButtonSelected:(id)sender
{
    [self scrollToY:_inputSummaryViewController.view.frame.origin.y];
}

- (IBAction)currentLoadButtonSelected:(id)sender
{
    [_currentLoadScheduleViewController.view setNeedsDisplay];
    [self scrollToY:_currentLoadScheduleViewController.view.frame.origin.y];
}

- (IBAction)fullLoadButtonSelected:(id)sender
{
    [self scrollToY:_fullLoadScheduleViewController.view.frame.origin.y];
}

- (IBAction)reportButtonSelected:(id)sender
{
    [self scrollToY:_outputSummaryViewController.view.frame.origin.y];
}

- (IBAction)scenarioListButtonSelected:(id)sender
{
    if (!_scenarioListDropdownController) {
        _scenarioListDropdownController = [DropdownController dropdownPopoverControllerForDropdownDataSource:_scenarioListDataSource withDelegate:self];
    }
    
    if([_scenarioListDropdownController isPopoverVisible]){
        [_scenarioListDropdownController dismissPopoverAnimated:YES];
    }
    CGRect fromRect = ((UIButton*)sender).frame;
    [_scenarioListDropdownController presentPopoverFromRect:fromRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - DropdownDelegate Protocol Methods
- (void)dropdown:(DropdownController *)dropdown item:(id)item selectedAtIndex:(NSInteger)index fromDataSource:(DropdownDataSource *)dataSource
{
    NSDictionary* userInfo = @{SCENARIO_SELECTED : [NSNumber numberWithInteger:index]};
    [[NSNotificationCenter defaultCenter] postNotificationName:SCENARIO_LIST_OPTION_SELECTED_NOTIFICATION object:nil userInfo:userInfo];
    
    [_scenarioListDropdownController dismissPopoverAnimated:YES];
}

#pragma mark - Solution Process Notification
- (void)solutionDataDidFinishProcessingNotification:(NSNotification*)notification
{
    if(!_resultsAreDisplayed){
        //Check and load result data
        [self checkAndLoadResultData];
    }
}

#pragma mark - GraphScreenshotQueue Delegate
- (void)graphScreenshotQueueProcessingFinished:(GraphScreenshotQueue *)queue
{
    if (queue == _screenshotQueue) {
        [[GraphWebView getStaticView] clearView];
        [self repositionSubviews];
    }
}

- (void)graphScreenshotQueueProcessingCancelled:(GraphScreenshotQueue *)queue
{
    [[GraphWebView getStaticView] stopLoading];
}

#pragma mark - GraphLoadQueue Delegate
- (void)graphLoadQueueHasFinished:(GraphLoadQueue *)graphLoadQueue
{
    if (graphLoadQueue == _graphLoadQueue){
        [self repositionSubviews];
    }
}

- (void)graphLoadQueueCancelled:(GraphLoadQueue *)graphLoadQueue
{
    
}

- (void)repositionSubviews
{
    //reposition subviews
    UIView* inputView = _inputSummaryViewController.view;
    UIView* currentScheduleView = _currentLoadScheduleViewController.view;
    UIView* fullScheduleView = _fullLoadScheduleViewController.view;
    UIView* reportView = _outputSummaryViewController.view;
    
    [currentScheduleView setFrame:CGRectMake(0, inputView.frame.origin.y + inputView.frame.size.height, currentScheduleView.frame.size.width, currentScheduleView.frame.size.height)];
    [fullScheduleView setFrame:CGRectMake(0, currentScheduleView.frame.origin.y + currentScheduleView.frame.size.height, fullScheduleView.frame.size.width, fullScheduleView.frame.size.height)];
    [reportView setFrame:CGRectMake(0, fullScheduleView.frame.origin.y + fullScheduleView.frame.size.height, reportView.frame.size.width, reportView.frame.size.height)];
    
    CGFloat totalHeight = inputView.frame.size.height + currentScheduleView.frame.size.height + fullScheduleView.frame.size.height + reportView.frame.size.height;
    
    [_reportScrollView setContentSize:CGSizeMake(_reportScrollView.contentSize.width, totalHeight)];
}

-(NSString*)analyticsIdentifier
{
    return @"scenario_report_overlay";
}

@end
