//
//  NewPresentationSetupViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "NewPresentationSetupViewController.h"
#import "AppDelegate.h"
#import "AccountFormViewController.h"
#import "UtilizationFormViewController.h"
#import "PenetrationFormViewController.h"
#import "PayerMixFormViewController.h"
#import "ReimbursementFormViewController.h"
#import "VialTrendFormViewController.h"
#import "Presentation.h"
#import "PayerMix.h"
#import "Reimbursement.h"
#import "VialTrend.h"
#import "VialTrend+Extension.h"
#import "Utilization.h"
#import "Utilization+Extension.h"
#import "Colors.h"
#import "ListValues.h"
#import "UIView+IOMExtensions.h"
#import "IOMAnalyticsManager.h"

@interface NewPresentationSetupViewController ()<IOMAnalyticsIdentifiable>{
    UIStoryboard *storyboard;
    AppDelegate* appDelegate;
    NSManagedObjectContext* context;
    
    NSDateFormatter* presentationDateFormatter;
    NSDateFormatter* vialMonthsDateFormatter;
    
    UIViewController* _currentChildFormController;
}

@property (nonatomic, weak) IBOutlet UIView* formView;

@property (nonatomic, strong) AccountFormViewController* accountForm;
@property (nonatomic, strong) UtilizationFormViewController* utilizationForm;

- (IBAction)accountButtonSelected:(id)sender;
- (IBAction)utilizationButtonSelected:(id)sender;

@end

@implementation NewPresentationSetupViewController
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
	// Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentationTypeChangedNotification:) name:@"updatePresentationType" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePresentationType" object:nil userInfo:@{@"presentationType":_presentation.presentationTypeID}];
    
    presentationDateFormatter = [[NSDateFormatter alloc] init];
    [presentationDateFormatter setDateFormat:@"M/d/yyyy"];
    vialMonthsDateFormatter = [[NSDateFormatter alloc] init];
    [vialMonthsDateFormatter setDateFormat:@"M/yy"];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    [self initializeForms];
    [self toggleButtonSelected:_accountButton];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;


//    for (UIView* view in self.view.allSubviewsInHierarchy) {
//        view.translatesAutoresizingMaskIntoConstraints = NO;
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    storyboard = nil;
    appDelegate = nil;
    context = nil;
    presentationDateFormatter = nil;
    vialMonthsDateFormatter = nil;
    _currentChildFormController = nil;
    _accountForm = nil;
    _utilizationForm = nil;
    _presentation = nil;
}

- (void)presentationTypeChangedNotification:(NSNotification*)notification
{
    NSNumber* presentationType = [[notification userInfo] objectForKey:@"presentationType"];
    _presentation.presentationTypeID = presentationType;
    _utilizationForm.presentationType = _presentation.presentationTypeID;
    if (([_presentation.presentationTypeID intValue]==2)||([_presentation.presentationTypeID intValue]==5))
    {
        _presentation.utilization.simponiAriaPatients=0;
        _utilizationForm.simponiPatients=0;
    }
}

- (void)showError
{
    if (![_utilizationForm isInputDataValid]){
        [_utilizationForm showError];
        return;
    }
    [self toggleButtonSelected:_accountButton];
    [_accountForm showError];
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

- (BOOL)isInputDataValid
{
    if(!_accountForm.presentationNameString || (id)_accountForm.presentationNameString == [NSNull null] || [_accountForm.presentationNameString isEqualToString:@""] ||  !_accountForm.presentationDateString || (id)_accountForm.presentationDateString == [NSNull null]){
        return NO;
    }
    
    if ([_accountForm.presentationTypeString isEqualToString:[LIST_VALUES_ARRAY_PRESENTATION_TYPE objectAtIndex:0]]) {
        return NO;
    }

    NSDate* presentationDate = [presentationDateFormatter dateFromString:_accountForm.presentationDateString];
    
    if (!presentationDate) {
        return NO;
    }
    
    if (![_utilizationForm isInputDataValid]){
        return NO;
    }
    
    return YES;
}

- (void)willSavePresentation
{
    //Parent is about to save the presentation, assign values
    NSLog(@"NewPresentationSetupViewController - Saving Presentation");
    
    //Account form data
    _presentation.accountID = _accountForm.accountNameString;
    _presentation.accountName = _accountForm.presentationNameString;
    _presentation.presentationDate = [presentationDateFormatter dateFromString:_accountForm.presentationDateString];
    _presentation.presentationTypeID = [NSNumber numberWithInteger:[LIST_VALUES_ARRAY_PRESENTATION_TYPE indexOfObject:_accountForm.presentationTypeString]];
    _presentation.presentationsIncluded = [NSNumber numberWithInteger:[LIST_VALUES_ARRAY_PRESENTATION_SECTIONS indexOfObject:_accountForm.presentationSectionString]];
    _presentation.timeToCapacityReport = [NSNumber numberWithBool:_accountForm.timeToCapacityReport];

    //Utilization form data
    if(!_presentation.utilization){
        Utilization* utilization = [NSEntityDescription insertNewObjectForEntityForName:@"Utilization" inManagedObjectContext:context];
        _presentation.utilization = utilization;
    }
    _presentation.patientPopulation = [NSNumber numberWithInteger:_utilizationForm.patientPopulation];
    _presentation.utilization.remicadePatients = [NSNumber numberWithInteger:_utilizationForm.remicadePatients];
    _presentation.utilization.stelaraPatients = [NSNumber numberWithInteger:_utilizationForm.stelaraPatients];
    _presentation.utilization.simponiAriaPatients = [NSNumber numberWithInteger:_utilizationForm.simponiPatients];
    _presentation.utilization.otherIVBiologics = [NSNumber numberWithInteger:_utilizationForm.otherIVBiologics];
    _presentation.utilization.subcutaneousPatients = [NSNumber numberWithInteger:_utilizationForm.subcutaneousPatients];
}

- (void)initializeForms{
    if(!_accountForm){
        self.accountForm = [storyboard instantiateViewControllerWithIdentifier:@"accountForm"];
        _accountForm.accountNameString = _presentation.accountID;
        _accountForm.accountName2String = _presentation.accountID2;
        _accountForm.accountName3String = _presentation.accountID3;
        _accountForm.presentationNameString = _presentation.accountName;
        _accountForm.presentationDateString = [presentationDateFormatter stringFromDate:_presentation.presentationDate];
        _accountForm.presentationTypeString = [LIST_VALUES_ARRAY_PRESENTATION_TYPE objectAtIndex:[_presentation.presentationTypeID integerValue]];
        _accountForm.presentationSectionString = [LIST_VALUES_ARRAY_PRESENTATION_SECTIONS objectAtIndex:[_presentation.presentationsIncluded integerValue]];
        _accountForm.timeToCapacityReport = _presentation.timeToCapacityReport.boolValue;
    }
    if(!_utilizationForm){
        self.utilizationForm = [storyboard instantiateViewControllerWithIdentifier:@"utilizationForm"];
        if(_presentation.utilization) {
            [self updateUtilizationForm];
        }
    }
}

- (void)updateUtilizationForm
{
    _utilizationForm.patientPopulation = [_presentation.patientPopulation integerValue];
    _utilizationForm.remicadePatients = [_presentation.utilization.remicadePatients integerValue];
    _utilizationForm.simponiPatients = [_presentation.utilization.simponiAriaPatients integerValue];
    _utilizationForm.stelaraPatients = [_presentation.utilization.stelaraPatients integerValue];
    _utilizationForm.otherIVBiologics = [_presentation.utilization.otherIVBiologics integerValue];
    _utilizationForm.subcutaneousPatients = [_presentation.utilization.subcutaneousPatients integerValue];
    _utilizationForm.presentationType = _presentation.presentationTypeID ;
}

#pragma mark - IBActions
- (IBAction)accountButtonSelected:(id)sender
{
    [self toggleButtonSelected:sender];
}

- (IBAction)utilizationButtonSelected:(id)sender
{
    [self toggleButtonSelected:sender];
}

- (void)toggleButtonSelected:(id)sender
{
    //Remove old child view controller
    [self removeCurrentChildViewController];
    
    if (sender == _accountButton) {
        _currentChildFormController = _accountForm; // 123
    } else if (sender == _utilizationButton) {
        _currentChildFormController = _utilizationForm;
    }
    
    [self addChildViewController:_currentChildFormController];
    [_formView addSubview:_currentChildFormController.view];
    [_currentChildFormController didMoveToParentViewController:self];
    [_currentChildFormController.view bindFrameToSuperviewBounds];
    [self highlightButton:sender];

    if (self.delegate != nil) {
        [self.delegate newPresentationSetupViewController:self didSelectToggleButton:sender];
    }
}

- (BOOL)currentFormIsAccountForm {
    return _currentChildFormController == _accountForm;
}

- (void)removeCurrentChildViewController
{
    if (_currentChildFormController) {
        [_currentChildFormController willMoveToParentViewController:nil];
        [_currentChildFormController.view removeFromSuperview];
        [_currentChildFormController removeFromParentViewController];
    }
    
    _currentChildFormController = nil;
}

- (void)highlightButton:(UIButton*)button
{
    [_accountButton setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    [_utilizationButton setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    
    [button setBackgroundColor:[[Colors getInstance] lightBlueColor]];
}

-(NSString*)analyticsIdentifier
{
    return @"new_presentation_setup";
}

@end
