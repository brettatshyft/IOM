//
//  ScenarioOverviewViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/27/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "ScenarioOverviewViewController.h"
#import "Presentation+Extension.h"
#import "Scenario+Extension.h"
#import "SolutionData+Extension.h"
#import "SolutionStatistics+Extension.h"
#import "Colors.h"
#import "ScenarioReportOverlayViewController.h"
#import "IOMAnalyticsManager.h"
#import "IOMScenarioTableViewCell.h"

#define CELL_SCENARIO_TITLE_TAG 100
#define CELL_CHAIRS_OPERATION_DAYS_PER_WEEK_CURRENT 101
#define CELL_CHAIRS_NUM_OF_CHAIRS_CURRENT 102
#define CELL_CHAIRS_HOURS_AVAILABLE_CURRENT 103
#define CELL_CHAIRS_HOURS_OCCUPIED_CURRENT 104
#define CELL_CHAIRS_PERCENT_CAPACITY_CURRENT 105
#define CELL_STAFF_NUM_OF_STAFF_CURRENT 120
#define CELL_STAFF_HOURS_AVAILABLE_CURRENT 106
#define CELL_STAFF_HOURS_UTILIZED_CURRENT 107
#define CELL_STAFF_PERCENT_CAPACITY_CURRENT 108
#define CELL_SIMP_INFUSIONS_PER_WEEK_CURRENT 109
#define CELL_SIMP_INFUSIONS_PER_MONTH_CURRENT 110
#define CELL_REM_INFUSIONS_PER_WEEK_CURRENT 111
#define CELL_REM_INFUSIONS_PER_MONTH_CURRENT 112
#define CELL_CHAIRS_OPERATION_DAYS_PER_WEEK_FULL 201
#define CELL_CHAIRS_NUM_OF_CHAIRS_FULL 202
#define CELL_CHAIRS_HOURS_AVAILABLE_FULL 203
#define CELL_CHAIRS_HOURS_OCCUPIED_FULL 204
#define CELL_CHAIRS_PERCENT_CAPACITY_FULL 205
#define CELL_STAFF_HOURS_AVAILABLE_FULL 206
#define CELL_STAFF_NUM_OF_STAFF_FULL 220
#define CELL_STAFF_HOURS_UTILIZED_FULL 207
#define CELL_STAFF_PERCENT_CAPACITY_FULL 208
#define CELL_SIMP_INFUSIONS_PER_WEEK_FULL 209
#define CELL_SIMP_INFUSIONS_PER_MONTH_FULL 210
#define CELL_REM_INFUSIONS_PER_WEEK_FULL 211
#define CELL_REM_INFUSIONS_PER_MONTH_FULL 212
#define CELL_CHAIRS_CHANGE_PERCENT_OF_CAPACITY 301
#define CELL_STAFF_CHANGE_PERCENT_OF_CAPACITY 302
#define CELL_SIM_CHANGE_INFUSIONS_PER_WEEK 303
#define CELL_SIM_CHANGE_INFUSIONS_PER_MONTH 304
#define CELL_SIM_CHANGE_PERCENT_INFUSIONS 305
#define CELL_REM_CHANGE_INFUSIONS_PER_WEEK 306
#define CELL_REM_CHANGE_INFUSIONS_PER_MONTH 307
#define CELL_REM_CHANGE_PERCENT_INFUSIONS 308
#define CELL_STEL_INFUSIONS_PER_WEEK_CURRENT    113
#define CELL_STEL_INFUSIONS_PER_MONTH_CURRENT   114
#define CELL_STEL_INFUSIONS_PER_WEEK_FULL       213
#define CELL_STEL_INFUSIONS_PER_MONTH_FULL      214
#define CELL_STEL_CHANGE_INFUSIONS_PER_WEEK     309
#define CELL_STEL_CHANGE_INFUSIONS_PER_MONTH    310

@interface ScenarioOverviewViewController ()<IOMAnalyticsIdentifiable> {
    NSArray* _scenariosArray;
}

@property (nonatomic, weak) IBOutlet UITableView * scenarioTableView;
@property (weak, nonatomic) IBOutlet UIStackView *simponiAriaHeaderView;
@property (weak, nonatomic) IBOutlet UIStackView *remicadeHeaderView;
@property (weak, nonatomic) IBOutlet UIStackView *stelaraHeaderView;


@end

@implementation ScenarioOverviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
    //Register for solution data finished processing notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(solutionDataDidFinishProcessingNotification:) name:SOLUTION_DATA_FINISHED_PROCESSING_NOTIFICATION object:nil];
    [self loadScenarios];

    switch (_presentation.presentationType) {
        case PresentationTypeRAIOI: {
            // no stelara
            _simponiAriaHeaderView.hidden = NO;
            _remicadeHeaderView.hidden = NO;
            _stelaraHeaderView.hidden = YES;
            break;
        }
        case PresentationTypeGIIOI: {
            // no simponi
            _simponiAriaHeaderView.hidden = YES;
            _remicadeHeaderView.hidden = NO;
            _stelaraHeaderView.hidden = NO;
            break;
        }
        case PresentationTypeDermIOI: {
            // only remicade
            _simponiAriaHeaderView.hidden = YES;
            _remicadeHeaderView.hidden = NO;
            _stelaraHeaderView.hidden = YES;
            break;
        }
        case PresentationTypeHOPD:
        case PresentationTypeMixedIOI:
        case PresentationTypeOther:
        default: {
            _simponiAriaHeaderView.hidden = NO;
            _remicadeHeaderView.hidden = NO;
            _stelaraHeaderView.hidden = NO;
            break;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadScenarios
{
    /*
    NSPredicate *processingPredicate = [NSPredicate predicateWithFormat:@"solutionData.needsToBeProcessed != %@", [NSNumber numberWithBool:YES]];
    _scenariosArray = [[_presentation.scenarios allObjects] filteredArrayUsingPredicate:processingPredicate];
     */
    NSSortDescriptor * nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    _scenariosArray = [[_presentation.scenarios allObjects] sortedArrayUsingDescriptors:@[nameSort]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_scenariosArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OverviewSimpCellIdentifier = @"overviewSimpCell";
    IOMScenarioTableViewCell *cell = nil;
    cell = (IOMScenarioTableViewCell*)[tableView dequeueReusableCellWithIdentifier:OverviewSimpCellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    
    Scenario * scenario = [_scenariosArray objectAtIndex:indexPath.row];
    
    UILabel *scenarioTitleLabel = (UILabel*)[cell viewWithTag:CELL_SCENARIO_TITLE_TAG];
    
    UILabel *chairOperationDaysCurrentLabel = (UILabel*)[cell viewWithTag:CELL_CHAIRS_OPERATION_DAYS_PER_WEEK_CURRENT];
    UILabel *chairNumCurrentLabel = (UILabel*)[cell viewWithTag:CELL_CHAIRS_NUM_OF_CHAIRS_CURRENT];
    UILabel *chairHoursAvailCurrentLabel = (UILabel*)[cell viewWithTag:CELL_CHAIRS_HOURS_AVAILABLE_CURRENT];
    UILabel *chairHoursOccupiedCurrentLabel = (UILabel*)[cell viewWithTag:CELL_CHAIRS_HOURS_OCCUPIED_CURRENT];
    UILabel *chairPercentCapacityCurrentLabel = (UILabel*)[cell viewWithTag:CELL_CHAIRS_PERCENT_CAPACITY_CURRENT];
    
    UILabel *staffNumCurrentLabel = (UILabel*)[cell viewWithTag:CELL_STAFF_NUM_OF_STAFF_CURRENT];
    UILabel *staffHoursAvailCurrentLabel = (UILabel*)[cell viewWithTag:CELL_STAFF_HOURS_AVAILABLE_CURRENT];
    UILabel *staffHoursUtilCurrentLabel = (UILabel*)[cell viewWithTag:CELL_STAFF_HOURS_UTILIZED_CURRENT];
    UILabel *staffPercentCapacityCurrentLabel = (UILabel*)[cell viewWithTag:CELL_STAFF_PERCENT_CAPACITY_CURRENT];
    
    UILabel *simpInfusionsPerWeekCurrentLabel = (UILabel*)[cell viewWithTag:CELL_SIMP_INFUSIONS_PER_WEEK_CURRENT];
    UILabel *simpInfusionsPerMonthCurrentLabel = (UILabel*)[cell viewWithTag:CELL_SIMP_INFUSIONS_PER_MONTH_CURRENT];
    UILabel *remInfusionsPerWeekCurrentLabel = (UILabel*)[cell viewWithTag:CELL_REM_INFUSIONS_PER_WEEK_CURRENT];
    UILabel *remInfusionsPerMonthCurrentLabel = (UILabel*)[cell viewWithTag:CELL_REM_INFUSIONS_PER_MONTH_CURRENT];
    
    UILabel *chairOperationDaysFullLabel = (UILabel*)[cell viewWithTag:CELL_CHAIRS_OPERATION_DAYS_PER_WEEK_FULL];
    UILabel *chairNumFullLabel = (UILabel*)[cell viewWithTag:CELL_CHAIRS_NUM_OF_CHAIRS_FULL];
    UILabel *chairHoursAvailFullLabel = (UILabel*)[cell viewWithTag:CELL_CHAIRS_HOURS_AVAILABLE_FULL];
    UILabel *chairHoursOccupiedFullLabel = (UILabel*)[cell viewWithTag:CELL_CHAIRS_HOURS_OCCUPIED_FULL];
    UILabel *chairPercentCapacityFullLabel = (UILabel*)[cell viewWithTag:CELL_CHAIRS_PERCENT_CAPACITY_FULL];
    
    UILabel *staffNumFullLabel = (UILabel*)[cell viewWithTag:CELL_STAFF_NUM_OF_STAFF_FULL];
    UILabel *staffHoursAvailFullLabel = (UILabel*)[cell viewWithTag:CELL_STAFF_HOURS_AVAILABLE_FULL];
    UILabel *staffHoursUtilFullLabel = (UILabel*)[cell viewWithTag:CELL_STAFF_HOURS_UTILIZED_FULL];
    UILabel *staffPercentCapacityFullLabel = (UILabel*)[cell viewWithTag:CELL_STAFF_PERCENT_CAPACITY_FULL];

    UILabel *simpInfusionsPerWeekFullLabel = (UILabel*)[cell viewWithTag:CELL_SIMP_INFUSIONS_PER_WEEK_FULL];
    UILabel *simpInfusionsPerMonthFullLabel = (UILabel*)[cell viewWithTag:CELL_SIMP_INFUSIONS_PER_MONTH_FULL];
    UILabel *remInfusionsPerWeekFullLabel = (UILabel*)[cell viewWithTag:CELL_REM_INFUSIONS_PER_WEEK_FULL];
    UILabel *remInfusionsPerMonthFullLabel = (UILabel*)[cell viewWithTag:CELL_REM_INFUSIONS_PER_MONTH_FULL];
    
    UILabel *chairsChangePercentOfCapacityLabel = (UILabel*)[cell viewWithTag:CELL_CHAIRS_CHANGE_PERCENT_OF_CAPACITY];
    UILabel *staffChangePercentOfCapacityLabel = (UILabel*)[cell viewWithTag:CELL_STAFF_CHANGE_PERCENT_OF_CAPACITY];
    UILabel *simChangeInfusionsPerWeekLabel = (UILabel*)[cell viewWithTag:CELL_SIM_CHANGE_INFUSIONS_PER_WEEK];
    UILabel *simChangeInfusionsPerMonthLabel = (UILabel*)[cell viewWithTag:CELL_SIM_CHANGE_INFUSIONS_PER_MONTH];
    UILabel *simChangePercentLabel = (UILabel*)[cell viewWithTag:CELL_SIM_CHANGE_PERCENT_INFUSIONS];
    UILabel *remChangeInfusionsPerWeekLabel = (UILabel*)[cell viewWithTag:CELL_REM_CHANGE_INFUSIONS_PER_WEEK];
    UILabel *remChangeInfusionsPerMonthLabel = (UILabel*)[cell viewWithTag:CELL_REM_CHANGE_INFUSIONS_PER_MONTH];
    UILabel *remChangePercentLabel = (UILabel*)[cell viewWithTag:CELL_REM_CHANGE_PERCENT_INFUSIONS];

    UILabel *stelInfusionsPerWeekCurrentLabel = (UILabel*)[cell viewWithTag:CELL_STEL_INFUSIONS_PER_WEEK_CURRENT];
    UILabel *stelInfusionsPerMonthCurrentLabel = (UILabel*)[cell viewWithTag:CELL_STEL_INFUSIONS_PER_MONTH_CURRENT];
    UILabel *stelInfusionsPerWeekFullLabel = (UILabel*)[cell viewWithTag:CELL_STEL_INFUSIONS_PER_WEEK_FULL];
    UILabel *stelInfusionsPerMonthFullLabel = (UILabel*)[cell viewWithTag:CELL_STEL_INFUSIONS_PER_MONTH_FULL];
    UILabel *stelInfusionsPerkWeekChangeLabel = (UILabel*)[cell viewWithTag:CELL_STEL_CHANGE_INFUSIONS_PER_WEEK];
    UILabel *stelInfusionsPerMonthChangeLabel = (UILabel*)[cell viewWithTag:CELL_STEL_CHANGE_INFUSIONS_PER_MONTH];
    
    
    //Scenario
    [scenarioTitleLabel setText:[NSString stringWithFormat:@"%@", scenario.name]];

    //Chairs
    [chairOperationDaysCurrentLabel setText:[NSString stringWithFormat:@"%i", [scenario.solutionData.solutionStatistics.daysWithAtleastOneChairWithTime intValue]]];
    [chairNumCurrentLabel setText:[NSString stringWithFormat:@"%i", [scenario.solutionData.solutionStatistics.totalChairs intValue]]];
    [chairHoursAvailCurrentLabel setText:[NSString stringWithFormat:@"%.01f", [scenario.solutionData.solutionStatistics totalChairHours]]];
    [chairHoursOccupiedCurrentLabel setText:[NSString stringWithFormat:@"%.01f", [scenario.solutionData.solutionStatistics totalChairHoursUsedCurrentLoad]]];
    float chairPercentCapacity = [scenario.solutionData.solutionStatistics chairHoursCapacityCurrentLoad] * 100.0f;
    [chairPercentCapacityCurrentLabel setText:[NSString stringWithFormat:@"%.01f%%", chairPercentCapacity]];
//    [chairPercentCapacityCurrentLabel setBackgroundColor:[self getColorForValue:chairPercentCapacity]];
//    [chairPercentCapacityCurrentLabel setTextColor:[UIColor whiteColor]];
    
    [chairOperationDaysFullLabel setText:[NSString stringWithFormat:@"%i", [scenario.solutionData.solutionStatistics.daysWithAtleastOneChairWithTime intValue]]];
    [chairNumFullLabel setText:[NSString stringWithFormat:@"%i", [scenario.solutionData.solutionStatistics.totalChairs intValue]]];
    [chairHoursAvailFullLabel setText:[NSString stringWithFormat:@"%.01f", [scenario.solutionData.solutionStatistics totalChairHours]]];
    [chairHoursOccupiedFullLabel setText:[NSString stringWithFormat:@"%.01f", [scenario.solutionData.solutionStatistics totalChairHoursUsedFullLoad]]];
    [chairPercentCapacityFullLabel setText:[NSString stringWithFormat:@"%.01f%%", [scenario.solutionData.solutionStatistics chairHoursCapacityFullLoad] * 100]];
    
    float chairPercentChange = ([scenario.solutionData.solutionStatistics chairHoursCapacityFullLoad] - [scenario.solutionData.solutionStatistics chairHoursCapacityCurrentLoad]) * 100;
    [chairsChangePercentOfCapacityLabel setText:[NSString stringWithFormat:@"%.01f%%", chairPercentChange]];
    
    //Staff
    [staffNumCurrentLabel setText:[NSString stringWithFormat:@"%.1lu", (unsigned long)[scenario.staff count]]];
    [staffHoursAvailCurrentLabel setText:[NSString stringWithFormat:@"%.01f", [scenario.solutionData.solutionStatistics totalStaffHours]]];
    [staffHoursUtilCurrentLabel setText:[NSString stringWithFormat:@"%.01f", [scenario.solutionData.solutionStatistics totalStaffHoursUsedCurrentLoad]]];
    float staffPercentCapacityCurrent = [scenario.solutionData.solutionStatistics staffHoursCapacityCurrentLoad] * 100.0f;
    [staffPercentCapacityCurrentLabel setText:[NSString stringWithFormat:@"%.01f%%", staffPercentCapacityCurrent]];
//    [staffPercentCapacityCurrentLabel setBackgroundColor:[self getColorForValue:staffPercentCapacityCurrent]];
//    [staffPercentCapacityCurrentLabel setTextColor:[UIColor whiteColor]];

    [staffNumFullLabel setText:[NSString stringWithFormat:@"%.1lu", (unsigned long)[scenario.staff count]]];
    [staffHoursAvailFullLabel setText:[NSString stringWithFormat:@"%.01f", [scenario.solutionData.solutionStatistics totalStaffHours]]];
    [staffHoursUtilFullLabel setText:[NSString stringWithFormat:@"%.01f", [scenario.solutionData.solutionStatistics totalStaffHoursUsedFullLoad]]];
    [staffPercentCapacityFullLabel setText:[NSString stringWithFormat:@"%.01f%%", [scenario.solutionData.solutionStatistics staffHoursCapacityFullLoad] * 100]];
    
    float staffPercentChange = ([scenario.solutionData.solutionStatistics staffHoursCapacityFullLoad] - [scenario.solutionData.solutionStatistics staffHoursCapacityCurrentLoad]) * 100;
    [staffChangePercentOfCapacityLabel setText:[NSString stringWithFormat:@"%.01f%%", staffPercentChange]];
    
    //Simponi
    if ([_presentation includeSimponiAria]) {
        [simpInfusionsPerWeekCurrentLabel setText:[NSString stringWithFormat:@"%.f", [scenario.solutionData.solutionStatistics totalSimponiPerWeekCurrentLoad]]];
        [simpInfusionsPerMonthCurrentLabel setText:[NSString stringWithFormat:@"%.f", [scenario.solutionData.solutionStatistics totalSimponiPerMonthCurrentLoad]]];
        
        [simpInfusionsPerWeekFullLabel setText:[NSString stringWithFormat:@"%.f", [scenario.solutionData.solutionStatistics totalSimponiPerWeekFullLoad]]];
        [simpInfusionsPerMonthFullLabel setText:[NSString stringWithFormat:@"%.f", [scenario.solutionData.solutionStatistics totalSimponiPerMonthFullLoad]]];
        
        int change = [scenario.solutionData.solutionStatistics totalSimponiPerWeekChange];
        NSString *sign = @"";
        if(change > 0) {
            sign = @"+";
        } else if (change < 0) {
            sign = @"-";
        }
        [simChangeInfusionsPerWeekLabel setText:[NSString stringWithFormat:@"%@%i", sign, change]];
        
        change = [scenario.solutionData.solutionStatistics totalSimponiPerMonthChange];
        sign = @"";
        if(change > 0) {
            sign = @"+";
        } else if (change < 0) {
            sign = @"-";
        }
        [simChangeInfusionsPerMonthLabel setText:[NSString stringWithFormat:@"%@%i", sign, change]];
        
        [simChangePercentLabel setText:[NSString stringWithFormat:@"%.01f%%", [scenario.solutionData.solutionStatistics totalSimponiChange] * 100]];
    }

    [stelInfusionsPerWeekCurrentLabel setText:[NSString stringWithFormat:@"%.f", [scenario.solutionData.solutionStatistics totalStelaraPerWeekCurrentLoad]]];
    [stelInfusionsPerMonthCurrentLabel setText:[NSString stringWithFormat:@"%.f", [scenario.solutionData.solutionStatistics totalStelaraPerMonthCurrentLoad]]];
    [stelInfusionsPerWeekFullLabel setText:[NSString stringWithFormat:@"%.f", [scenario.solutionData.solutionStatistics totalStelaraPerWeekFullLoad]]];
    [stelInfusionsPerMonthFullLabel setText:[NSString stringWithFormat:@"%.f", [scenario.solutionData.solutionStatistics totalStelaraPerMonthFullLoad]]];

    int sChange = [scenario.solutionData.solutionStatistics totalStelaraPerWeekChange];
    NSString *sign = @"";
    if(sChange > 0) {
        sign = @"+";
    } else if (sChange < 0) {
        sign = @"-";
    }
    [stelInfusionsPerkWeekChangeLabel setText:[NSString stringWithFormat:@"%@%i", sign, sChange]];

    sChange = [scenario.solutionData.solutionStatistics totalStelaraPerMonthChange];
    sign = @"";
    if(sChange > 0) {
        sign = @"+";
    } else if (sChange < 0) {
        sign = @"-";
    }
    [stelInfusionsPerMonthChangeLabel setText:[NSString stringWithFormat:@"%@%i", sign, sChange]];

    [remChangePercentLabel setText:[NSString stringWithFormat:@"%.01f%%", [scenario.solutionData.solutionStatistics totalStelaraChange] * 100]];

    //Remicade
    [remInfusionsPerWeekCurrentLabel setText:[NSString stringWithFormat:@"%.f", [scenario.solutionData.solutionStatistics totalRemicadePerWeekCurrentLoad]]];
    [remInfusionsPerMonthCurrentLabel setText:[NSString stringWithFormat:@"%.f", [scenario.solutionData.solutionStatistics totalRemicadePerMonthCurrentLoad]]];
    
    [remInfusionsPerWeekFullLabel setText:[NSString stringWithFormat:@"%.f", [scenario.solutionData.solutionStatistics totalRemicadePerWeekFullLoad]]];
    [remInfusionsPerMonthFullLabel setText:[NSString stringWithFormat:@"%.f", [scenario.solutionData.solutionStatistics totalRemicadePerMonthFullLoad]]];
    
    int change = [scenario.solutionData.solutionStatistics totalRemicadePerWeekChange];
    sign = @"";
    if(change > 0) {
        sign = @"+";
    } else if (change < 0) {
        sign = @"-";
    }
    [remChangeInfusionsPerWeekLabel setText:[NSString stringWithFormat:@"%@%i", sign, change]];
    
    change = [scenario.solutionData.solutionStatistics totalRemicadePerMonthChange];
    sign = @"";
    if(change > 0) {
        sign = @"+";
    } else if (change < 0) {
        sign = @"-";
    }
    [remChangeInfusionsPerMonthLabel setText:[NSString stringWithFormat:@"%@%i", sign, change]];
    
    [remChangePercentLabel setText:[NSString stringWithFormat:@"%.01f%%", [scenario.solutionData.solutionStatistics totalRemicadeChange] * 100]];

    [cell setPresentationType: _presentation.presentationType];
    
    return cell;
}

#pragma mark - Solution Process Notification
- (void)solutionDataDidFinishProcessingNotification:(NSNotification*)notification
{
    //Check and load result data
    [self loadScenarios];
    [self.scenarioTableView reloadData];
}

- (UIColor*)getColorForValue:(float)value
{
    if (value >= 60 && value <=80) {
        return [[Colors getInstance] altGreenColor];
    }else {
        return [[Colors getInstance] yellowColor];
    }
}

-(NSString*)analyticsIdentifier
{
    return @"scenario_overlay";
}

@end
