//
//  RemicadeInfusionViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/23/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "RemicadeInfusionViewController.h"
#import "Scenario+Extension.h"
#import "RemicadeInfusion+Extension.h"
#import "DropdownDataSource.h"
#import "DropdownController.h"
#import "ListValues.h"
#import "Constants.h"
#import "Colors.h"
#import "UILabel+SuperscriptLabel.h"
#import "IOMAnalyticsManager.h"
#import "UIView+IOMExtensions.h"

@interface RemicadeInfusionViewController ()<IOMAnalyticsIdentifiable, UIScrollViewDelegate>{
    RemicadeInfusion* _remicadeInfusion;
    
    DropdownDataSource* _percentagesDropdownDataSource;
    DropdownDataSource* _prepStepTimeDropdownDataSource;
    DropdownDataSource* _postStepTimeDropdownDataSource;
    
    UIButton* _selectedDropdownButton;
    UIPopoverController* _dropdownPopoverController;
}

@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property (nonatomic, weak) IBOutlet UITextField* averageInfusionsPerMonthTextField;
@property (nonatomic, weak) IBOutlet UITextField* averageNewPatientsPerMonthQ6TextField;
@property (nonatomic, weak) IBOutlet UITextField* averageNewPatientsPerMonthQ8TextField;

@property (nonatomic, weak) IBOutlet UIButton* preInfusionTimeButton;
@property (nonatomic, weak) IBOutlet UIButton* postInfusionTimeButton;
@property (nonatomic, weak) IBOutlet UILabel* infusionAdminTimeLabel;
@property (nonatomic, weak) IBOutlet UISwitch* preInfusionAncillarySwitch;
@property (nonatomic, weak) IBOutlet UISwitch* postInfusionAncillarySwitch;
@property (nonatomic, weak) IBOutlet UIButton* stepTimesClearButton;

@property (nonatomic, weak) IBOutlet UIButton* rem2HrPercentageButton;
@property (nonatomic, weak) IBOutlet UIButton* rem25HrPercentageButton;
@property (nonatomic, weak) IBOutlet UIButton* rem3HrPercentageButton;
@property (nonatomic, weak) IBOutlet UIButton* rem35HrPercentageButton;
@property (nonatomic, weak) IBOutlet UIButton* rem4HrPercentageButton;
@property (nonatomic, weak) IBOutlet UILabel* rem2HrTreatmentsPerMonthLabel;
@property (nonatomic, weak) IBOutlet UILabel* rem25HrTreatmentsPerMonthLabel;
@property (nonatomic, weak) IBOutlet UILabel* rem3HrTreatmentsPerMonthLabel;
@property (nonatomic, weak) IBOutlet UILabel* rem35HrTreatmentsPerMonthLabel;
@property (nonatomic, weak) IBOutlet UILabel* rem4HrTreatmentsPerMonthLabel;
@property (nonatomic, weak) IBOutlet UILabel* rem2HrInfusionAdminTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* rem25HrInfusionAdminTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* rem3HrInfusionAdminTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* rem35HrInfusionAdminTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* rem4HrInfusionAdminTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* totalDurationPercentageLabel;
@property (nonatomic, weak) IBOutlet UIButton* treatmentDurationClearButton;

@property (nonatomic, weak) IBOutlet UIButton* suggestedClinicalPathwayButton;


@end

@implementation RemicadeInfusionViewController
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

    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];

	// Do any additional setup after loading the view.
    
    //Array of textfields for keyboard navigation
    self.textFieldArray = @[_averageInfusionsPerMonthTextField, _averageNewPatientsPerMonthQ6TextField, _averageNewPatientsPerMonthQ8TextField];
    
    [_suggestedClinicalPathwayButton.titleLabel setSuperscriptForRegisteredTradeMarkSymbols];
    
    //Set switch actions
    [_preInfusionAncillarySwitch addTarget:self action:@selector(ancillarySwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [_postInfusionAncillarySwitch addTarget:self action:@selector(ancillarySwitchChanged:) forControlEvents:UIControlEventValueChanged];
    
    //Create dropdown datasources
    [self createDropdownDataSources];
    
    [self initializeInputData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RemicadeInfusion*)remicadeInfusion
{
    if(!_remicadeInfusion){
        //Get remicade infusion model to display and modify
        _remicadeInfusion = [RemicadeInfusion getRemicadeInfusionForScenario:_scenario];
    }
    
    return _remicadeInfusion;
}

#pragma mark - Display Data
- (void)initializeInputData
{
    //Set patient information
    NSString* avgInfusionsPerMonthString = ([[self remicadeInfusion].avgInfusionsPerMonth intValue] == 0) ? @"" : [[self remicadeInfusion].avgInfusionsPerMonth stringValue];
    NSString* avgNewQ6String = ([[self remicadeInfusion].avgNewPatientsPerMonthQ6 intValue] == 0) ? @"" : [[self remicadeInfusion].avgNewPatientsPerMonthQ6 stringValue];
    NSString* avgNewQ8String = ([[self remicadeInfusion].avgNewPatientsPerMonthQ8 intValue] == 0) ? @"" : [[self remicadeInfusion].avgNewPatientsPerMonthQ8 stringValue];
    [_averageInfusionsPerMonthTextField setText:avgInfusionsPerMonthString];
    [_averageNewPatientsPerMonthQ6TextField setText:avgNewQ6String];
    [_averageNewPatientsPerMonthQ8TextField setText:avgNewQ8String];
    
    //Set step time fields
    //Times
    [self updateStepTimes];
    //Step time ancillary
    [self updateAncillarySelections];
    
    //Set Treatment Duration fields
    //Duration buttons
    [self updateTreatmentDurationPercentages];
    //Treatments/month labels
    [self updateDurationTreatmentsPerMonthLabels];
    //InfusionAdmins labels
    [self updateDurationInfusionAdminMinLabels];
    //Total duration percentage label
}

- (void)updateStepTimes
{
    [_preInfusionTimeButton setTitle:[NSString stringWithFormat:@"%i", [[self remicadeInfusion].prepTime intValue] * 10] forState:UIControlStateNormal];
    [_postInfusionTimeButton setTitle:[NSString stringWithFormat:@"%i", [[self remicadeInfusion].postTime intValue] * 10] forState:UIControlStateNormal];
    [_infusionAdminTimeLabel setText:[NSString stringWithFormat:@"%i", 120]];
    
    if ([[self remicadeInfusion] infusionAdministrationTime] >= 12) {
        [_infusionAdminTimeLabel setTextColor:[Colors getInstance].darkGrayColor];
    } else {
        [_infusionAdminTimeLabel setTextColor:[Colors getInstance].redColor];
    }
}

- (void)updateAncillarySelections
{
    [_preInfusionAncillarySwitch setOn:[[self remicadeInfusion].prepAncillary boolValue]];
    [_postInfusionAncillarySwitch setOn:[[self remicadeInfusion].postAncillary boolValue]];
}

- (void)updateTreatmentDurationPercentages
{
    [_rem2HrPercentageButton setTitle:[NSString stringWithFormat:@"%i", [[self remicadeInfusion].percent2hr intValue]] forState:UIControlStateNormal];
    [_rem25HrPercentageButton setTitle:[NSString stringWithFormat:@"%i", [[self remicadeInfusion].percent2_5hr intValue]] forState:UIControlStateNormal];
    [_rem3HrPercentageButton setTitle:[NSString stringWithFormat:@"%i", [[self remicadeInfusion].percent3hr intValue]] forState:UIControlStateNormal];
    [_rem35HrPercentageButton setTitle:[NSString stringWithFormat:@"%i", [[self remicadeInfusion].percent3_5hr intValue]] forState:UIControlStateNormal];
    [_rem4HrPercentageButton setTitle:[NSString stringWithFormat:@"%i", [[self remicadeInfusion].percent4hr intValue]] forState:UIControlStateNormal];
    
    [_totalDurationPercentageLabel setText:[NSString stringWithFormat:@"%i%%", [[self remicadeInfusion] totalTreatmentDistributionPercentages]]];
    if([[self remicadeInfusion] totalTreatmentDistributionPercentages] != 100){
        [_totalDurationPercentageLabel setTextColor:[Colors getInstance].redColor];
    }else{
        [_totalDurationPercentageLabel setTextColor:[Colors getInstance].lightBlueColor];
    }
}

- (void)updateDurationTreatmentsPerMonthLabels
{
    int avgTreatmentsPerMonth = [[self remicadeInfusion].avgInfusionsPerMonth intValue];
    [_rem2HrTreatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [[self remicadeInfusion] numberPerMonth:avgTreatmentsPerMonth byPercentage:[[self remicadeInfusion].percent2hr intValue]]]];
    
    [_rem25HrTreatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [[self remicadeInfusion] numberPerMonth:avgTreatmentsPerMonth byPercentage:[[self remicadeInfusion].percent2_5hr intValue]]]];
    
    [_rem3HrTreatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [[self remicadeInfusion] numberPerMonth:avgTreatmentsPerMonth byPercentage:[[self remicadeInfusion].percent3hr intValue]]]];
    
    [_rem35HrTreatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [[self remicadeInfusion] numberPerMonth:avgTreatmentsPerMonth byPercentage:[[self remicadeInfusion].percent3_5hr intValue]]]];
    
    [_rem4HrTreatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", [[self remicadeInfusion] numberPerMonth:avgTreatmentsPerMonth byPercentage:[[self remicadeInfusion].percent4hr intValue]]]];
}

- (void)updateDurationInfusionAdminMinLabels
{
    [_rem2HrInfusionAdminTimeLabel setText:[NSString stringWithFormat:@"%i", [[self remicadeInfusion] infusionMakeTime2HR] * 10]];
    [_rem25HrInfusionAdminTimeLabel setText:[NSString stringWithFormat:@"%i", [[self remicadeInfusion] infusionMakeTime2_5HR] * 10]];
    [_rem3HrInfusionAdminTimeLabel setText:[NSString stringWithFormat:@"%i", [[self remicadeInfusion] infusionMakeTime3HR] * 10]];
    [_rem35HrInfusionAdminTimeLabel setText:[NSString stringWithFormat:@"%i", [[self remicadeInfusion] infusionMakeTime3_5HR] * 10]];
    [_rem4HrInfusionAdminTimeLabel setText:[NSString stringWithFormat:@"%i", [[self remicadeInfusion] infusionMakeTime4HR] * 10]];
}

#pragma mark - IBActions
- (IBAction)prepStepTimeButtonSelected:(id)sender
{
    [self showDropdownPopoverFromSender:sender withDataSource:_prepStepTimeDropdownDataSource];
}

- (IBAction)postStepTimeButtonSelected:(id)sender
{
    [self showDropdownPopoverFromSender:sender withDataSource:_postStepTimeDropdownDataSource];
}

- (IBAction)percentagesButtonSelected:(id)sender
{
    [self showDropdownPopoverFromSender:sender withDataSource:_percentagesDropdownDataSource];
}

- (IBAction)stepTimesClearButtonSelected:(id)sender
{
    [self remicadeInfusion].prepTime = [NSNumber numberWithInt:DEFAULT_REM3HR_PREP1_TIME + DEFAULT_REM3HR_PREP2_TIME];
    [self remicadeInfusion].postTime = [NSNumber numberWithInt:DEFAULT_REM3HR_PREP1_TIME + DEFAULT_REM3HR_PREP2_TIME];
    [self remicadeInfusion].prepAncillary = [NSNumber numberWithBool:NO];
    [self remicadeInfusion].postAncillary = [NSNumber numberWithBool:NO];
    
    [self updateStepTimes];
    [self updateDurationInfusionAdminMinLabels];
    [self updateAncillarySelections];
}

- (IBAction)treatmentDurationClearButtonSelected:(id)sender
{
    [self remicadeInfusion].percent2hr = @0;
    [self remicadeInfusion].percent2_5hr = @0;
    [self remicadeInfusion].percent3hr = @100;
    [self remicadeInfusion].percent3_5hr = @0;
    [self remicadeInfusion].percent4hr = @0;
    
    [self updateTreatmentDurationPercentages];
    [self updateDurationTreatmentsPerMonthLabels];
}

- (IBAction)ancillarySwitchChanged:(id)sender
{
    if(sender == _preInfusionAncillarySwitch){
        [self remicadeInfusion].prepAncillary = [NSNumber numberWithBool:_preInfusionAncillarySwitch.isOn];
    }else if(sender == _postInfusionAncillarySwitch){
        [self remicadeInfusion].postAncillary = [NSNumber numberWithBool:_postInfusionAncillarySwitch.isOn];
    }
}

- (IBAction)openSuggestedClinicalPathwayDocument:(id)sender
{
    
    [self performSegueWithIdentifier:@"ShowPDF" sender:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPDF" object:nil userInfo:@{@"showPDFType":[NSNumber numberWithInt:3]}];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGPoint contentOffset = CGPointMake(0, sender.contentOffset.y);
    sender.contentOffset = contentOffset;
}

#pragma mark - UITextFieldDelegate Protocol Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //Text fields should only contain numbers and be no longer than 3 characters
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if([newString rangeOfCharacterFromSet:nonDigits].location != NSNotFound){
        return NO;
    }else if([newString length] > 3){
        return NO;
    }
    
    if (newString.length == 0) {
        return YES;
    }
    
    NSString* removeLeadingZeros = [[NSNumber numberWithInt:[newString intValue]] stringValue];
    [textField setText:removeLeadingZeros];
    
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _averageInfusionsPerMonthTextField){
        [self remicadeInfusion].avgInfusionsPerMonth = [NSNumber numberWithInt:[textField.text intValue]];
        [self updateDurationTreatmentsPerMonthLabels];
    }else if(textField == _averageNewPatientsPerMonthQ6TextField){
        [self remicadeInfusion].avgNewPatientsPerMonthQ6 = [NSNumber numberWithInt:[textField.text intValue]];
    }else if(textField == _averageNewPatientsPerMonthQ8TextField){
        [self remicadeInfusion].avgNewPatientsPerMonthQ8 = [NSNumber numberWithInt:[textField.text intValue]];
    }
}

#pragma mark - Dropdowns
- (void)createDropdownDataSources
{
    _percentagesDropdownDataSource = [[DropdownDataSource alloc]
                                      initWithItems:LIST_VALUES_ARRAY_TREATMENT_DURATION_PERCENTAGES
                                      andTitleForItemBlock:^ NSString *(id item){
                                          return [NSString stringWithFormat:@"%i", [item intValue]];
                                      }];
    
    _prepStepTimeDropdownDataSource = [[DropdownDataSource alloc]
                                      initWithItems:LIST_VALUES_ARRAY_REM_PREP_TIME
                                       andTitleForItemBlock:^ NSString *(id item){
                                           return [NSString stringWithFormat:@"%i", [item intValue] * 10];
                                      }];
    
    _postStepTimeDropdownDataSource = [[DropdownDataSource alloc]
                                      initWithItems:LIST_VALUES_ARRAY_REM_POST_TIME
                                       andTitleForItemBlock:^ NSString *(id item){
                                           return [NSString stringWithFormat:@"%i", [item intValue] * 10];
                                      }];
}

- (void)showDropdownPopoverFromSender:(id)sender withDataSource:(DropdownDataSource*)dataSource
{
    _selectedDropdownButton = sender;
    CGRect fromRect = (_selectedDropdownButton != nil) ? _selectedDropdownButton.frame : CGRectMake(0, 0, 1, 1);
    
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
    [_dropdownPopoverController presentPopoverFromRect:fromRect inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)dropdown:(DropdownController *)dropdown item:(id)item selectedAtIndex:(int)index fromDataSource:(DropdownDataSource *)dataSource
{
    if(dataSource == _prepStepTimeDropdownDataSource){
        //Set new preptime
        [self remicadeInfusion].prepTime = [NSNumber numberWithInt:[item intValue]];
        [self updateStepTimes];
        [self updateDurationInfusionAdminMinLabels];
        
        [self showError];
    }else if(dataSource == _postStepTimeDropdownDataSource){
        [self remicadeInfusion].postTime = [NSNumber numberWithInt:[item intValue]];
        [self updateStepTimes];
        [self updateDurationInfusionAdminMinLabels];
        
        [self showError];
    }else if(dataSource == _percentagesDropdownDataSource){
        if(_selectedDropdownButton == _rem2HrPercentageButton){
            [self remicadeInfusion].percent2hr = [NSNumber numberWithInt:[item intValue]];
        }else if(_selectedDropdownButton == _rem25HrPercentageButton){
            [self remicadeInfusion].percent2_5hr = [NSNumber numberWithInt:[item intValue]];
        }else if(_selectedDropdownButton == _rem3HrPercentageButton){
            [self remicadeInfusion].percent3hr = [NSNumber numberWithInt:[item intValue]];
        }else if(_selectedDropdownButton == _rem35HrPercentageButton){
            [self remicadeInfusion].percent3_5hr = [NSNumber numberWithInt:[item intValue]];
        }else if(_selectedDropdownButton == _rem4HrPercentageButton){
            [self remicadeInfusion].percent4hr = [NSNumber numberWithInt:[item intValue]];
        }
        
        [self updateTreatmentDurationPercentages];
        [self updateDurationTreatmentsPerMonthLabels];
    }
    
    [_dropdownPopoverController dismissPopoverAnimated:YES];
    _dropdownPopoverController = nil;
}

#pragma mark - ChildViewController Methods
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil) {
        //removed
    } else {
        //Added
    }
}

#pragma mark - PresentationForm Protocol Methods
- (BOOL)isInputDataValid
{
    BOOL percentsEqual100 = ([[self remicadeInfusion] totalTreatmentDistributionPercentages] == 100);
    
    BOOL infusionIs120OrGreater = ([[self remicadeInfusion] infusionAdministrationTime] >= 12);
    return percentsEqual100 && infusionIs120OrGreater;
}

- (void)willSavePresentation
{
    
}

- (void)showError
{
    BOOL percentsEqual100 = ([[self remicadeInfusion] totalTreatmentDistributionPercentages] == 100);
    BOOL infusionIs120OrGreater = ([[self remicadeInfusion] infusionAdministrationTime] >= 12);
    
    if (!infusionIs120OrGreater) {
        [[[UIAlertView alloc] initWithTitle:@"Input Error" message:@"Remicade infusion administration time cannot be less than 120 minutes." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    } else if (!percentsEqual100) {
        [[[UIAlertView alloc] initWithTitle:@"Input Error" message:@"Remicade infusion treatment duration percentages do not equal 100%" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

-(NSString*)analyticsIdentifier
{
    return @"remicade_infusion";
}

@end
