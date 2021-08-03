//
//  InputSummaryReportViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/3/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "InputSummaryReportViewController.h"
#import "Scenario+Extension.h"
#import "Presentation+Extension.h"
#import "RemicadeInfusion+Extension.h"
#import "StelaraInfusion+CoreDataProperties.h"
#import "StelaraInfusion+CoreDataClass.h"
#import "SimponiAriaInfusion+Extension.h"
#import "OtherInfusion+Extension.h"
#import "OtherInjection+Extension.h"
#import "Constants.h"
#import "IOMPDFPage.h"
#import "IOMAnalyticsManager.h"
#import "NSString+IOMExtensions.h"
#import "DropdownDataSource.h"
#import "DropdownController.h"
#import "ListValues.h"

@interface InputSummaryReportViewController ()<IOMAnalyticsIdentifiable, DropdownDelegate> {
    NSDateFormatter* _dateFormatter;
    
    OtherInjection* _otherInjection1;
    OtherInjection* _otherInjection2;
    OtherInjection* _otherInjection3;
    OtherInjection* _otherInjection4;
    OtherInjection* _otherInjection5;
    OtherInjection* _otherInjection6;
    OtherInjection* _otherInjection7;
    
    DropdownDataSource* _injectionFrequencyDataSoure;
    UIButton* _selectedDropdownButton;
    UIPopoverController* _dropdownPopoverController;
}

//Sections
@property (nonatomic, weak) IBOutlet UIView * chairsSection;
@property (nonatomic, weak) IBOutlet UIView * staffSection;
@property (nonatomic, weak) IBOutlet UIView * remicadeSection;
@property (nonatomic, weak) IBOutlet UIView * otherTreatmentsSection;
@property (nonatomic, weak) IBOutlet UILabel * bottomLabel;
@property (weak, nonatomic) IBOutlet UIStackView *stelaraStackView;
@property (weak, nonatomic) IBOutlet UIStackView *simponiStackView;

//Simponi views
@property (nonatomic, weak) IBOutlet UIView * simponiHeaderView;
@property (nonatomic, weak) IBOutlet UIView * simponiView;
@property (weak, nonatomic) IBOutlet UIView *stelaraHeaderView;
@property (weak, nonatomic) IBOutlet UIView *stelaraView;

//Summary info
@property (nonatomic, weak) IBOutlet UILabel * presentationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * scenarioLabel;
@property (nonatomic, weak) IBOutlet UILabel * reportCreatedLabel;
@property (nonatomic, weak) IBOutlet UILabel * lastModifiedLabel;
//Chair inputs
@property (nonatomic, weak) IBOutlet UILabel * operationDaysPerWeekLabel;
@property (nonatomic, weak) IBOutlet UILabel * numberOfChairsLabel;
@property (nonatomic, weak) IBOutlet UILabel * totalChairHoursLabel;
@property (nonatomic, weak) IBOutlet UILabel * chairHoursDay1Label;
@property (nonatomic, weak) IBOutlet UILabel * chairHoursDay2Label;
@property (nonatomic, weak) IBOutlet UILabel * chairHoursDay3Label;
@property (nonatomic, weak) IBOutlet UILabel * chairHoursDay4Label;
@property (nonatomic, weak) IBOutlet UILabel * chairHoursDay5Label;
@property (nonatomic, weak) IBOutlet UILabel * chairHoursDay6Label;
@property (nonatomic, weak) IBOutlet UILabel * chairHoursDay7Label;
//Staff inputs
@property (nonatomic, weak) IBOutlet UILabel * maxChairsPerHCPLabel;
@property (nonatomic, weak) IBOutlet UILabel * numberOfQHPLabel;
@property (nonatomic, weak) IBOutlet UILabel * numberOfAncillaryLabel;
@property (nonatomic, weak) IBOutlet UILabel * qhpHoursDay1Label;
@property (nonatomic, weak) IBOutlet UILabel * qhpHoursDay2Label;
@property (nonatomic, weak) IBOutlet UILabel * qhpHoursDay3Label;
@property (nonatomic, weak) IBOutlet UILabel * qhpHoursDay4Label;
@property (nonatomic, weak) IBOutlet UILabel * qhpHoursDay5Label;
@property (nonatomic, weak) IBOutlet UILabel * qhpHoursDay6Label;
@property (nonatomic, weak) IBOutlet UILabel * qhpHoursDay7Label;
@property (nonatomic, weak) IBOutlet UILabel * qhpHoursTotalLabel;
@property (nonatomic, weak) IBOutlet UILabel * ancHoursDay1Label;
@property (nonatomic, weak) IBOutlet UILabel * ancHoursDay2Label;
@property (nonatomic, weak) IBOutlet UILabel * ancHoursDay3Label;
@property (nonatomic, weak) IBOutlet UILabel * ancHoursDay4Label;
@property (nonatomic, weak) IBOutlet UILabel * ancHoursDay5Label;
@property (nonatomic, weak) IBOutlet UILabel * ancHoursDay6Label;
@property (nonatomic, weak) IBOutlet UILabel * ancHoursDay7Label;
@property (nonatomic, weak) IBOutlet UILabel * ancHoursTotalLabel;
@property (nonatomic, weak) IBOutlet UILabel * totalStaffHoursDay1Label;
@property (nonatomic, weak) IBOutlet UILabel * totalStaffHoursDay2Label;
@property (nonatomic, weak) IBOutlet UILabel * totalStaffHoursDay3Label;
@property (nonatomic, weak) IBOutlet UILabel * totalStaffHoursDay4Label;
@property (nonatomic, weak) IBOutlet UILabel * totalStaffHoursDay5Label;
@property (nonatomic, weak) IBOutlet UILabel * totalStaffHoursDay6Label;
@property (nonatomic, weak) IBOutlet UILabel * totalStaffHoursDay7Label;
@property (nonatomic, weak) IBOutlet UILabel * totalStaffHoursTotalLabel;
@property (nonatomic, weak) IBOutlet UILabel * fteDay1Label;
@property (nonatomic, weak) IBOutlet UILabel * fteDay2Label;
@property (nonatomic, weak) IBOutlet UILabel * fteDay3Label;
@property (nonatomic, weak) IBOutlet UILabel * fteDay4Label;
@property (nonatomic, weak) IBOutlet UILabel * fteDay5Label;
@property (nonatomic, weak) IBOutlet UILabel * fteDay6Label;
@property (nonatomic, weak) IBOutlet UILabel * fteDay7Label;
@property (nonatomic, weak) IBOutlet UILabel * fteTotalLabel;
//remicade inputs
@property (weak, nonatomic) IBOutlet UILabel *remicade2HRPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicade25HRPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicade3HRPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicade35HRPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicade4HRPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadePrepMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadeInfusionAdminMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadePostMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadeTotalMinutesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *remicadePrepQHPCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *remicadePrepANCCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *remicadeInfusionQHPCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *remicadeInfusionANCCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *remicadePostQHPCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *remicadePostANCCheckImageView;
@property (weak, nonatomic) IBOutlet UILabel *remicadeInfusionsPerMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadeNewPatientsPerMonthQ6Label;
@property (weak, nonatomic) IBOutlet UILabel *remicadeNewPatientsPerMonthQ8Label;
//Simponi inputs
@property (weak, nonatomic) IBOutlet UILabel *simponiPrepMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiInfusionAdminMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiPostMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiTotalMinutesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *simponiPrepQHPCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *simponiPrepANCCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *simponiInfusionQHPCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *simponiInfusionANCCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *simponiPostQHPCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *simponiPostANCCheckImageView;
@property (weak, nonatomic) IBOutlet UILabel *simponiInfusionsPerMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiNewPatientsPerMonthQ8Label;
// stelara
@property (weak, nonatomic) IBOutlet UILabel *stelaraPrepMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraInfusionAdminMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraPostMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraTotalMinutesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stelaraPrepQHPCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stelaraPrepANCCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stelaraInfusionQHPCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stelaraInfusionANCCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stelaraPostQHPCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stelaraPostANCCheckImageView;
@property (weak, nonatomic) IBOutlet UILabel *stelaraInfusionsPerMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraNewPatientsPerMonthQ8Label;
//Other treatments
@property (weak, nonatomic) IBOutlet UILabel *rxATotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxBTotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxCTotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxDTotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxETotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxFTotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxGTotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxHTotalTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *rxATreatmentsPerMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxBTreatmentsPerMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxCTreatmentsPerMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxDTreatmentsPerMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxETreatmentsPerMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxFTreatmentsPerMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxGTreatmentsPerMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxHTreatmentsPerMonthLabel;

@property (weak, nonatomic) IBOutlet UILabel *rxAPrepLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxBPrepLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxCPrepLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxDPrepLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxEPrepLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxFPrepLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxGPrepLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxHPrepLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxAInfusionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxBInfusionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxCInfusionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxDInfusionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxEInfusionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxFInfusionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxGInfusionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxHInfusionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxAPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxBPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxCPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxDPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxEPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxFPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxGPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxHPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxAnewPatientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxBnewPatientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxCnewPatientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxDnewPatientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxEnewPatientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxFnewPatientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxGnewPatientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxHnewPatientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxAweeksBetweenLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxBweeksBetweenLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxCweeksBetweenLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxDweeksBetweenLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxEweeksBetweenLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxFweeksBetweenLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxGweeksBetweenLabel;
@property (weak, nonatomic) IBOutlet UILabel *rxHweeksBetweenLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection1TotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection2TotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection3TotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection4TotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection5TotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection6TotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection7TotalTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *injection1TreatmentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection2TreatmentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection3TreatmentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection4TreatmentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection5TreatmentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection6TreatmentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection7TreatmentsLabel;

@property (weak, nonatomic) IBOutlet UIButton *injection1FrequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *injection2FrequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *injection3FrequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *injection4FrequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *injection5FrequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *injection6FrequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *injection7FrequencyButton;

@end

@implementation InputSummaryReportViewController
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
    // Do any additional setup after loading the view from its nib.
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"M/d/y"];
    
    [self displaySummaryInformation];
    [self displayChairInformation];
    [self displayStaffInformation];
    [self displayRemicadeInformation];
    [self displaySimponiInformation];
    [self displayStelaraInformation];
    [self displayOtherTreatmentsInformation];
    [self displayBottomLabelContent];
    [self hideSimponi:![_scenario.presentation includeSimponiAria]];
    [self hideStelara:![_scenario.presentation includeStelara]];
    [self initializeDropDownDataSource];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideSimponi:(BOOL)hide
{
    _simponiStackView.hidden = hide;
    if(hide) {
        CGFloat simpHeight = _simponiHeaderView.frame.size.height + _simponiView.frame.size.height;
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - simpHeight)];
    }
}

- (void)hideStelara:(BOOL)hide
{
    _stelaraStackView.hidden = hide;
    if(hide) {
        CGFloat simpHeight = _stelaraHeaderView.frame.size.height + _stelaraView.frame.size.height;
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - simpHeight)];
    }
}

- (void)displayBottomLabelContent
{
    [_bottomLabel setText:[NSString stringWithFormat:@"Please see accompanying Indications, Important Safety Information, Dosing and Administration, and full Prescribing Information and Medication Guide for %@.", [NSString humanReadableListFromArray:_scenario.presentation.drugTitlesForPresentationType]]];
}

//Display data
- (void)displaySummaryInformation
{
    [_presentationNameLabel setText:_scenario.presentation.accountName];
    [_scenarioLabel setText:_scenario.name];
    [_reportCreatedLabel setText:[_dateFormatter stringFromDate:_scenario.dateCreated]];
    [_lastModifiedLabel setText:[_dateFormatter stringFromDate:_scenario.lastUpdated]];
}

- (void)displayChairInformation
{
    [_operationDaysPerWeekLabel setText:[NSString stringWithFormat:@"%i", [_scenario getDaysWithAtleastOneChairAvailable]]];
    [_numberOfChairsLabel setText:[NSString stringWithFormat:@"%i", [_scenario.chairs count]]];
    [_totalChairHoursLabel setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalChairHours]]];
    [_chairHoursDay1Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalChairHoursForDay:0]]];
    [_chairHoursDay2Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalChairHoursForDay:1]]];
    [_chairHoursDay3Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalChairHoursForDay:2]]];
    [_chairHoursDay4Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalChairHoursForDay:3]]];
    [_chairHoursDay5Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalChairHoursForDay:4]]];
    [_chairHoursDay6Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalChairHoursForDay:5]]];
    [_chairHoursDay7Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalChairHoursForDay:6]]];
}

- (void)displayStaffInformation
{
    [_maxChairsPerHCPLabel setText:[NSString stringWithFormat:@"%i", [_scenario.maxChairsPerStaff intValue]]];
    [_numberOfQHPLabel setText:[NSString stringWithFormat:@"%i", [_scenario getCountOfStaffForType:StaffTypeQHP]]];
    [_numberOfAncillaryLabel setText:[NSString stringWithFormat:@"%i", [_scenario getCountOfStaffForType:StaffTypeAncillary]]];
    
    [_qhpHoursDay1Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeQHP onDay:0]]];
    [_qhpHoursDay2Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeQHP onDay:1]]];
    [_qhpHoursDay3Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeQHP onDay:2]]];
    [_qhpHoursDay4Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeQHP onDay:3]]];
    [_qhpHoursDay5Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeQHP onDay:4]]];
    [_qhpHoursDay6Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeQHP onDay:5]]];
    [_qhpHoursDay7Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeQHP onDay:6]]];
    [_qhpHoursTotalLabel setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeQHP]]];
    
    [_ancHoursDay1Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeAncillary onDay:0]]];
    [_ancHoursDay2Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeAncillary onDay:1]]];
    [_ancHoursDay3Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeAncillary onDay:2]]];
    [_ancHoursDay4Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeAncillary onDay:3]]];
    [_ancHoursDay5Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeAncillary onDay:4]]];
    [_ancHoursDay6Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeAncillary onDay:5]]];
    [_ancHoursDay7Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeAncillary onDay:6]]];
    [_ancHoursTotalLabel setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForStaffType:StaffTypeAncillary]]];
    
    [_totalStaffHoursDay1Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForDay:0]]];
    [_totalStaffHoursDay2Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForDay:1]]];
    [_totalStaffHoursDay3Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForDay:2]]];
    [_totalStaffHoursDay4Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForDay:3]]];
    [_totalStaffHoursDay5Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForDay:4]]];
    [_totalStaffHoursDay6Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForDay:5]]];
    [_totalStaffHoursDay7Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHoursForDay:6]]];
    [_totalStaffHoursTotalLabel setText:[NSString stringWithFormat:@"%.01f", [_scenario getTotalStaffHours]]];
    
    [_fteDay1Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getStaffFTEForDay:0]]];
    [_fteDay2Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getStaffFTEForDay:1]]];
    [_fteDay3Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getStaffFTEForDay:2]]];
    [_fteDay4Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getStaffFTEForDay:3]]];
    [_fteDay5Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getStaffFTEForDay:4]]];
    [_fteDay6Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getStaffFTEForDay:5]]];
    [_fteDay7Label setText:[NSString stringWithFormat:@"%.01f", [_scenario getStaffFTEForDay:6]]];
    [_fteTotalLabel setText:[NSString stringWithFormat:@"%.01f", [_scenario getStaffFTE]]];
}

- (void)displayRemicadeInformation
{
    [_remicade2HRPercentLabel setText:[NSString stringWithFormat:@"%i%%",[_scenario.remicadeInfusion.percent2hr intValue]]];
    [_remicade25HRPercentLabel setText:[NSString stringWithFormat:@"%i%%",[_scenario.remicadeInfusion.percent2_5hr intValue]]];
    [_remicade3HRPercentLabel setText:[NSString stringWithFormat:@"%i%%",[_scenario.remicadeInfusion.percent3hr intValue]]];
    [_remicade35HRPercentLabel setText:[NSString stringWithFormat:@"%i%%",[_scenario.remicadeInfusion.percent3_5hr intValue]]];
    [_remicade4HRPercentLabel setText:[NSString stringWithFormat:@"%i%%",[_scenario.remicadeInfusion.percent4hr intValue]]];
    
    [_remicadePrepMinutesLabel setText:[NSString stringWithFormat:@"%i", [_scenario.remicadeInfusion.prepTime intValue] *10]];
    [_remicadeInfusionAdminMinutesLabel setText:[NSString stringWithFormat:@"%i", [_scenario.remicadeInfusion infusionAdministrationTime] *10]];
    [_remicadePostMinutesLabel setText:[NSString stringWithFormat:@"%i", [_scenario.remicadeInfusion.postTime intValue] *10]];
    [_remicadeTotalMinutesLabel setText:[NSString stringWithFormat:@"%i", [_scenario.remicadeInfusion getTotalTime] *10]];
    //QHP is always checked
    [_remicadePrepANCCheckImageView setHidden:!([_scenario.remicadeInfusion.prepAncillary boolValue])];
    //Infusion ANC always checked
    [_remicadePostANCCheckImageView setHidden:!([_scenario.remicadeInfusion.postAncillary boolValue])];
    
    [_remicadeInfusionsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [_scenario.remicadeInfusion.avgInfusionsPerMonth intValue]]];
    [_remicadeNewPatientsPerMonthQ6Label setText:[NSString stringWithFormat:@"%i", [_scenario.remicadeInfusion.avgNewPatientsPerMonthQ6 intValue]]];
    [_remicadeNewPatientsPerMonthQ8Label setText:[NSString stringWithFormat:@"%i", [_scenario.remicadeInfusion.avgNewPatientsPerMonthQ8 intValue]]];
    
}

- (void)displaySimponiInformation
{
    [_simponiPrepMinutesLabel setText:[NSString stringWithFormat:@"%i", [_scenario.simponiAriaInfusion.prepTime intValue] *10]];
    [_simponiInfusionAdminMinutesLabel setText:[NSString stringWithFormat:@"%i", [_scenario.simponiAriaInfusion.infusionAdminTime intValue] *10]];
    [_simponiPostMinutesLabel setText:[NSString stringWithFormat:@"%i", [_scenario.simponiAriaInfusion.postTime intValue] *10]];
    [_simponiTotalMinutesLabel setText:[NSString stringWithFormat:@"%i", [_scenario.simponiAriaInfusion getTotalTime] *10]];
    //QHP is always checked
    [_simponiPrepANCCheckImageView setHidden:!([_scenario.simponiAriaInfusion.prepAncillary boolValue])];
    //Infusion ANC always checked
    [_simponiPostANCCheckImageView setHidden:!([_scenario.simponiAriaInfusion.postAncillary boolValue])];
    
    [_simponiInfusionsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [_scenario.simponiAriaInfusion.avgInfusionsPerMonth intValue]]];
    [_simponiNewPatientsPerMonthQ8Label setText:[NSString stringWithFormat:@"%i", [_scenario.simponiAriaInfusion.avgNewPatientsPerMonth intValue]]];
}

- (void)displayStelaraInformation
{
    [_stelaraPrepMinutesLabel setText:[NSString stringWithFormat:@"%i", [_scenario.stelaraInfusion.prepTime intValue] *10]];
    [_stelaraInfusionAdminMinutesLabel setText:[NSString stringWithFormat:@"%i", [_scenario.stelaraInfusion.infusionAdminTime intValue] *10]];
    [_stelaraPostMinutesLabel setText:[NSString stringWithFormat:@"%i", [_scenario.stelaraInfusion.postTime intValue] *10]];
    [_stelaraTotalMinutesLabel setText:[NSString stringWithFormat:@"%i", [_scenario.stelaraInfusion getTotalTime] *10]];
    //QHP is always checked
    [_stelaraPrepANCCheckImageView setHidden:!([_scenario.stelaraInfusion.prepAncillary boolValue])];
    //Infusion ANC always checked
    [_stelaraPostANCCheckImageView setHidden:!([_scenario.stelaraInfusion.postAncillary boolValue])];

    [_stelaraInfusionsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [_scenario.stelaraInfusion.avgInfusionsPerMonth intValue]]];
    [_stelaraNewPatientsPerMonthQ8Label setText:[NSString stringWithFormat:@"%i", [_scenario.stelaraInfusion.avgNewPatientsPerMonth intValue]]];
}

- (void)displayOtherTreatmentsInformation
{
    OtherInfusion* infA = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxA forScenario:_scenario];
    OtherInfusion* infB = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxB forScenario:_scenario];
    OtherInfusion* infC = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxC forScenario:_scenario];
    OtherInfusion* infD = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxD forScenario:_scenario];
    OtherInfusion* infE = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxE forScenario:_scenario];
    OtherInfusion* infF = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxF forScenario:_scenario];
    OtherInfusion* infG = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxG forScenario:_scenario];
    OtherInfusion* infH = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxH forScenario:_scenario];
    
    [_rxATotalTimeLabel setText:[NSString stringWithFormat:@"%i", [infA getTotalTime] *10]];
    [_rxBTotalTimeLabel setText:[NSString stringWithFormat:@"%i", [infB getTotalTime] *10]];
    [_rxCTotalTimeLabel setText:[NSString stringWithFormat:@"%i", [infC getTotalTime] *10]];
    [_rxDTotalTimeLabel setText:[NSString stringWithFormat:@"%i", [infD getTotalTime] *10]];
    [_rxETotalTimeLabel setText:[NSString stringWithFormat:@"%i", [infE getTotalTime] *10]];
    [_rxFTotalTimeLabel setText:[NSString stringWithFormat:@"%i", [infF getTotalTime] *10]];
    [_rxGTotalTimeLabel setText:[NSString stringWithFormat:@"%i", [infG getTotalTime] *10]];
    [_rxHTotalTimeLabel setText:[NSString stringWithFormat:@"%i", [infH getTotalTime] *10]];
    
    [_rxATreatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [infA.treatmentsPerMonth intValue]]];
    [_rxBTreatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [infB.treatmentsPerMonth intValue]]];
    [_rxCTreatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [infC.treatmentsPerMonth intValue]]];
    [_rxDTreatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [infD.treatmentsPerMonth intValue]]];
    [_rxETreatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [infE.treatmentsPerMonth intValue]]];
    [_rxFTreatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [infF.treatmentsPerMonth intValue]]];
    [_rxGTreatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [infG.treatmentsPerMonth intValue]]];
    [_rxHTreatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [infH.treatmentsPerMonth intValue]]];
    
    [_rxAPrepLabel setText:[NSString stringWithFormat:@"%i", [infA.prepTime intValue] *10]];
    [_rxBPrepLabel setText:[NSString stringWithFormat:@"%i", [infB.prepTime intValue] *10]];
    [_rxCPrepLabel setText:[NSString stringWithFormat:@"%i", [infC.prepTime intValue] *10]];
    [_rxDPrepLabel setText:[NSString stringWithFormat:@"%i", [infD.prepTime intValue] *10]];
    [_rxEPrepLabel setText:[NSString stringWithFormat:@"%i", [infE.prepTime intValue] *10]];
    [_rxFPrepLabel setText:[NSString stringWithFormat:@"%i", [infF.prepTime intValue] *10]];
    [_rxGPrepLabel setText:[NSString stringWithFormat:@"%i", [infG.prepTime intValue] *10]];
    [_rxHPrepLabel setText:[NSString stringWithFormat:@"%i", [infH.prepTime intValue] *10]];
    
    [_rxAInfusionLabel setText:[NSString stringWithFormat:@"%i", [infA.infusionTime intValue] *10]];
    [_rxBInfusionLabel setText:[NSString stringWithFormat:@"%i", [infB.infusionTime intValue] *10]];
    [_rxCInfusionLabel setText:[NSString stringWithFormat:@"%i", [infC.infusionTime intValue] *10]];
    [_rxDInfusionLabel setText:[NSString stringWithFormat:@"%i", [infD.infusionTime intValue] *10]];
    [_rxEInfusionLabel setText:[NSString stringWithFormat:@"%i", [infE.infusionTime intValue] *10]];
    [_rxFInfusionLabel setText:[NSString stringWithFormat:@"%i", [infF.infusionTime intValue] *10]];
    [_rxGInfusionLabel setText:[NSString stringWithFormat:@"%i", [infG.infusionTime intValue] *10]];
    [_rxHInfusionLabel setText:[NSString stringWithFormat:@"%i", [infH.infusionTime intValue] *10]];
    
    [_rxAPostLabel setText:[NSString stringWithFormat:@"%i", [infA.postTime intValue] *10]];
    [_rxBPostLabel setText:[NSString stringWithFormat:@"%i", [infB.postTime intValue] *10]];
    [_rxCPostLabel setText:[NSString stringWithFormat:@"%i", [infC.postTime intValue] *10]];
    [_rxDPostLabel setText:[NSString stringWithFormat:@"%i", [infD.postTime intValue] *10]];
    [_rxEPostLabel setText:[NSString stringWithFormat:@"%i", [infE.postTime intValue] *10]];
    [_rxFPostLabel setText:[NSString stringWithFormat:@"%i", [infF.postTime intValue] *10]];
    [_rxGPostLabel setText:[NSString stringWithFormat:@"%i", [infG.postTime intValue] *10]];
    [_rxHPostLabel setText:[NSString stringWithFormat:@"%i", [infH.postTime intValue] *10]];
    
    [_rxAnewPatientsLabel setText:[NSString stringWithFormat:@"%i", [infA.avgNewPatientsPerMonth intValue]]];
    [_rxBnewPatientsLabel setText:[NSString stringWithFormat:@"%i", [infB.avgNewPatientsPerMonth intValue]]];
    [_rxCnewPatientsLabel setText:[NSString stringWithFormat:@"%i", [infC.avgNewPatientsPerMonth intValue]]];
    [_rxDnewPatientsLabel setText:[NSString stringWithFormat:@"%i", [infD.avgNewPatientsPerMonth intValue]]];
    [_rxEnewPatientsLabel setText:[NSString stringWithFormat:@"%i", [infE.avgNewPatientsPerMonth intValue]]];
    [_rxFnewPatientsLabel setText:[NSString stringWithFormat:@"%i", [infF.avgNewPatientsPerMonth intValue]]];
    [_rxGnewPatientsLabel setText:[NSString stringWithFormat:@"%i", [infG.avgNewPatientsPerMonth intValue]]];
    [_rxHnewPatientsLabel setText:[NSString stringWithFormat:@"%i", [infH.avgNewPatientsPerMonth intValue]]];
    
    [_rxAweeksBetweenLabel setText:[NSString stringWithFormat:@"%i", [infA.weeksBetween intValue]]];
    [_rxBweeksBetweenLabel setText:[NSString stringWithFormat:@"%i", [infB.weeksBetween intValue]]];
    [_rxCweeksBetweenLabel setText:[NSString stringWithFormat:@"%i", [infC.weeksBetween intValue]]];
    [_rxDweeksBetweenLabel setText:[NSString stringWithFormat:@"%i", [infD.weeksBetween intValue]]];
    [_rxEweeksBetweenLabel setText:[NSString stringWithFormat:@"%i", [infE.weeksBetween intValue]]];
    [_rxFweeksBetweenLabel setText:[NSString stringWithFormat:@"%i", [infF.weeksBetween intValue]]];
    [_rxGweeksBetweenLabel setText:[NSString stringWithFormat:@"%i", [infG.weeksBetween intValue]]];
    [_rxHweeksBetweenLabel setText:[NSString stringWithFormat:@"%i", [infH.weeksBetween intValue]]];
    
    [self updateTotalTreatmentsPerMonthLabelsAndinjectionObjects];
    
    [_injection1TotalTimeLabel setText:[NSString stringWithFormat:@"%g", DEFAULT_INJECTION1_PREP1_TIME*10]];
    [_injection2TotalTimeLabel setText:[NSString stringWithFormat:@"%g", DEFAULT_INJECTION2_PREP1_TIME*10]];
    [_injection3TotalTimeLabel setText:[NSString stringWithFormat:@"%g", DEFAULT_INJECTION3_PREP1_TIME*10]];
    [_injection4TotalTimeLabel setText:[NSString stringWithFormat:@"%g", DEFAULT_INJECTION4_PREP1_TIME*10]];
    [_injection5TotalTimeLabel setText:[NSString stringWithFormat:@"%g", DEFAULT_INJECTION5_PREP1_TIME*10]];
    [_injection6TotalTimeLabel setText:[NSString stringWithFormat:@"%g", DEFAULT_INJECTION6_PREP1_TIME*10]];
    [_injection7TotalTimeLabel setText:[NSString stringWithFormat:@"%g", DEFAULT_INJECTION7_PREP1_TIME*10]];
    
    NSString* inj1Frequency = [_otherInjection1.frequency stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[_otherInjection1.frequency substringToIndex:1] uppercaseString]];
    NSString* inj2Frequency = [_otherInjection2.frequency stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[_otherInjection2.frequency substringToIndex:1] uppercaseString]];
    NSString* inj3Frequency = [_otherInjection3.frequency stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[_otherInjection3.frequency substringToIndex:1] uppercaseString]];
    NSString* inj4Frequency = [_otherInjection4.frequency stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[_otherInjection4.frequency substringToIndex:1] uppercaseString]];
    NSString* inj5Frequency = [_otherInjection5.frequency stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[_otherInjection5.frequency substringToIndex:1] uppercaseString]];
    NSString* inj6Frequency = [_otherInjection6.frequency stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[_otherInjection6.frequency substringToIndex:1] uppercaseString]];
    NSString* inj7Frequency = [_otherInjection7.frequency stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[_otherInjection7.frequency substringToIndex:1] uppercaseString]];
    
    [_injection1FrequencyButton setTitle:inj1Frequency forState:UIControlStateNormal];
    [_injection2FrequencyButton setTitle:inj2Frequency forState:UIControlStateNormal];
    [_injection3FrequencyButton setTitle:inj3Frequency forState:UIControlStateNormal];
    [_injection4FrequencyButton setTitle:inj4Frequency forState:UIControlStateNormal];
    [_injection5FrequencyButton setTitle:inj5Frequency forState:UIControlStateNormal];
    [_injection6FrequencyButton setTitle:inj6Frequency forState:UIControlStateNormal];
    [_injection7FrequencyButton setTitle:inj7Frequency forState:UIControlStateNormal];
}

- (void) updateTotalTreatmentsPerMonthLabelsAndinjectionObjects{
    
    _otherInjection1 = [OtherInjection getOtherInjectionOfType:OtherInjectionType1 forScenario:_scenario];
    _otherInjection2 = [OtherInjection getOtherInjectionOfType:OtherInjectionType2 forScenario:_scenario];
    _otherInjection3 = [OtherInjection getOtherInjectionOfType:OtherInjectionType3 forScenario:_scenario];
    _otherInjection4 = [OtherInjection getOtherInjectionOfType:OtherInjectionType4 forScenario:_scenario];
    _otherInjection5 = [OtherInjection getOtherInjectionOfType:OtherInjectionType5 forScenario:_scenario];
    _otherInjection6 = [OtherInjection getOtherInjectionOfType:OtherInjectionType6 forScenario:_scenario];
    _otherInjection7 = [OtherInjection getOtherInjectionOfType:OtherInjectionType7 forScenario:_scenario];
    
    [_injection1TreatmentsLabel setText:[NSString stringWithFormat:@"%.02f", [_otherInjection1.treatmentsPerMonth doubleValue]]];
    [_injection2TreatmentsLabel setText:[NSString stringWithFormat:@"%.02f", [_otherInjection2.treatmentsPerMonth doubleValue]]];
    [_injection3TreatmentsLabel setText:[NSString stringWithFormat:@"%.02f", [_otherInjection3.treatmentsPerMonth doubleValue]]];
    [_injection4TreatmentsLabel setText:[NSString stringWithFormat:@"%.02f", [_otherInjection4.treatmentsPerMonth doubleValue]]];
    [_injection5TreatmentsLabel setText:[NSString stringWithFormat:@"%.02f", [_otherInjection5.treatmentsPerMonth doubleValue]]];
    [_injection6TreatmentsLabel setText:[NSString stringWithFormat:@"%.02f", [_otherInjection6.treatmentsPerMonth doubleValue]]];
    [_injection7TreatmentsLabel setText:[NSString stringWithFormat:@"%.02f", [_otherInjection7.treatmentsPerMonth doubleValue]]];
}

- (void)initializeDropDownDataSource{
    _injectionFrequencyDataSoure = [[DropdownDataSource alloc] initWithItems:LIST_VALUES_ARRAY_INJECTION_FREQUENCY andTitleForItemBlock:^NSString *(id item) {
        return item;
    }];
}

- (IBAction)injectionFrequencyButtonSelected:(id)sender {
//    [self showDropdownPopoverFromSender:sender withDataSource:_injectionFrequencyDataSoure];
}

- (void)showDropdownPopoverFromSender:(id)sender withDataSource:(DropdownDataSource*)dataSource
{
    _selectedDropdownButton = sender;
    CGRect tempFrame = _selectedDropdownButton.frame;
    tempFrame.origin.x = 41 + _selectedDropdownButton.frame.origin.x;
    tempFrame.origin.y = 150 + 199 + 345 + 398 + 398 + 505 + 103 + _selectedDropdownButton.frame.origin.y;
    CGRect fromRect = _selectedDropdownButton ? tempFrame : CGRectMake(0, 0, 1, 1);
    
    if(_dropdownPopoverController){
        if(_dropdownPopoverController.isPopoverVisible){
            [_dropdownPopoverController dismissPopoverAnimated:YES];
        }
        _dropdownPopoverController = nil;
    }
    
    DropdownController* controller = [[DropdownController alloc] init];
    [controller setDataSource:dataSource];
    [controller setDelegate:self];
    _dropdownPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
    [_dropdownPopoverController setContentViewController:controller];
    [_dropdownPopoverController presentPopoverFromRect:fromRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - DropdownDelegate Protocol methods
- (void)dropdown:(DropdownController*)dropdown item:(id)item selectedAtIndex:(int)index fromDataSource:(DropdownDataSource *)dataSource
{
    [_selectedDropdownButton setTitle:item forState:UIControlStateNormal];
    
    OtherInjection *otherInjection = [self getOtherInjectionForCorrespondingDropDownButton:_selectedDropdownButton];
    otherInjection.frequency = item;
    
    [otherInjection calculateTotalTreatmentsPerMonth];
    [self updateTotalTreatmentsPerMonthLabelsAndinjectionObjects];
    
    //Dismiss popover
    [_dropdownPopoverController dismissPopoverAnimated:YES];
    _dropdownPopoverController = nil;
    _selectedDropdownButton = nil;
}

- (OtherInjection*)getOtherInjectionForCorrespondingDropDownButton:(id)sender{
    if (sender == _injection1FrequencyButton){
        return _otherInjection1;
    }else if (sender == _injection2FrequencyButton){
        return _otherInjection2;
    }else if (sender == _injection3FrequencyButton){
        return _otherInjection3;
    }else if (sender == _injection4FrequencyButton){
        return _otherInjection4;
    }else if (sender == _injection5FrequencyButton){
        return _otherInjection5;
    }else if (sender == _injection6FrequencyButton){
        return _otherInjection6;
    }else if (sender == _injection7FrequencyButton){
        return _otherInjection7;
    }
}

#pragma mark - IOMReportProtocol
- (NSArray*)getPDFPageDataForPageHeight:(CGFloat)pageHeight
{
    IOMPDFPage *page1 = [[IOMPDFPage alloc] init];
    page1.pageStart = 17;
    page1.pageEnd = _remicadeSection.frame.origin.y + _remicadeSection.frame.size.height;
    
    return @[page1];
}

- (NSArray*)getPDFSchedulePageDataForPageHeight:(CGFloat)pageHeight andPaddingBetweenViews:(CGFloat)padding
{
    return nil;
}

-(NSString*)analyticsIdentifier
{
    return @"input_summary_report";
}

@end
