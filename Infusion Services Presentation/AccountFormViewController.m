//
//  AccountFormViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "AccountFormViewController.h"
#import "Presentation+Extension.h"
#import "IOMTextField.h"
#import "ListValues.h"
#import "DropdownDataSource.h"
#import "DropdownController.h"
#import "Constants.h"
#import "IOMAnalyticsManager.h"
#import "NSUserDefaults+IOMMyInfoUserDefaults.h"
#import "IOMDataClient.h"
#import "Colors.h"
#import <MLPAutoCompleteTextField/MLPAutoCompleteTextField.h>

@interface AccountFormViewController ()<IOMAnalyticsIdentifiable, MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate>{
    NSDateFormatter* dateFormatter;
    UIStoryboard* _mainStoryboard;
    UIPopoverController* _currentPopoverController;
    
    UIPopoverController* _presentationDatePopoverController;
    UIDatePicker* _presentationDatePicker;
    
    UIPopoverController* _presentationTypePopoverController;
    DropdownDataSource* _presentationTypeDataSource;
    
    UIPopoverController* _presentationSectionsPopoverController;
    DropdownDataSource* _presentationSectionsDataSource;
    
    NSInteger chosenTypeValue;
    id chosenItem;
}



@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *accountName3TextField;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *accountName2TextField;
@property (nonatomic, weak) IBOutlet MLPAutoCompleteTextField *accountNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *presentationNameTextField;
@property (nonatomic, weak) IBOutlet UITextField* presentationDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *presentationTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *presentationSectionTextField;
@property (weak, nonatomic) IBOutlet UIButton *presentationDateButton;
@property (weak, nonatomic) IBOutlet UIButton *presentationTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *presentationSectionsButton;
@property (weak, nonatomic) IBOutlet UISwitch *timeToCapacitySwitch;

@property (nonnull, strong) IOMDataClient* client;
@property (nonnull, strong) NSURLSessionDataTask* currentTask;
@property (nonnull, strong) NSArray<NSString*>* jnjIds;
@property (nonnull, strong) NSArray<NSString*>* accountNameDisplayStrings;
@property (nonnull, strong) NSDictionary<NSString*, NSString*>* lastRequestedDictionary;

@end

@implementation AccountFormViewController

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
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d/yyyy"];
    
    _mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    if(_accountNameString) [_accountNameTextField setText:_accountNameString];
    if(_accountName2String) [_accountName2TextField setText:_accountName2String];
    if(_accountName3String) [_accountName3TextField setText:_accountName3String];

    if(_presentationNameString) [_presentationNameTextField setText:_presentationNameString];
    
    NSDate * presentationDate = [dateFormatter dateFromString:_presentationDateString];
    
    if (presentationDate) {
        [_presentationDateButton setTitle:[dateFormatter stringFromDate:presentationDate] forState:UIControlStateNormal];
    } else {
        NSDate* today = [NSDate date];
        [_presentationDateButton setTitle:[dateFormatter stringFromDate:today] forState:UIControlStateNormal];
        _presentationDateString = [dateFormatter stringFromDate:today];
    }


    _client = [[IOMDataClient alloc] init];
    [_timeToCapacitySwitch setOn:_timeToCapacityReport];

    _accountNameTextField.autoCompleteDelegate = self;
    _accountNameTextField.autoCompleteDataSource = self;
    _accountNameTextField.autoCompleteTableView.backgroundColor = UIColor.whiteColor;

    _accountName2TextField.autoCompleteDelegate = self;
    _accountName2TextField.autoCompleteDataSource = self;
    _accountName2TextField.autoCompleteTableView.backgroundColor = UIColor.whiteColor;

    _accountName3TextField.autoCompleteDelegate = self;
    _accountName3TextField.autoCompleteDataSource = self;
    _accountName3TextField.autoCompleteTableView.backgroundColor = UIColor.whiteColor;

    if (_presentationTypeString&&(![_presentationTypeString isEqualToString:@""]))
        [_presentationTypeButton setTitle:_presentationTypeString forState:UIControlStateNormal];
    else
        [_presentationTypeButton setTitle:@"MIXED IOI" forState:UIControlStateNormal];
    
    if (_presentationSectionString&&(![_presentationSectionString isEqualToString:@""]))
        [_presentationSectionsButton setTitle:_presentationSectionString forState:UIControlStateNormal];
    else
        [_presentationSectionsButton setTitle:@"Infusion Services & Infusion Optimization" forState:UIControlStateNormal];
    
    self.textFieldArray = @[_accountNameTextField, _presentationNameTextField, _accountName2TextField, _accountName3TextField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateTitle];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void) updateTitle
{
    NSString * presentationDate;
    if (_presentationDateString)
        presentationDate = _presentationDateString;
    else
        presentationDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString* presentationTitleString = @"";
    if (_presentationNameString&&!([_presentationNameString isEqualToString:@""])) {
        presentationTitleString=[presentationTitleString stringByAppendingFormat:@"%@ - %@", _presentationNameString, presentationDate];
        [(IOMTextField*)_presentationNameTextField setErrorBackgroundEnabled:NO];
    } else {
        presentationTitleString = [presentationTitleString stringByAppendingFormat:@"%@ - %@", @"New Presentation", presentationDate];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTitle" object:nil userInfo:@{@"presentationTitle":presentationTitleString}];
}

- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell.textLabel setTextColor:[[Colors getInstance] lightGrayColor]];
    NSString* displayName = @"";
    if (indexPath.row < _accountNameDisplayStrings.count) {
        displayName = [_accountNameDisplayStrings objectAtIndex:indexPath.row];
    }

    [cell.textLabel setText:[NSString stringWithFormat:@"%@ – %@", autocompleteString, displayName]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu-Medium" size:12]];
    cell.backgroundColor = [UIColor whiteColor];

    return NO;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (textField == _accountNameTextField) {
        _accountNameTextField.text = _jnjIds[indexPath.row];
        _accountNameString = _jnjIds[indexPath.row];
        _presentationNameString = _accountNameDisplayStrings[indexPath.row];
        _presentationNameTextField.text = _accountNameDisplayStrings[indexPath.row];
        [textField closeAutoCompleteTableView];
    } else if (textField == _accountName2TextField) {
        _accountName2TextField.text = _jnjIds[indexPath.row];
        _accountName2String = _jnjIds[indexPath.row];
        [textField closeAutoCompleteTableView];
    } else if (textField == _accountName3TextField) {
        _accountName3TextField.text = _jnjIds[indexPath.row];
        _accountName3String = _jnjIds[indexPath.row];
        [textField closeAutoCompleteTableView];
    }

    [self postUpdateAccountIDNotification];
}

- (void)postUpdateAccountIDNotification
{
    NSMutableDictionary<NSString*, NSString*>* accountIDs = [@{} mutableCopy];

    NSString* account1 = _accountNameTextField.text;
    if (account1 != nil && ![account1 isEqualToString:@""]) {
        [accountIDs setObject:account1 forKey:@"accountID1"];
    }

    NSString* account2 = _accountName2TextField.text;
    if (account2 != nil && ![account2 isEqualToString:@""]) {
        [accountIDs setObject:account2 forKey:@"accountID2"];
    }

    NSString* account3 = _accountName3TextField.text;
    if (account3 != nil && ![account3 isEqualToString:@""]) {
        [accountIDs setObject:account3 forKey:@"accountID3"];
    }

    if (![accountIDs isEqualToDictionary:_lastRequestedDictionary]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAccountIDs" object:nil userInfo:accountIDs];
        _lastRequestedDictionary = accountIDs;
    }
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    _timeToCapacityReport = sender.isOn;
}

- (void)dealloc
{
    
    dateFormatter = nil;
    _mainStoryboard = nil;
    _currentPopoverController = nil;
    
    _presentationDatePopoverController = nil;
    _presentationDatePicker = nil;
    
    _presentationTypePopoverController = nil;
    _presentationTypeDataSource = nil;
    
    _presentationSectionsPopoverController = nil;
    _presentationSectionsDataSource = nil;
}

- (void)showError
{
    [self markErrors];

    if ([_presentationNameTextField text]==nil || [[_presentationNameTextField text] isEqualToString:@""])
    {
        [self showNameError];
    }
    else if ([_presentationTypeButton.titleLabel.text isEqualToString:[LIST_VALUES_ARRAY_PRESENTATION_TYPE objectAtIndex:0]])
    {
        [[[UIAlertView alloc] initWithTitle:@"Information Missing"
                                    message:@"Please select a presentation type."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles: nil] show];
    }
}

- (void)showNameError
{
    [[[UIAlertView alloc] initWithTitle:@"Information Missing"
                                message:@"Please create a name."
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles: nil] show];
}

- (void)markErrors
{
    if ([_presentationNameTextField text]==nil || [[_presentationNameTextField text] isEqualToString:@""]) {
        [((IOMTextField*)_presentationNameTextField) setErrorBackgroundEnabled:YES];
        [((IOMTextField*)_presentationNameTextField) setPlaceholder:@"Please create a name."];
    } else {
        [((IOMTextField*)_presentationNameTextField) setErrorBackgroundEnabled:NO];
    }
}

- (IBAction)presentationTypeButtonSelected:(UIButton *)sender {
    
    [self.view endEditing:TRUE];
    
    if (!_presentationTypePopoverController) {
        _presentationTypeDataSource = [[DropdownDataSource alloc]
                                       initWithItems:LIST_VALUES_ARRAY_PRESENTATION_TYPE
                                      andTitleForItemBlock:^ NSString* (id item)
                                      {
                                          return item;
                                      }];
        
        _presentationTypePopoverController = [DropdownController
                                             dropdownPopoverControllerForDropdownDataSource:_presentationTypeDataSource
                                             withDelegate:self andContentSize:CGSizeMake(320, 7*44)];
        _presentationTypePopoverController.delegate=self;
        
    }
    [_presentationTypePopoverController presentPopoverFromRect:[sender frame]
                                                       inView:self.view
                                     permittedArrowDirections:UIPopoverArrowDirectionUp
                                                     animated:YES];
}


- (IBAction)presentationSectionsButtonSelected:(UIButton *)sender {
    
    [self.view endEditing:TRUE];
    
    if (!_presentationSectionsPopoverController) {
        _presentationSectionsDataSource = [[DropdownDataSource alloc]
                                       initWithItems:LIST_VALUES_ARRAY_PRESENTATION_SECTIONS
                                       andTitleForItemBlock:^ NSString* (id item)
                                       {
                                           return item;
                                       }];
        
        _presentationSectionsPopoverController = [DropdownController
                                              dropdownPopoverControllerForDropdownDataSource:_presentationSectionsDataSource
                                              withDelegate:self andContentSize:CGSizeMake(375, 3*44)];
    }
    [_presentationSectionsPopoverController presentPopoverFromRect:[sender frame]
                                                        inView:self.view
                                      permittedArrowDirections:UIPopoverArrowDirectionUp
                                                      animated:YES];
    
}


- (IBAction)presentationDateButtonSelected:(UIButton *)sender {
    
    [self.view endEditing:TRUE];
    
    if (!_presentationDatePopoverController) {
        
        UIView *v = [[UIView alloc] init];
        CGRect pickerFrame = CGRectMake(0, 0, 320, 216);
        UIDatePicker *pView=[[UIDatePicker alloc] initWithFrame:pickerFrame];
        pView.datePickerMode = UIDatePickerModeDate;
        
        _presentationDatePicker = pView;
        [v addSubview:_presentationDatePicker];
        
        UIViewController *popoverContent = [[UIViewController alloc]init];
        popoverContent.view = v;
        
        
        //resize the popover view shown
        //in the current view to the view's size
        popoverContent.preferredContentSize = CGSizeMake(320, 216);
        
        //create a popover controller with my DatePickerViewController in it
        _presentationDatePopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        
        //Set the delegate to self to receive the data of the Datepicker in the popover
        _presentationDatePopoverController.delegate = self;
        
        //Adjust the popover Frame to appear where I want
        CGRect myFrame = sender.frame;//CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 320,     200);
        myFrame.origin.x = 260;
        myFrame.origin.y = 320;
        
    }
    
    //Present the popover
    [_presentationDatePopoverController presentPopoverFromRect:[sender frame]
                                                  inView:self.view
                                permittedArrowDirections:UIPopoverArrowDirectionUp
                                                animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    
    [_presentationDateButton setTitle:[dateFormatter stringFromDate:_presentationDatePicker.date] forState:UIControlStateNormal];
    _presentationDateString = [dateFormatter stringFromDate:_presentationDatePicker.date];
    [self updateTitle];
}

#pragma mark - UITextFieldDelegate 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* stringNew = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
    [self updateValues:textField withNewString:stringNew];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSString* stringNew = @"";
    
    [self updateValues:textField withNewString:stringNew];
    
    return YES;
}

- (void)updateValues:(UITextField *)textField withNewString:(NSString *)newString {
    
    if(textField == _accountNameTextField){
        _accountNameString = newString;
    } else if (textField == _presentationNameTextField){
        _presentationNameString = newString;
        [self updateTitle];
    } else if (textField == _accountName2TextField) {
        _accountName2String = newString;
    } else if (textField == _accountName3TextField) {
        _accountName3String = newString;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _presentationDateTextField){
        NSString* dateString = textField.text;
        NSDate* dateNew = [dateFormatter dateFromString:dateString];
        if(dateNew && (id)dateNew != [NSNull null]){
            [((IOMTextField*)textField) setErrorBackgroundEnabled:NO];
        }else{
            [((IOMTextField*)textField) setErrorBackgroundEnabled:YES];
            [[[UIAlertView alloc] initWithTitle:@"Invalid Date"
                                        message:@"The date entered is invalid. "
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil] show];
        }
    } else if (textField == _presentationNameTextField) {
        if ([textField text]==nil || [[textField text] isEqualToString:@""]) {
            [((IOMTextField*)textField) setErrorBackgroundEnabled:YES];
            [self showNameError];
        } else {
            [((IOMTextField*)textField) setErrorBackgroundEnabled:NO];

        }
    } else if (textField == _accountNameTextField ||
               textField == _accountName2TextField ||
               textField == _accountName3TextField) {
        if (textField.text != nil && ![textField.text isEqualToString:@""]) {
            [self postUpdateAccountIDNotification];
        }
        [(MLPAutoCompleteTextField*)textField closeAutoCompleteTableView];
    }
    [super textFieldDidEndEditing:textField];
}

#pragma mark - DropdownDelegate Protocol Methods
- (void)dropdown:(DropdownController*)dropdown item:(id)item selectedAtIndex:(NSInteger)index fromDataSource:(DropdownDataSource *)dataSource
{
    if ([LIST_VALUES_ARRAY_PRESENTATION_TYPE containsObject:item])
    {
        chosenTypeValue = [LIST_VALUES_ARRAY_PRESENTATION_TYPE indexOfObject:item];
        chosenItem = item;

        PresentationType pType = [[[ListValues listValuesForDictionaryPresentationTypes] objectForKey:chosenItem] integerValue];

        NSString* alertMessage = [NSString stringWithFormat:@"You have selected an account type where the target audience will be presented information on the following products:\n%@\nPlease click Accept to confirm that this is the correct audience or Cancel to change the account type.", [[Presentation drugTitlesForPresentationType:pType] componentsJoinedByString:@"\n"]];
        
        if (chosenTypeValue!=0) {
            [[[UIAlertView alloc] initWithTitle:@"Presentation Type"
                                        message:alertMessage
                                       delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Accept", nil] show];
        }
    }
    else
    {
        [_presentationSectionsButton setTitle:item forState:UIControlStateNormal];
        [_presentationSectionsPopoverController dismissPopoverAnimated:YES];
        _presentationSectionString = item;
        IOMPresentationSectionsIncludedType includedType = [[[ListValues listValuesForDictionaryIncludedPresentationTypes] objectForKey:item] integerValue];

        if (includedType == PresentationSectionsIncludedTypeInfusionServices) {
            _timeToCapacityReport = NO;
            [_timeToCapacitySwitch setOn:NO];
            [_timeToCapacitySwitch setEnabled:NO];
        } else {
            _timeToCapacityReport = YES;
            [_timeToCapacitySwitch setOn:YES];
            [_timeToCapacitySwitch setEnabled:YES];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSectionAvailability" object:nil userInfo:@{@"presentationsIncluded":[NSNumber numberWithInteger:includedType]}];
    }
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController;
{
    if (popoverController==_presentationTypePopoverController)
        return NO;
    else return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex==1)
    {
        [_presentationTypeButton setTitle:chosenItem forState:UIControlStateNormal];
        [_presentationTypePopoverController dismissPopoverAnimated:YES];
        _presentationTypeString = chosenItem;
        PresentationType pType = [[[ListValues listValuesForDictionaryPresentationTypes] objectForKey:chosenItem] integerValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePresentationType"
                                                            object:nil
                                                          userInfo:@{@"presentationType":[NSNumber numberWithInteger:pType]}];
        [((IOMTextField*)_presentationTypeTextField) setErrorBackgroundEnabled:NO];
    }
}

-(NSString*)analyticsIdentifier
{
    return @"account_form";
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void(^)(NSArray *suggestions))handler {
    if (_currentTask != nil) {
        [_currentTask cancel];
        _currentTask = nil;
    }

    __weak typeof(self) weakSelf = self;
    NSString* abs = [NSUserDefaults iom_getMyInfoUserDefaultForType:IOMMyInfoDefaultsRDT] ?: @"8540004";
    _currentTask = [_client getAccountsForJNJID:string
                                        withABS:abs
                                 withCompletion:^(NSArray<NSString*> * strings, NSArray<NSString*>* displayNames) {
        if (weakSelf == nil || strings == nil || displayNames == nil) { return; }
        weakSelf.accountNameDisplayStrings = displayNames;
        weakSelf.jnjIds = strings;
        handler(strings);
    }];
}

@end
