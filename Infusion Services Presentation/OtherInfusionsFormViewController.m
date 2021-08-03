//
//  OtherInfusionsFormViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/13/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "OtherInfusionsFormViewController.h"
#import "Constants.h"
#import "ListValues.h"
#import "Scenario+Extension.h"
#import "OtherInfusion+Extension.h"
#import "DropdownDataSource.h"
#import "DropdownController.h"
#import "IOMAnalyticsManager.h"

@interface OtherInfusionsFormViewController ()<IOMAnalyticsIdentifiable>{
    DropdownDataSource* _preInfusionDropdownDataSource;
    DropdownDataSource* _infusionAdminDropdownDataSource;
    DropdownDataSource* _postInfusionDropdownDataSource;
    DropdownDataSource* _weeksBetweenDropdownDataSource;
    
    UIPopoverController* _dropdownPopoverController;
    
    UIButton* _selectedDropdownButton;
    OtherInfusion* _otherInfusionRxA;
    OtherInfusion* _otherInfusionRxB;
    OtherInfusion* _otherInfusionRxC;
    OtherInfusion* _otherInfusionRxD;
    OtherInfusion* _otherInfusionRxE;
    OtherInfusion* _otherInfusionRxF;
    OtherInfusion* _otherInfusionRxG;
    OtherInfusion* _otherInfusionRxH;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end



@implementation OtherInfusionsFormViewController



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
    
    [_scrollView setScrollEnabled:FALSE];
    
    //Array of textfields for keyboard navigation
    self.textFieldArray = @[_treatmentsPerMonthRxATextField,
                            _rxANewPatientsPerMonthTextField,
                            _treatmentsPerMonthRxBTextField,
                            _rxBNewPatientsPerMonthTextField,
                            _treatmentsPerMonthRxCTextField,
                            _rxCNewPatientsPerMonthTextField,
                            _treatmentsPerMonthRxDTextField,
                            _rxDNewPatientsPerMonthTextField,
                            _treatmentsPerMonthRxETextField,
                            _rxENewPatientsPerMonthTextField,
                            _treatmentsPerMonthRxFTextField,
                            _rxFNewPatientsPerMonthTextField,
                            _treatmentsPerMonthRxGTextField,
                            _rxGNewPatientsPerMonthTextField,
                            _treatmentsPerMonthRxHTextField,
                            _rxHNewPatientsPerMonthTextField];
    
    //Create datasources for dropdowns
    [self createDropdownDataSources];
    
    //Display model data in views
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

- (void)initializeInputData
{
    //Get infusions of type
    _otherInfusionRxA = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxA forScenario:_scenario];
    _otherInfusionRxB = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxB forScenario:_scenario];
    _otherInfusionRxC = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxC forScenario:_scenario];
    _otherInfusionRxD = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxD forScenario:_scenario];
    _otherInfusionRxE = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxE forScenario:_scenario];
    _otherInfusionRxF = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxF forScenario:_scenario];
    _otherInfusionRxG = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxG forScenario:_scenario];
    _otherInfusionRxH = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxH forScenario:_scenario];
    
    //Treatments/month inputs
    [_treatmentsPerMonthRxATextField setText:([_otherInfusionRxA.treatmentsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxA.treatmentsPerMonth intValue]]];
    [_treatmentsPerMonthRxBTextField setText:([_otherInfusionRxB.treatmentsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxB.treatmentsPerMonth intValue]]];
    [_treatmentsPerMonthRxCTextField setText:([_otherInfusionRxC.treatmentsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxC.treatmentsPerMonth intValue]]];
    [_treatmentsPerMonthRxDTextField setText:([_otherInfusionRxD.treatmentsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxD.treatmentsPerMonth intValue]]];
    [_treatmentsPerMonthRxETextField setText:([_otherInfusionRxE.treatmentsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxE.treatmentsPerMonth intValue]]];
    [_treatmentsPerMonthRxFTextField setText:([_otherInfusionRxF.treatmentsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxF.treatmentsPerMonth intValue]]];
    [_treatmentsPerMonthRxGTextField setText:([_otherInfusionRxG.treatmentsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxG.treatmentsPerMonth intValue]]];
    [_treatmentsPerMonthRxHTextField setText:([_otherInfusionRxH.treatmentsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxH.treatmentsPerMonth intValue]]];
    
    //New Patients/Month inputs
    [_rxANewPatientsPerMonthTextField setText:([_otherInfusionRxA.avgNewPatientsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxA.avgNewPatientsPerMonth intValue]]];
    [_rxBNewPatientsPerMonthTextField setText:([_otherInfusionRxB.avgNewPatientsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxB.avgNewPatientsPerMonth intValue]]];
    [_rxCNewPatientsPerMonthTextField setText:([_otherInfusionRxC.avgNewPatientsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxC.avgNewPatientsPerMonth intValue]]];
    [_rxDNewPatientsPerMonthTextField setText:([_otherInfusionRxD.avgNewPatientsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxD.avgNewPatientsPerMonth intValue]]];
    [_rxENewPatientsPerMonthTextField setText:([_otherInfusionRxE.avgNewPatientsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxE.avgNewPatientsPerMonth intValue]]];
    [_rxFNewPatientsPerMonthTextField setText:([_otherInfusionRxF.avgNewPatientsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxF.avgNewPatientsPerMonth intValue]]];
    [_rxGNewPatientsPerMonthTextField setText:([_otherInfusionRxG.avgNewPatientsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxG.avgNewPatientsPerMonth intValue]]];
    [_rxHNewPatientsPerMonthTextField setText:([_otherInfusionRxH.avgNewPatientsPerMonth intValue] == 0) ? @"" : [NSString stringWithFormat:@"%i", [_otherInfusionRxH.avgNewPatientsPerMonth intValue]]];
    
    [_preInfusionTimeRxAButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxA.prepTime intValue] *10] forState:UIControlStateNormal];
    [_preInfusionTimeRxBButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxB.prepTime intValue] *10] forState:UIControlStateNormal];
    [_preInfusionTimeRxCButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxC.prepTime intValue] *10] forState:UIControlStateNormal];
    [_preInfusionTimeRxDButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxD.prepTime intValue] *10] forState:UIControlStateNormal];
    [_preInfusionTimeRxEButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxE.prepTime intValue] *10] forState:UIControlStateNormal];
    [_preInfusionTimeRxFButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxF.prepTime intValue] *10] forState:UIControlStateNormal];
    [_preInfusionTimeRxGButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxG.prepTime intValue] *10] forState:UIControlStateNormal];
    [_preInfusionTimeRxHButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxH.prepTime intValue] *10] forState:UIControlStateNormal];
    
    [_infusionAdminTimeRxAButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxA.infusionTime intValue] *10] forState:UIControlStateNormal];
    [_infusionAdminTimeRxBButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxB.infusionTime intValue] *10] forState:UIControlStateNormal];
    [_infusionAdminTimeRxCButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxC.infusionTime intValue] *10] forState:UIControlStateNormal];
    [_infusionAdminTimeRxDButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxD.infusionTime intValue] *10] forState:UIControlStateNormal];
    [_infusionAdminTimeRxEButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxE.infusionTime intValue] *10] forState:UIControlStateNormal];
    [_infusionAdminTimeRxFButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxF.infusionTime intValue] *10] forState:UIControlStateNormal];
    [_infusionAdminTimeRxGButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxG.infusionTime intValue] *10] forState:UIControlStateNormal];
    [_infusionAdminTimeRxHButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxH.infusionTime intValue] *10] forState:UIControlStateNormal];
    
    [_postInfusionTimeRxAButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxA.postTime intValue] *10] forState:UIControlStateNormal];
    [_postInfusionTimeRxBButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxB.postTime intValue] *10] forState:UIControlStateNormal];
    [_postInfusionTimeRxCButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxC.postTime intValue] *10] forState:UIControlStateNormal];
    [_postInfusionTimeRxDButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxD.postTime intValue] *10] forState:UIControlStateNormal];
    [_postInfusionTimeRxEButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxE.postTime intValue] *10] forState:UIControlStateNormal];
    [_postInfusionTimeRxFButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxF.postTime intValue] *10] forState:UIControlStateNormal];
    [_postInfusionTimeRxGButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxG.postTime intValue] *10] forState:UIControlStateNormal];
    [_postInfusionTimeRxHButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxH.postTime intValue] *10] forState:UIControlStateNormal];
    
    [_weeksBetweenRxAButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxA.weeksBetween intValue]] forState:UIControlStateNormal];
    [_weeksBetweenRxBButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxB.weeksBetween intValue]] forState:UIControlStateNormal];
    [_weeksBetweenRxCButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxC.weeksBetween intValue]] forState:UIControlStateNormal];
    [_weeksBetweenRxDButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxD.weeksBetween intValue]] forState:UIControlStateNormal];
    [_weeksBetweenRxEButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxE.weeksBetween intValue]] forState:UIControlStateNormal];
    [_weeksBetweenRxFButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxF.weeksBetween intValue]] forState:UIControlStateNormal];
    [_weeksBetweenRxGButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxG.weeksBetween intValue]] forState:UIControlStateNormal];
    [_weeksBetweenRxHButton setTitle:[NSString stringWithFormat:@"%i", [_otherInfusionRxH.weeksBetween intValue]] forState:UIControlStateNormal];
    
    [self refreshTotalTimes];
    [self updateTotalTreatmentsPerMonthLabel];
}

- (void)refreshTotalTimes
{
    int totalTimeRxA = ([_otherInfusionRxA.prepTime intValue] + [_otherInfusionRxA.postTime intValue] + [_otherInfusionRxA.infusionTime intValue]) *10;
    int totalTimeRxB = ([_otherInfusionRxB.prepTime intValue] + [_otherInfusionRxB.postTime intValue] + [_otherInfusionRxB.infusionTime intValue]) *10;
    int totalTimeRxC = ([_otherInfusionRxC.prepTime intValue] + [_otherInfusionRxC.postTime intValue] + [_otherInfusionRxC.infusionTime intValue]) *10;
    int totalTimeRxD = ([_otherInfusionRxD.prepTime intValue] + [_otherInfusionRxD.postTime intValue] + [_otherInfusionRxD.infusionTime intValue]) *10;
    int totalTimeRxE = ([_otherInfusionRxE.prepTime intValue] + [_otherInfusionRxE.postTime intValue] + [_otherInfusionRxE.infusionTime intValue]) *10;
    int totalTimeRxF = ([_otherInfusionRxF.prepTime intValue] + [_otherInfusionRxF.postTime intValue] + [_otherInfusionRxF.infusionTime intValue]) *10;
    int totalTimeRxG = ([_otherInfusionRxG.prepTime intValue] + [_otherInfusionRxG.postTime intValue] + [_otherInfusionRxG.infusionTime intValue]) *10;
    int totalTimeRxH = ([_otherInfusionRxH.prepTime intValue] + [_otherInfusionRxH.postTime intValue] + [_otherInfusionRxH.infusionTime intValue]) *10;
    
    [_totalTimeRxALabel setText:[NSString stringWithFormat:@"%i", totalTimeRxA]];
    [_totalTimeRxBLabel setText:[NSString stringWithFormat:@"%i", totalTimeRxB]];
    [_totalTimeRxCLabel setText:[NSString stringWithFormat:@"%i", totalTimeRxC]];
    [_totalTimeRxDLabel setText:[NSString stringWithFormat:@"%i", totalTimeRxD]];
    [_totalTimeRxELabel setText:[NSString stringWithFormat:@"%i", totalTimeRxE]];
    [_totalTimeRxFLabel setText:[NSString stringWithFormat:@"%i", totalTimeRxF]];
    [_totalTimeRxGLabel setText:[NSString stringWithFormat:@"%i", totalTimeRxG]];
    [_totalTimeRxHLabel setText:[NSString stringWithFormat:@"%i", totalTimeRxH]];
}

- (void)updateTotalTreatmentsPerMonthLabel
{
    int totalTreatmentsPerMonth = [_otherInfusionRxA.treatmentsPerMonth intValue] + [_otherInfusionRxB.treatmentsPerMonth intValue] + [_otherInfusionRxC.treatmentsPerMonth intValue] + [_otherInfusionRxD.treatmentsPerMonth intValue] + [_otherInfusionRxE.treatmentsPerMonth intValue] + [_otherInfusionRxF.treatmentsPerMonth intValue] + [_otherInfusionRxG.treatmentsPerMonth intValue] + [_otherInfusionRxH.treatmentsPerMonth intValue];
    [_treatmentsPerMonthLabel setText:[NSString stringWithFormat:@"%i", totalTreatmentsPerMonth]];
}

- (void)createDropdownDataSources
{
    _preInfusionDropdownDataSource = [[DropdownDataSource alloc] initWithItems:LIST_VALUES_ARRAY_RX_PREP_TIME
                                                          andTitleForItemBlock:^ NSString* (id item){
                                                              return [NSString stringWithFormat:@"%i", [item intValue] *10];
                                                          }];
    
    _infusionAdminDropdownDataSource = [[DropdownDataSource alloc] initWithItems:LIST_VALUES_ARRAY_RX_INFUSION_TIME
                                                          andTitleForItemBlock:^ NSString* (id item){
                                                              return [NSString stringWithFormat:@"%i", [item intValue] *10];
                                                          }];
    
    _postInfusionDropdownDataSource = [[DropdownDataSource alloc] initWithItems:LIST_VALUES_ARRAY_RX_POST_TIME
                                                          andTitleForItemBlock:^ NSString* (id item){
                                                              return [NSString stringWithFormat:@"%i", [item intValue] *10];
                                                          }];
    
    _weeksBetweenDropdownDataSource = [[DropdownDataSource alloc] initWithItems:LIST_VALUES_ARRAY_RX_WEEKS_BETWEEN
                                                          andTitleForItemBlock:^ NSString* (id item){
                                                              return [NSString stringWithFormat:@"%i", [item intValue]];
                                                          }];
}

#pragma mark - IBActions
- (IBAction)preInfusionTimeButtonSelected:(id)sender
{
    [self showDropdownPopoverFromSender:sender withDataSource:_preInfusionDropdownDataSource];
}

- (IBAction)infusionAdminTimeButtonSelected:(id)sender
{
    [self showDropdownPopoverFromSender:sender withDataSource:_infusionAdminDropdownDataSource];
}

- (IBAction)postInfusionTimeButtonSelected:(id)sender
{
    [self showDropdownPopoverFromSender:sender withDataSource:_postInfusionDropdownDataSource];
}

- (IBAction)weeksBetweenButtonSelected:(id)sender
{
    [self showDropdownPopoverFromSender:sender withDataSource:_weeksBetweenDropdownDataSource];
}

- (void)showDropdownPopoverFromSender:(id)sender withDataSource:(DropdownDataSource*)dataSource
{
    _selectedDropdownButton = sender;
    CGRect fromRect = _selectedDropdownButton ? _selectedDropdownButton.frame : CGRectMake(0, 0, 1, 1);
    
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
    OtherInfusion* otherInfusion = [self getOtherInfusionForCorrespongingTextField:textField];
    NSString* key = [self getOtherInfusionAttributeKeyForCorrespondingTextField:textField];
    if(otherInfusion && key){
        [otherInfusion setValue:[NSNumber numberWithInt:[textField.text intValue]] forKey:key];
    }else{
        NSLog(@"%@ - Error: Failed to get correct otherInfusion or key. OtherInfusion: %@, Key: %@", NSStringFromSelector(_cmd), otherInfusion, key);
    }
    
    [self updateTotalTreatmentsPerMonthLabel];
}

- (OtherInfusion*)getOtherInfusionForCorrespongingTextField:(UITextField*)textField
{
    if(textField == _treatmentsPerMonthRxATextField || textField == _rxANewPatientsPerMonthTextField){
        return _otherInfusionRxA;
    }else if(textField == _treatmentsPerMonthRxBTextField || textField == _rxBNewPatientsPerMonthTextField){
        return _otherInfusionRxB;
    }else if(textField == _treatmentsPerMonthRxCTextField || textField == _rxCNewPatientsPerMonthTextField){
        return _otherInfusionRxC;
    }else if(textField == _treatmentsPerMonthRxDTextField || textField == _rxDNewPatientsPerMonthTextField){
        return _otherInfusionRxD;
    }else if(textField == _treatmentsPerMonthRxETextField || textField == _rxENewPatientsPerMonthTextField){
        return _otherInfusionRxE;
    }else if(textField == _treatmentsPerMonthRxFTextField || textField == _rxFNewPatientsPerMonthTextField){
        return _otherInfusionRxF;
    }else if(textField == _treatmentsPerMonthRxGTextField || textField == _rxGNewPatientsPerMonthTextField){
        return _otherInfusionRxG;
    }else if(textField == _treatmentsPerMonthRxHTextField || textField == _rxHNewPatientsPerMonthTextField){
        return _otherInfusionRxH;
    }
        
    return nil;
}

- (NSString*)getOtherInfusionAttributeKeyForCorrespondingTextField:(UITextField*)textField
{
    if(textField == _treatmentsPerMonthRxATextField || textField == _treatmentsPerMonthRxBTextField || textField == _treatmentsPerMonthRxCTextField || textField == _treatmentsPerMonthRxDTextField || textField == _treatmentsPerMonthRxETextField || textField == _treatmentsPerMonthRxFTextField || textField == _treatmentsPerMonthRxGTextField || textField == _treatmentsPerMonthRxHTextField){
        return @"treatmentsPerMonth";
    }else if(textField == _rxANewPatientsPerMonthTextField || textField == _rxBNewPatientsPerMonthTextField || textField == _rxCNewPatientsPerMonthTextField || textField == _rxDNewPatientsPerMonthTextField || textField == _rxENewPatientsPerMonthTextField || textField == _rxFNewPatientsPerMonthTextField || textField == _rxGNewPatientsPerMonthTextField || textField == _rxHNewPatientsPerMonthTextField){
        return @"avgNewPatientsPerMonth";
    }
    return nil;
}

#pragma mark - DropdownDelegate Protocol methods
- (void)dropdown:(DropdownController*)dropdown item:(id)item selectedAtIndex:(int)index fromDataSource:(DropdownDataSource *)dataSource
{
    if(dataSource == _weeksBetweenDropdownDataSource) {
        //Set view to show selected value
        [_selectedDropdownButton setTitle:[NSString stringWithFormat:@"%i", [item intValue]] forState:UIControlStateNormal];
    } else {
        //Set view to show selected value
        [_selectedDropdownButton setTitle:[NSString stringWithFormat:@"%i", [item intValue] * 10] forState:UIControlStateNormal];
    }
    
    //Update model to new value
    OtherInfusion* otherInfusion = [self getOtherInfusionForCorrespondingDropdownButton:_selectedDropdownButton];
    NSString* key = [self getOtherInfusionAttributeKeyForCorrespondingDropdownButton:_selectedDropdownButton];
    if(otherInfusion && key){
        [otherInfusion setValue:item forKey:key];
    }else{
        NSLog(@"%@ - Error: Failed to get correct otherInfusion or key. OtherInfusion: %@, Key: %@", NSStringFromSelector(_cmd), otherInfusion, key);
    }
    
    //Dismiss popover
    [_dropdownPopoverController dismissPopoverAnimated:YES];
    _dropdownPopoverController = nil;
    _selectedDropdownButton = nil;
    
    //Refresh total times
    [self refreshTotalTimes];
}

- (OtherInfusion*)getOtherInfusionForCorrespondingDropdownButton:(UIButton*)dropdownButton
{
    if (dropdownButton == _preInfusionTimeRxAButton || dropdownButton == _postInfusionTimeRxAButton || dropdownButton == _infusionAdminTimeRxAButton || dropdownButton == _weeksBetweenRxAButton){
        return _otherInfusionRxA;
    }else if (dropdownButton == _preInfusionTimeRxBButton || dropdownButton == _postInfusionTimeRxBButton || dropdownButton == _infusionAdminTimeRxBButton || dropdownButton == _weeksBetweenRxBButton){
        return _otherInfusionRxB;
    }else if (dropdownButton == _preInfusionTimeRxCButton || dropdownButton == _postInfusionTimeRxCButton || dropdownButton == _infusionAdminTimeRxCButton || dropdownButton == _weeksBetweenRxCButton){
        return _otherInfusionRxC;
    }else if (dropdownButton == _preInfusionTimeRxDButton || dropdownButton == _postInfusionTimeRxDButton || dropdownButton == _infusionAdminTimeRxDButton || dropdownButton == _weeksBetweenRxDButton){
        return _otherInfusionRxD;
    }else if (dropdownButton == _preInfusionTimeRxEButton || dropdownButton == _postInfusionTimeRxEButton || dropdownButton == _infusionAdminTimeRxEButton || dropdownButton == _weeksBetweenRxEButton){
        return _otherInfusionRxE;
    }else if (dropdownButton == _preInfusionTimeRxFButton || dropdownButton == _postInfusionTimeRxFButton || dropdownButton == _infusionAdminTimeRxFButton || dropdownButton == _weeksBetweenRxFButton){
        return _otherInfusionRxF;
    }else if (dropdownButton == _preInfusionTimeRxGButton || dropdownButton == _postInfusionTimeRxGButton || dropdownButton == _infusionAdminTimeRxGButton || dropdownButton == _weeksBetweenRxGButton){
        return _otherInfusionRxG;
    }else if (dropdownButton == _preInfusionTimeRxHButton || dropdownButton == _postInfusionTimeRxHButton || dropdownButton == _infusionAdminTimeRxHButton || dropdownButton == _weeksBetweenRxHButton){
        return _otherInfusionRxH;
    }
    
    return nil;
}

- (NSString*)getOtherInfusionAttributeKeyForCorrespondingDropdownButton:(UIButton*)dropdownButton
{
    if(dropdownButton == _preInfusionTimeRxAButton || dropdownButton == _preInfusionTimeRxBButton || dropdownButton == _preInfusionTimeRxCButton || dropdownButton == _preInfusionTimeRxDButton || dropdownButton == _preInfusionTimeRxEButton || dropdownButton == _preInfusionTimeRxFButton || dropdownButton == _preInfusionTimeRxGButton || dropdownButton == _preInfusionTimeRxHButton){
        return @"prepTime";
    }else if(dropdownButton == _postInfusionTimeRxAButton || dropdownButton == _postInfusionTimeRxBButton || dropdownButton == _postInfusionTimeRxCButton || dropdownButton == _postInfusionTimeRxDButton || dropdownButton == _postInfusionTimeRxEButton || dropdownButton == _postInfusionTimeRxFButton || dropdownButton == _postInfusionTimeRxGButton || dropdownButton == _postInfusionTimeRxHButton){
        return @"postTime";
    }else if(dropdownButton == _infusionAdminTimeRxAButton || dropdownButton == _infusionAdminTimeRxBButton || dropdownButton == _infusionAdminTimeRxCButton || dropdownButton == _infusionAdminTimeRxDButton || dropdownButton == _infusionAdminTimeRxEButton || dropdownButton == _infusionAdminTimeRxFButton || dropdownButton == _infusionAdminTimeRxGButton || dropdownButton == _infusionAdminTimeRxHButton){
        return @"infusionTime";
    }else if(dropdownButton == _weeksBetweenRxAButton || dropdownButton == _weeksBetweenRxBButton || dropdownButton == _weeksBetweenRxCButton || dropdownButton == _weeksBetweenRxDButton || dropdownButton == _weeksBetweenRxEButton || dropdownButton == _weeksBetweenRxFButton || dropdownButton == _weeksBetweenRxGButton || dropdownButton == _weeksBetweenRxHButton){
        return @"weeksBetween";
    }else
    return nil;
}

- (void)setValue:(id)value toModelForDropdownButton:(UIButton*)dropdownButton
{
    if (dropdownButton == _preInfusionTimeRxAButton) {
        
    }else if (dropdownButton == _preInfusionTimeRxBButton){
        
    }
}

#pragma mark - UIPopoverControllerDelegate Protocol methods
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    _dropdownPopoverController = nil;
    _selectedDropdownButton = nil;
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
    return @"other_infusions_form";
}

@end
