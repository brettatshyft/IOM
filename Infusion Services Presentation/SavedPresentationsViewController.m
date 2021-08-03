//
//  SavedPresentationsViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/20/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "SavedPresentationsViewController.h"
#import "NewPresentationViewController.h"
#import "AppDelegate.h"
#import "Presentation.h"
#import "PresentationViewController.h"
#import "ListValues.h"
#import "Colors.h"
#import "Presentation+Extension.h"
#import "PresentationFormProtocol.h"
#import "TestReportOptionsViewController.h"
#import <UIAlertView+Block/UIAlertView+Block.h>
#import "IOMMyInfoManager.h"
#import "IOMSyncManager.h"
#import "IOMAnalyticsManager.h"


#define NO_SORT 0
#define BUTTON_NAME_SORT 1
#define BUTTON_DATE_SORT 2
#define BUTTON_TYPE_SORT 3
#define BUTTON_STATUS_SORT 4

@interface SavedPresentationsViewController ()<IOMAnalyticsIdentifiable>{
    Presentation* selectedPresentation;
    NSDateFormatter* dateFormatter;
    BOOL ascending;
    int buttonSelected;
    
    BOOL initialLoad;
    NSArray *selectedIndexPaths;
    UIStoryboard *presentationStoryboard;
    
    UIActivityIndicatorView * activityIndicatorView;
    
    NSSortDescriptor *_presentationsSortDescriptor;
    NSArray *_presentationsArray;
    
    NSArray * _defaultBarButtonItems;
    
    NSArray * _editBarButtonItems;
    
    UIBarButtonItem * _flexibleSpace;
}

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, weak) IBOutlet UITableView* presentationsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createNewPresentationButton;
@property (nonatomic, weak) IBOutlet UIButton* sortByNameButton;
@property (nonatomic, weak) IBOutlet UIButton* sortByDateButton;
@property (weak, nonatomic) IBOutlet UIButton *sortByTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *sortByStatusButton;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;
@property (weak, nonatomic) IBOutlet UIImageView *sortArrowDateImage;
@property (weak, nonatomic) IBOutlet UIImageView *sortArrowNameImage;
@property (weak, nonatomic) IBOutlet UIImageView *sortArrowTypeImage;
@property (weak, nonatomic) IBOutlet UIImageView *sortArrowStatusImage;

@end


@implementation SavedPresentationsViewController

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
    
    AppDelegate* appDel = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDel managedObjectContext];
    
    initialLoad=TRUE;
    presentationStoryboard = [UIStoryboard storyboardWithName:@"PresentationStoryboard" bundle:[NSBundle mainBundle]];
    
    buttonSelected = BUTTON_DATE_SORT;
    ascending=NO;
    
    [_sortByDateButton setHighlighted:YES];
    
    [_presentationsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_presentationsTableView setBackgroundColor:[[Colors getInstance] defaultBackgroundColor]];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    [self initBarButtonItems];
    [[self bottomToolbar] setItems:_defaultBarButtonItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];

//    TestReportOptionsViewController* test = [[TestReportOptionsViewController alloc] init];
//    [self.navigationController pushViewController:test animated:YES];
}

- (void)initBarButtonItems
{
    UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:nil
                                                                                    action:nil];
    
    UIBarButtonItem * myInfoBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"My Info"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showMyInfoAlert)];
    
    UIBarButtonItem * backupRestoreBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Backup/Restore"
                                                                                    style:UIBarButtonItemStylePlain
                                                                                   target:self
                                                                                   action:@selector(syncToolbarButtonSelect:)];
    
    _defaultBarButtonItems = @[myInfoBarButtonItem, flexibleSpace, backupRestoreBarButtonItem];
    
    UIBarButtonItem * duplicateBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Duplicate"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(duplicateToolbarButtonSelected:)];
    
    UIBarButtonItem * deleteBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(deleteToolbarButtonSelected:)];
    
    UIBarButtonItem * changeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Change"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(editToolbarButtonSelected:)];
    
    _editBarButtonItems = @[changeBarButtonItem, flexibleSpace, duplicateBarButtonItem, flexibleSpace, deleteBarButtonItem];
}

- (void)showMyInfoAlert
{
    IOMMyInfoManager * myInfoManager = [[IOMMyInfoManager alloc] init];
    [myInfoManager showMyInfoAlert];
}

- (void)contextDidSaveNotification:(id)sender
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.managedObjectContext = [((AppDelegate*) [[UIApplication sharedApplication] delegate]) managedObjectContext];
        [weakSelf loadData];
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Presentation"];
        NSError * error = nil;
        NSArray *presentationsArray = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (presentationsArray.count > 0){
            Presentation *presentation = (Presentation*)[presentationsArray objectAtIndex:0];
            if (presentation.scenarios.count > 0){
                Scenario *scenario = (Scenario*) [[presentation.scenarios allObjects] objectAtIndex:0];
                NSArray *persistenStores = self.managedObjectContext.persistentStoreCoordinator.persistentStores;
                NSLog(@"%@",persistenStores);
                NSLog(@"%@",[persistenStores objectAtIndex:0]);
                NSLog(@"%@",scenario);
                NSLog(@"%@",presentation);
            }
        }
        [weakSelf.presentationsTableView reloadData];
    });

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    selectedPresentation = nil;
    [self loadData];
    [self fadeReload];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) return YES;
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"Prepare for Segue");
    if([[segue identifier] isEqualToString:@"new_presentation_anim"]){
        UINavigationController* controller = [segue destinationViewController];
        NewPresentationViewController* containedController = (NewPresentationViewController *)[controller topViewController];
        containedController.presentation = selectedPresentation;
        
        containedController = nil;
        selectedPresentation = nil;
    }
}

- (void)loadData
{
    _presentationsArray = nil;
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Presentation"];
    NSError * error = nil;
    _presentationsArray = [_managedObjectContext executeFetchRequest:request error:&error];
    
    [self sortPresentations];
}

#pragma mark - IBActions
- (IBAction)editButtonSelected:(id)sender{
    if([_presentationsTableView isEditing]){
        [_createNewPresentationButton setEnabled:YES];
        [_presentationsTableView setEditing:NO animated:YES];
        _editButton.title=@"Edit";
        [[self bottomToolbar] setItems:_defaultBarButtonItems];
        [_presentationsTableView reloadData]; // force reload to reset selection style
    }else{
        [_createNewPresentationButton setEnabled:NO];
        _editButton.title=@"Done";
        [_presentationsTableView setEditing:YES animated:YES];
        [[self bottomToolbar] setItems:_editBarButtonItems];
        [_presentationsTableView reloadData]; // force reload to reset selection style
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_presentationsTableView setNeedsLayout];
    [self fadeReload];
}

- (IBAction)editToolbarButtonSelected:(id)sender
{
    NSLog(@"Edit selected");
    if ([[_presentationsTableView indexPathsForSelectedRows] count] > 1)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Selection Error" message:@"You cannot edit multiple presentations at one time. Please select only one presentation to edit." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else if ([[_presentationsTableView indexPathsForSelectedRows] count] > 0)
    {
        [self editButtonSelected:sender];
        NSIndexPath* selectedPath = [_presentationsTableView indexPathForSelectedRow];
        [_presentationsTableView cellForRowAtIndexPath:selectedPath].backgroundColor=[[Colors getInstance] lightGrayColor];
        [self performSegueWithIdentifier:@"new_presentation_anim" sender:nil];
    }
}

- (IBAction)syncToolbarButtonSelect:(id)sender
{
    IOMBackupManager * ibm = [[IOMBackupManager alloc] init];
    ibm.delegate = self;
    [ibm showBackupAlert];
}

- (void)backupDidStart
{
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
}

- (void)backupDidEnd
{
    [[[IOMSyncManager alloc] init] requestSync];
    [activityIndicatorView stopAnimating];
    [activityIndicatorView removeFromSuperview];
}

- (void)restoreWasSuccessful
{
    AppDelegate* appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
//    appDel.persistentStoreCoordinator = nil;
//    appDel.managedObjectModel = nil;
//    appDel.managedObjectContext = nil;
    self.managedObjectContext = [appDel managedObjectContext];
    [self loadData];
    [_presentationsTableView reloadData];
}

- (void)presentMailComposeViewController:(MFMailComposeViewController *)mcvc
{
    [self presentViewController:mcvc animated:YES completion:nil];
    mcvc.mailComposeDelegate = self;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)duplicateToolbarButtonSelected:(id)sender
{
    selectedIndexPaths = [_presentationsTableView indexPathsForSelectedRows];
    
    NSString* buttonTitle=@"Duplicate presentation?";
    if ([selectedIndexPaths count]==0) return;
    else if ([selectedIndexPaths count]>1) buttonTitle=[NSString stringWithFormat:@"Duplicate %d presentations?", [selectedIndexPaths count]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:buttonTitle message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Duplicate", nil];
    
    [alertView show];
}

- (IBAction)deleteToolbarButtonSelected:(id)sender
{
    selectedIndexPaths = [_presentationsTableView indexPathsForSelectedRows];
    
    NSString* buttonTitle=@"Delete presentation?";
    if ([selectedIndexPaths count]==0) return;
    else if ([selectedIndexPaths count]>1) buttonTitle=[NSString stringWithFormat:@"Delete %d presentations?", [selectedIndexPaths count]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:buttonTitle message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* selectedButtonTitle=[alertView buttonTitleAtIndex:buttonIndex];
    NSLog(@"The %@ button was tapped.", selectedButtonTitle);
    if ([selectedButtonTitle hasPrefix:@"Delete"])
    {
        for(NSIndexPath* indexPath in selectedIndexPaths)
        {
            Presentation* presentation = [_presentationsArray objectAtIndex:indexPath.row];
            [_managedObjectContext deleteObject:presentation];
        }
        
        [self editButtonSelected:self];
        AppDelegate* appDel = [[UIApplication sharedApplication] delegate];
        [appDel saveContext];
        [self loadData];
        [self fadeReload];
        
        selectedPresentation = nil;
        selectedIndexPaths = nil;
        
    } else if ([selectedButtonTitle hasPrefix:@"Duplicate"]) {
        for (NSIndexPath* indexPath in selectedIndexPaths)
        {
            Presentation* presentation = [_presentationsArray objectAtIndex:indexPath.row];
            [presentation duplicatePresentationWithCopyTag:TRUE];
        }
        
        [self editButtonSelected:self];
        AppDelegate* appDel = [[UIApplication sharedApplication] delegate];
        [appDel saveContext];
        [self loadData];
        [self fadeReload];
        
        selectedPresentation = nil;
        selectedIndexPaths = nil;
    }
}


- (void) fadeReload
{
    //_presentationsTableView.alpha=0;
    [_presentationsTableView reloadData];
    /*[UIView transitionWithView: _presentationsTableView
     duration: 0.20f
     options: UIViewAnimationOptionTransitionCrossDissolve
     animations: ^(void)
     { _presentationsTableView.alpha=1; }
     completion: ^(BOOL isFinished) {}]; */
}

- (IBAction)sortByNameButtonSelected:(id)sender{
    if(buttonSelected != BUTTON_NAME_SORT){
        buttonSelected = BUTTON_NAME_SORT;
        ascending = YES;
    }else{
        ascending = !ascending;
    }
    
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
    
    _presentationsSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"accountName" ascending:ascending];
    [self sortPresentations];
    [self fadeReload];
}

- (IBAction)sortByDateButtonSelected:(id)sender{
    if(buttonSelected != BUTTON_DATE_SORT){
        buttonSelected = BUTTON_DATE_SORT;
        ascending = NO;
    }else{
        ascending = !ascending;
    }
    
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
    
    _presentationsSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"presentationDate" ascending:ascending];
    [self sortPresentations];
    [self fadeReload];
}

- (IBAction)sortByTypeButtonSelected:(id)sender {
    if(buttonSelected != BUTTON_TYPE_SORT){
        buttonSelected = BUTTON_TYPE_SORT;
        ascending = YES;
    }else{
        ascending = !ascending;
    }
    
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
    
    _presentationsSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"presentationTypeID" ascending:ascending];
    [self sortPresentations];
    [self fadeReload];
}


- (IBAction)sortByStatusButtonSelected:(id)sender {
    if(buttonSelected != BUTTON_STATUS_SORT){
        buttonSelected = BUTTON_STATUS_SORT;
        ascending = YES;
    }else{
        ascending = !ascending;
    }
    
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
    
    _presentationsSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"isCompleted" ascending:ascending];
    [self sortPresentations];
    [self fadeReload];
}

- (void)sortPresentations
{
    if (!_presentationsSortDescriptor) {
        _presentationsSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"presentationDate" ascending:YES];
    }
    
    _presentationsArray = [_presentationsArray sortedArrayUsingDescriptors:@[_presentationsSortDescriptor]];
}


- (void)unhighlightAllButtons{
    [_sortByDateButton setHighlighted:NO];
    [_sortByNameButton setHighlighted:NO];
    [_sortByTypeButton setHighlighted:NO];
    [_sortByStatusButton setHighlighted:NO];
    [_sortArrowDateImage setImage:[UIImage imageNamed:@"SortDownArrowBlue.png"]];
    [_sortArrowNameImage setImage:[UIImage imageNamed:@"SortUpArrowBlue.png"]];
    [_sortArrowTypeImage setImage:[UIImage imageNamed:@"SortUpArrowBlue.png"]];
    [_sortArrowStatusImage setImage:[UIImage imageNamed:@"SortUpArrowBlue.png"]];
}

- (void)highlightButton:(UIButton*)button{
    [self unhighlightAllButtons];
    [button setHighlighted:YES];
    UIImage *arrowImage;
    if (ascending) arrowImage = [UIImage imageNamed:@"SortUpArrowWhite.png"];
    else arrowImage = [UIImage imageNamed:@"SortDownArrowWhite.png"];
    if ([button isEqual:_sortByDateButton])
        [_sortArrowDateImage setImage:arrowImage];
    else if ([button isEqual:_sortByNameButton])
        [_sortArrowNameImage setImage:arrowImage];
    else if ([button isEqual:_sortByTypeButton])
        [_sortArrowTypeImage setImage:arrowImage];
    else if ([button isEqual:_sortByStatusButton])
        [_sortArrowStatusImage setImage:arrowImage];
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
    return [_presentationsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PresentationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    if  ([_presentationsTableView isEditing]) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    UILabel* accountNameLabel = (UILabel*)[cell viewWithTag:101];
    UILabel* presentationDateLabel = (UILabel*)[cell viewWithTag:102];
    UILabel* presentationTypeLabel = (UILabel*)[cell viewWithTag:103];
    UILabel* presentationStatusLabel = (UILabel*)[cell viewWithTag:104];
    
    cell.backgroundColor=[[Colors getInstance] lightBackgroundColor];
    
    Presentation* presentation = [_presentationsArray objectAtIndex:indexPath.row];
    [presentationDateLabel setText:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:presentation.presentationDate]]];
    [accountNameLabel setText:presentation.accountName];
    [accountNameLabel setTextColor:[[Colors getInstance] lightBlueColor]];
    IOMPresentationSectionsIncludedType includedType = [presentation.presentationsIncluded integerValue];
    switch (includedType) {
        case PresentationSectionsIncludedTypeInfusionServicesAndInfusionOptimization:
            [presentationTypeLabel setText:@"Both"];
            break;
        case PresentationSectionsIncludedTypeInfusionServices:
            [presentationTypeLabel setText:@"Bus. Review"];
            break;
        case PresentationSectionsIncludedTypeInfusionOptimization:
            [presentationTypeLabel setText:@"IOM"];
            break;
            
        default:
            break;
    }
    //[presentationTypeLabel setText:[LIST_VALUES_ARRAY_PRESENTATION_TYPE objectAtIndex:[presentation.presentationTypeID intValue]]];
    if ([presentation verifyCompleted]) {
        [presentationStatusLabel setText:@"Complete"];
        [presentationStatusLabel setTextColor:[[Colors getInstance] greenColor]];
    } else {
        [presentationStatusLabel setText:@"Draft"];
        [presentationStatusLabel setTextColor:[[Colors getInstance] lightGrayColor]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

- (NSString*)analyticsIdentifier
{
    return @"presentations_list";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedPresentation = [_presentationsArray objectAtIndex:indexPath.row];
    if  (![_presentationsTableView isEditing]) {
        if ([selectedPresentation verifyCompleted]) {
            [tableView cellForRowAtIndexPath:indexPath].backgroundColor=[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];;
            
            PresentationViewController* presentationController = [presentationStoryboard instantiateViewControllerWithIdentifier:@"presentationController"];
            presentationController.presentation = selectedPresentation;
            [self.navigationController pushViewController:presentationController animated:YES];
            
        } else {
            [tableView cellForRowAtIndexPath:indexPath].backgroundColor=[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];;
            [self performSegueWithIdentifier:@"new_presentation_anim" sender:nil];
        }
    }
    
}

@end
