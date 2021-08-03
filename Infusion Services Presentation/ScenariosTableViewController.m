//
//  ScenariosTableViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/9/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "ScenariosTableViewController.h"
#import "AppDelegate.h"
#import "Presentation+Extension.h"
//#import "AddEditStaffViewController.h"
#import "Scenario+Extension.h"
#import "ScenarioEditingViewController.h"
#import "Colors.h"
#import "IOMAnalyticsManager.h"

#define TAG_SCENARIO_TABLE_CELL_NAME_LABEL 101
#define TAG_SCENARIO_TABLE_CELL_DATE_CREATED_LABEL 102
#define TAG_SCENARIO_TABLE_CELL_DATE_LAST_UPDATED_LABEL 103

#define ALERT_TAG_DUPLICATE 1
#define ALERT_TAG_DELETE 2

#define TEST_PRESENTATION_NAME @"testScenariosPresentation"

@interface ScenariosTableViewController ()<IOMAnalyticsIdentifiable>{
    NSDateFormatter* _scenarioDateFormatter;
    NSArray* _arrayOfScenarios;
    NSSortDescriptor* _scenarioSortDescriptor;
    NSManagedObjectContext* _context;
    
    Scenario* _scenarioToEdit;
    
    UIImage* _upArrowBlueImage;
    UIImage* _upArrowWhiteImage;
    UIImage* _downArrowWhiteImage;
}

@property (nonatomic, weak) IBOutlet UIButton* editButton;
@property (nonatomic, weak) IBOutlet UIButton* addButton;
@property (nonatomic, weak) IBOutlet UIButton* sortByNameButton;
@property (nonatomic, weak) IBOutlet UIButton* sortByDateCreatedButton;
@property (nonatomic, weak) IBOutlet UIButton* sortByDateLastUpdatedButton;
@property (nonatomic, weak) IBOutlet UIImageView* sortByNameArrow;
@property (nonatomic, weak) IBOutlet UIImageView* sortByDateCreatedArrow;
@property (nonatomic, weak) IBOutlet UIImageView* sortByDateLastUpdatedArrow;

@end

@implementation ScenariosTableViewController
@synthesize presentation = _presentation;

#pragma mark - Lifecycle
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
    
    _upArrowBlueImage = [UIImage imageNamed:@"SortUpArrowBlue.png"];
    _upArrowWhiteImage = [UIImage imageNamed:@"SortUpArrowWhite.png"];
    _downArrowWhiteImage = [UIImage imageNamed:@"SortDownArrowWhite.png"];
    
    _context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    _scenarioDateFormatter = [[NSDateFormatter alloc] init];
    [_scenarioDateFormatter setDateFormat:@"M/d/yyyy"];
    
    _scenarioSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    [self sortButtonSelected:_sortByNameButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
    [self refreshScenarioData];
    [self.tableView reloadData];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PresentationFormProtocol Methods
- (BOOL)isInputDataValid
{
    //There are no form inputs on this view
    return YES;
}

- (void)willSavePresentation
{
    //do nothing
}

- (void)showError
{
    //Do nothing
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editScenario"]) {
        ScenarioEditingViewController* editingController = (ScenarioEditingViewController*)[segue destinationViewController];
        editingController.presentation = _presentation;
        editingController.scenario = _scenarioToEdit;
        _scenarioToEdit = nil;
    }
}

- (void)performEditSegueWithScenario:(Scenario*)scenario
{
    _scenarioToEdit = scenario;
    [self performSegueWithIdentifier:@"editScenario" sender:nil];
}

#pragma mark - Toolbar
- (void)setupToolbar
{
    UIBarButtonItem * editButton = [[UIBarButtonItem alloc] initWithTitle:@"Change" style:UIBarButtonItemStyleBordered target:self action:@selector(editToolbarButtonSelected:)];
    UIBarButtonItem * duplicateButton = [[UIBarButtonItem alloc] initWithTitle:@"Duplicate" style:UIBarButtonItemStyleBordered target:self action:@selector(duplicateToolbarButtonSelected:)];
    UIBarButtonItem * deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteToolbarButtonSelected:)];
    
    UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.parentViewController.toolbarItems = @[editButton, spacer, duplicateButton, spacer, deleteButton];
}

#pragma mark - Data
- (void)refreshScenarioData
{
    if (!_presentation) _arrayOfScenarios = nil;
    _arrayOfScenarios = [[_presentation.scenarios allObjects] sortedArrayUsingDescriptors:@[_scenarioSortDescriptor]];
}

#pragma mark - IBActions
- (IBAction)editButtonSelected:(id)sender
{
    if([_arrayOfScenarios count] == 0) return;
    
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    [self.navigationController setToolbarHidden:!self.tableView.isEditing animated:YES];
    
    [_editButton setSelected:self.tableView.isEditing];
    UIImage * addImage = (self.tableView.isEditing) ? [UIImage imageNamed:@"AddButtonOff"] : [UIImage imageNamed:@"AddButtonDark"];
    [_addButton setImage:addImage forState:UIControlStateNormal];
    [_addButton setUserInteractionEnabled:!(self.tableView.isEditing)];
}

- (IBAction)addButtonSelected:(id)sender
{
    //Create new scenario
    [self performSegueWithIdentifier:@"editScenario" sender:nil];
}

- (IBAction)sortButtonSelected:(id)sender
{
    //Reset arrows
    [_sortByNameArrow setImage:_upArrowBlueImage];
    [_sortByDateCreatedArrow setImage:_upArrowBlueImage];
    [_sortByDateLastUpdatedArrow setImage:_upArrowBlueImage];
    
    NSString* newKey = nil;
    UIImageView* sortArrowImageView = nil;
    if(sender == _sortByNameButton)
    {
        newKey = @"name";
        sortArrowImageView = _sortByNameArrow;
    }
    else if(sender == _sortByDateCreatedButton)
    {
        newKey = @"dateCreated";
        sortArrowImageView = _sortByDateCreatedArrow;
    }
    else if(sender == _sortByDateLastUpdatedButton)
    {
        newKey = @"lastUpdated";
        sortArrowImageView = _sortByDateLastUpdatedArrow;
    }
    
    BOOL ascending = _scenarioSortDescriptor.ascending;
    if ([_scenarioSortDescriptor.key isEqualToString:newKey])
    {
        ascending = !ascending;
    }
    else
    {
        ascending = YES;
    }
    
    [sortArrowImageView setHidden:NO];
    [sortArrowImageView setImage:(ascending) ? _upArrowWhiteImage : _downArrowWhiteImage];
    
    _scenarioSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:newKey ascending:ascending];
    [self refreshScenarioData];
    [self.tableView reloadData];
}

- (IBAction)editToolbarButtonSelected:(id)sender
{
    NSLog(@"Edit selected");
    if ([[self.tableView indexPathsForSelectedRows] count] == 0) return;
    
    if ([[self.tableView indexPathsForSelectedRows] count] > 1)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Selection Error" message:@"You cannot edit multiple scenarios at one time. Please select only one scenario to edit." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else if ([[self.tableView indexPathsForSelectedRows] count] > 0)
    {
        NSIndexPath* selectedPath = [self.tableView indexPathForSelectedRow];
        [self performEditSegueWithScenario:[_arrayOfScenarios objectAtIndex:selectedPath.row]];
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

- (IBAction)duplicateToolbarButtonSelected:(id)sender
{
    NSLog(@"Duplicate selected");
    NSArray* selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    NSString* alertMessage = nil;
    if ([selectedIndexPaths count] == 0) {
        return;
    } else if ([selectedIndexPaths count] == 1) {
        alertMessage = @"Duplicate scenario?";
    } else {
        alertMessage = [NSString stringWithFormat:@"Duplicate %i scenarios?", [selectedIndexPaths count]];
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Duplicate" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Duplicate", nil];
    [alert setTag:ALERT_TAG_DUPLICATE];
    [alert show];
}

- (IBAction)deleteToolbarButtonSelected:(id)sender
{
    NSLog(@"Delete selected");
    NSArray* selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    NSString* alertMessage = nil;
    if ([selectedIndexPaths count] == 0) {
        return;
    } else if ([selectedIndexPaths count] == 1) {
        alertMessage = @"Delete scenario?";
    } else {
        alertMessage = [NSString stringWithFormat:@"Delete %i scenarios?", [selectedIndexPaths count]];
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert setTag:ALERT_TAG_DELETE];
    [alert show];
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
    return [_arrayOfScenarios count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScenarioCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell forRowAtIndexPath:indexPath];
    [cell.contentView.superview setBackgroundColor:[[Colors getInstance] lightBackgroundColor]];
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:TAG_SCENARIO_TABLE_CELL_NAME_LABEL];
    UILabel* dateCreatedLabel = (UILabel*)[cell viewWithTag:TAG_SCENARIO_TABLE_CELL_DATE_CREATED_LABEL];
    UILabel* dateUpdatedLabel = (UILabel*)[cell viewWithTag:TAG_SCENARIO_TABLE_CELL_DATE_LAST_UPDATED_LABEL];
    
    Scenario* scenario = [_arrayOfScenarios objectAtIndex:indexPath.row];
    [nameLabel setText:scenario.name];
    [dateCreatedLabel setText:[_scenarioDateFormatter stringFromDate:scenario.dateCreated]];
    [dateUpdatedLabel setText:[_scenarioDateFormatter stringFromDate:scenario.lastUpdated]];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self.tableView isEditing]){
        [self performEditSegueWithScenario:[_arrayOfScenarios objectAtIndex:indexPath.row]];
    }
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
    [self setupToolbar];
}

- (void)formRemoved
{
    if([self.tableView isEditing])
    {
        //disable editing when form is removed
        [self editButtonSelected:nil];
    }
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] == buttonIndex) {
        return;
    }
    
    if (alertView.tag == ALERT_TAG_DUPLICATE) {
        
        NSArray* selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
        for (NSIndexPath* indexPath in selectedIndexPaths)
        {
            Scenario* scenario = [_arrayOfScenarios objectAtIndex: indexPath.row];
            Scenario* newScenario = [scenario duplicateScenarioWithCopyTag:YES];
            [_presentation addScenariosObject:newScenario];
            [newScenario setPresentation:_presentation];
        }
        
        [self refreshScenarioData];
        [self.tableView reloadData];
        
    } else if (alertView.tag == ALERT_TAG_DELETE) {
        
        NSArray* selectedRows = [self.tableView indexPathsForSelectedRows];
        
        for(NSIndexPath* indexPath in selectedRows)
        {
            Scenario* scenario = [_arrayOfScenarios objectAtIndex:indexPath.row];
            [_presentation removeScenariosObject:scenario];
            [_context deleteObject:scenario];
        }
        
        [self refreshScenarioData];
        [self.tableView reloadData];
        
    }
}

-(NSString*)analyticsIdentifier
{
    return @"scenarios";
}

@end
