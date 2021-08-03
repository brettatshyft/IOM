//
//  ReportCoverPageViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/21/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "ReportCoverPageViewController.h"
#import "IOMPDFPage.h"
#import "Scenario+Extension.h"
#import "Presentation+Extension.h"
#import "IOMAnalyticsManager.h"

@interface ReportCoverPageViewController ()<IOMAnalyticsIdentifiable>
{
    NSDateFormatter * dateFormatter;
}

@property (nonatomic, weak) IBOutlet UILabel *accountNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *scenarioLabel;
@property (nonatomic, weak) IBOutlet UILabel *simponiLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraLabel;

@end

@implementation ReportCoverPageViewController
@synthesize scenario = _scenario;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d/yyyy"];
    
    [self updateText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateText
{
    [_accountNameLabel setText:_scenario.presentation.accountName];
    [_scenarioLabel setText:_scenario.name];
    [_dateLabel setText:[dateFormatter stringFromDate:_scenario.presentation.presentationDate]];
    
    if (![_scenario.presentation includeSimponiAria]) {
        [self.simponiLabel setHidden:YES];
    }

    if (![_scenario.presentation includeStelara]) {
        [self.stelaraLabel setHidden:YES];
    }
}

- (NSArray*)getPDFPageDataForPageHeight:(CGFloat)pageHeight
{
    IOMPDFPage *page1 = [[IOMPDFPage alloc] init];
    page1.pageStart = PDF_PADDING;
    page1.pageEnd = self.view.bounds.size.height;
    
    return @[page1];
    
}

- (NSArray*)getPDFSchedulePageDataForPageHeight:(CGFloat)pageHeight andPaddingBetweenViews:(CGFloat)padding
{
    return nil;
}

-(NSString*)analyticsIdentifier
{
    return @"report_cover_page";
}

@end
