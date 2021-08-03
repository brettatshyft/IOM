//
//  AddEditChairsViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/10/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "AddEditChairsViewController.h"
#import "ListValues.h"
#import "Scenario+Extension.h"
#import "WeekdaysSelectionViewController.h"
#import "Chair+Extension.h"
#import "Constants.h"
#import "IOMAnalyticsManager.h"

//STATIC CONSTANTS
static NSIndexPath * kNumberOfChairsIndexPath;
static NSIndexPath * kNumberOfChairsPickerIndexPath;
static NSIndexPath * kWeekdaysIndexPath;
static NSIndexPath * kStartTimeIndexPath;
static NSIndexPath * kStartTimePickerIndexPath;
static NSIndexPath * kEndTimeIndexPath;
static NSIndexPath * kEndTimePickerIndexPath;
static NSIndexPath * kClearHoursIndexPath;

@interface AddEditChairsViewController ()<IOMAnalyticsIdentifiable>{
    
    NSArray* _numberOfChairsOptionsArray;
    NSDateFormatter* _timeFormatter;
    
    NSInteger _selectedNumberOfChairs;
    NSDate* _selectedStartDate;
    NSDate* _selectedEndDate;
    
    NSNumber* _weekdayBitMask;
    
    NSIndexPath* _openIndexPath;
}

@property (nonatomic, weak) IBOutlet UIPickerView* numberOfChairsPicker;
@property (nonatomic, weak) IBOutlet UIDatePicker* startTimePicker;
@property (nonatomic, weak) IBOutlet UIDatePicker* endTimePicker;

@property (nonatomic, weak) IBOutlet UILabel* numberOfChairsDetailLabel;
@property (nonatomic, weak) IBOutlet UILabel* weekdaysDetailLabel;
@property (nonatomic, weak) IBOutlet UILabel* startTimeDetailLabel;
@property (nonatomic, weak) IBOutlet UILabel* endTimeDetailLabel;

@end

@implementation AddEditChairsViewController

+ (void)initialize
{
    [super initialize];
    
    //Create static index paths to represent different static rows
    if(!kNumberOfChairsIndexPath){
        kNumberOfChairsIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    if(!kNumberOfChairsPickerIndexPath){
        kNumberOfChairsPickerIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    if(!kWeekdaysIndexPath){
        kWeekdaysIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    }
    if(!kStartTimeIndexPath){
        kStartTimeIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    if(!kStartTimePickerIndexPath){
        kStartTimePickerIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    }
    if(!kEndTimeIndexPath){
        kEndTimeIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    }
    if(!kEndTimePickerIndexPath){
        kEndTimePickerIndexPath = [NSIndexPath indexPathForRow:3 inSection:1];
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
    
    //Only show cancel button if there are chairs belonging to this scenario.
    if([_scenario.chairs count] > 0){
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonSelected:)];
        [self.navigationItem setLeftBarButtonItem:cancelButton];
    }
    
    //Done Button
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonSelected:)];
    [self.navigationItem setRightBarButtonItem:doneButton];
    
    //Date/Time Picker action callbacks
    [_startTimePicker addTarget:self action:@selector(datePickerDidChange:) forControlEvents:UIControlEventValueChanged];
    [_endTimePicker addTarget:self action:@selector(datePickerDidChange:) forControlEvents:UIControlEventValueChanged];
    
    //Date Formatter for start/end time
    _timeFormatter = [[NSDateFormatter alloc] init];
    [_timeFormatter setDateFormat:@"h:mm a"];
    
    [self setInitialValues];
    [self setNavigationTitle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[IOMAnalyticsManager shared] trackScreenView:self];

    [self updateAllDetailLabels];
    [self.tableView reloadData];
    
    [self.tableView cellForRowAtIndexPath:kNumberOfChairsPickerIndexPath].hidden=TRUE;
    [self.tableView cellForRowAtIndexPath:kStartTimePickerIndexPath].hidden=TRUE;
    [self.tableView cellForRowAtIndexPath:kEndTimePickerIndexPath].hidden=TRUE;
    
    if (_chairsToEdit)
        [self.tableView cellForRowAtIndexPath:kNumberOfChairsIndexPath].hidden=TRUE;
}

- (void)viewDidAppear:(BOOL)animated
{
    
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
    }
}

#pragma mark - Initialize and Update methods

- (void)setNavigationTitle
{
    //Set title for navigation bar
    if(_chairsToEdit){
        [self setTitle:@"Change Chair Hours"];
    }else{
        [self setTitle:@"Add New Chairs"];
    }
}

- (void)setInitialValues
{
    //if editing
    if (_chairsToEdit) {
        _weekdayBitMask = @0;

        /*
        if([_chairsToEdit count] == 1) {
            //Set values to those of single selected chair
            Chair* chair = [_chairsToEdit objectAtIndex:0];
            NSInteger weekdayMask = 0;
            if ([chair getTotalHoursForDay:0] > 0){
                weekdayMask = (weekdayMask | Sunday);
            }
            if ([chair getTotalHoursForDay:1] > 0){
                weekdayMask = (weekdayMask | Monday);
            }
            if ([chair getTotalHoursForDay:2] > 0){
                weekdayMask = (weekdayMask | Tuesday);
            }
            if ([chair getTotalHoursForDay:3] > 0){
                weekdayMask = (weekdayMask | Wednesday);
            }
            if ([chair getTotalHoursForDay:4] > 0){
                weekdayMask = (weekdayMask | Thursday);
            }
            if ([chair getTotalHoursForDay:5] > 0){
                weekdayMask = (weekdayMask | Friday);
            }
            if ([chair getTotalHoursForDay:6] > 0){
                weekdayMask = (weekdayMask | Saturday);
            }
            _weekdayBitMask = @(weekdayMask);
        } else {
            _weekdayBitMask = @0;
        }
        */
        
        _openIndexPath = nil;
        _numberOfChairsOptionsArray = LIST_VALUES_ARRAY_NUMBER_OF_CHAIRS;
        _selectedNumberOfChairs = 0;
        [self setInitialPickerValues];
    } else {
        //Initial values for instance variables
        _openIndexPath = nil;
        _numberOfChairsOptionsArray = LIST_VALUES_ARRAY_NUMBER_OF_CHAIRS;
        _selectedNumberOfChairs = 1;
        _weekdayBitMask = @(Monday|Tuesday|Wednesday|Thursday|Friday);
        [self setInitialPickerValues];
    }
}

- (void)setInitialPickerValues
{
    _selectedStartDate = [_timeFormatter dateFromString:@"8:00 am"];
    _selectedEndDate = [_timeFormatter dateFromString:@"5:00 pm"];
    [_startTimePicker setDate:_selectedStartDate];
    [_endTimePicker setDate:_selectedEndDate];
}

- (void)updateAllDetailLabels
{
    [self updateNumberOfChairsDetailLabel];
    [self updateWeekdaysDetailLabel];
    [self updateStartTimeDetailLabel];
    [self updateEndTimeDetailLabel];
}

- (void)updateNumberOfChairsDetailLabel
{
    [_numberOfChairsDetailLabel setText:[NSString stringWithFormat:@"%i", _selectedNumberOfChairs]];
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

- (void)updateStartTimeDetailLabel
{
    [_startTimeDetailLabel setText:[_timeFormatter stringFromDate:_selectedStartDate]];
}

- (void)updateEndTimeDetailLabel
{
    [_endTimeDetailLabel setText:[_timeFormatter stringFromDate:_selectedEndDate]];
}

- (void)dismissContainingPopover
{
    [_containingPopover dismissPopoverAnimated:YES];
    [_containingPopover.delegate popoverControllerDidDismissPopover:_containingPopover];
}

#pragma mark - Validation

- (BOOL)timesAreValid
{
    return (_selectedStartDate == nil && _selectedEndDate == nil) || ([_selectedStartDate compare:_selectedEndDate] != NSOrderedDescending && [_selectedStartDate compare:_selectedEndDate] != NSOrderedSame);
}

- (BOOL)daysAreValid
{
    return [_weekdayBitMask integerValue] != 0;
}

#pragma mark - IBActions
- (IBAction)cancelButtonSelected:(id)sender
{
    [self dismissContainingPopover];
}

- (IBAction)doneButtonSelected:(id)sender
{
    if(![self timesAreValid]){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Work Times" message:@"Start work time must be earlier than end work time." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if(![self daysAreValid]){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Weekdays" message:@"At least one weekday should be selected." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if(_chairsToEdit){
        [self finishEditingChairs];
    }else{
        [self finishAddingChairs];
    }
}

- (void)finishAddingChairs
{
    //Cannot add more than MAX_NUMBER_OF_CHAIRS
    _selectedNumberOfChairs = MIN(_selectedNumberOfChairs, (MAX_NUMBER_OF_CHAIRS - _currentNumberOfChairs));
    
    NSInteger bitmask = [_weekdayBitMask integerValue];
    for (int i = 0; i < _selectedNumberOfChairs; i++){
        Chair* chair = [Chair createChairEntityForScenario:_scenario];
        
        if (bitmask & Sunday){
            chair.startTime0 = _selectedStartDate;
            chair.endTime0 = _selectedEndDate;
        }
        if (bitmask & Monday){
            chair.startTime1 = _selectedStartDate;
            chair.endTime1 = _selectedEndDate;
        }
        if (bitmask & Tuesday){
            chair.startTime2 = _selectedStartDate;
            chair.endTime2 = _selectedEndDate;
        }
        if (bitmask & Wednesday){
            chair.startTime3 = _selectedStartDate;
            chair.endTime3 = _selectedEndDate;
        }
        if (bitmask & Thursday){
            chair.startTime4 = _selectedStartDate;
            chair.endTime4 = _selectedEndDate;
        }
        if (bitmask & Friday){
            chair.startTime5 = _selectedStartDate;
            chair.endTime5 = _selectedEndDate;
        }
        if (bitmask & Saturday){
            chair.startTime6 = _selectedStartDate;
            chair.endTime6 = _selectedEndDate;
        }
    }
    [self dismissContainingPopover];
}

- (void)finishEditingChairs
{
    NSInteger bitmask = [_weekdayBitMask integerValue];
    for (int i = 0; i < [_chairsToEdit count]; i++){
        Chair* chair = [_chairsToEdit objectAtIndex:i];
        
        if (bitmask & Sunday){
            chair.startTime0 = _selectedStartDate;
            chair.endTime0 = _selectedEndDate;
        }
        if (bitmask & Monday){
            chair.startTime1 = _selectedStartDate;
            chair.endTime1 = _selectedEndDate;
        }
        if (bitmask & Tuesday){
            chair.startTime2 = _selectedStartDate;
            chair.endTime2 = _selectedEndDate;
        }
        if (bitmask & Wednesday){
            chair.startTime3 = _selectedStartDate;
            chair.endTime3 = _selectedEndDate;
        }
        if (bitmask & Thursday){
            chair.startTime4 = _selectedStartDate;
            chair.endTime4 = _selectedEndDate;
        }
        if (bitmask & Friday){
            chair.startTime5 = _selectedStartDate;
            chair.endTime5 = _selectedEndDate;
        }
        if (bitmask & Saturday){
            chair.startTime6 = _selectedStartDate;
            chair.endTime6 = _selectedEndDate;
        }
    }
    [self dismissContainingPopover];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_chairsToEdit){
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if([kNumberOfChairsPickerIndexPath compare:indexPath] == NSOrderedSame || [kStartTimePickerIndexPath compare:indexPath] == NSOrderedSame || [kEndTimePickerIndexPath compare:indexPath] == NSOrderedSame){
        height = (_openIndexPath && [_openIndexPath compare:indexPath] == NSOrderedSame) ? 217 : 0;
    }else if([indexPath compare:kNumberOfChairsIndexPath] == NSOrderedSame){
        height = (_chairsToEdit) ? 0 : self.tableView.rowHeight;
    }else{
        height = self.tableView.rowHeight;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath compare:kClearHoursIndexPath] == NSOrderedSame){
        //TODO clear hours for selected weekdays
        _selectedStartDate = _selectedEndDate = nil;
        [self updateStartTimeDetailLabel];
        [self updateEndTimeDetailLabel];
        return;
    }
    
    NSIndexPath* newOpenIndexPath = nil;
    
    //detect if selected row is a row above a collapsable picker
    if([indexPath compare:kNumberOfChairsIndexPath] == NSOrderedSame || [indexPath compare:kStartTimeIndexPath] == NSOrderedSame || [indexPath compare:kEndTimeIndexPath] == NSOrderedSame){
        newOpenIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
    }
    
    if(newOpenIndexPath != nil){
        if (_openIndexPath && [_openIndexPath compare:newOpenIndexPath] == NSOrderedSame) {
            //Close open cell
            newOpenIndexPath = nil;
        }
        
        NSMutableArray* cellsToAnimate = [[NSMutableArray alloc] init];
        if(_openIndexPath){
            [cellsToAnimate addObject:_openIndexPath];
            [self.tableView cellForRowAtIndexPath:_openIndexPath].hidden=FALSE;
        }
        if(newOpenIndexPath){
            [cellsToAnimate addObject:newOpenIndexPath];
            [self.tableView cellForRowAtIndexPath:newOpenIndexPath].hidden=FALSE;
        }
        
        _openIndexPath = newOpenIndexPath;
        
        //Start animation
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithArray:cellsToAnimate] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
        }];
    }
}


#pragma mark - UIPickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == _numberOfChairsPicker){
        return [_numberOfChairsOptionsArray count];
    }
    
    return 0;
}

#pragma mark - UIPickerView Delegate
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSNumber* value = [_numberOfChairsOptionsArray objectAtIndex:row];
    return [NSString stringWithFormat:@"%@", value];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == _numberOfChairsPicker){
        _selectedNumberOfChairs = [[_numberOfChairsOptionsArray objectAtIndex:row] integerValue];
        [self updateNumberOfChairsDetailLabel];
    }
}

#pragma mark - UIDatePicker Action
- (IBAction)datePickerDidChange:(id)sender
{
    if (sender == _startTimePicker) {
        _selectedStartDate = _startTimePicker.date;
        NSLog(@"%@", _selectedStartDate);
        [self updateStartTimeDetailLabel];
    }else if(sender == _endTimePicker) {
        _selectedEndDate = _endTimePicker.date;
        
        /*
         *  SPECIAL INSTRUCTIONS -
         *  If selected end time is 12:00 AM, add 24 hours.
         *  This allows the user to select a time range of
         *  12:00AM - 12:00 AM
         */
        NSDate* endDay12 = [_timeFormatter dateFromString:@"12:00 am"];
        if ([_selectedEndDate isEqualToDate:endDay12]){
            _selectedEndDate = [_selectedEndDate dateByAddingTimeInterval:60*60*24];    //add 24 hours
        }
        
        NSLog(@"%@", _selectedEndDate);
        [self updateEndTimeDetailLabel];
    }
}

-(NSString*)analyticsIdentifier
{
    return @"add_edit_chairs";
}

@end
