//
//  ScenarioInfoViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/9/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "ScenarioInfoFormViewController.h"
#import "Scenario+Extension.h"
#import "ScenarioFormDataSource.h"
#import "ListValues.h"
#import "DropdownDataSource.h"
#import "DropdownController.h"
#import "IOMTextField.h"
#import "IOMAnalyticsManager.h"

@interface ScenarioInfoFormViewController ()<IOMAnalyticsIdentifiable>{
    NSDateFormatter* _dateFormatter;
    
    UIPopoverController* _maxChairsPerHCPPopoverController;
    DropdownDataSource* _maxChairsPerHCPDataSource;
    
    UIPopoverController* _datePickerPopoverController;
    UIDatePicker* _datePicker;
}

@property (nonatomic, weak) IBOutlet UITextField* nameTextField;
@property (nonatomic, weak) IBOutlet UIButton* dateButton;
@property (nonatomic, weak) IBOutlet UIButton* maxChairsPerHCPButton;

@end

@implementation ScenarioInfoFormViewController
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
    [_dateFormatter setDateFormat:@"M/d/yyyy"];
    
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
    if(_scenario){
        [_nameTextField setText:_scenario.name];
        [_dateButton setTitle:[_dateFormatter stringFromDate: _scenario.dateCreated] forState:UIControlStateNormal];
        NSNumber* maxChairsPerHCP = [_scenario.maxChairsPerStaff copy];
        [_maxChairsPerHCPButton setTitle:[NSString stringWithFormat:@"%i", [maxChairsPerHCP integerValue]] forState:UIControlStateNormal];
    }else{
        //Scenario not found
        NSLog(@"%@ - No scenario passed to view property!", NSStringFromSelector(_cmd));
    }
}

- (void)markInvalidFields
{
    //Mark any invalid fields as invalid
    [((IOMTextField*)_nameTextField) setErrorBackgroundEnabled:(_nameTextField.text.length == 0)];
}

#pragma mark - IBActions
- (IBAction)maxChairsPerHCPButtonSelected:(id)sender
{
    if (!_maxChairsPerHCPPopoverController) {
        _maxChairsPerHCPDataSource = [[DropdownDataSource alloc]
                                      initWithItems:LIST_VALUES_ARRAY_MAX_CHAIRS_PER_HCP
                                      andTitleForItemBlock:^ NSString* (id item)
        {
            NSNumber* number = item;
            return [NSString stringWithFormat:@"%@", number];
        }];
        
        _maxChairsPerHCPPopoverController = [DropdownController
                                             dropdownPopoverControllerForDropdownDataSource:_maxChairsPerHCPDataSource
                                             withDelegate:self andContentSize:CGSizeMake(200, 5*44)];
    }
    [_maxChairsPerHCPPopoverController presentPopoverFromRect:[sender frame]
                                                       inView:self.view
                                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                                     animated:YES];
}

- (IBAction)dateButtonSelected:(id)sender
{
    if (!_datePickerPopoverController) {
        if (!_datePicker) {
            _datePicker = [[UIDatePicker alloc] init];
            [_datePicker setDate:[NSDate date]];
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
        }
        
        UIViewController* contentController = [[UIViewController alloc] init];
        contentController.view = _datePicker;
        contentController.preferredContentSize = CGSizeMake(320, 216);
        
        _datePickerPopoverController = [[UIPopoverController alloc] initWithContentViewController:contentController];
        _datePickerPopoverController.delegate = self;
    }
    
    if ([_datePickerPopoverController isPopoverVisible]) {
        [_datePickerPopoverController dismissPopoverAnimated:YES];
    } else {
        UIView* senderView = sender;
        CGRect fromRect = senderView.frame;
        
        [_datePickerPopoverController presentPopoverFromRect:fromRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - UITextFieldDelegate Methods
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _nameTextField){
        if(_nameTextField.text.length != 0){
            _scenario.name = [NSString stringWithFormat:@"%@", textField.text];
        } else {
            [self showError];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _nameTextField){
        NSString* replaced = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(replaced.length > 60){
            return NO;
        }
    }
    return YES;
}

#pragma mark - ChildViewController Methods
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil) {
        //removing
    } else {
        //adding
    }
}

#pragma mark - PresentationForm Protocol Methods
- (BOOL)isInputDataValid
{
    if([_nameTextField.text length] <= 0){
        return NO;
    }
    
    return YES;
}

- (void)willSavePresentation
{
    //Nothing
}

- (void)showError
{
    [self markInvalidFields];
    
    if([_nameTextField.text length] <= 0){
        [[[UIAlertView alloc] initWithTitle:@"Input Error" message:@"Scenario has not been given a valid name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}


#pragma mark - DropdownDelegate Protocol Methods
- (void)dropdown:(DropdownController*)dropdown item:(id)item selectedAtIndex:(NSInteger)index fromDataSource:(DropdownDataSource *)dataSource
{
    _scenario.maxChairsPerStaff = [NSNumber numberWithInteger:[item integerValue]];
    [_maxChairsPerHCPButton setTitle:[NSString stringWithFormat:@"%i", [item integerValue]] forState:UIControlStateNormal];
    [_maxChairsPerHCPPopoverController dismissPopoverAnimated:YES];
}

#pragma mark - UIPopoverController Delegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    //Set Date
    _scenario.dateCreated = _datePicker.date;
    [_dateButton setTitle:[_dateFormatter stringFromDate:_datePicker.date] forState:UIControlStateNormal];
}

-(NSString*)analyticsIdentifier
{
    return @"scenario_info_form";
}

@end
