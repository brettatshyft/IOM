//
//  TestWebMemoryViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/6/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "TestWebMemoryViewController.h"
#import "Scenario+Extension.h"
#import "GraphWebView.h"
#import "SolutionData+Extension.h"
#import "SolutionStatistics+Extension.h"

@interface TestWebMemoryViewController ()

@property (nonatomic, weak) IBOutlet GraphWebView* webView;

@end

@implementation TestWebMemoryViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(loadGraph1) withObject:nil afterDelay:5.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)loadGraph1
{
    Scenario * __weak weakScenario = _scenario;
    GraphWebView * __weak weakWebView = _webView;
    [weakWebView loadGraphFilesWithCompletion:^{
        NSMutableArray* dataArray = [NSMutableArray array];
        [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Chair Hours Occupied", @"Types", [NSNumber numberWithInt:(int)[weakScenario.solutionData.solutionStatistics totalChairHoursUsedCurrentLoad]], @"Current Patient Load", [NSNumber numberWithInt:(int)[weakScenario.solutionData.solutionStatistics totalChairHoursUsedFullLoad]], @"Full Load Schedule", nil]];
        [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Staff Hours Utilized", @"Types", [NSNumber numberWithInt:(int)[weakScenario.solutionData.solutionStatistics totalStaffHoursUsedCurrentLoad]], @"Current Patient Load", [NSNumber numberWithInt:(int)[weakScenario.solutionData.solutionStatistics totalStaffHoursUsedFullLoad]], @"Full Load Schedule", nil]];
        
        [weakWebView barGraphCapacityUsageWithData:dataArray];
        
        
        [self performSelector:@selector(loadGraph2) withObject:nil afterDelay:10.0];
        
    }];
}

- (void)loadGraph2
{
    NSLog(@"Clear");
    //[_webView loadHTMLString:@"" baseURL:nil];
    
    //[NSURLCache sharedURLCache]
    
    NSLog(@"load");
    Scenario * __weak weakScenario = _scenario;
    GraphWebView * __weak weakWebView = _webView;
    NSMutableArray* dataArray = [NSMutableArray array];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Current Patient Load", @"name", [NSNumber numberWithInt:[weakScenario.solutionData.solutionStatistics totalRemicadePerWeekCurrentLoad]], @"infusions", nil]];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Full Load Schedule", @"name", [NSNumber numberWithInt:[weakScenario.solutionData.solutionStatistics totalRemicadePerWeekFullLoad]], @"infusions", nil]];
    //NSLog(@"%@", [dataArray JSONString]);
    
    [weakWebView barGraphInfusionsPerWeekWithData:dataArray andInfusionType:1];
    
    [self performSelector:@selector(loadGraph3) withObject:nil afterDelay:10.0];
}

- (void)loadGraph3
{
    Scenario * __weak weakScenario = _scenario;
    GraphWebView * __weak weakWebView = _webView;
    NSMutableArray* dataArray = [NSMutableArray array];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Chair Hours Occupied", @"Types", [NSNumber numberWithInt:(int)[weakScenario.solutionData.solutionStatistics totalChairHoursUsedCurrentLoad]], @"Current Patient Load", [NSNumber numberWithInt:(int)[weakScenario.solutionData.solutionStatistics totalChairHoursUsedFullLoad]], @"Full Load Schedule", nil]];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Staff Hours Utilized", @"Types", [NSNumber numberWithInt:(int)[weakScenario.solutionData.solutionStatistics totalStaffHoursUsedCurrentLoad]], @"Current Patient Load", [NSNumber numberWithInt:(int)[weakScenario.solutionData.solutionStatistics totalStaffHoursUsedFullLoad]], @"Full Load Schedule", nil]];
    
    [weakWebView barGraphCapacityUsageWithData:dataArray];
    
    
    [self performSelector:@selector(loadGraph2) withObject:nil afterDelay:10.0];
}
 */

@end
