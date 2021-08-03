//
//  StelaraInfusionViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/23/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "StelaraInfusionViewController.h"
#import "DropdownDataSource.h"
#import "DropdownController.h"
#import "ListValues.h"
#import "Constants.h"
#import "IOMAnalyticsManager.h"

@interface StelaraInfusionViewController ()<IOMAnalyticsIdentifiable>
{
    StelaraInfusion* _StelaraInfusion;
    
    DropdownDataSource* _prepTimeDropdownDataSource;
    DropdownDataSource* _postTimeDropdownDataSource;
    
    UIPopoverController* _dropdownPopoverController;
}

@property (nonatomic, weak) IBOutlet UITextField* averageInfusionsPerMonthTextField;
@property (nonatomic, weak) IBOutlet UIButton* preInfusionTimeButton;
@property (nonatomic, weak) IBOutlet UIButton* postInfusionTimeButton;
@property (nonatomic, weak) IBOutlet UISwitch* preInfusionAncillarySwitch;
@property (nonatomic, weak) IBOutlet UISwitch* postInfusionAncillarySwitch;
@property (nonatomic, weak) IBOutlet UIButton* clearButton;

@end

@implementation StelaraInfusionViewController
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
    
    //Array of textfields for keyboard navigation
    self.textFieldArray = @[_averageInfusionsPerMonthTextField];
    
    
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

- (StelaraInfusion*)StelaraInfusion
{
    if(!_StelaraInfusion){
        //Get simponi infusion model to display and modify
        _StelaraInfusion = [StelaraInfusion getStelaraInfusionForScenario:_scenario];
    }
    
    return _StelaraInfusion;
}

#pragma mark - Display Data
- (void)initializeInputData
{
    //Infusion information
    NSString* avgInfusionsPerMonthString = ([[self StelaraInfusion].avgInfusionsPerMonth intValue] == 0) ? @"" : [[self StelaraInfusion].avgInfusionsPerMonth stringValue];
    
    //Always zero as this option is an off-label use and no longer valid
//    NSString* avgNewQ6String = ([[self StelaraInfusion].avgNewPatientsPerMonth intValue] == 0) ? @"" : [[self StelaraInfusion].avgNewPatientsPerMonth stringValue];
    
    [_averageInfusionsPerMonthTextField setText:avgInfusionsPerMonthString];
    
    //Set step time inputs
    [self updateStepTimes];
    
    //Set ancillary switches
    [self updateAncillarySelections];
}

- (void)updateStepTimes
{
    [_preInfusionTimeButton setTitle:[NSString stringWithFormat:@"%i", [[self StelaraInfusion].prepTime intValue] *10] forState:UIControlStateNormal];
    [_postInfusionTimeButton setTitle:[NSString stringWithFormat:@"%i", [[self StelaraInfusion].postTime intValue] *10] forState:UIControlStateNormal];
}

- (void)updateAncillarySelections
{
    [_preInfusionAncillarySwitch setOn:[[self StelaraInfusion].prepAncillary boolValue]];
    [_postInfusionAncillarySwitch setOn:[[self StelaraInfusion].postAncillary boolValue]];
}

#pragma mark - IBActions
- (IBAction)stepTimeButtonSelected:(id)sender
{
    if(sender == _preInfusionTimeButton){
        [self showDropdownPopoverFromSender:sender withDataSource:_prepTimeDropdownDataSource];
    }else if(sender == _postInfusionTimeButton){
        [self showDropdownPopoverFromSender:sender withDataSource:_postTimeDropdownDataSource];
    }
}

- (IBAction)ancillarySwitchChanged:(id)sender
{
    if(sender == _preInfusionAncillarySwitch){
        [self StelaraInfusion].prepAncillary = [NSNumber numberWithBool:_preInfusionAncillarySwitch.isOn];
    }else if(sender == _postInfusionAncillarySwitch){
        [self StelaraInfusion].postAncillary = [NSNumber numberWithBool:_postInfusionAncillarySwitch.isOn];
    }
}

- (IBAction)clearButtonSelected:(id)sender
{
    [self StelaraInfusion].prepTime = [NSNumber numberWithInt:DEFAULT_STELARA_PREP1_TIME + DEFAULT_STELARA_PREP2_TIME];
    [self StelaraInfusion].postTime = [NSNumber numberWithInt:DEFAULT_STELARA_POST1_TIME + DEFAULT_STELARA_POST2_TIME];
    [self StelaraInfusion].prepAncillary = [NSNumber numberWithBool:NO];
    [self StelaraInfusion].postAncillary = [NSNumber numberWithBool:NO];
    
    [self updateAncillarySelections];
    [self updateStepTimes];
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
        [self StelaraInfusion].avgInfusionsPerMonth = [NSNumber numberWithInt:[textField.text intValue]];
    }
    
    //Always zero as this option is an off-label use and no longer valid
    [self StelaraInfusion].avgNewPatientsPerMonth = [NSNumber numberWithInt:0];
}

#pragma mark - Dropdowns
- (void)createDropdownDataSources
{
    _prepTimeDropdownDataSource = [[DropdownDataSource alloc]
                                      initWithItems:LIST_VALUES_ARRAY_STELARA_PREP_TIME
                                   andTitleForItemBlock:^ NSString *(id item){
                                       return [NSString stringWithFormat:@"%i", [item intValue] * 10];
                                      }];
    
    _postTimeDropdownDataSource = [[DropdownDataSource alloc]
                                       initWithItems:LIST_VALUES_ARRAY_STELARA_POST_TIME
                                   andTitleForItemBlock:^ NSString *(id item){
                                       return [NSString stringWithFormat:@"%i", [item intValue] * 10];
                                       }];
}

- (void)showDropdownPopoverFromSender:(id)sender withDataSource:(DropdownDataSource*)dataSource
{
    CGRect fromRect = sender ? ((UIView*)sender).frame : CGRectMake(0, 0, 1, 1);
    
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

- (void)dropdown:(DropdownController *)dropdown item:(id)item selectedAtIndex:(int)index fromDataSource:(DropdownDataSource *)dataSource
{
    if(dataSource == _prepTimeDropdownDataSource){
        //Set new preptime
        [self StelaraInfusion].prepTime = [NSNumber numberWithInt:[item intValue]];
        [self updateStepTimes];
    }else if(dataSource == _postTimeDropdownDataSource){
        [self StelaraInfusion].postTime = [NSNumber numberWithInt:[item intValue]];
        [self updateStepTimes];
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
    return @"stelara_infusion";
}

@end
