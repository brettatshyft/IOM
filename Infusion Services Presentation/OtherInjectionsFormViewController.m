//
//  OtherInjectionsFormViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/13/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "OtherInjectionsFormViewController.h"
#import "Constants.h"
#import "Scenario+Extension.h"
#import "OtherInjection+Extension.h"
#import "IOMAnalyticsManager.h"
#import "DropdownDataSource.h"
#import "ListValues.h"
#import "DropdownController.h"

@interface OtherInjectionsFormViewController ()<IOMAnalyticsIdentifiable, DropdownDelegate>{
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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel* treatmentsPerMonthLabel;


@property (nonatomic, weak) IBOutlet UITextField* injection1TreatmentsTextField;
@property (nonatomic, weak) IBOutlet UITextField* injection2TreatmentsTextField;
@property (weak, nonatomic) IBOutlet UITextField *injection3TreatmentsTextField;
@property (weak, nonatomic) IBOutlet UITextField *injection4TreatmentsTextField;
@property (weak, nonatomic) IBOutlet UITextField *injection5TreatmentsTextField;
@property (weak, nonatomic) IBOutlet UITextField *injection6TreatmentsTextField;
@property (weak, nonatomic) IBOutlet UITextField *injection7TreatmentsTextField;

@property (nonatomic, weak) IBOutlet UILabel* injection1TotalTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* injection2TotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection3TotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection4TotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection5TotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection6TotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *injection7TotalTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *injection1FrequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *injection2FrequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *injection3FrequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *injection4FrequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *injection5FrequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *injection6FrequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *injection7FrequencyButton;


@end

@implementation OtherInjectionsFormViewController
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
    
    self.textFieldArray = @[_injection1TreatmentsTextField, _injection2TreatmentsTextField, _injection3TreatmentsTextField, _injection4TreatmentsTextField, _injection5TreatmentsTextField];
    
    _otherInjection1 = [OtherInjection getOtherInjectionOfType:OtherInjectionType1 forScenario:_scenario];
    _otherInjection2 = [OtherInjection getOtherInjectionOfType:OtherInjectionType2 forScenario:_scenario];
    _otherInjection3 = [OtherInjection getOtherInjectionOfType:OtherInjectionType3 forScenario:_scenario];
    _otherInjection4 = [OtherInjection getOtherInjectionOfType:OtherInjectionType4 forScenario:_scenario];
    _otherInjection5 = [OtherInjection getOtherInjectionOfType:OtherInjectionType5 forScenario:_scenario];
    _otherInjection6 = [OtherInjection getOtherInjectionOfType:OtherInjectionType6 forScenario:_scenario];
    _otherInjection7 = [OtherInjection getOtherInjectionOfType:OtherInjectionType7 forScenario:_scenario];
    
    _scrollView.scrollEnabled=FALSE;
    //_scrollView.contentSize = CGSizeMake(1, 1);
    
    [self initializeInputData];
    [self initializeDropDownDataSource];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeDropDownDataSource{
    _injectionFrequencyDataSoure = [[DropdownDataSource alloc] initWithItems:LIST_VALUES_ARRAY_INJECTION_FREQUENCY andTitleForItemBlock:^NSString *(id item) {
        return item;
    }];
}

- (void)initializeInputData
{
    //Assign data to views from data model
    [_injection1TotalTimeLabel setText:[NSString stringWithFormat:@"%g",DEFAULT_INJECTION1_PREP1_TIME*10]];
    [_injection2TotalTimeLabel setText:[NSString stringWithFormat:@"%g",DEFAULT_INJECTION2_PREP1_TIME*10]];
    [_injection3TotalTimeLabel setText:[NSString stringWithFormat:@"%g",DEFAULT_INJECTION3_PREP1_TIME*10]];
    [_injection4TotalTimeLabel setText:[NSString stringWithFormat:@"%g",DEFAULT_INJECTION4_PREP1_TIME*10]];
    [_injection5TotalTimeLabel setText:[NSString stringWithFormat:@"%g",DEFAULT_INJECTION5_PREP1_TIME*10]];
    [_injection6TotalTimeLabel setText:[NSString stringWithFormat:@"%g",DEFAULT_INJECTION6_PREP1_TIME*10]];
    [_injection7TotalTimeLabel setText:[NSString stringWithFormat:@"%g",DEFAULT_INJECTION7_PREP1_TIME*10]];
    
    NSNumber* inj1Treatments = _otherInjection1.treatments;
    NSNumber* inj2Treatments = _otherInjection2.treatments;
    NSNumber* inj3Treatments = _otherInjection3.treatments;
    NSNumber* inj4Treatments = _otherInjection4.treatments;
    NSNumber* inj5Treatments = _otherInjection5.treatments;
    NSNumber* inj6Treatments = _otherInjection6.treatments;
    NSNumber* inj7Treatments = _otherInjection7.treatments;
    
    [_injection1TreatmentsTextField setText:[NSString stringWithFormat:@"%li", [inj1Treatments integerValue]]];
    [_injection2TreatmentsTextField setText:[NSString stringWithFormat:@"%li", [inj2Treatments integerValue]]];
    [_injection3TreatmentsTextField setText:[NSString stringWithFormat:@"%li", [inj3Treatments integerValue]]];
    [_injection4TreatmentsTextField setText:[NSString stringWithFormat:@"%li", [inj4Treatments integerValue]]];
    [_injection5TreatmentsTextField setText:[NSString stringWithFormat:@"%li", [inj5Treatments integerValue]]];
    [_injection6TreatmentsTextField setText:[NSString stringWithFormat:@"%li", [inj6Treatments integerValue]]];
    [_injection7TreatmentsTextField setText:[NSString stringWithFormat:@"%li", [inj7Treatments integerValue]]];
    
    [self updateTreatmentsPerMonthLabel];
    
    NSString* inj1Frequency = _otherInjection1.frequency;
    NSString* inj2Frequency = _otherInjection2.frequency;
    NSString* inj3Frequency = _otherInjection3.frequency;
    NSString* inj4Frequency = _otherInjection4.frequency;
    NSString* inj5Frequency = _otherInjection5.frequency;
    NSString* inj6Frequency = _otherInjection6.frequency;
    NSString* inj7Frequency = _otherInjection7.frequency;
    
    [_injection1FrequencyButton setTitle:inj1Frequency forState:UIControlStateNormal];
    [_injection2FrequencyButton setTitle:inj2Frequency forState:UIControlStateNormal];
    [_injection3FrequencyButton setTitle:inj3Frequency forState:UIControlStateNormal];
    [_injection4FrequencyButton setTitle:inj4Frequency forState:UIControlStateNormal];
    [_injection5FrequencyButton setTitle:inj5Frequency forState:UIControlStateNormal];
    [_injection6FrequencyButton setTitle:inj6Frequency forState:UIControlStateNormal];
    [_injection7FrequencyButton setTitle:inj7Frequency forState:UIControlStateNormal];
    
}

- (void)updateTreatmentsPerMonthLabel
{
    NSNumber* inj1Treatments = _otherInjection1.treatmentsPerMonth;
    NSNumber* inj2Treatments = _otherInjection2.treatmentsPerMonth;
    NSNumber* inj3Treatments = _otherInjection3.treatmentsPerMonth;
    NSNumber* inj4Treatments = _otherInjection4.treatmentsPerMonth;
    NSNumber* inj5Treatments = _otherInjection5.treatmentsPerMonth;
    NSNumber* inj6Treatments = _otherInjection6.treatmentsPerMonth;
    NSNumber* inj7Treatments = _otherInjection7.treatmentsPerMonth;
    
    NSNumber* totalTreatments = [NSNumber numberWithDouble: ([inj1Treatments doubleValue] + [inj2Treatments doubleValue] + [inj3Treatments doubleValue] + [inj4Treatments doubleValue] + [inj5Treatments doubleValue] + [inj6Treatments doubleValue] + [inj7Treatments doubleValue])];
    
    [_treatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%.02f", [totalTreatments doubleValue]]];
}

#pragma mark - UITextField Delegate Methods
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
    if(textField == _injection1TreatmentsTextField){
        _otherInjection1.treatments = [NSNumber numberWithInteger:[textField.text integerValue]];
    }else if(textField == _injection2TreatmentsTextField){
        _otherInjection2.treatments = [NSNumber numberWithInteger:[textField.text integerValue]];
    }else if(textField == _injection3TreatmentsTextField){
        _otherInjection3.treatments = [NSNumber numberWithInteger:[textField.text integerValue]];
    }else if(textField == _injection4TreatmentsTextField){
        _otherInjection4.treatments = [NSNumber numberWithInteger:[textField.text integerValue]];
    }else if(textField == _injection5TreatmentsTextField){
        _otherInjection5.treatments = [NSNumber numberWithInteger:[textField.text integerValue]];
    }else if(textField == _injection6TreatmentsTextField){
        _otherInjection6.treatments = [NSNumber numberWithInteger:[textField.text integerValue]];
    }else if(textField == _injection7TreatmentsTextField){
        _otherInjection7.treatments = [NSNumber numberWithInteger:[textField.text integerValue]];
    }
    
    [self calculateTreatments];
    [self updateTreatmentsPerMonthLabel];
}

- (void)calculateTreatments{
    [_otherInjection1 calculateTotalTreatmentsPerMonth];
    [_otherInjection2 calculateTotalTreatmentsPerMonth];
    [_otherInjection3 calculateTotalTreatmentsPerMonth];
    [_otherInjection4 calculateTotalTreatmentsPerMonth];
    [_otherInjection5 calculateTotalTreatmentsPerMonth];
    [_otherInjection6 calculateTotalTreatmentsPerMonth];
    [_otherInjection7 calculateTotalTreatmentsPerMonth];
}

- (IBAction)injectionFrequencyButtonSelected:(id)sender {
    [self showDropdownPopoverFromSender:sender withDataSource:_injectionFrequencyDataSoure];
}

- (void)showDropdownPopoverFromSender:(id)sender withDataSource:(DropdownDataSource*)dataSource
{
    _selectedDropdownButton = sender;
    CGRect tempFrame = _selectedDropdownButton.frame;
    tempFrame.origin.x = 70 + 490.5 + _selectedDropdownButton.frame.origin.x;
    tempFrame.origin.y = 91 + _selectedDropdownButton.frame.origin.y;
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
    
    [self calculateTreatments];
    [self updateTreatmentsPerMonthLabel];
    
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
    return YES;
}

- (void)willSavePresentation
{
    
}

- (void)showError
{
    
}

-(NSString*)analyticsIdentifier
{
    return @"other_injections_form";
}

@end
