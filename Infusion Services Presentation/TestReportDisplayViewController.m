//
//  TestReportDisplayViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/22/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "TestReportDisplayViewController.h"
#import "InputSummaryReportViewController.h"
#import "OutputSummaryReportViewController.h"
#import "SolutionData+Extension.h"
#import "ScheduleReportViewController.h"

@interface TestReportDisplayViewController (){
    UIViewController* _reportController;
}

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation TestReportDisplayViewController

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
    // Do any additional setup after loading the view from its nib.
    
    //load
    [self loadChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadChart
{
    if (_outSummary) {
        
        OutputSummaryReportViewController * pdfController = [[OutputSummaryReportViewController alloc] init];
        pdfController.scenario = _scenario;
        
        _reportController = pdfController;
        
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:_reportController.view];
        [_scrollView setContentSize:_reportController.view.bounds.size];
        
    } else if (_inSummary) {
        
        InputSummaryReportViewController * pdfController = [[InputSummaryReportViewController alloc] init];
        pdfController.scenario = _scenario;
        
        _reportController = pdfController;
        
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:_reportController.view];
        [_scrollView setContentSize:_reportController.view.bounds.size];
        
    } else if (_schedule) {
        
        ScheduleReportViewController *pdfController = [[ScheduleReportViewController alloc] init];
        pdfController.scenario = _scenario;
        pdfController.isFullLoad = YES;
        
        _reportController = pdfController;
        
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:_reportController.view];
        [_scrollView setContentSize:_reportController.view.bounds.size];
        
    }
}

@end
