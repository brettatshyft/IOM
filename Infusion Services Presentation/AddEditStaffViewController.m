//
//  AddEditStaffViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/26/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "AddEditStaffViewController.h"
#import "WeekdaysSelectionViewController.h"
#import "Scenario+Extension.h"
#import "Staff+Extension.h"
#import "ListValues.h"
#import "StaffTypeSelectionViewController.h"
#import "Constants.h"
#import "IOMAnalyticsManager.h"

static NSIndexPath * kNumberOfQHPStaffIndexPath;
static NSIndexPath * kNumberOfQHPStaffPickerIndexPath;
static NSIndexPath * kNumberOfAncillaryStaffIndexPath;
static NSIndexPath * kNumberOfAncillaryStaffPickerIndexPath;
static NSIndexPath * kStaffTypeIndexPath;
static NSIndexPath * kWeekdaysIndexPath;
static NSIndexPath * kWorkStartsIndexPath;
static NSIndexPath * kWorkStartsPickerIndexPath;
static NSIndexPath * kWorkEndsIndexPath;
static NSIndexPath * kWorkEndsPickerIndexPath;
static NSIndexPath * kIncludeBreaksIndexPath;
static NSIndexPath * kBreakStartsIndexPath;
static NSIndexPath * kBreakStartsPickerIndexPath;
static NSIndexPath * kBreakEndsIndexPath;
static NSIndexPath * kBreakEndsPickerIndexPath;
static NSIndexPath * kClearHoursIndexPath;

@interface AddEditStaffViewController ()<IOMAnalyticsIdentifiable>{
    
    NSArray * _numberOfQHPStaffOptionsArray;
    NSArray * _numberOfANCStaffOptionsArray;
    NSDateFormatter * _timeFormatter;
    
    NSInteger _selectedNumberOfQHPStaff;
    NSInteger _selectedNumberOfAncillaryStaff;
    NSDate * _selectedWorkStartDate;
    NSDate * _selectedWorkEndDate;
    NSDate * _selectedBreakEndDate;
    NSDate * _selectedBreakStartDate;
    NSNumber * _selectedStaffTypeIDNumber;
    
    NSNumber* _weekdayBitMask;
    
    NSIndexPath* _openPickerIndexPath;
    NSMutableArray* _cellsToAnimateArray;
    
}

//Picker views
@property (nonatomic, weak) IBOutlet UIPickerView* numberOfQHPStaffPicker;
@property (nonatomic, weak) IBOutlet UIPickerView* numberOfAncillaryStaffPicker;
@property (nonatomic, weak) IBOutlet UIDatePicker* workStartTimePicker;
@property (nonatomic, weak) IBOutlet UIDatePicker* workEndTimePicker;
@property (nonatomic, weak) IBOutlet UIDatePicker* breakStartTimePicker;
@property (nonatomic, weak) IBOutlet UIDatePicker* breakEndTimePicker;

//Detail labels
@property (nonatomic, weak) IBOutlet UILabel* numberOfQHPStaffDetailLabel;
@property (nonatomic, weak) IBOutlet UILabel* numberOfAncillaryStaffDetailLabel;
@property (nonatomic, weak) IBOutlet UILabel* staffTypeDetailLabel;
@property (nonatomic, weak) IBOutlet UILabel* weekdaysDetailLabel;
@property (nonatomic, weak) IBOutlet UILabel* workStartTimeDetailLabel;
@property (nonatomic, weak) IBOutlet UILabel* workEndTimeDetailLabel;
@property (nonatomic, weak) IBOutlet UILabel* breakStartTimeDetailLabel;
@property (nonatomic, weak) IBOutlet UILabel* breakEndTimeDetailLabel;

@property (nonatomic, weak) IBOutlet UISwitch* includeBreakSwitch;

@end

@implementation AddEditStaffViewController

+ (void)initialize
{
    [super initialize];
    
    if(!kNumberOfQHPStaffIndexPath){
        kNumberOfQHPStaffIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    if(!kNumberOfQHPStaffPickerIndexPath){
        kNumberOfQHPStaffPickerIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    if(!kNumberOfAncillaryStaffIndexPath){
        kNumberOfAncillaryStaffIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }
    if(!kNumberOfAncillaryStaffPickerIndexPath){
        kNumberOfAncillaryStaffPickerIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    }
    if(!kStaffTypeIndexPath){
        kStaffTypeIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    }
    if(!kWeekdaysIndexPath){
        kWeekdaysIndexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    }
    if(!kWorkStartsIndexPath){
        kWorkStartsIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    if(!kWorkStartsPickerIndexPath){
        kWorkStartsPickerIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    }
    if(!kWorkEndsIndexPath){
        kWorkEndsIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    }
    if(!kWorkEndsPickerIndexPath){
        kWorkEndsPickerIndexPath = [NSIndexPath indexPathForRow:3 inSection:1];
    }
    if(!kIncludeBreaksIndexPath){
        kIncludeBreaksIndexPath = [NSIndexPath indexPathForRow:4 inSection:1];
    }
    if(!kBreakStartsIndexPath){
        kBreakStartsIndexPath = [NSIndexPath indexPathForRow:5 inSection:1];
    }
    if(!kBreakStartsPickerIndexPath){
        kBreakStartsPickerIndexPath = [NSIndexPath indexPathForRow:6 inSection:1];
    }
    if(!kBreakEndsIndexPath){
        kBreakEndsIndexPath = [NSIndexPath indexPathForRow:7 inSection:1];
    }
    if(!kBreakEndsPickerIndexPath){
        kBreakEndsPickerIndexPath = [NSIndexPath indexPathForRow:8 inSection:1];
    }
    if(!kClearHoursIndexPath){
        kClearHoursIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    }
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Only show clear button if there are staff in this scenario
    if([_scenario.staff count] > 0){
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:self
                                                                        action:@selector(cancelButtonSelected:)];
        [self.navigationItem setLeftBarButtonItem:cancelButton];
    }
    //Done Button
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonSelected:)];
    [self.navigationItem setRightBarButtonItem:doneButton];
    
    //Initial values for instance variables
    _openPickerIndexPath = nil;
    _numberOfQHPStaffOptionsArray = LIST_VALUES_ARRAY_NUMBER_OF_QHP_STAFF;
    _numberOfANCStaffOptionsArray = LIST_VALUES_ARRAY_NUMBER_OF_ANC_STAFF;
    _selectedNumberOfQHPStaff = 1;
    _selectedNumberOfAncillaryStaff = 0;
    [self setInitialWeekdayMask];
    [self setInitialStaffType];
    
    //Date/Time Picker action callbacks
    [_workStartTimePicker addTarget:self action:@selector(datePickerDidChange:) forControlEvents:UIControlEventValueChanged];
    [_workEndTimePicker addTarget:self action:@selector(datePickerDidChange:) forControlEvents:UIControlEventValueChanged];
    [_breakStartTimePicker addTarget:self action:@selector(datePickerDidChange:) forControlEvents:UIControlEventValueChanged];
    [_breakEndTimePicker addTarget:self action:@selector(datePickerDidChange:) forControlEvents:UIControlEventValueChanged];
    //Include break switch action callback
    [_includeBreakSwitch addTarget:self action:@selector(includeBreakSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [_includeBreakSwitch setOn:NO];
    
    //Date Formatter for start/end time
    _timeFormatter = [[NSDateFormatter alloc] init];
    [_timeFormatter setDateFormat:@"h:mm a"];
    
    //Cells to animate array
    _cellsToAnimateArray = [[NSMutableArray alloc] init];
    
    [self setInitialPickerValues];
    [self setNavigationTitle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[IOMAnalyticsManager shared] trackScreenView:self];
    
    [self updateAllDetailLabels];
    [self.tableView reloadData];

    [self.tableView cellForRowAtIndexPath:kNumberOfQHPStaffPickerIndexPath].hidden=TRUE;
    [self.tableView cellForRowAtIndexPath:kNumberOfAncillaryStaffPickerIndexPath].hidden=TRUE;
    [self.tableView cellForRowAtIndexPath:kWorkStartsPickerIndexPath].hidden=TRUE;
    [self.tableView cellForRowAtIndexPath:kWorkEndsPickerIndexPath].hidden=TRUE;
    [self.tableView cellForRowAtIndexPath:kBreakStartsPickerIndexPath].hidden=TRUE;
    [self.tableView cellForRowAtIndexPath:kBreakEndsPickerIndexPath].hidden=TRUE;
    
    if (_staffToEdit) {
        [self.tableView cellForRowAtIndexPath:kNumberOfQHPStaffIndexPath].hidden=TRUE;
        [self.tableView cellForRowAtIndexPath:kNumberOfAncillaryStaffIndexPath].hidden=TRUE;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"weekdaysSelection"]){
        WeekdaysSelectionViewController* controller = [segue destinationViewController];
        controller.weekdaysSelectedMask = &_weekdayBitMask;
    }else if([[segue identifier] isEqualToString:@"staffTypeSelection"]){
        StaffTypeSelectionViewController* controller = [segue destinationViewController];
        controller.staffTypeID = &_selectedStaffTypeIDNumber;
    }
}

- (void)dismissContainingPopover
{
    [_containingPopover dismissPopoverAnimated:YES];
    [_containingPopover.delegate popoverControllerDidDismissPopover:_containingPopover];
}

#pragma mark - Update View Methods
- (void)setNavigationTitle
{
    //Set title for navigation bar
    if(_staffToEdit){
        [self setTitle:@"Change Staff Hours"];
    }else{
        [self setTitle:@"Add New Staff"];
    }
}

- (void)setInitialStaffType
{
    //If editing
    if (_staffToEdit) {
        if ([_staffToEdit count] == 1) {
            Staff * staff = [_staffToEdit objectAtIndex:0];
            _selectedStaffTypeIDNumber = [staff.staffTypeID copy];
        } else {
            //Set to -1
            _selectedStaffTypeIDNumber = [NSNumber numberWithInteger:-1];
        }
        
    } else {
        //Set to -1
        _selectedStaffTypeIDNumber = [NSNumber numberWithInteger:-1];
    }
}

- (void)setInitialWeekdayMask
{
    if (_staffToEdit) {
        _weekdayBitMask = @0;
        /*
        if ([_staffToEdit count] == 1) {
            Staff * staff = [_staffToEdit objectAtIndex:0];
            NSInteger weekdayMask = 0;
            if ([staff getTotalHoursForDay:0] > 0){
                weekdayMask = (weekdayMask | Sunday);
            }
            if ([staff getTotalHoursForDay:1] > 0){
                weekdayMask = (weekdayMask | Monday);
            }
            if ([staff getTotalHoursForDay:2] > 0){
                weekdayMask = (weekdayMask | Tuesday);
            }
            if ([staff getTotalHoursForDay:3] > 0){
                weekdayMask = (weekdayMask | Wednesday);
            }
            if ([staff getTotalHoursForDay:4] > 0){
                weekdayMask = (weekdayMask | Thursday);
            }
            if ([staff getTotalHoursForDay:5] > 0){
                weekdayMask = (weekdayMask | Friday);
            }
            if ([staff getTotalHoursForDay:6] > 0){
                weekdayMask = (weekdayMask | Saturday);
            }
            _weekdayBitMask = @(weekdayMask);
        } else {
            _weekdayBitMask = @0;
        }
         */
    } else {
        _weekdayBitMask = @(Monday|Tuesday|Wednesday|Thursday|Friday);
    }
    
}

- (void)setInitialPickerValues
{
    [_numberOfQHPStaffPicker selectRow:_selectedNumberOfQHPStaff inComponent:0 animated:NO];
    
    _selectedWorkStartDate = [_timeFormatter dateFromString:@"8:00 am"];
    _selectedWorkEndDate = [_timeFormatter dateFromString:@"5:00 pm"];
    [_workStartTimePicker setDate:_selectedWorkStartDate];
    [_workEndTimePicker setDate:_selectedWorkEndDate];
    
    _selectedBreakStartDate = [_timeFormatter dateFromString:@"12:00 pm"];
    _selectedBreakEndDate = [_timeFormatter dateFromString:@"12:30 pm"];
    [_breakStartTimePicker setDate:_selectedBreakStartDate];
    [_breakEndTimePicker setDate:_selectedBreakEndDate];
}

- (void)updateAllDetailLabels
{
    [self updateNumberOfQHPStaffDetailLabel];
    [self updateNumberOfAncillaryStaffDetailLabel];
    [self updateStaffTypeDetailLabel];
    [self updateWeekdaysDetailLabel];
    [self updateWorkStartTimeDetailLabel];
    [self updateWorkEndTimeDetailLabel];
    [self updateBreakStartTimeDetailLabel];
    [self updateBreakEndTimeDetailLabel];
}

- (void)updateNumberOfQHPStaffDetailLabel
{
    [_numberOfQHPStaffDetailLabel setText:[NSString stringWithFormat:@"%i", _selectedNumberOfQHPStaff]];
}

- (void)updateNumberOfAncillaryStaffDetailLabel
{
    [_numberOfAncillaryStaffDetailLabel setText:[NSString stringWithFormat:@"%i", _selectedNumberOfAncillaryStaff]];
}

- (void)updateStaffTypeDetailLabel
{
    NSString* detailString = @"";
    if ([_selectedStaffTypeIDNumber integerValue] == StaffTypeQHP) {
        detailString = @"QHP";
    } else if ([_selectedStaffTypeIDNumber integerValue] == StaffTypeAncillary){
        detailString = @"Ancillary";
    }
    
    [_staffTypeDetailLabel setText:detailString];
}

- (void)updateWeekdaysDetailLabel
{
    NSMutableString* weekdaysString = [NSMutableString stringWithFormat:@""];
    NSInteger weekdayBitMask = [_weekdayBitMask integerValue];
    if(weekdayBitMask & Sunday) [weekdaysString appendString:@"Su"];
    if(weekdayBitMask & Monday) [weekdaysString appendString:@" M"];
    if(weekdayBitMask & Tuesday) [weekdaysString appendString:@" Tu"];
    if(weekdayBitMask & Wednesday) [weekdaysString appendString:@" W"];
    if(weekdayBitMask & Thursday) [weekdaysString appendString:@" Th"];
    if(weekdayBitMask & Friday) [weekdaysString appendString:@" F"];
    if(weekdayBitMask & Saturday) [weekdaysString appendString:@" Sa"];
    
    NSString* weekdaysFinalString = [weekdaysString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [_weekdaysDetailLabel setText:weekdaysFinalString];
}

- (void)updateWorkStartTimeDetailLabel
{
    [_workStartTimeDetailLabel setText:[_timeFormatter stringFromDate:_selectedWorkStartDate]];
}

- (void)updateWorkEndTimeDetailLabel
{
    [_workEndTimeDetailLabel setText:[_timeFormatter stringFromDate:_selectedWorkEndDate]];
}

- (void)updateBreakStartTimeDetailLabel
{
    NSString* detailString = ([_includeBreakSwitch isOn]) ? [_timeFormatter stringFromDate:_selectedBreakStartDate] : @"";
    [_breakStartTimeDetailLabel setText:detailString];
}

- (void)updateBreakEndTimeDetailLabel
{
    NSString* detailString = ([_includeBreakSwitch isOn]) ? [_timeFormatter stringFromDate:_selectedBreakEndDate] : @"";
    [_breakEndTimeDetailLabel setText:detailString];
}

- (void)clearHours
{
    _selectedWorkStartDate = _selectedWorkEndDate = nil;
    [_includeBreakSwitch setOn:NO];
    [self updateWorkStartTimeDetailLabel];
    [self updateWorkEndTimeDetailLabel];
    [self updateBreakStartTimeDetailLabel];
    [self updateBreakEndTimeDetailLabel];
}

#pragma mark - Validation
- (BOOL)timesAreValid
{
    BOOL valid = YES;
    NSString* alertMessage = nil;
    if ([_includeBreakSwitch isOn]) {
        if ([_selectedWorkStartDate compare:_selectedBreakStartDate] == NSOrderedDescending || [_selectedWorkStartDate compare:_selectedBreakStartDate] == NSOrderedSame) {
            //Break start must be after Work start.
            valid = NO;
            alertMessage = @"Break start time must be after work start time.";
        } else if ([_selectedBreakStartDate compare:_selectedBreakEndDate] == NSOrderedDescending || [_selectedBreakStartDate compare:_selectedBreakEndDate] == NSOrderedSame) {
            //Break end must be after break start.
            valid = NO;
            alertMessage = @"Break end time must be after break start time.";
        } else if ([_selectedBreakEndDate compare:_selectedWorkEndDate] == NSOrderedDescending || [_selectedBreakEndDate compare:_selectedWorkEndDate] == NSOrderedSame) {
            //Work end must be after break end.
            valid = NO;
            alertMessage = @"Work end time must be after break end time.";
        }
    } else {
        if (!(_selectedWorkStartDate && _selectedWorkEndDate) && (_selectedWorkStartDate || _selectedWorkEndDate)) {
            //Only one is nil, not valid
            valid = NO;
            alertMessage = @"Either both start-time and end-time must be selected or neither must be selected.";
        } else if ((_selectedWorkStartDate && _selectedWorkEndDate) && ([_selectedWorkStartDate compare:_selectedWorkEndDate] == NSOrderedDescending || [_selectedWorkStartDate compare:_selectedWorkEndDate] == NSOrderedSame)) {
            //Work end must be after work start
            valid = NO;
            alertMessage = @"Work end time must be after work start time.";
        }
    }
    
    if (!valid) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Input" message:alertMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    
    return valid;
}

- (BOOL)daysAreValid
{
    return [_weekdayBitMask integerValue] != 0;
}

- (BOOL)workTimesAreValid
{
    return [_weekdayBitMask integerValue] == 0 || (_selectedWorkStartDate == nil && _selectedWorkEndDate == nil) || ([_selectedWorkStartDate compare:_selectedWorkEndDate] != NSOrderedDescending && [_selectedWorkStartDate compare:_selectedWorkEndDate] != NSOrderedSame);
}

- (BOOL)breakTimesAreValid
{
    return [_weekdayBitMask integerValue] == 0 || ![_includeBreakSwitch isOn] || (_selectedBreakStartDate == nil && _selectedBreakEndDate == nil) ||([_selectedBreakStartDate compare:_selectedBreakEndDate] != NSOrderedDescending && [_selectedBreakStartDate compare:_selectedBreakEndDate] != NSOrderedSame);
}

#pragma mark - IBActions
- (IBAction)cancelButtonSelected:(id)sender
{
    [self dismissContainingPopover];
}

- (IBAction)doneButtonSelected:(id)sender
{
    /*if (![self daysAreValid]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"At least one weekday should be selected." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }*/
    
    if ([_selectedStaffTypeIDNumber integerValue] == -1 && ![self daysAreValid]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"You must select a new staff type and/or select days of the week times to be adjusted." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (![self timesAreValid]) {
        return;
    }
    
    if(_staffToEdit){
        [self finishEditingStaff];
    }else{
        [self finishAddingStaff];
    }
}

#pragma mark - Done Methods
- (void)finishAddingStaff
{
    //Cannot add more staff than MAX_NUMBER_OF_STAFF
    int numberOfStaffToAdd = (_selectedNumberOfQHPStaff + _selectedNumberOfAncillaryStaff);
    numberOfStaffToAdd = MIN(numberOfStaffToAdd, (MAX_NUMBER_OF_STAFF - _currentNumberOfStaff));
    
    for (int i = 0; i < numberOfStaffToAdd; i++){
        Staff* staff = [Staff createStaffEntityForScenario:_scenario];
        StaffType type = (i < _selectedNumberOfQHPStaff) ? StaffTypeQHP : StaffTypeAncillary;
        [self setPropertiesOfStaffObject:staff withType:type];
    }
    [self dismissContainingPopover];
}

- (void)finishEditingStaff
{
    for (int i = 0; i < [_staffToEdit count]; i++){
        Staff* staff = [_staffToEdit objectAtIndex:i];
        StaffType type = [_selectedStaffTypeIDNumber integerValue];
        [self setPropertiesOfStaffObject:staff withType:type];
    }
    [self dismissContainingPopover];
}

- (void)setPropertiesOfStaffObject:(Staff*)staff withType:(NSInteger)staffType
{
    NSInteger bitmask = [_weekdayBitMask integerValue];
    BOOL includeBreaks = [_includeBreakSwitch isOn];
    
    if (staffType != -1) {
        //Set staff type if selected
        staff.staffTypeID = [NSNumber numberWithInteger:staffType];
    }
    
    
    if (bitmask & Sunday){
        staff.workStartTime0 = _selectedWorkStartDate;
        staff.workEndTime0 = _selectedWorkEndDate;
        staff.breakStartTime0 = (includeBreaks) ? _selectedBreakStartDate : nil;
        staff.breakEndTime0 = (includeBreaks) ? _selectedBreakEndDate : nil;
    }
    if (bitmask & Monday){
        staff.workStartTime1 = _selectedWorkStartDate;
        staff.workEndTime1 = _selectedWorkEndDate;
        staff.breakStartTime1 = (includeBreaks) ? _selectedBreakStartDate : nil;
        staff.breakEndTime1 = (includeBreaks) ? _selectedBreakEndDate : nil;
    }
    if (bitmask & Tuesday){
        staff.workStartTime2 = _selectedWorkStartDate;
        staff.workEndTime2 = _selectedWorkEndDate;
        staff.breakStartTime2 = (includeBreaks) ? _selectedBreakStartDate : nil;
        staff.breakEndTime2 = (includeBreaks) ? _selectedBreakEndDate : nil;
    }
    if (bitmask & Wednesday){
        staff.workStartTime3 = _selectedWorkStartDate;
        staff.workEndTime3 = _selectedWorkEndDate;
        staff.breakStartTime3 = (includeBreaks) ? _selectedBreakStartDate : nil;
        staff.breakEndTime3 = (includeBreaks) ? _selectedBreakEndDate : nil;
    }
    if (bitmask & Thursday){
        staff.workStartTime4 = _selectedWorkStartDate;
        staff.workEndTime4 = _selectedWorkEndDate;
        staff.breakStartTime4 = (includeBreaks) ? _selectedBreakStartDate : nil;
        staff.breakEndTime4 = (includeBreaks) ? _selectedBreakEndDate : nil;
    }
    if (bitmask & Friday){
        staff.workStartTime5 = _selectedWorkStartDate;
        staff.workEndTime5 = _selectedWorkEndDate;
        staff.breakStartTime5 = (includeBreaks) ? _selectedBreakStartDate : nil;
        staff.breakEndTime5 = (includeBreaks) ? _selectedBreakEndDate : nil;
    }
    if (bitmask & Saturday){
        staff.workStartTime6 = _selectedWorkStartDate;
        staff.workEndTime6 = _selectedWorkEndDate;
        staff.breakStartTime6 = (includeBreaks) ? _selectedBreakStartDate : nil;
        staff.breakEndTime6 = (includeBreaks) ? _selectedBreakEndDate : nil;
    }
}

#pragma mark - UIDatePicker Action
- (IBAction)datePickerDidChange:(id)sender
{
    if (sender == _workStartTimePicker) {
        _selectedWorkStartDate = _workStartTimePicker.date;
        [self updateWorkStartTimeDetailLabel];
    }else if(sender == _workEndTimePicker) {
        _selectedWorkEndDate = _workEndTimePicker.date;
        
        /*
         *  SPECIAL INSTRUCTIONS -
         *  If selected end time is 12:00 AM, add 24 hours.
         *  This allows the user to select a time range of
         *  12:00AM - 12:00 AM
         */
        NSDate* endDay12 = [_timeFormatter dateFromString:@"12:00 am"];
        if ([_selectedWorkEndDate isEqualToDate:endDay12]){
            _selectedWorkEndDate = [_selectedWorkEndDate dateByAddingTimeInterval:60*60*24];    //add 24 hours
        }
        
        [self updateWorkEndTimeDetailLabel];
    }else if (sender == _breakStartTimePicker) {
        _selectedBreakStartDate = _breakStartTimePicker.date;
        [self updateBreakStartTimeDetailLabel];
    }else if(sender == _breakEndTimePicker) {
        _selectedBreakEndDate = _breakEndTimePicker.date;
        [self updateBreakEndTimeDetailLabel];
    }
}

#pragma mark - UISwitch Action
- (IBAction)includeBreakSwitchChange:(id)sender
{
    [self updateBreakStartTimeDetailLabel];
    [self updateBreakEndTimeDetailLabel];
    
    //If any break picker is open, close it
    if(_openPickerIndexPath && ([_openPickerIndexPath compare: kBreakStartsPickerIndexPath] == NSOrderedSame ||
                                [_openPickerIndexPath compare:kBreakEndsPickerIndexPath] == NSOrderedSame)){
        [_cellsToAnimateArray removeAllObjects];
        [_cellsToAnimateArray addObject:_openPickerIndexPath];
        
        _openPickerIndexPath = nil;
        
        //Start animation
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithArray:_cellsToAnimateArray] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }else{
        [self.tableView reloadRowsAtIndexPaths:@[kBreakStartsIndexPath, kBreakEndsIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UIPickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == _numberOfQHPStaffPicker){
        return [_numberOfQHPStaffOptionsArray count];
    }else if(pickerView == _numberOfAncillaryStaffPicker){
        return [_numberOfANCStaffOptionsArray count];
    }
    
    return 0;
}

#pragma mark - UIPickerView Delegate
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSNumber* value = nil;
    if(pickerView == _numberOfQHPStaffPicker){
        value = [_numberOfQHPStaffOptionsArray objectAtIndex:row];
    }else if(pickerView == _numberOfAncillaryStaffPicker){
        value = [_numberOfANCStaffOptionsArray objectAtIndex:row];
    }

    return [value stringValue];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == _numberOfQHPStaffPicker){
        _selectedNumberOfQHPStaff = [[_numberOfQHPStaffOptionsArray objectAtIndex:row] integerValue];
        [self updateNumberOfQHPStaffDetailLabel];
    }else if(pickerView == _numberOfAncillaryStaffPicker){
        _selectedNumberOfAncillaryStaff = [[_numberOfANCStaffOptionsArray objectAtIndex:row] integerValue];
        [self updateNumberOfAncillaryStaffDetailLabel];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (_staffToEdit) {
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    if([indexPath compare:kNumberOfQHPStaffIndexPath] == NSOrderedSame){
        height = (_staffToEdit) ? 0 : self.tableView.rowHeight;
    }else if([indexPath compare:kNumberOfQHPStaffPickerIndexPath] == NSOrderedSame){
        height = (_openPickerIndexPath && [_openPickerIndexPath compare:indexPath] == NSOrderedSame) ? 216 : 0;
    }else if([indexPath compare:kNumberOfAncillaryStaffIndexPath] == NSOrderedSame){
        height = (_staffToEdit) ? 0 : self.tableView.rowHeight;
    }else if([indexPath compare:kNumberOfAncillaryStaffPickerIndexPath] == NSOrderedSame){
        height = (_openPickerIndexPath && [_openPickerIndexPath compare:indexPath] == NSOrderedSame) ? 216 : 0;
    }else if([indexPath compare:kStaffTypeIndexPath] == NSOrderedSame){ height=0;
        //height = (_staffToEdit) ? self.tableView.rowHeight : 0;
    }else if([indexPath compare:kWorkStartsPickerIndexPath] == NSOrderedSame){
        height = (_openPickerIndexPath && [_openPickerIndexPath compare:indexPath] == NSOrderedSame) ? 216 : 0;
    }else if([indexPath compare:kWorkEndsPickerIndexPath] == NSOrderedSame){
        height = (_openPickerIndexPath && [_openPickerIndexPath compare:indexPath] == NSOrderedSame) ? 216 : 0;
    }else if([indexPath compare:kBreakStartsPickerIndexPath] == NSOrderedSame){
        height = (_openPickerIndexPath && [_openPickerIndexPath compare:indexPath] == NSOrderedSame) ? 216 : 0;
    }else if([indexPath compare:kBreakEndsPickerIndexPath] == NSOrderedSame){
        height = (_openPickerIndexPath && [_openPickerIndexPath compare:indexPath] == NSOrderedSame) ? 216 : 0;
    }else{
        height = self.tableView.rowHeight;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath compare:kClearHoursIndexPath] == NSOrderedSame){
        [self clearHours];
        return;
    }
    
    NSIndexPath* newOpenIndexPath = nil;
    
    //If selected index is above a picker, open the picker
    if([indexPath compare:kNumberOfQHPStaffIndexPath] == NSOrderedSame ||
       [indexPath compare:kNumberOfAncillaryStaffIndexPath] == NSOrderedSame ||
       [indexPath compare:kWorkStartsIndexPath] == NSOrderedSame ||
       [indexPath compare:kWorkEndsIndexPath] == NSOrderedSame){
        
        newOpenIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
        
    }else if([_includeBreakSwitch isOn] && ([indexPath compare:kBreakStartsIndexPath] == NSOrderedSame ||
                                            [indexPath compare:kBreakEndsIndexPath] == NSOrderedSame)){
        
        //Only open break pickers if _includeBreakSwitch is on
        newOpenIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
        
    }
    
    //Clear cell animation array
    [_cellsToAnimateArray removeAllObjects];
    
    if(newOpenIndexPath != nil){
        if(_openPickerIndexPath && [_openPickerIndexPath compare:newOpenIndexPath] == NSOrderedSame){
            //close open cell
            newOpenIndexPath = nil;
        }
        
        if(_openPickerIndexPath){
            [_cellsToAnimateArray addObject:_openPickerIndexPath];
            [self.tableView cellForRowAtIndexPath:_openPickerIndexPath].hidden=FALSE;
        }
        if(newOpenIndexPath){
            [_cellsToAnimateArray addObject:newOpenIndexPath];
            [self.tableView cellForRowAtIndexPath:newOpenIndexPath].hidden=FALSE;
        }
        
        _openPickerIndexPath = newOpenIndexPath;
        
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:_cellsToAnimateArray withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
        }];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath compare:kIncludeBreaksIndexPath] == NSOrderedSame){
        return NO;
    }
    
    return NO;
}*/

-(NSString*)analyticsIdentifier
{
    return @"add_edit_stff";
}

@end
