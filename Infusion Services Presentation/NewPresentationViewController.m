//
//  NewPresentationViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "NewPresentationViewController.h"
#import "AppDelegate.h"
#import "AccountFormViewController.h"
#import "UtilizationFormViewController.h"
#import "PenetrationFormViewController.h"
#import "PayerMixFormViewController.h"
#import "ReimbursementFormViewController.h"
#import "VialTrendFormViewController.h"
#import "PayerMix.h"
#import "Reimbursement.h"
#import "VialTrend.h"
#import "VialTrend+Extension.h"
#import "Utilization.h"
#import "Utilization+Extension.h"
#import "Colors.h"
#import "PresentationFormProtocol.h"
#import "Presentation+Extension.h"
#import "NewPresentationSetupViewController.h"
#import "InfusionServicesViewController.h"
#import "IOMAnalyticsManager.h"
#import "UIView+IOMExtensions.h"
#import "IOMDataClient.h"
#import "IOMParsedPatientEstimates.h"
#import "Presentation+Extension.h"
#import "Scenario+Extension.h"
#import "RemicadeInfusion+Extension.h"
#import "StelaraInfusion+CoreDataClass.h"
#import "SimponiAriaInfusion+Extension.h"
#import "OtherInfusion+Extension.h"
#import "OtherInjection+Extension.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface NewPresentationViewController ()<IOMAnalyticsIdentifiable, NewPresentationSetupViewControllerDelegate>{
    UIStoryboard *storyboard;
    UIStoryboard *scenariosStoryboard;
    
    AppDelegate* appDelegate;
    NSManagedObjectContext* context;
    
    NSDateFormatter* presentationDateFormatter;
    
    NSUndoManager* undoManager;
    
    NewPresentationSetupViewController * newPresentationSetupViewController;
    InfusionServicesViewController * infusionServicesViewController;
    UIViewController<PresentationFormProtocol> * scenariosController;
    UIViewController<PresentationFormProtocol> * _currentFormController;
    
    BOOL isInitialLoad;
    
    PresentationType originalPresentationType;
}

@property (nonatomic, weak) IBOutlet UIView* formView;
@property (weak, nonatomic) IBOutlet UIButton *presentationSetupButton;
@property (weak, nonatomic) IBOutlet UIButton *infusionServicesButton;
@property (weak, nonatomic) IBOutlet UIButton *infusionOptimizationButton;
//@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

- (IBAction)cancelButtonSelected:(id)sender;
- (IBAction)saveButtonSelected:(id)sender;

@end

@implementation NewPresentationViewController

@synthesize presentation = _presentation;

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
    
    [self refreshBarButtonItems];
    
    presentationDateFormatter = [[NSDateFormatter alloc] init];
    [presentationDateFormatter setDateFormat:@"M/d/yyyy"];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    undoManager = [context undoManager];
    [undoManager beginUndoGrouping];
    
    originalPresentationType = [_presentation.presentationTypeID integerValue];
    
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    scenariosStoryboard = [UIStoryboard storyboardWithName:@"ScenariosStoryboard" bundle:[NSBundle mainBundle]];
    
    UISwipeGestureRecognizer* swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeRightRecognizer setDelegate:self];
    UISwipeGestureRecognizer* swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeLeftRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:swipeRightRecognizer];
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    
    [self initializePresentation];
    [self initializeChildForms];
    [self toggleButtonSelected:_presentationSetupButton];

    isInitialLoad=TRUE;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentationSectionsTypeChangedNotification:) name:@"updateSectionAvailability" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentationTypeChangedNotification:) name:@"updatePresentationType" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectInfusionOptimization) name:@"selectInfusionOptimization" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTitle:) name:@"updateTitle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAccountIDs:) name:@"updateAccountIDs" object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[IOMAnalyticsManager shared] trackScreenView:self];
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    storyboard = nil;
    scenariosStoryboard = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    storyboard = nil;
    scenariosStoryboard = nil;
    
    appDelegate = nil;
    context = nil;
    
    presentationDateFormatter = nil;
    undoManager = nil;
    
    newPresentationSetupViewController = nil;
    infusionServicesViewController = nil;
    scenariosController = nil;
    _currentFormController = nil;
    
    _presentation = nil;
}

- (void)refreshBarButtonItems
{
    UIBarButtonItem * saveAndClose = [self.navigationItem rightBarButtonItem];
    UIBarButtonItem * saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonSelected:)];
    UIBarButtonItem * refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonSelected:)]; // 123
    UIBarButtonItem * fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 20.0f;
    NSMutableArray<UIBarButtonItem*>* barButtonItems = [@[saveAndClose, fixedSpace, saveButton, fixedSpace] mutableCopy];
    if ([newPresentationSetupViewController currentFormIsAccountForm] && _currentFormController == newPresentationSetupViewController) {
        [barButtonItems addObject:refreshButton];
    }
    [self.navigationItem setRightBarButtonItems:barButtonItems];
}

#pragma NSNotifications
- (void)presentationTypeChangedNotification:(NSNotification*)notification
{
    //Update presentation model
    NSNumber* presentationType = [[notification userInfo] objectForKey:@"presentationType"];
    _presentation.presentationTypeID = presentationType;
    [_presentation updateScenariosForPresentationType];
    
    //Flagging all scenarios as needs processing.
    //Presentation type is the only presentation property that affects how scenarios are processed.
    if (originalPresentationType != [_presentation.presentationTypeID integerValue]) {
        [_presentation flagAllScenariosAsNeedsProcessing];
    }
}

- (void)presentationSectionsTypeChangedNotification:(NSNotification*)notification
{
    //Update presentation model
    NSNumber * presentationsIncluded = [[notification userInfo] valueForKey:@"presentationsIncluded"];
    _presentation.presentationsIncluded = presentationsIncluded;
    
    //update UI
    [self updateSectionAvailability];
}

#pragma mark - NewPresentationSetupViewControllerDelegate

- (void)newPresentationSetupViewController:(NewPresentationSetupViewController *)newPresentationSetupViewController didSelectToggleButton:(UIButton *)toggleButton
{
    [self refreshBarButtonItems];
}

#pragma mark - Update Functions
- (void)updateSectionAvailability
{
    if ([_presentation includeInfusionServicesSection]) {
        [self enableButton:_infusionServicesButton];
    } else {
        [self disableButton:_infusionServicesButton];
    }
    
    if ([_presentation includeInfusionOptimizationSection]) {
        [self enableButton:_infusionOptimizationButton];
    } else {
        [self disableButton:_infusionOptimizationButton];
    }
}

- (void)refreshButtonSelected:(id)sender
{
    [self downloadAndPromptWithJNJID:_presentation.accountID jnjID2:_presentation.accountID2 jnjID3:_presentation.accountID3];
}

- (void)updateAccountIDs:(NSDictionary*)userInfo
{
    NSString * accountID1 = [[userInfo valueForKey:@"userInfo"] valueForKey:@"accountID1"];
    NSString * accountID2 = [[userInfo valueForKey:@"userInfo"] valueForKey:@"accountID2"];
    NSString * accountID3 = [[userInfo valueForKey:@"userInfo"] valueForKey:@"accountID3"];
    _presentation.accountID = accountID1;
    _presentation.accountID2 = accountID2;
    _presentation.accountID3 = accountID3;
    [self downloadAndPromptWithJNJID:accountID1 jnjID2:accountID2 jnjID3:accountID3];
}

- (void)downloadAndPromptWithJNJID:(NSString*)accountID1 jnjID2:(NSString*)accountID2 jnjID3:(NSString*)accountID3 {
    __weak typeof(self) weakSelf = self;
    IOMDataClient* client = [[IOMDataClient alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [client getMonthlyDataForJNJID1:accountID1 jnjID2:accountID2 jnjID3:accountID3 withCompletion:^(IOMMonthlyData *monthlyData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (weakSelf == nil) {
            return;
        } else if (monthlyData == nil) {
            UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"No Data Found"
                                                                                message:@"This J&J ID does not seem to have any data associated with it, confirm it is correct and try again."
                                                                         preferredStyle:UIAlertControllerStyleAlert];

            [controller addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];

            [weakSelf presentViewController:controller animated:YES completion:nil];
        }

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Data Downloaded"
                                                                       message:@"This J&J ID already has some data associated with it – would you like to apply it to this presentation?"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"Apply" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [VialTrend getVialTrendFromParsed:monthlyData.stelaraVialTrends forPresentation:weakSelf.presentation];
            [VialTrend getVialTrendFromParsed:monthlyData.simponiAriaVialTrends forPresentation:weakSelf.presentation];
            [VialTrend getVialTrendFromParsed:monthlyData.remicadeVialTrends forPresentation:weakSelf.presentation];
            [infusionServicesViewController updateVialTrends];

            IOMParsedPatientEstimates* estimates = monthlyData.patientEstimates;
            switch (weakSelf.presentation.presentationType) {
                case PresentationTypeRAIOI:
                    weakSelf.presentation.patientPopulation = estimates.rheumPatientsPotential52Wk;
                    break;
                case PresentationTypeGIIOI:
                    weakSelf.presentation.patientPopulation = estimates.gastroPatientsPotential52Wk;
                    break;
                default:
                    weakSelf.presentation.patientPopulation = @([estimates.rheumPatientsPotential52Wk floatValue] + [estimates.gastroPatientsPotential52Wk floatValue]);
                    break;
            }

            if(!weakSelf.presentation.utilization){
                Utilization* utilization = [NSEntityDescription insertNewObjectForEntityForName:@"Utilization" inManagedObjectContext:context];
                _presentation.utilization = utilization;
            }

            weakSelf.presentation.utilization.remicadePatients = estimates.remPatients52Wk;
            weakSelf.presentation.utilization.simponiAriaPatients = estimates.simponiAriaPatients52Wk;
            weakSelf.presentation.utilization.stelaraPatients = estimates.stelara130MgPatients52Wk;

            // (1/2 * ore patients 52wk)+actemra iv patients 52wk+entyvio patients 52wk+inflectra patients 52wk+renflexis patients 52wk
            weakSelf.presentation.utilization.otherIVBiologics = @((estimates.orePatients52Wk.floatValue / 2) + estimates.actemraIvPatients52Wk.floatValue + estimates.entyvioPatients52Wk.floatValue + estimates.inflectraPatients52Wk.floatValue + estimates.renflexisPatients52Wk.floatValue);

            //(1/2 * ore patients 52wk)+enb patients 52wk+hum patients 52wk+cimzia patients 52wk
            weakSelf.presentation.utilization.subcutaneousPatients = @((estimates.orePatients52Wk.floatValue / 2) + estimates.enbPatients52Wk.floatValue + estimates.humPatients52Wk.floatValue +
            estimates.cimziaPatients52Wk.floatValue);

            weakSelf.presentation.utilization.previous52WeeksSubcutaneousPatients =
            @(
            (0.5 * estimates.orePatients52Wk.floatValue - estimates.orePatients52X52Chg.floatValue) +
            (estimates.enbPatients52Wk.floatValue - estimates.enbPatients52X52Chg.floatValue) +
            (estimates.humPatients52Wk.floatValue - estimates.humPatients52X52Chg.floatValue) +
            (estimates.cimziaPatients52Wk.floatValue - estimates.cimziaPatients52X52Chg.floatValue)
            );

            weakSelf.presentation.utilization.previous52WeeksIVPatients =
            @(
            (estimates.remPatients52Wk.floatValue - estimates.remPatients52X52Chg.floatValue) +
            (estimates.stelara130MgPatients52Wk.floatValue - estimates.stelara130MgPatients52X52Chg.floatValue) +
            (0.5 * (estimates.orePatients52Wk.floatValue - estimates.orePatients52X52Chg.floatValue)) +
            (estimates.actemraIvPatients52Wk.floatValue - estimates.actemraIvPatients52X52Chg.floatValue) +
            (estimates.entyvioPatients52Wk.floatValue - estimates.entyvioPatients52X52Chg.floatValue) +
            (estimates.inflectraPatients52Wk.floatValue - estimates.inflectraPatients52X52Chg.floatValue) +
            (estimates.renflexisPatients52Wk.floatValue - estimates.renflexisPatients52X52Chg.floatValue)
            );

            NSInteger supposedTotal = weakSelf.presentation.utilization.remicadePatients.integerValue +
            weakSelf.presentation.utilization.simponiAriaPatients.integerValue +
            weakSelf.presentation.utilization.stelaraPatients.integerValue +
            weakSelf.presentation.utilization.otherIVBiologics.integerValue +
            weakSelf.presentation.utilization.subcutaneousPatients.integerValue;
            if (weakSelf.presentation.patientPopulation.integerValue < supposedTotal) {
                NSInteger difference = supposedTotal - weakSelf.presentation.patientPopulation.integerValue;
                weakSelf.presentation.patientPopulation = @(weakSelf.presentation.patientPopulation.integerValue + difference);
            }

            [((NewPresentationSetupViewController *)newPresentationSetupViewController) updateUtilizationForm];
        }]];

        [alert addAction: [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            {}
        }]];

        [weakSelf presentViewController:alert animated:YES completion:^{
            {}
        }];
    }];
}

- (void) updateTitle:(NSDictionary *)userInfo
{
    NSString * presentationTitleString=[[userInfo valueForKey:@"userInfo"] valueForKey:@"presentationTitle"];

    if (!presentationTitleString) {
        NSString * presentationDate;
        if (_presentation.presentationDate)
            presentationDate = [presentationDateFormatter stringFromDate:_presentation.presentationDate];
        else
            presentationDate = [presentationDateFormatter stringFromDate:[NSDate date]];
        
        presentationTitleString = @"";
        if (_presentation.accountName)
            presentationTitleString=[presentationTitleString stringByAppendingFormat:@"%@ - %@", _presentation.accountName, presentationDate];
        else
            presentationTitleString = [presentationTitleString stringByAppendingFormat:@"%@ - %@", @"New Presentation", presentationDate];
    }
    
    [self setTitle:presentationTitleString];
}


- (void) disableButton:(UIButton *) theButton
{
    theButton.Enabled=FALSE;
    [theButton setBackgroundColor:[UIColor darkGrayColor]];
}

- (void) enableButton:(UIButton *) theButton
{
    theButton.Enabled=TRUE;
    [theButton setBackgroundColor:[[Colors getInstance] darkBlueColor]];
}

- (void)swipeDetected:(UISwipeGestureRecognizer*)recognizer{
    //if(![_overlayView isHidden]) return;
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        //NSLog(@"Right - %@, %@", [_presentationSetupButton.backgroundColor description], [[Colors getInstance] lightBlueColor]);
        if ([_infusionOptimizationButton.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
        {
            if ([_infusionServicesButton isEnabled])
            {
                [self toggleButtonSelected:_infusionServicesButton];
                [((InfusionServicesViewController *)infusionServicesViewController) toggleButtonSelected:((InfusionServicesViewController *)infusionServicesViewController).reimbursementButton];
            }
            else
            {
                [self toggleButtonSelected:_presentationSetupButton];
                [((NewPresentationSetupViewController *)newPresentationSetupViewController) toggleButtonSelected:((NewPresentationSetupViewController *)newPresentationSetupViewController).utilizationButton];
            }
        }
        else if ([_infusionServicesButton.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
        {
            if ([((InfusionServicesViewController *)infusionServicesViewController).reimbursementButton.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            {
                [((InfusionServicesViewController *)infusionServicesViewController) toggleButtonSelected:((InfusionServicesViewController *)infusionServicesViewController).payerMixButton];
            }
            else if ([((InfusionServicesViewController *)infusionServicesViewController).payerMixButton.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            {
                [((InfusionServicesViewController *)infusionServicesViewController) toggleButtonSelected:((InfusionServicesViewController *)infusionServicesViewController).vialTrendButton];
            }
            else
            {
                [self toggleButtonSelected:_presentationSetupButton];
                [((NewPresentationSetupViewController *)newPresentationSetupViewController) toggleButtonSelected:((NewPresentationSetupViewController *)newPresentationSetupViewController).utilizationButton];
            }

        }
        else if ([_presentationSetupButton.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
        {
            if ([((NewPresentationSetupViewController *)newPresentationSetupViewController).utilizationButton.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            {
                [((NewPresentationSetupViewController *)newPresentationSetupViewController) toggleButtonSelected:((NewPresentationSetupViewController *)newPresentationSetupViewController).accountButton];
            }
        }
    }else if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
        //NSLog(@"Left");
        if ([_presentationSetupButton.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
        {
            if ([((NewPresentationSetupViewController *)newPresentationSetupViewController).accountButton.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            {
                [((NewPresentationSetupViewController *)newPresentationSetupViewController) toggleButtonSelected:((NewPresentationSetupViewController *)newPresentationSetupViewController).utilizationButton];
            }
            else if ([_infusionServicesButton isEnabled])
            {
                [self toggleButtonSelected:_infusionServicesButton];
                [((InfusionServicesViewController *)infusionServicesViewController) toggleButtonSelected:((InfusionServicesViewController *)infusionServicesViewController).vialTrendButton];
            }
            else
            {
                [self toggleButtonSelected:_infusionOptimizationButton];
            }
        }
        else if ([_infusionServicesButton.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
        {
            if ([((InfusionServicesViewController *)infusionServicesViewController).vialTrendButton.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            {
                [((InfusionServicesViewController *)infusionServicesViewController) toggleButtonSelected:((InfusionServicesViewController *)infusionServicesViewController).payerMixButton];
            }
            else if ([((InfusionServicesViewController *)infusionServicesViewController).payerMixButton.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            {
                [((InfusionServicesViewController *)infusionServicesViewController) toggleButtonSelected:((InfusionServicesViewController *)infusionServicesViewController).reimbursementButton];
            }
            else if ([((InfusionServicesViewController *)infusionServicesViewController).reimbursementButton.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            {
                if ([_infusionOptimizationButton isEnabled])
                {
                    [self toggleButtonSelected:_infusionOptimizationButton];
                }
            }

        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) return YES;
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initializePresentation
{
    if(!_presentation){
        _presentation = [NSEntityDescription insertNewObjectForEntityForName:@"Presentation" inManagedObjectContext:context];
        _presentation.presentationsIncluded = [NSNumber numberWithInteger:PresentationSectionsIncludedTypeInfusionServicesAndInfusionOptimization];
    }
}

- (void)initializeChildForms
{
    if (!newPresentationSetupViewController){
        newPresentationSetupViewController = [storyboard instantiateViewControllerWithIdentifier:@"NewPresentationSetup"];
        newPresentationSetupViewController.presentation = _presentation;
        newPresentationSetupViewController.delegate = self;
    }
    
    if (!infusionServicesViewController) {
        infusionServicesViewController = [storyboard instantiateViewControllerWithIdentifier:@"InfusionServices"];
        infusionServicesViewController.presentation = _presentation;
    }
        
    
    if (!scenariosController) {
        scenariosController = [scenariosStoryboard instantiateViewControllerWithIdentifier:@"scenariosController"];
        scenariosController.presentation = _presentation;
    }

    /*UIImage* arrowImage=[UIImage imageNamed:@"blue-arrow-navigation.png"];
    UIImageView* arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
    [arrowImageView setFrame:CGRectMake(839,655,28,9)];
    [scenariosController.view addSubview:arrowImageView];*/
}

#pragma mark - IBActions
- (IBAction)presentationSetupButtonSelected:(UIButton *)sender
{
    [self toggleButtonSelected:sender];
}

- (IBAction)infusionServicesButtonSelected:(UIButton *)sender
{
    [self toggleButtonSelected:sender];
}

- (IBAction)infusionOptimizationButtonSelected:(UIButton *)sender
{
    [self toggleButtonSelected:sender];
}

- (void)toggleButtonSelected:(id)sender
{
    //Remove old child view controller
    if (_currentFormController) {
        [_currentFormController willMoveToParentViewController:nil];
        [_currentFormController.view removeFromSuperview];
        [_currentFormController removeFromParentViewController];
    }
    
    if (sender == _presentationSetupButton) {
        _currentFormController = newPresentationSetupViewController;
    } else if (sender == _infusionServicesButton) {
        _currentFormController = infusionServicesViewController;
    } else if (sender == _infusionOptimizationButton) {
        _currentFormController = scenariosController;
    }
    
    
    [self addChildViewController:_currentFormController];
    [_formView addSubview:_currentFormController.view];
    [_currentFormController didMoveToParentViewController:self];
    [_currentFormController.view bindFrameToSuperviewBounds];
    [self highlightButton:sender];

    [self refreshBarButtonItems];
}

-(void)selectInfusionOptimization {
    [self toggleButtonSelected:_infusionOptimizationButton];
}

- (IBAction)cancelButtonSelected:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Unsaved Information" message:@"Do you want to save the changes you have made?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save and Cancel", nil];
    [alert show];
}

- (IBAction)saveAndCloseButtonSelected:(id)sender
{
    if([self saveChanges]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)saveButtonSelected:(id)sender
{
    if([self saveChanges]) {
        [undoManager beginUndoGrouping];
    }
}

- (void)highlightButton:(UIButton*)button{
    [_presentationSetupButton setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    if (_infusionServicesButton.enabled) [_infusionServicesButton setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    if (_infusionOptimizationButton.enabled) [_infusionOptimizationButton setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    
    [button setBackgroundColor:[[Colors getInstance] lightBlueColor]];
}

- (BOOL)saveChanges
{
    NSLog(@"NewPresentationViewController - Saving Presentation");
    
    if (![newPresentationSetupViewController isInputDataValid])
    {
        [self presentationSetupButtonSelected:_presentationSetupButton];
        [_currentFormController showError];
        return NO;
    } else if ([_infusionServicesButton isEnabled] && ![infusionServicesViewController isInputDataValid]) {
        [self infusionServicesButtonSelected:_infusionServicesButton];
        [_currentFormController showError];
        return NO;
    } else if ([_infusionOptimizationButton isEnabled] && ![scenariosController isInputDataValid]) {
        [self infusionOptimizationButtonSelected:_infusionOptimizationButton];
        [[[UIAlertView alloc] initWithTitle:@"Information Missing" message:@"Invalid Infusion Optimization" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        return NO;
    }
    

    //Calls to child views before saving, allowing child view controllers to prepare for saving
    [newPresentationSetupViewController willSavePresentation];
    [infusionServicesViewController willSavePresentation];
    [scenariosController willSavePresentation];
    
    NSError* error = nil;
    if(![context save:&error]){
        NSLog(@"ERROR: Could not save presentation! --> %@", [error localizedDescription]);
        [[[UIAlertView alloc] initWithTitle:@"Failed to Save" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];

        NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
        if(detailedErrors != nil && [detailedErrors count] > 0) {
            for(NSError* detailedError in detailedErrors) {
                NSLog(@"  DetailedError: %@", [detailedError userInfo]);
            }
        }
        else {
            NSLog(@"  %@", [error userInfo]);
        }

        return NO;
    }
    
    //End undo grouping
    [undoManager endUndoGrouping];
    
    return YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [undoManager endUndoGrouping];
        [undoManager undo];
        _presentation = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self saveAndCloseButtonSelected:nil];
    }
}

-(NSString*)analyticsIdentifier
{
    return @"new_presentation";
}

@end
