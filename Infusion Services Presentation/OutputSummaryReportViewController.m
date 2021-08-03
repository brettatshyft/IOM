//
//  OutputSummaryReportViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/23/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "OutputSummaryReportViewController.h"
#import "Scenario+Extension.h"
#import "Presentation+Extension.h"
#import "SolutionData+Extension.h"
#import "SolutionStatistics+Extension.h"
#import "GraphWebView.h"
#import "IOMPDFPage.h"
#import "GraphScreenshotQueue.h"
#import "IOMAnalyticsManager.h"
#import "VialTrend+Extension.h"
#import "NSString+IOMExtensions.h"

@interface OutputSummaryReportViewController ()<IOMAnalyticsIdentifiable> {
    NSDateFormatter* _dateFormatter;
}

//sections
@property (weak, nonatomic) IBOutlet UIView *chairsAndStaffSection;
@property (weak, nonatomic) IBOutlet UIView *otherTreatmentsSection;
@property (weak, nonatomic) IBOutlet UIView *increaseCapacitySection;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UIStackView *simponiAriaSectionStackView;
@property (weak, nonatomic) IBOutlet UIStackView *stelaraSectionStackView;
@property (weak, nonatomic) IBOutlet UIStackView *simponiAriaIncreaseSectionStackView;
@property (weak, nonatomic) IBOutlet UIStackView *stelaraIncreaseSectionStackView;

@property (weak, nonatomic) IBOutlet UIStackView *mainStackView;
@property (weak, nonatomic) IBOutlet UIView *timeToCapacityGraphWebViewContainer;
@property (strong, nonatomic) GraphWebView *timeToCapacityGraphWebView;

//Summary report
@property (weak, nonatomic) IBOutlet UILabel* presentationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* scenarioLabel;
@property (weak, nonatomic) IBOutlet UILabel* dateCreatedLabel;
@property (weak, nonatomic) IBOutlet UILabel* lastModifiedLabel;
//Chairs & staff
@property (weak, nonatomic) IBOutlet UILabel* operationDaysCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel* operationDaysFullLabel;
@property (weak, nonatomic) IBOutlet UILabel* numberOfChairsCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel* numberOfChairsFullLabel;
@property (weak, nonatomic) IBOutlet UILabel* chairHoursAvailableCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel* chairHoursAvailableFullLabel;
@property (weak, nonatomic) IBOutlet UILabel* chairHoursOccupiedCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel* chairHoursOccupiedFullLabel;
@property (weak, nonatomic) IBOutlet UILabel* chairPercentOfCapacityCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel* chairPercentOfCapacityFullLabel;
@property (weak, nonatomic) IBOutlet UILabel* chairPercentOfCapacityChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel* staffHoursAvailableCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel* staffHoursAvailableFullLabel;
@property (weak, nonatomic) IBOutlet UILabel* staffHoursOccupiedCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel* staffHoursOccupiedFullLabel;
@property (weak, nonatomic) IBOutlet UILabel* staffPercentOfCapacityCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel* staffPercentOfCapacityFullLabel;
@property (weak, nonatomic) IBOutlet UILabel* staffPercentOfCapacityChangeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *capacityUsageImageView;
//Remicade
@property (weak, nonatomic) IBOutlet UILabel *remicadeInfusionsPerWeekCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadeInfusionsPerWeekFullLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadeInfusionsPerWeekChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadeInfusionsPerMonthCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadeInfusionsPerMonthFullLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadeInfusionsPerMonthChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadeInfusionsPerYearCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadeInfusionsPerYearFullLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadeInfusionsPerYearChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadePercentOfInfusionsChangeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *remicadeInfusionsImageView;
//Simponi
@property (weak, nonatomic) IBOutlet UILabel *simponiInfusionsPerWeekCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiInfusionsPerWeekFullLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiInfusionsPerWeekChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiInfusionsPerMonthCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiInfusionsPerMonthFullLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiInfusionsPerMonthChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiInfusionsPerYearCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiInfusionsPerYearFullLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiInfusionsPerYearChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiPercentOfInfusionsChangeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *simponiInfusionsImageView;
// Stelara
@property (weak, nonatomic) IBOutlet UILabel *stelaraInfusionsPerWeekCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraInfusionsPerWeekFullLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraInfusionsPerWeekChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraInfusionsPerMonthCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraInfusionsPerMonthFullLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraInfusionsPerMonthChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraInfusionsPerYearCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraInfusionsPerYearFullLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraInfusionsPerYearChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraPercentOfInfusionsChangeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stelaraInfusionsImageView;

//Other treatments
@property (weak, nonatomic) IBOutlet UILabel *otherTreatmentsInfusionsPerWeekCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherTreatmentsInfusionsPerWeekFullLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherTreatmentsInfusionsPerMonthCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherTreatmentsInfusionsPerMonthFullLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherTreatmentsInfusionsPerYearCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherTreatmentsInfusionsPerYearFullLabel;
//increase in remicade
@property (weak, nonatomic) IBOutlet UILabel *remIncreaseInfusionsPerWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *remIncreaseInfusionsPerYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *remIncreaseInfusionsChangeLabel;

@property (weak, nonatomic) IBOutlet UILabel *stelIncreaseInfusionsPerWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelIncreaseInfusionsPerYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelIncreaseInfusionsChangeLabel;

//increase in simponi aria
@property (weak, nonatomic) IBOutlet UILabel *simpIncreaseInfusionsPerWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *simpIncreaseInfusionsPerYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *simpIncreaseInfusionsChangeLabel;
//Increase in Capacity
@property (weak, nonatomic) IBOutlet UILabel *chairCapacityCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *chairCapacityFullLabel;
@property (weak, nonatomic) IBOutlet UILabel *chairCapacityChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *staffCapacityCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *staffCapacityFullLabel;
@property (weak, nonatomic) IBOutlet UILabel *staffCapacityChangeLabel;
//Time to capacity
@property (weak, nonatomic) IBOutlet UILabel *timeToCapacityCurrentScheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeToCapacityAvailableCapacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeToCapacityMonthMaximumCapacityLabel;
@property (weak, nonatomic) IBOutlet UIStackView *timeToCapacityReportContainingStackView;

@end

@implementation OutputSummaryReportViewController
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
    
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"M/d/y"];

    [self displaySummaryInformation];
    [self displayChairAndStaffInformation];
    [self displayRemicadeInformation];
    [self displaySimponiInformation];
    [self displayOtherTreatmentInformation];
    [self displayIncreaseInRemicadeInformation];
    [self displayIncreaseInSimponiInformation];
    [self displayCapacityInformation];
    [self displayBottomLabelContent];
    [self displayIncreaseInStelaraInformation];
    [self displayStelaraInformation];
    [self displayTimeToCapacityReport];
    [self loadGraphs];
    
    _stelaraSectionStackView.hidden = ![_scenario.presentation includeStelara];
    _stelaraIncreaseSectionStackView.hidden = ![_scenario.presentation includeStelara];
    _simponiAriaSectionStackView.hidden = ![_scenario.presentation includeSimponiAria];
    _simponiAriaIncreaseSectionStackView.hidden = ![_scenario.presentation includeSimponiAria];

    CGSize size = [_mainStackView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSLog(@"%f", size.height);
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, size.height + 20)];
}

- (void)displayTimeToCapacityReport
{
    [_timeToCapacityReportContainingStackView setHidden:!_scenario.presentation.timeToCapacityReport.boolValue];
    NSNumber* availableCapacity = @(_scenario.solutionData.solutionStatistics.availableCapacity);
    _timeToCapacityCurrentScheduleLabel.text = [NSString stringWithFormat:@"%@", @(ceil(_scenario.solutionData.solutionStatistics.totalInfusionPerMonthCurrentLoad)).stringValue];
    _timeToCapacityAvailableCapacityLabel.text = [availableCapacity stringValue];
    NSInteger exceeded = _scenario.solutionData.solutionStatistics.indexOfMonthAvailableCapacityIsExceeded;
    if (exceeded == -1) {
        _timeToCapacityMonthMaximumCapacityLabel.text = @">12";
    } else {
        _timeToCapacityMonthMaximumCapacityLabel.text = [NSString stringWithFormat:@"%li", exceeded];
    }

    // WEEK_TO_MONTH_MULTIPLIER
    _timeToCapacityGraphWebView = [[GraphWebView alloc] initWithFrame:_timeToCapacityGraphWebViewContainer.frame configuration:[[WKWebViewConfiguration alloc]init]];
    [_timeToCapacityGraphWebViewContainer addSubview:_timeToCapacityGraphWebView];
    [_timeToCapacityGraphWebView loadGraphFilesWithCompletion:^{
        [_timeToCapacityGraphWebView timeToCapacityReportWithVialData:_scenario.solutionData.solutionStatistics.infusionData
                                                    availableCapacity:availableCapacity
                                     andTotalWidgetsInCurrentSchedule:@(ceil(_scenario.solutionData.solutionStatistics.totalInfusionPerMonthCurrentLoad))];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void)displayBottomLabelContent
{
    NSString* drugsString = [NSString humanReadableListFromArray:_scenario.presentation.drugTitlesForPresentationType];
    [_bottomLabel setText:[NSString stringWithFormat: @"Please see accompanying Indications, Important Safety Information, Dosing and Administration, and full Prescribing Information and Medication Guide for %@.", drugsString]];
}

//Display data
- (void)displaySummaryInformation
{
    [_presentationNameLabel setText:_scenario.presentation.accountName];
    [_scenarioLabel setText:_scenario.name];
    [_dateCreatedLabel setText:[_dateFormatter stringFromDate:_scenario.dateCreated]];
    [_lastModifiedLabel setText:[_dateFormatter stringFromDate:_scenario.lastUpdated]];
}

- (void)displayChairAndStaffInformation
{
    //Chairs
    [_operationDaysCurrentLabel setText:[NSString stringWithFormat:@"%i", [_scenario.solutionData.solutionStatistics.daysWithAtleastOneChairWithTime intValue]]];
    [_operationDaysFullLabel setText:[NSString stringWithFormat:@"%i", [_scenario.solutionData.solutionStatistics.daysWithAtleastOneChairWithTime intValue]]];
    
    [_numberOfChairsCurrentLabel setText:[NSString stringWithFormat:@"%i", [_scenario.solutionData.solutionStatistics.totalChairs intValue]]];
    [_numberOfChairsFullLabel setText:[NSString stringWithFormat:@"%i", [_scenario.solutionData.solutionStatistics.totalChairs intValue]]];
    
    [_chairHoursAvailableCurrentLabel setText:[NSString stringWithFormat:@"%.01f", [_scenario.solutionData.solutionStatistics totalChairHours]]];
    [_chairHoursAvailableFullLabel setText:[NSString stringWithFormat:@"%.01f", [_scenario.solutionData.solutionStatistics totalChairHours]]];
    
    [_chairHoursOccupiedCurrentLabel setText:[NSString stringWithFormat:@"%.01f", [_scenario.solutionData.solutionStatistics totalChairHoursUsedCurrentLoad]]];
    [_chairHoursOccupiedFullLabel setText:[NSString stringWithFormat:@"%.01f", [_scenario.solutionData.solutionStatistics totalChairHoursUsedFullLoad]]];
    
    //Rounding
    float chairCapacityCurrent = 100 * [_scenario.solutionData.solutionStatistics chairHoursCapacityCurrentLoad];
    float chairCapacityFull = 100 * [_scenario.solutionData.solutionStatistics chairHoursCapacityFullLoad];
    chairCapacityCurrent = roundf(10 * chairCapacityCurrent) / 10;
    chairCapacityFull = roundf(10 * chairCapacityFull) / 10;
    [_chairPercentOfCapacityCurrentLabel setText:[NSString stringWithFormat:@"%.01f%%", chairCapacityCurrent]];
    [_chairPercentOfCapacityFullLabel setText:[NSString stringWithFormat:@"%.01f%%", chairCapacityFull]];
    float chairPercentChange = (chairCapacityFull - chairCapacityCurrent);
    [_chairPercentOfCapacityChangeLabel setText:[NSString stringWithFormat:@"%.01f%%", chairPercentChange]];
    
    //Staff
    [_staffHoursAvailableCurrentLabel setText:[NSString stringWithFormat:@"%.01f", [_scenario.solutionData.solutionStatistics totalStaffHours]]];
    [_staffHoursAvailableFullLabel setText:[NSString stringWithFormat:@"%.01f", [_scenario.solutionData.solutionStatistics totalStaffHours]]];
    [_staffHoursOccupiedCurrentLabel setText:[NSString stringWithFormat:@"%.01f", [_scenario.solutionData.solutionStatistics totalStaffHoursUsedCurrentLoad]]];
    [_staffHoursOccupiedFullLabel setText:[NSString stringWithFormat:@"%.01f", [_scenario.solutionData.solutionStatistics totalStaffHoursUsedFullLoad]]];
    
    //Rounding
    float staffCapacityCurrent = [_scenario.solutionData.solutionStatistics staffHoursCapacityCurrentLoad] * 100;
    float staffCapacityFull = [_scenario.solutionData.solutionStatistics staffHoursCapacityFullLoad] * 100;
    staffCapacityCurrent = roundf(10 * staffCapacityCurrent) / 10;
    staffCapacityFull = roundf(10 * staffCapacityFull) / 10;
    [_staffPercentOfCapacityCurrentLabel setText:[NSString stringWithFormat:@"%.01f%%", staffCapacityCurrent]];
    [_staffPercentOfCapacityFullLabel setText:[NSString stringWithFormat:@"%.01f%%", staffCapacityFull]];
    float staffPercentChange = (staffCapacityFull - staffCapacityCurrent);
    [_staffPercentOfCapacityChangeLabel setText:[NSString stringWithFormat:@"%.01f%%", staffPercentChange]];
}

- (void)displayRemicadeInformation
{
    [_remicadeInfusionsPerWeekCurrentLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalRemicadePerWeekCurrentLoad]]];
    [_remicadeInfusionsPerMonthCurrentLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalRemicadePerMonthCurrentLoad]]];
    [_remicadeInfusionsPerYearCurrentLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalRemicadePerYearCurrentLoad]]];
    
    [_remicadeInfusionsPerWeekFullLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalRemicadePerWeekFullLoad]]];
    [_remicadeInfusionsPerMonthFullLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalRemicadePerMonthFullLoad]]];
    [_remicadeInfusionsPerYearFullLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalRemicadePerYearFullLoad]]];
    
    int change = [_scenario.solutionData.solutionStatistics totalRemicadePerWeekChange];
    NSString *sign = @"";
    if(change > 0) {
        sign = @"+";
    } else if (change < 0) {
        sign = @"-";
    }
    [_remicadeInfusionsPerWeekChangeLabel setText:[NSString stringWithFormat:@"%@%i", sign, change]];
    
    change = [_scenario.solutionData.solutionStatistics totalRemicadePerMonthChange];
    sign = @"";
    if(change > 0) {
        sign = @"+";
    } else if (change < 0) {
        sign = @"-";
    }
    [_remicadeInfusionsPerMonthChangeLabel setText:[NSString stringWithFormat:@"%@%i", sign, change]];
    
    change = [_scenario.solutionData.solutionStatistics totalRemicadePerYearChange];
    sign = @"";
    if(change > 0) {
        sign = @"+";
    } else if (change < 0) {
        sign = @"-";
    }
    [_remicadeInfusionsPerYearChangeLabel setText:[NSString stringWithFormat:@"%@%i", sign, change]];
    
    [_remicadePercentOfInfusionsChangeLabel setText:[NSString stringWithFormat:@"%.01f%%", [_scenario.solutionData.solutionStatistics totalRemicadeChange] * 100]];
}

- (void)displayStelaraInformation
{
    [_stelaraInfusionsPerWeekCurrentLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalStelaraPerWeekCurrentLoad]]];
    [_stelaraInfusionsPerMonthCurrentLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalStelaraPerMonthCurrentLoad]]];
    [_stelaraInfusionsPerYearCurrentLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalStelaraPerYearCurrentLoad]]];

    [_stelaraInfusionsPerWeekFullLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalStelaraPerWeekFullLoad]]];
    [_stelaraInfusionsPerMonthFullLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalStelaraPerMonthFullLoad]]];
    [_stelaraInfusionsPerYearFullLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalStelaraPerYearFullLoad]]];

    int change = [_scenario.solutionData.solutionStatistics totalStelaraPerWeekChange];
    NSString *sign = @"";
    if(change > 0) {
        sign = @"+";
    } else if (change < 0) {
        sign = @"-";
    }
    [_stelaraInfusionsPerWeekChangeLabel setText:[NSString stringWithFormat:@"%@%i", sign, change]];

    change = [_scenario.solutionData.solutionStatistics totalStelaraPerMonthChange];
    sign = @"";
    if(change > 0) {
        sign = @"+";
    } else if (change < 0) {
        sign = @"-";
    }
    [_stelaraInfusionsPerMonthChangeLabel setText:[NSString stringWithFormat:@"%@%i", sign, change]];

    change = [_scenario.solutionData.solutionStatistics totalStelaraPerYearChange];
    sign = @"";
    if(change > 0) {
        sign = @"+";
    } else if (change < 0) {
        sign = @"-";
    }
    [_stelaraInfusionsPerYearChangeLabel setText:[NSString stringWithFormat:@"%@%i", sign, change]];

    [_stelaraPercentOfInfusionsChangeLabel setText:[NSString stringWithFormat:@"%.01f%%", [_scenario.solutionData.solutionStatistics totalStelaraChange] * 100]];
}

- (void)displaySimponiInformation
{
    [_simponiInfusionsPerWeekCurrentLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalSimponiPerWeekCurrentLoad]]];
    [_simponiInfusionsPerMonthCurrentLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalSimponiPerMonthCurrentLoad]]];
    [_simponiInfusionsPerYearCurrentLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalSimponiPerYearCurrentLoad]]];
    
    [_simponiInfusionsPerWeekFullLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalSimponiPerWeekFullLoad]]];
    [_simponiInfusionsPerMonthFullLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalSimponiPerMonthFullLoad]]];
    [_simponiInfusionsPerYearFullLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalSimponiPerYearFullLoad]]];
    
    int change = [_scenario.solutionData.solutionStatistics totalSimponiPerWeekChange];
    NSString *sign = @"";
    if(change > 0) {
        sign = @"+";
    } else if (change < 0) {
        sign = @"-";
    }
    [_simponiInfusionsPerWeekChangeLabel setText:[NSString stringWithFormat:@"%@%i", sign, change]];
    
    change = [_scenario.solutionData.solutionStatistics totalSimponiPerMonthChange];
    sign = @"";
    if(change > 0) {
        sign = @"+";
    } else if (change < 0) {
        sign = @"-";
    }
    [_simponiInfusionsPerMonthChangeLabel setText:[NSString stringWithFormat:@"%@%i", sign, change]];
    
    change = [_scenario.solutionData.solutionStatistics totalSimponiPerYearChange];
    sign = @"";
    if(change > 0) {
        sign = @"+";
    } else if (change < 0) {
        sign = @"-";
    }
    [_simponiInfusionsPerYearChangeLabel setText:[NSString stringWithFormat:@"%@%i", sign, change]];
    
    [_simponiPercentOfInfusionsChangeLabel setText:[NSString stringWithFormat:@"%.01f%%", [_scenario.solutionData.solutionStatistics totalSimponiChange] * 100]];
}

- (void)displayOtherTreatmentInformation
{
    [_otherTreatmentsInfusionsPerWeekCurrentLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalOtherPerWeek]]];
    [_otherTreatmentsInfusionsPerWeekFullLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalOtherPerWeek]]];
    [_otherTreatmentsInfusionsPerMonthCurrentLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalOtherPerMonth]]];
    [_otherTreatmentsInfusionsPerMonthFullLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalOtherPerMonth]]];
    [_otherTreatmentsInfusionsPerYearCurrentLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalOtherPerYear]]];
    [_otherTreatmentsInfusionsPerYearFullLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalOtherPerYear]]];
}

- (void)displayIncreaseInRemicadeInformation
{
    [_remIncreaseInfusionsPerWeekLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalRemicadePerWeekChange]]];
    [_remIncreaseInfusionsPerYearLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalRemicadePerYearChange]]];
    [_remIncreaseInfusionsChangeLabel setText:[NSString stringWithFormat:@"%.01f%%", [_scenario.solutionData.solutionStatistics totalRemicadeChange] * 100]];
}

- (void)displayIncreaseInStelaraInformation
{
    [_stelIncreaseInfusionsPerWeekLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalStelaraPerWeekChange]]];
    [_stelIncreaseInfusionsPerYearLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalStelaraPerYearChange]]];
    [_stelIncreaseInfusionsChangeLabel setText:[NSString stringWithFormat:@"%.01f%%", [_scenario.solutionData.solutionStatistics totalStelaraChange] * 100]];
}

- (void)displayIncreaseInSimponiInformation
{
    [_simpIncreaseInfusionsPerWeekLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalSimponiPerWeekChange]]];
    [_simpIncreaseInfusionsPerYearLabel setText:[NSString stringWithFormat:@"%.f", [_scenario.solutionData.solutionStatistics totalSimponiPerYearChange]]];
    [_simpIncreaseInfusionsChangeLabel setText:[NSString stringWithFormat:@"%.01f%%", [_scenario.solutionData.solutionStatistics totalSimponiChange] * 100]];
}

- (void)displayCapacityInformation
{
    //Chairs
    [_chairCapacityCurrentLabel setText:[NSString stringWithFormat:@"%.01f%%", [_scenario.solutionData.solutionStatistics chairHoursCapacityCurrentLoad] * 100]];
    [_chairCapacityFullLabel setText:[NSString stringWithFormat:@"%.01f%%", [_scenario.solutionData.solutionStatistics chairHoursCapacityFullLoad] * 100]];
    [_chairCapacityChangeLabel setText:[NSString stringWithFormat:@"%.01f%%", ([_scenario.solutionData.solutionStatistics chairHoursCapacityFullLoad] - [_scenario.solutionData.solutionStatistics chairHoursCapacityCurrentLoad]) * 100]];
    
    //staff
    [_staffCapacityCurrentLabel setText:[NSString stringWithFormat:@"%.01f%%", [_scenario.solutionData.solutionStatistics staffHoursCapacityCurrentLoad] * 100]];
    [_staffCapacityFullLabel setText:[NSString stringWithFormat:@"%.01f%%", [_scenario.solutionData.solutionStatistics staffHoursCapacityFullLoad] * 100]];
    float staffPercentChange = ([_scenario.solutionData.solutionStatistics staffHoursCapacityFullLoad] - [_scenario.solutionData.solutionStatistics staffHoursCapacityCurrentLoad]) * 100;
    [_staffCapacityChangeLabel setText:[NSString stringWithFormat:@"%.01f%%", staffPercentChange]];
}

- (void)loadGraphs
{
    GraphWebView *graphView = [GraphWebView getStaticView];
    __weak GraphWebView *weakGraphView = graphView;
    __weak UIImageView *weakCapacityUsageImageView = _capacityUsageImageView;
    __weak typeof(self) weakSelf = self;
    
    //Load and set image for capacity usage graph
    [_screenshotQueue enqueueView:graphView
                       setupBlock:^{
                           [weakGraphView readyForReuse];
                           [weakGraphView setFrame:weakCapacityUsageImageView.bounds];
                           [weakGraphView setOpaque:NO];
                           [weakGraphView setBackgroundColor:[UIColor clearColor]];
                           
                           if (!weakGraphView.graphFilesLoaded) {
                               [weakGraphView loadGraphFilesWithCompletion:^{
                                   [weakSelf loadCapacityDataForGraph:weakGraphView];
                               }];
                           } else {
                               [weakSelf loadCapacityDataForGraph:weakGraphView];
                           }
                           
                       }
       andScreenshotFinishedBlock:^(UIImage *image){
           [weakCapacityUsageImageView setImage:image];
       }];
    
    //Load and set image for remicade infusions
    __weak UIImageView *weakRemicadeImageView = _remicadeInfusionsImageView;
    [_screenshotQueue enqueueView:graphView
                       setupBlock:^{
                           [weakGraphView readyForReuse];
                           [weakGraphView setFrame:weakRemicadeImageView.bounds];
                           [weakGraphView setOpaque:NO];
                           [weakGraphView setBackgroundColor:[UIColor clearColor]];
                           
                           if (!weakGraphView.graphFilesLoaded) {
                               [weakGraphView loadGraphFilesWithCompletion:^{
                                   [weakSelf loadRemicadeDataForGraph:weakGraphView];
                               }];
                           } else {
                               [weakSelf loadRemicadeDataForGraph:weakGraphView];
                           }
                       }
       andScreenshotFinishedBlock:^(UIImage *image){
           [weakRemicadeImageView setImage:image];
       }];
    
    //Load and set image for remicade infusions
    __weak UIImageView *weakSimponiImageView = _simponiInfusionsImageView;
    [_screenshotQueue enqueueView:graphView
                       setupBlock:^{
                           [weakGraphView readyForReuse];
                           [weakGraphView setFrame:weakRemicadeImageView.bounds];
                           [weakGraphView setOpaque:NO];
                           [weakGraphView setBackgroundColor:[UIColor clearColor]];
                           
                           if (!weakGraphView.graphFilesLoaded) {
                               [weakGraphView loadGraphFilesWithCompletion:^{
                                   [weakSelf loadSimponiDataForGraph:weakGraphView];
                               }];
                           } else {
                               [weakSelf loadSimponiDataForGraph:weakGraphView];
                           }
                       }
       andScreenshotFinishedBlock:^(UIImage *image){
           [weakSimponiImageView setImage:image];
       }];

    //Load and set image for remicade infusions
    __weak UIImageView *weakstelaraImageView = _stelaraInfusionsImageView;
    [_screenshotQueue enqueueView:graphView
                       setupBlock:^{
                           [weakGraphView readyForReuse];
                           [weakGraphView setFrame:weakRemicadeImageView.bounds];
                           [weakGraphView setOpaque:NO];
                           [weakGraphView setBackgroundColor:[UIColor clearColor]];

                           if (!weakGraphView.graphFilesLoaded) {
                               [weakGraphView loadGraphFilesWithCompletion:^{
                                   [weakSelf loadStelaraDataForGraph:weakGraphView];
                               }];
                           } else {
                               [weakSelf loadStelaraDataForGraph:weakGraphView];
                           }
                       }
       andScreenshotFinishedBlock:^(UIImage *image){
           [weakstelaraImageView setImage:image];
       }];
}

- (void)loadCapacityDataForGraph:(GraphWebView*)graphWebView
{
    NSMutableArray* dataArray = [NSMutableArray array];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Chair Hours Occupied", @"Types", [NSNumber numberWithInt:(int)[_scenario.solutionData.solutionStatistics totalChairHoursUsedCurrentLoad]], @"Current Patient Load", [NSNumber numberWithInt:(int)[_scenario.solutionData.solutionStatistics totalChairHoursUsedFullLoad]], @"Full Load Schedule", nil]];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Staff Hours Utilized", @"Types", [NSNumber numberWithInt:(int)[_scenario.solutionData.solutionStatistics totalStaffHoursUsedCurrentLoad]], @"Current Patient Load", [NSNumber numberWithInt:(int)[_scenario.solutionData.solutionStatistics totalStaffHoursUsedFullLoad]], @"Full Load Schedule", nil]];
    
    [graphWebView barGraphCapacityUsageWithData:dataArray largeText:_isPDF];
}

- (void)loadStelaraDataForGraph:(GraphWebView*)graphWebView
{
    NSMutableArray* dataArray = [NSMutableArray array];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Current Patient Load", @"name", [NSNumber numberWithInt:[_scenario.solutionData.solutionStatistics totalStelaraPerWeekCurrentLoad]], @"infusions", nil]];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Full Load Schedule", @"name", [NSNumber numberWithInt:[_scenario.solutionData.solutionStatistics totalStelaraPerWeekFullLoad]], @"infusions", nil]];

    [graphWebView barGraphInfusionsPerWeekWithData:dataArray andInfusionType:1 largeText:_isPDF];
}

- (void)loadRemicadeDataForGraph:(GraphWebView*)graphWebView
{
    NSMutableArray* dataArray = [NSMutableArray array];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Current Patient Load", @"name", [NSNumber numberWithInt:[_scenario.solutionData.solutionStatistics totalRemicadePerWeekCurrentLoad]], @"infusions", nil]];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Full Load Schedule", @"name", [NSNumber numberWithInt:[_scenario.solutionData.solutionStatistics totalRemicadePerWeekFullLoad]], @"infusions", nil]];
    
    [graphWebView barGraphInfusionsPerWeekWithData:dataArray andInfusionType:2 largeText:_isPDF];
}

- (void)loadSimponiDataForGraph:(GraphWebView*)graphWebView
{
    NSMutableArray* dataArray = [NSMutableArray array];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Current Patient Load", @"name", [NSNumber numberWithInt:[_scenario.solutionData.solutionStatistics totalSimponiPerWeekCurrentLoad]], @"infusions", nil]];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Full Load Schedule", @"name", [NSNumber numberWithInt:[_scenario.solutionData.solutionStatistics totalSimponiPerWeekFullLoad]], @"infusions", nil]];
    
    [graphWebView barGraphInfusionsPerWeekWithData:dataArray andInfusionType:0 largeText:_isPDF];
}

#pragma mark - IOMReportProtocol
- (NSArray*)getPDFPageDataForPageHeight:(CGFloat)pageHeight
{
    
    IOMPDFPage * page1 = [[IOMPDFPage alloc] init];
//    page1.pageStart = 17;
//    page1.pageEnd = ([_scenario.presentation includeSimponiAria]) ?(_page2View.frame.origin.y + _simponiView.frame.origin.y + _simponiView.frame.size.height) : (_page2View.frame.origin.y + _otherTreatmentsSection.frame.origin.y + _otherTreatmentsSection.frame.size.height);

    IOMPDFPage * page2 = [[IOMPDFPage alloc] init];
//    page2.pageStart = page1.pageEnd;
//    page2.pageEnd = self.view.bounds.size.height;

    return @[page1, page2];
    
    /*
    NSArray* sectionsArray = nil;
    if ([_scenario.presentation includeSimponiAria]) {
        sectionsArray = @[_chairsAndStaffSection, _remicadeSection, _simponiView, _otherTreatmentsSection, _increaseRemicadeSection, _simponiIncreaseView, _increaseCapacitySection, _bottomLabel];
    } else {
        sectionsArray = @[_chairsAndStaffSection, _remicadeSection, _otherTreatmentsSection, _increaseRemicadeSection, _increaseCapacitySection, _bottomLabel];
    }
    
    CGFloat currentPageStart = 0;
    
    NSMutableArray * pagesArray = [NSMutableArray array];
    
    UIView * previousView = nil;
    for (UIView* view in sectionsArray) {
        if ((view.frame.origin.y + view.frame.size.height) > (currentPageStart + pageHeight)) {
            
            if (previousView) {
                PDFPage *page = [PDFPage new];
                page.pageStart = currentPageStart;
                page.pageEnd = previousView.frame.origin.y + previousView.frame.size.height;
                
                [pagesArray addObject:page];
                
                currentPageStart = page.pageEnd;
                
            } else {
                
                PDFPage *page = [PDFPage new];
                page.pageStart = currentPageStart;
                page.pageEnd = currentPageStart + pageHeight;
                
                [pagesArray addObject:page];
                
                currentPageStart = page.pageEnd;
            }
        }
        
        previousView = view;
    }
    
    //Add last page
    PDFPage * lastPage = [PDFPage new];
    lastPage.pageStart = currentPageStart;
    lastPage.pageEnd = self.view.frame.size.height;
    [pagesArray addObject:lastPage];
    
    return [NSArray arrayWithArray:pagesArray];
     */
}

-(NSString*)analyticsIdentifier
{
    return @"output_summary_report";
}

@end
