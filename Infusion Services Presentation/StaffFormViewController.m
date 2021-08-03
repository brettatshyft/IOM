//
//  StaffFormViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/13/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "StaffFormViewController.h"
#import "Scenario+Extension.h"
#import "Staff+Extension.h"
#import "AddEditStaffViewController.h"
#import "StaffTypeSelectionViewController.h"
#import "Colors.h"
#import "Constants.h"
#import "IOMAnalyticsManager.h"

#define STAFF_CELL_NAME_LABEL_TAG 101
#define STAFF_CELL_TYPE_LABEL_TAG 102
#define STAFF_CELL_WORK_START_1_LABEL_TAG 201
#define STAFF_CELL_WORK_START_2_LABEL_TAG 202
#define STAFF_CELL_WORK_START_3_LABEL_TAG 203
#define STAFF_CELL_WORK_START_4_LABEL_TAG 204
#define STAFF_CELL_WORK_START_5_LABEL_TAG 205
#define STAFF_CELL_WORK_START_6_LABEL_TAG 206
#define STAFF_CELL_WORK_START_7_LABEL_TAG 207
#define STAFF_CELL_BREAK_START_1_LABEL_TAG 301
#define STAFF_CELL_BREAK_START_2_LABEL_TAG 302
#define STAFF_CELL_BREAK_START_3_LABEL_TAG 303
#define STAFF_CELL_BREAK_START_4_LABEL_TAG 304
#define STAFF_CELL_BREAK_START_5_LABEL_TAG 305
#define STAFF_CELL_BREAK_START_6_LABEL_TAG 306
#define STAFF_CELL_BREAK_START_7_LABEL_TAG 307
#define STAFF_CELL_BREAK_END_1_LABEL_TAG 401
#define STAFF_CELL_BREAK_END_2_LABEL_TAG 402
#define STAFF_CELL_BREAK_END_3_LABEL_TAG 403
#define STAFF_CELL_BREAK_END_4_LABEL_TAG 404
#define STAFF_CELL_BREAK_END_5_LABEL_TAG 405
#define STAFF_CELL_BREAK_END_6_LABEL_TAG 406
#define STAFF_CELL_BREAK_END_7_LABEL_TAG 407
#define STAFF_CELL_WORK_END_1_LABEL_TAG 501
#define STAFF_CELL_WORK_END_2_LABEL_TAG 502
#define STAFF_CELL_WORK_END_3_LABEL_TAG 503
#define STAFF_CELL_WORK_END_4_LABEL_TAG 504
#define STAFF_CELL_WORK_END_5_LABEL_TAG 505
#define STAFF_CELL_WORK_END_6_LABEL_TAG 506
#define STAFF_CELL_WORK_END_7_LABEL_TAG 507
#define STAFF_CELL_TOTAL_HOURS_1_LABEL_TAG 601
#define STAFF_CELL_TOTAL_HOURS_2_LABEL_TAG 602
#define STAFF_CELL_TOTAL_HOURS_3_LABEL_TAG 603
#define STAFF_CELL_TOTAL_HOURS_4_LABEL_TAG 604
#define STAFF_CELL_TOTAL_HOURS_5_LABEL_TAG 605
#define STAFF_CELL_TOTAL_HOURS_6_LABEL_TAG 606
#define STAFF_CELL_TOTAL_HOURS_7_LABEL_TAG 607
#define STAFF_CELL_WEEK_TOTAL_HOURS_LABEL_TAG 608

#define STAFF_INFO_CELL_QHP_HOURS_1_LABEL_TAG 201
#define STAFF_INFO_CELL_QHP_HOURS_2_LABEL_TAG 202
#define STAFF_INFO_CELL_QHP_HOURS_3_LABEL_TAG 203
#define STAFF_INFO_CELL_QHP_HOURS_4_LABEL_TAG 204
#define STAFF_INFO_CELL_QHP_HOURS_5_LABEL_TAG 205
#define STAFF_INFO_CELL_QHP_HOURS_6_LABEL_TAG 206
#define STAFF_INFO_CELL_QHP_HOURS_7_LABEL_TAG 207
#define STAFF_INFO_CELL_ANCILLARY_HOURS_1_LABEL_TAG 301
#define STAFF_INFO_CELL_ANCILLARY_HOURS_2_LABEL_TAG 302
#define STAFF_INFO_CELL_ANCILLARY_HOURS_3_LABEL_TAG 303
#define STAFF_INFO_CELL_ANCILLARY_HOURS_4_LABEL_TAG 304
#define STAFF_INFO_CELL_ANCILLARY_HOURS_5_LABEL_TAG 305
#define STAFF_INFO_CELL_ANCILLARY_HOURS_6_LABEL_TAG 306
#define STAFF_INFO_CELL_ANCILLARY_HOURS_7_LABEL_TAG 307
#define STAFF_INFO_CELL_TOTAL_HOURS_1_LABEL_TAG 601
#define STAFF_INFO_CELL_TOTAL_HOURS_2_LABEL_TAG 602
#define STAFF_INFO_CELL_TOTAL_HOURS_3_LABEL_TAG 603
#define STAFF_INFO_CELL_TOTAL_HOURS_4_LABEL_TAG 604
#define STAFF_INFO_CELL_TOTAL_HOURS_5_LABEL_TAG 605
#define STAFF_INFO_CELL_TOTAL_HOURS_6_LABEL_TAG 606
#define STAFF_INFO_CELL_TOTAL_HOURS_7_LABEL_TAG 607
#define STAFF_INFO_CELL_WEEK_TOTAL_HOURS_LABEL_TAG 608

@interface StaffFormViewController ()<IOMAnalyticsIdentifiable>{
    
    UIStoryboard* _scenariosStoryboard;
    
    UIBarButtonItem * _typeBarButton;
    UIBarButtonItem * _editBarButton;
    UIBarButtonItem * _deleteBarButton;
    UIBarButtonItem * _selectAllBarButton;
    UIBarButtonItem * _spacer;
    
    NSArray* _arrayOfStaff;
    NSDateFormatter* _timeFormatter;
    
    UIPopoverController* _currentPopoverController;
}

@property (nonatomic, weak) IBOutlet UILabel* fullTimeEquivalentLabel;
@property (nonatomic, weak) IBOutlet UIButton* addStaffButton;
@property (nonatomic, weak) IBOutlet UIButton* editStaffButton;
@property (nonatomic, weak) IBOutlet UITableView* tableView;

@end

@implementation StaffFormViewController
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
    
    _scenariosStoryboard = [UIStoryboard storyboardWithName:@"ScenariosStoryboard" bundle:[NSBundle mainBundle]];
    
    _timeFormatter = [[NSDateFormatter alloc] init];
    [_timeFormatter setDateFormat:@"h:mm a"];
    
    [self updateArrayOfStaff];
    [self updateFullTimeEquivalentLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
    if([_scenario.staff count] == 0){
        [self addStaffButtonSelected:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Update Methods

- (void) updateFullTimeEquivalentLabel
{
    double totalHours = 0;
    for (int i = 0; i < [_arrayOfStaff count]; i++) {
        Staff* staff = [_arrayOfStaff objectAtIndex:i];
        totalHours += [staff getTotalHoursForDay:0];
        totalHours += [staff getTotalHoursForDay:1];
        totalHours += [staff getTotalHoursForDay:2];
        totalHours += [staff getTotalHoursForDay:3];
        totalHours += [staff getTotalHoursForDay:4];
        totalHours += [staff getTotalHoursForDay:5];
        totalHours += [staff getTotalHoursForDay:6];
    }
    
    [_fullTimeEquivalentLabel setText:[NSString stringWithFormat:@"%.01f", (totalHours/40.0f)]];
}

- (void)updateArrayOfStaff
{
    if (_scenario) {
        NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES];
        _arrayOfStaff = [[_scenario.staff allObjects] sortedArrayUsingDescriptors:@[sort]];
    }else{
        NSLog(@"Error: Scenario property not set in StaffFormController!");
    }
}

#pragma mark - Toolbar
- (void)setupParentViewControllerToolbar
{
    if (!_selectAllBarButton) {
        _selectAllBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStyleBordered target:self action:@selector(selectAllToolbarButtonSelected:)];
    }
    if(!_typeBarButton){
        _typeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Change Staff Type" style:UIBarButtonItemStyleBordered target:self action:@selector(typeToolbarButtonSelected:)];
    }
    if(!_editBarButton){
        _editBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Change Staff Hours" style:UIBarButtonItemStyleBordered target:self action:@selector(editToolbarButtonSelected:)];
    }
    if(!_deleteBarButton){
        _deleteBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteToolbarButtonSelected:)];
    }
    if(!_spacer){
        _spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    
    self.parentViewController.toolbarItems = @[_selectAllBarButton, _spacer, _typeBarButton, _spacer, _editBarButton, _spacer, _deleteBarButton];
}

- (UIPopoverController*)addEditStaffPopoverControllerWithStaffToEdit:(NSArray*)staffToEdit
{
    if(_currentPopoverController){
        if([_currentPopoverController isPopoverVisible]){
            [_currentPopoverController dismissPopoverAnimated:YES];
        }
        _currentPopoverController = nil;
    }
    
    AddEditStaffViewController* controller = [_scenariosStoryboard instantiateViewControllerWithIdentifier:@"addEditStaffMenu"];
    controller.scenario = _scenario;
    controller.staffToEdit = staffToEdit;
    controller.currentNumberOfStaff = [_arrayOfStaff count];
    
    UINavigationController* popoverNavController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    _currentPopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverNavController];
    [_currentPopoverController setDelegate:self];
    
    controller.containingPopover = _currentPopoverController;
    
    return _currentPopoverController;
}

#pragma mark - IBActions
- (IBAction)addStaffButtonSelected:(id)sender
{
    if([_arrayOfStaff count] >= MAX_NUMBER_OF_STAFF) {
        NSString * message = [NSString stringWithFormat:@"You cannot add more than %i staff members.", MAX_NUMBER_OF_STAFF];
        [[[UIAlertView alloc] initWithTitle:@"Limit Reached" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        return;
    }
    
    [_addStaffButton setSelected:TRUE];
    
    UIPopoverController* popover = [self addEditStaffPopoverControllerWithStaffToEdit:nil];
    [popover presentPopoverFromRect:_addStaffButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)editStaffButtonSelected:(id)sender
{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    NSString* editButtonTitle = (self.tableView.isEditing) ? @"Done" : @"Edit";
    [_editStaffButton setTitle:editButtonTitle forState:UIControlStateNormal];
    [self.parentViewController.navigationController setToolbarHidden:!self.tableView.isEditing animated:YES];
    if(self.tableView.isEditing){
        [_addStaffButton setUserInteractionEnabled:NO];
        [_addStaffButton setImage:[UIImage imageNamed:@"AddButtonOff"] forState:UIControlStateNormal];
        [_editStaffButton setSelected:TRUE];
    }else{
        [_addStaffButton setUserInteractionEnabled:YES];
        [_addStaffButton setImage:[UIImage imageNamed:@"AddButtonDark"] forState:UIControlStateNormal];
        [_editStaffButton setSelected:FALSE];
    }
}

#pragma mark - Toolbar Actions
- (void)typeToolbarButtonSelected:(id)sender
{
    //Create an array of all selected chairs
    NSArray* selectedRows = [self.tableView indexPathsForSelectedRows];
    NSMutableArray* staffToEdit = [NSMutableArray array];
    
    for(NSIndexPath* indexPath in selectedRows)
    {
        Staff* staff = [_arrayOfStaff objectAtIndex:indexPath.row - 1]; //subtract 1 because first row is not a staff object, it is the staff information overview cell.
        [staffToEdit addObject:staff];
    }
    
    if([staffToEdit count] > 0){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Change Staff Type" message:@"Please select the staff type." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"QHP", @"Ancillary", nil];
        [alertView show];
    }else{
        //Alert user that chairs need to be selected to edit
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Selection Error" message:@"Please select at least one staff member to edit." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)editToolbarButtonSelected:(id)sender
{
    //Create an array of all selected chairs
    NSArray* selectedRows = [self.tableView indexPathsForSelectedRows];
    NSMutableArray* staffToEdit = [NSMutableArray array];
    
    for(NSIndexPath* indexPath in selectedRows)
    {
        Staff* staff = [_arrayOfStaff objectAtIndex:indexPath.row - 1]; //subtract 1 because first row is not a staff object, it is the staff information overview cell.
        [staffToEdit addObject:staff];
    }
    
    if([staffToEdit count] > 0){
        UIPopoverController* popover = [self addEditStaffPopoverControllerWithStaffToEdit:staffToEdit];
        [popover presentPopoverFromBarButtonItem:_editBarButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        //Alert user that chairs need to be selected to edit
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Selection Error" message:@"Please select at least one staff member to edit." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)deleteToolbarButtonSelected:(id)sender
{
    NSArray* selectedRows = [self.tableView indexPathsForSelectedRows];
    if ([selectedRows count] == 0)
        return;
    
    NSString* alertMessage = nil;
    if ([selectedRows count] == 1) {
        alertMessage = @"Delete staff?";
    } else {
        alertMessage = [NSString stringWithFormat:@"Delete %i staff?", [selectedRows count]];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Delete" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil] show];
}

- (void)selectAllToolbarButtonSelected:(id)sender
{
    for (int i = 1; i < [_arrayOfStaff count] + 1; i++) {   //Start at one because first row is not selectable!
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 202;
    } else {
        return 262;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_arrayOfStaff count] == 0) {
        return 0;
    }
    return [_arrayOfStaff count] + 1;   //We add one for the staff information cell
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *staffCellIdentifier = @"staffCell";
    static NSString *staffInfoCellIdentifier = @"staffInformationCell";
    
    UITableViewCell *cell = nil;
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:staffInfoCellIdentifier forIndexPath:indexPath];
        
        UILabel* qhp1Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_QHP_HOURS_1_LABEL_TAG];
        UILabel* qhp2Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_QHP_HOURS_2_LABEL_TAG];
        UILabel* qhp3Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_QHP_HOURS_3_LABEL_TAG];
        UILabel* qhp4Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_QHP_HOURS_4_LABEL_TAG];
        UILabel* qhp5Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_QHP_HOURS_5_LABEL_TAG];
        UILabel* qhp6Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_QHP_HOURS_6_LABEL_TAG];
        UILabel* qhp7Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_QHP_HOURS_7_LABEL_TAG];
        UILabel* ancillary1Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_ANCILLARY_HOURS_1_LABEL_TAG];
        UILabel* ancillary2Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_ANCILLARY_HOURS_2_LABEL_TAG];
        UILabel* ancillary3Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_ANCILLARY_HOURS_3_LABEL_TAG];
        UILabel* ancillary4Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_ANCILLARY_HOURS_4_LABEL_TAG];
        UILabel* ancillary5Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_ANCILLARY_HOURS_5_LABEL_TAG];
        UILabel* ancillary6Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_ANCILLARY_HOURS_6_LABEL_TAG];
        UILabel* ancillary7Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_ANCILLARY_HOURS_7_LABEL_TAG];
        UILabel* totalHours1Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_TOTAL_HOURS_1_LABEL_TAG];
        UILabel* totalHours2Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_TOTAL_HOURS_2_LABEL_TAG];
        UILabel* totalHours3Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_TOTAL_HOURS_3_LABEL_TAG];
        UILabel* totalHours4Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_TOTAL_HOURS_4_LABEL_TAG];
        UILabel* totalHours5Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_TOTAL_HOURS_5_LABEL_TAG];
        UILabel* totalHours6Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_TOTAL_HOURS_6_LABEL_TAG];
        UILabel* totalHours7Label = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_TOTAL_HOURS_7_LABEL_TAG];
        UILabel* weekTotalLabel = (UILabel*)[cell viewWithTag:STAFF_INFO_CELL_WEEK_TOTAL_HOURS_LABEL_TAG];
        
        double qhpHours1 = 0;
        double qhpHours2 = 0;
        double qhpHours3 = 0;
        double qhpHours4 = 0;
        double qhpHours5 = 0;
        double qhpHours6 = 0;
        double qhpHours7 = 0;
        double ancillaryHours1 = 0;
        double ancillaryHours2 = 0;
        double ancillaryHours3 = 0;
        double ancillaryHours4 = 0;
        double ancillaryHours5 = 0;
        double ancillaryHours6 = 0;
        double ancillaryHours7 = 0;
        
        for (int i = 0; i < [_arrayOfStaff count]; i++) {
            Staff* staff = [_arrayOfStaff objectAtIndex:i];
            if([staff.staffTypeID integerValue] == StaffTypeQHP){
                //qhp hours
                qhpHours1 += [staff getTotalHoursForDay:0];
                qhpHours2 += [staff getTotalHoursForDay:1];
                qhpHours3 += [staff getTotalHoursForDay:2];
                qhpHours4 += [staff getTotalHoursForDay:3];
                qhpHours5 += [staff getTotalHoursForDay:4];
                qhpHours6 += [staff getTotalHoursForDay:5];
                qhpHours7 += [staff getTotalHoursForDay:6];
            }else{
                //ancillary hours
                ancillaryHours1 += [staff getTotalHoursForDay:0];
                ancillaryHours2 += [staff getTotalHoursForDay:1];
                ancillaryHours3 += [staff getTotalHoursForDay:2];
                ancillaryHours4 += [staff getTotalHoursForDay:3];
                ancillaryHours5 += [staff getTotalHoursForDay:4];
                ancillaryHours6 += [staff getTotalHoursForDay:5];
                ancillaryHours7 += [staff getTotalHoursForDay:6];
            }
        }
        
        [qhp1Label setText:[NSString stringWithFormat:@"%.01f", qhpHours1]];
        [qhp2Label setText:[NSString stringWithFormat:@"%.01f", qhpHours2]];
        [qhp3Label setText:[NSString stringWithFormat:@"%.01f", qhpHours3]];
        [qhp4Label setText:[NSString stringWithFormat:@"%.01f", qhpHours4]];
        [qhp5Label setText:[NSString stringWithFormat:@"%.01f", qhpHours5]];
        [qhp6Label setText:[NSString stringWithFormat:@"%.01f", qhpHours6]];
        [qhp7Label setText:[NSString stringWithFormat:@"%.01f", qhpHours7]];
        
        [ancillary1Label setText:[NSString stringWithFormat:@"%.01f", ancillaryHours1]];
        [ancillary2Label setText:[NSString stringWithFormat:@"%.01f", ancillaryHours2]];
        [ancillary3Label setText:[NSString stringWithFormat:@"%.01f", ancillaryHours3]];
        [ancillary4Label setText:[NSString stringWithFormat:@"%.01f", ancillaryHours4]];
        [ancillary5Label setText:[NSString stringWithFormat:@"%.01f", ancillaryHours5]];
        [ancillary6Label setText:[NSString stringWithFormat:@"%.01f", ancillaryHours6]];
        [ancillary7Label setText:[NSString stringWithFormat:@"%.01f", ancillaryHours7]];
        
        [totalHours1Label setText:[NSString stringWithFormat:@"%.01f", (qhpHours1 + ancillaryHours1)]];
        [totalHours2Label setText:[NSString stringWithFormat:@"%.01f", (qhpHours2 + ancillaryHours2)]];
        [totalHours3Label setText:[NSString stringWithFormat:@"%.01f", (qhpHours3 + ancillaryHours3)]];
        [totalHours4Label setText:[NSString stringWithFormat:@"%.01f", (qhpHours4 + ancillaryHours4)]];
        [totalHours5Label setText:[NSString stringWithFormat:@"%.01f", (qhpHours5 + ancillaryHours5)]];
        [totalHours6Label setText:[NSString stringWithFormat:@"%.01f", (qhpHours6 + ancillaryHours6)]];
        [totalHours7Label setText:[NSString stringWithFormat:@"%.01f", (qhpHours7 + ancillaryHours7)]];
        
        double weekTotal = (qhpHours1 + ancillaryHours1) + (qhpHours2 + ancillaryHours2) + (qhpHours3 + ancillaryHours3) + (qhpHours4 + ancillaryHours4) + (qhpHours5 + ancillaryHours5) + (qhpHours6 + ancillaryHours6) + (qhpHours7 + ancillaryHours7);
        [weekTotalLabel setText:[NSString stringWithFormat:@"%.01f", weekTotal]];
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:staffCellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        Staff* staff = [_arrayOfStaff objectAtIndex:indexPath.row - 1]; //subtract one because first cell at row 0 is the staff information overview cell.
        
        //Get labels
        UILabel* staffNameLabel = (UILabel*)[cell viewWithTag:STAFF_CELL_NAME_LABEL_TAG];
        UILabel* staffTypeLabel = (UILabel*)[cell viewWithTag:STAFF_CELL_TYPE_LABEL_TAG];
        UILabel* workStart1Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_START_1_LABEL_TAG];
        UILabel* workStart2Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_START_2_LABEL_TAG];
        UILabel* workStart3Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_START_3_LABEL_TAG];
        UILabel* workStart4Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_START_4_LABEL_TAG];
        UILabel* workStart5Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_START_5_LABEL_TAG];
        UILabel* workStart6Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_START_6_LABEL_TAG];
        UILabel* workStart7Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_START_7_LABEL_TAG];
        UILabel* workEnd1Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_END_1_LABEL_TAG];
        UILabel* workEnd2Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_END_2_LABEL_TAG];
        UILabel* workEnd3Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_END_3_LABEL_TAG];
        UILabel* workEnd4Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_END_4_LABEL_TAG];
        UILabel* workEnd5Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_END_5_LABEL_TAG];
        UILabel* workEnd6Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_END_6_LABEL_TAG];
        UILabel* workEnd7Label = (UILabel*)[cell viewWithTag:STAFF_CELL_WORK_END_7_LABEL_TAG];
        UILabel* breakStart1Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_START_1_LABEL_TAG];
        UILabel* breakStart2Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_START_2_LABEL_TAG];
        UILabel* breakStart3Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_START_3_LABEL_TAG];
        UILabel* breakStart4Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_START_4_LABEL_TAG];
        UILabel* breakStart5Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_START_5_LABEL_TAG];
        UILabel* breakStart6Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_START_6_LABEL_TAG];
        UILabel* breakStart7Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_START_7_LABEL_TAG];
        UILabel* breakEnd1Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_END_1_LABEL_TAG];
        UILabel* breakEnd2Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_END_2_LABEL_TAG];
        UILabel* breakEnd3Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_END_3_LABEL_TAG];
        UILabel* breakEnd4Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_END_4_LABEL_TAG];
        UILabel* breakEnd5Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_END_5_LABEL_TAG];
        UILabel* breakEnd6Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_END_6_LABEL_TAG];
        UILabel* breakEnd7Label = (UILabel*)[cell viewWithTag:STAFF_CELL_BREAK_END_7_LABEL_TAG];
        UILabel* totalHours1Label = (UILabel*)[cell viewWithTag:STAFF_CELL_TOTAL_HOURS_1_LABEL_TAG];
        UILabel* totalHours2Label = (UILabel*)[cell viewWithTag:STAFF_CELL_TOTAL_HOURS_2_LABEL_TAG];
        UILabel* totalHours3Label = (UILabel*)[cell viewWithTag:STAFF_CELL_TOTAL_HOURS_3_LABEL_TAG];
        UILabel* totalHours4Label = (UILabel*)[cell viewWithTag:STAFF_CELL_TOTAL_HOURS_4_LABEL_TAG];
        UILabel* totalHours5Label = (UILabel*)[cell viewWithTag:STAFF_CELL_TOTAL_HOURS_5_LABEL_TAG];
        UILabel* totalHours6Label = (UILabel*)[cell viewWithTag:STAFF_CELL_TOTAL_HOURS_6_LABEL_TAG];
        UILabel* totalHours7Label = (UILabel*)[cell viewWithTag:STAFF_CELL_TOTAL_HOURS_7_LABEL_TAG];
        UILabel* weekTotalHoursLabel = (UILabel*)[cell viewWithTag:STAFF_CELL_WEEK_TOTAL_HOURS_LABEL_TAG];
        
        [staffNameLabel setText:[NSString stringWithFormat:@"Staff %i", indexPath.row]];
        [staffTypeLabel setText:(([staff.staffTypeID integerValue] == StaffTypeQHP) ? @"QHP" : @"Ancillary")];
        [workStart1Label setText:[_timeFormatter stringFromDate:staff.workStartTime0]];
        [workStart2Label setText:[_timeFormatter stringFromDate:staff.workStartTime1]];
        [workStart3Label setText:[_timeFormatter stringFromDate:staff.workStartTime2]];
        [workStart4Label setText:[_timeFormatter stringFromDate:staff.workStartTime3]];
        [workStart5Label setText:[_timeFormatter stringFromDate:staff.workStartTime4]];
        [workStart6Label setText:[_timeFormatter stringFromDate:staff.workStartTime5]];
        [workStart7Label setText:[_timeFormatter stringFromDate:staff.workStartTime6]];
        [workEnd1Label setText:[_timeFormatter stringFromDate:staff.workEndTime0]];
        [workEnd2Label setText:[_timeFormatter stringFromDate:staff.workEndTime1]];
        [workEnd3Label setText:[_timeFormatter stringFromDate:staff.workEndTime2]];
        [workEnd4Label setText:[_timeFormatter stringFromDate:staff.workEndTime3]];
        [workEnd5Label setText:[_timeFormatter stringFromDate:staff.workEndTime4]];
        [workEnd6Label setText:[_timeFormatter stringFromDate:staff.workEndTime5]];
        [workEnd7Label setText:[_timeFormatter stringFromDate:staff.workEndTime6]];
        [breakStart1Label setText:[_timeFormatter stringFromDate:staff.breakStartTime0]];
        [breakStart2Label setText:[_timeFormatter stringFromDate:staff.breakStartTime1]];
        [breakStart3Label setText:[_timeFormatter stringFromDate:staff.breakStartTime2]];
        [breakStart4Label setText:[_timeFormatter stringFromDate:staff.breakStartTime3]];
        [breakStart5Label setText:[_timeFormatter stringFromDate:staff.breakStartTime4]];
        [breakStart6Label setText:[_timeFormatter stringFromDate:staff.breakStartTime5]];
        [breakStart7Label setText:[_timeFormatter stringFromDate:staff.breakStartTime6]];
        [breakEnd1Label setText:[_timeFormatter stringFromDate:staff.breakEndTime0]];
        [breakEnd2Label setText:[_timeFormatter stringFromDate:staff.breakEndTime1]];
        [breakEnd3Label setText:[_timeFormatter stringFromDate:staff.breakEndTime2]];
        [breakEnd4Label setText:[_timeFormatter stringFromDate:staff.breakEndTime3]];
        [breakEnd5Label setText:[_timeFormatter stringFromDate:staff.breakEndTime4]];
        [breakEnd6Label setText:[_timeFormatter stringFromDate:staff.breakEndTime5]];
        [breakEnd7Label setText:[_timeFormatter stringFromDate:staff.breakEndTime6]];
        
        double work1Hours = [staff getTotalHoursForDay:0];
        double work2Hours = [staff getTotalHoursForDay:1];
        double work3Hours = [staff getTotalHoursForDay:2];
        double work4Hours = [staff getTotalHoursForDay:3];
        double work5Hours = [staff getTotalHoursForDay:4];
        double work6Hours = [staff getTotalHoursForDay:5];
        double work7Hours = [staff getTotalHoursForDay:6];
        [totalHours1Label setText:[NSString stringWithFormat:@"%.01f", work1Hours]];
        [totalHours2Label setText:[NSString stringWithFormat:@"%.01f", work2Hours]];
        [totalHours3Label setText:[NSString stringWithFormat:@"%.01f", work3Hours]];
        [totalHours4Label setText:[NSString stringWithFormat:@"%.01f", work4Hours]];
        [totalHours5Label setText:[NSString stringWithFormat:@"%.01f", work5Hours]];
        [totalHours6Label setText:[NSString stringWithFormat:@"%.01f", work6Hours]];
        [totalHours7Label setText:[NSString stringWithFormat:@"%.01f", work7Hours]];
        
        double totalHours = work1Hours + work2Hours + work3Hours + work4Hours + work5Hours + work6Hours + work7Hours;

        [weekTotalHoursLabel setText:[NSString stringWithFormat:@"%.01f", totalHours]];
    }
    
    [cell.contentView.superview setBackgroundColor:[[Colors getInstance] lightBackgroundColor]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row != 0);
}

#pragma mark - UIPopoverController Delegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    if ([_arrayOfStaff count] == 0) {
        return NO;
    }
    
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self updateArrayOfStaff];
    [self updateFullTimeEquivalentLabel];
    [self.tableView reloadData];
    _currentPopoverController = nil;
    [_addStaffButton setSelected:FALSE];
}

#pragma mark - ChildViewController Methods
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil) {
        //removed
        [self formRemoved];
    } else {
        //Added
        [self formAdded];
    }
}

- (void)formAdded
{
    [self setupParentViewControllerToolbar];
}

- (void)formRemoved
{
    if([self.tableView isEditing])
    {
        //disable editing when form is removed
        [self editStaffButtonSelected:nil];
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

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] == buttonIndex)
        return;
    
    NSArray* selectedRows = [self.tableView indexPathsForSelectedRows];
    
    for(NSIndexPath* indexPath in selectedRows)
    {
        Staff* staff = [_arrayOfStaff objectAtIndex:indexPath.row - 1]; //subtract 1 because first row is not a staff object, it is the staff information overview cell.
        
        if ([alertView.title isEqualToString:@"Delete"])
        {
            //Delete staff
            NSLog(@"Delete Staff");
            [staff.scenario removeStaffObject:staff];
            [staff.managedObjectContext deleteObject:staff];
        } else {
            //Change staff type
            NSLog(@"Change Staff Type: %d", buttonIndex);
            if (buttonIndex==1)
            {
                //QHP
                staff.staffTypeID=[NSNumber numberWithInt:StaffTypeQHP];
            } else {
                //Ancillary
                staff.staffTypeID=[NSNumber numberWithInt:StaffTypeAncillary];
            }
        }
    }
    
    [self updateArrayOfStaff];
    [self updateFullTimeEquivalentLabel];
    [self.tableView reloadData];
}

-(NSString*)analyticsIdentifier
{
    return @"staff_form";
}

@end
