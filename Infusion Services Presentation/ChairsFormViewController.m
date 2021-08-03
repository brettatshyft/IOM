//
//  ChairsViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/10/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "ChairsFormViewController.h"
#import "AddEditChairsViewController.h"
#import "ScenarioFormDataSource.h"
#import "Scenario+Extension.h"
#import "Chair+Extension.h"
#import "Colors.h"
#import "Constants.h"
#import "IOMAnalyticsManager.h"

#define TAG_CHAIRS_CELL_CHAIR_NAME 100
#define TAG_CHAIRS_CELL_START_1 201
#define TAG_CHAIRS_CELL_START_2 202
#define TAG_CHAIRS_CELL_START_3 203
#define TAG_CHAIRS_CELL_START_4 204
#define TAG_CHAIRS_CELL_START_5 205
#define TAG_CHAIRS_CELL_START_6 206
#define TAG_CHAIRS_CELL_START_7 207
#define TAG_CHAIRS_CELL_END_1 301
#define TAG_CHAIRS_CELL_END_2 302
#define TAG_CHAIRS_CELL_END_3 303
#define TAG_CHAIRS_CELL_END_4 304
#define TAG_CHAIRS_CELL_END_5 305
#define TAG_CHAIRS_CELL_END_6 306
#define TAG_CHAIRS_CELL_END_7 307
#define TAG_CHAIRS_CELL_TOTAL_1 401
#define TAG_CHAIRS_CELL_TOTAL_2 402
#define TAG_CHAIRS_CELL_TOTAL_3 403
#define TAG_CHAIRS_CELL_TOTAL_4 404
#define TAG_CHAIRS_CELL_TOTAL_5 405
#define TAG_CHAIRS_CELL_TOTAL_6 406
#define TAG_CHAIRS_CELL_TOTAL_7 407
#define TAG_CHAIRS_CELL_WEEK_TOTAL 501

@interface ChairsFormViewController ()<IOMAnalyticsIdentifiable>{
    UIStoryboard* _scenariosStoryboard;
    
    UIBarButtonItem * _editBarButton;
    UIBarButtonItem * _deleteBarButton;
    UIBarButtonItem * _selectAllBarButton;
    UIBarButtonItem * _spacer;
    
    NSDateFormatter* _dateFormatter;
    
    UIPopoverController* _currentPopoverController;
    
    NSArray* _chairsArray;
}

@property (nonatomic, weak) IBOutlet UIButton* addButton;
@property (nonatomic, weak) IBOutlet UIButton* editButton;
@property (nonatomic, weak) IBOutlet UILabel* chairHoursLabel;

@end

@implementation ChairsFormViewController
@synthesize scenario = _scenario;

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
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"h:mm a"];
    
    _scenariosStoryboard = [UIStoryboard storyboardWithName:@"ScenariosStoryboard" bundle:[NSBundle mainBundle]];
    
    [self updateChairsArray];
    [self updateChairHoursPerWeek];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[IOMAnalyticsManager shared] trackScreenView:self];

    if ([_chairsArray count] == 0) {
        [self addChairsButtonSelected:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Update Methods
- (void)updateChairHoursPerWeek
{
    double total = 0;
    for(int i = 0; i < [_chairsArray count]; i++){
        Chair * chair = [_chairsArray objectAtIndex:i];
        total += [chair getTotalHoursForDay:0];
        total += [chair getTotalHoursForDay:1];
        total += [chair getTotalHoursForDay:2];
        total += [chair getTotalHoursForDay:3];
        total += [chair getTotalHoursForDay:4];
        total += [chair getTotalHoursForDay:5];
        total += [chair getTotalHoursForDay:6];
    }
    
    [_chairHoursLabel setText:[NSString stringWithFormat:@"%.01f", total]];
}

- (void)updateChairsArray
{
    if(_scenario){
        NSSortDescriptor* displayOrderDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES];
        _chairsArray = [[_scenario.chairs allObjects] sortedArrayUsingDescriptors:@[displayOrderDescriptor]];
    }else{
        NSLog(@"Error: no scenario passed to chairs form!");
        _chairsArray = nil;
    }
}

#pragma mark - Toolbar
- (void)setupParentViewControllerToolbar
{
    if (!_selectAllBarButton) {
        _selectAllBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStyleBordered target:self action:@selector(selectAllToolbarButtonSelected:)];
    }
    if (!_editBarButton) {
        _editBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Change Chair Hours" style:UIBarButtonItemStyleBordered target:self action:@selector(editToolbarButtonSelected:)];
    }
    if (!_deleteBarButton) {
        _deleteBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteToolbarButtonSelected:)];
    }
    if (!_spacer) {
        _spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    
    self.parentViewController.toolbarItems = @[_selectAllBarButton, _spacer, _editBarButton, _spacer, _deleteBarButton];
}

- (UIPopoverController*)addEditChairPopoverControllerWithChairsToEdit:(NSArray*)chairsToEdit
{
    if(_currentPopoverController){
        if([_currentPopoverController isPopoverVisible]){
            [_currentPopoverController dismissPopoverAnimated:YES];
        }
        _currentPopoverController = nil;
    }
    
    AddEditChairsViewController* controller = [_scenariosStoryboard instantiateViewControllerWithIdentifier:@"addEditChairsMenu"];
    controller.scenario = _scenario;
    controller.chairsToEdit = chairsToEdit;
    controller.currentNumberOfChairs = [_chairsArray count];
    
    UINavigationController* popoverNavController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    _currentPopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverNavController];
    [_currentPopoverController setDelegate:self];
    
    controller.containingPopover = _currentPopoverController;
    
    return _currentPopoverController;
}

#pragma mark - IBActions
- (IBAction)addChairsButtonSelected:(id)sender
{
    if([_chairsArray count] >= MAX_NUMBER_OF_CHAIRS) {
        NSString * message = [NSString stringWithFormat:@"You cannot add more than %i chairs.", MAX_NUMBER_OF_CHAIRS];
        [[[UIAlertView alloc] initWithTitle:@"Limit Reached" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        return;
    }
    
    [_addButton setSelected:TRUE];
    
    UIPopoverController* popover = [self addEditChairPopoverControllerWithChairsToEdit:nil];
    [popover presentPopoverFromRect:_addButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (IBAction)editChairsButtonSelected:(id)sender
{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    NSString* editButtonTitle = (self.tableView.isEditing) ? @"Done" : @"Edit";
    [_editButton setTitle:editButtonTitle forState:UIControlStateNormal];
    [self.parentViewController.navigationController setToolbarHidden:!self.tableView.isEditing animated:YES];
    if(self.tableView.isEditing){
        [_addButton setUserInteractionEnabled:NO];
        [_addButton setImage:[UIImage imageNamed:@"AddButtonOff"] forState:UIControlStateNormal];
        [_editButton setSelected:TRUE];
    }else{
        [_addButton setUserInteractionEnabled:YES];
        UIImage* image = [UIImage imageNamed:@"AddButtonDark"];
        if(image == nil) NSLog(@"IMAGE IS NIL");
        [_addButton setImage:[UIImage imageNamed:@"AddButtonDark"] forState:UIControlStateNormal];
        [_editButton setSelected:FALSE];
    }
}

#pragma mark - UINavigationToolbar Button Actions
- (void)editToolbarButtonSelected:(id)sender
{
    //Create an array of all selected chairs
    NSArray* selectedRows = [self.tableView indexPathsForSelectedRows];
    NSMutableArray* chairsToEdit = [NSMutableArray array];
    for(NSIndexPath* indexPath in selectedRows)
    {
        Chair* chair = [_chairsArray objectAtIndex:indexPath.row];
        [chairsToEdit addObject:chair];
    }
    if([chairsToEdit count] > 0){
        //send chairs to edit popover
        UIPopoverController* popover = [self addEditChairPopoverControllerWithChairsToEdit:[NSArray arrayWithArray:chairsToEdit]];
        [popover presentPopoverFromBarButtonItem:_editBarButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }else{
        //Alert user that chairs need to be selected to edit
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Selection Error" message:@"Please select at least one chair to edit." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
        alertMessage = @"Delete chair?";
    } else {
        alertMessage = [NSString stringWithFormat:@"Delete %i chairs?", [selectedRows count]];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Delete" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil] show];
}

- (void)selectAllToolbarButtonSelected:(id)sender
{
    for (int i = 0; i < [_chairsArray count]; i++) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_chairsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChairCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.contentView.superview setBackgroundColor:[[Colors getInstance] lightBackgroundColor]];
    
    Chair * chair = [_chairsArray objectAtIndex:indexPath.row];
    
    // Configure the cell...
    UILabel* chairNameLabel = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_CHAIR_NAME];
    UILabel* startLabel1 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_START_1];
    UILabel* startLabel2 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_START_2];
    UILabel* startLabel3 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_START_3];
    UILabel* startLabel4 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_START_4];
    UILabel* startLabel5 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_START_5];
    UILabel* startLabel6 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_START_6];
    UILabel* startLabel7 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_START_7];
    UILabel* endLabel1 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_END_1];
    UILabel* endLabel2 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_END_2];
    UILabel* endLabel3 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_END_3];
    UILabel* endLabel4 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_END_4];
    UILabel* endLabel5 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_END_5];
    UILabel* endLabel6 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_END_6];
    UILabel* endLabel7 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_END_7];
    UILabel* totalLabel1 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_TOTAL_1];
    UILabel* totalLabel2 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_TOTAL_2];
    UILabel* totalLabel3 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_TOTAL_3];
    UILabel* totalLabel4 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_TOTAL_4];
    UILabel* totalLabel5 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_TOTAL_5];
    UILabel* totalLabel6 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_TOTAL_6];
    UILabel* totalLabel7 = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_TOTAL_7];
    UILabel* weekTotalLabel = (UILabel*)[cell viewWithTag:TAG_CHAIRS_CELL_WEEK_TOTAL];
    
    [chairNameLabel setText:[NSString stringWithFormat:@"Chair %i", indexPath.row + 1]];
    [startLabel1 setText:[_dateFormatter stringFromDate:chair.startTime0]];
    [startLabel2 setText:[_dateFormatter stringFromDate:chair.startTime1]];
    [startLabel3 setText:[_dateFormatter stringFromDate:chair.startTime2]];
    [startLabel4 setText:[_dateFormatter stringFromDate:chair.startTime3]];
    [startLabel5 setText:[_dateFormatter stringFromDate:chair.startTime4]];
    [startLabel6 setText:[_dateFormatter stringFromDate:chair.startTime5]];
    [startLabel7 setText:[_dateFormatter stringFromDate:chair.startTime6]];
    [endLabel1 setText:[_dateFormatter stringFromDate:chair.endTime0]];
    [endLabel2 setText:[_dateFormatter stringFromDate:chair.endTime1]];
    [endLabel3 setText:[_dateFormatter stringFromDate:chair.endTime2]];
    [endLabel4 setText:[_dateFormatter stringFromDate:chair.endTime3]];
    [endLabel5 setText:[_dateFormatter stringFromDate:chair.endTime4]];
    [endLabel6 setText:[_dateFormatter stringFromDate:chair.endTime5]];
    [endLabel7 setText:[_dateFormatter stringFromDate:chair.endTime6]];

    double total1 = [chair getTotalHoursForDay:0];
    double total2 = [chair getTotalHoursForDay:1];
    double total3 = [chair getTotalHoursForDay:2];
    double total4 = [chair getTotalHoursForDay:3];
    double total5 = [chair getTotalHoursForDay:4];
    double total6 = [chair getTotalHoursForDay:5];
    double total7 = [chair getTotalHoursForDay:6];
    double weekTotal = total1 +  total2 + total3 + total4 + total5 + total6 + total7;
    
    [totalLabel1 setText:[NSString stringWithFormat:@"%.01f", total1]];
    [totalLabel2 setText:[NSString stringWithFormat:@"%.01f", total2]];
    [totalLabel3 setText:[NSString stringWithFormat:@"%.01f", total3]];
    [totalLabel4 setText:[NSString stringWithFormat:@"%.01f", total4]];
    [totalLabel5 setText:[NSString stringWithFormat:@"%.01f", total5]];
    [totalLabel6 setText:[NSString stringWithFormat:@"%.01f", total6]];
    [totalLabel7 setText:[NSString stringWithFormat:@"%.01f", total7]];
    [weekTotalLabel setText:[NSString stringWithFormat:@"%.01f", weekTotal]];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma mark - UIPopoverController Delegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    if ([_chairsArray count] == 0) {
        return NO;
    }
    
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self updateChairsArray];
    [self updateChairHoursPerWeek];
    [self.tableView reloadData];
    _currentPopoverController = nil;
    [_addButton setSelected:FALSE];
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
    //Form is added, setup toolbar items for this view
    [self setupParentViewControllerToolbar];
}

- (void)formRemoved
{
    if([self.tableView isEditing])
    {
        //disable editing when form is removed
        [self editChairsButtonSelected:nil];
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

#pragma mark - UIAlertView Delegate Protocol
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] == buttonIndex)
        return;
        
    //Delete chairs
    NSArray* selectedRows = [self.tableView indexPathsForSelectedRows];
    
    for(NSIndexPath* indexPath in selectedRows)
    {
        //Delete chair
        Chair* chair = [_chairsArray objectAtIndex:indexPath.row];
        [chair.scenario removeChairsObject:chair];
        [chair.managedObjectContext deleteObject:chair];
    }
    [self updateChairsArray];
    [self updateChairHoursPerWeek];
    [self.tableView reloadData];
}

-(NSString*)analyticsIdentifier
{
    return @"chairs_form";
}

@end
