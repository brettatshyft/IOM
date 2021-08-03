//
//  ScenarioEditingViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/9/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "ScenarioEditingViewController.h"
#import "Presentation+Extension.h"
#import "Scenario+Extension.h"
#import "ScenarioInfoFormViewController.h"
#import "ChairsFormViewController.h"
#import "StaffFormViewController.h"
#import "OurInfusionsFormViewController.h"
#import "OtherInfusionsFormViewController.h"
#import "OtherInjectionsFormViewController.h"
#import "Colors.h"
#import "RemicadeInfusion+Extension.h"
#import "SimponiAriaInfusion+Extension.h"
#import "OtherInfusion+Extension.h"
#import "OtherInjection+Extension.h"
#import "SolutionData+Extension.h"
#import "IOMAnalyticsManager.h"
#import "StelaraInfusion+CoreDataClass.h"
#import "StelaraInfusion+CoreDataProperties.h"

@interface ScenarioEditingViewController ()<IOMAnalyticsIdentifiable>{
    UIStoryboard* _scenarioStoryboard;
    
    UIViewController<PresentationFormProtocol, ScenarioForm> * _currentChildFormViewController;
    UIViewController<PresentationFormProtocol, ScenarioForm> * _scenarioInfoFormController;
    UIViewController<PresentationFormProtocol, ScenarioForm> * _chairsFormController;
    UIViewController<PresentationFormProtocol, ScenarioForm> * _staffFormController;
    UIViewController<PresentationFormProtocol, ScenarioForm> * _ourInfusionsFormController;
    UIViewController<PresentationFormProtocol, ScenarioForm> * _otherInfusionsFormController;
    UIViewController<PresentationFormProtocol, ScenarioForm> * _otherInjectionsFormController;
    
    NSUndoManager* _undoManager;
    
    NSDateFormatter* _dateFormatter;
}

@property (nonatomic, weak) IBOutlet UIButton* scenarioInfoTab;
@property (nonatomic, weak) IBOutlet UIButton* chairsTab;
@property (nonatomic, weak) IBOutlet UIButton* staffTab;
@property (nonatomic, weak) IBOutlet UIButton* ourInfusionsTab;
@property (nonatomic, weak) IBOutlet UIButton* otherInfusionsTab;
@property (nonatomic, weak) IBOutlet UIButton* otherInjectionsTab;

@property (nonatomic, weak) IBOutlet UIView* formContainerView;

@end

@implementation ScenarioEditingViewController

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
    [self initialize];
    
    _scenarioStoryboard = [UIStoryboard storyboardWithName:@"ScenariosStoryboard" bundle:[NSBundle mainBundle]];
    
    [self initializeFormControllers];
    
    //Select all tabs, this ensures all viewDidLoads get called
    [self tabSelected:_chairsTab];
    [self tabSelected:_staffTab];
    [self tabSelected:_ourInfusionsTab];
    [self tabSelected:_otherInfusionsTab];
    [self tabSelected:_otherInjectionsTab];
    
    UISwipeGestureRecognizer* swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeRightRecognizer setDelegate:self];
    UISwipeGestureRecognizer* swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeLeftRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:swipeRightRecognizer];
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"M/d/yyyy"];
    
    [self setNavTitle];
    
    [self tabSelected:_scenarioInfoTab];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    
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

- (void)handleBackButton:(id)sender
{
    //Alert
    [[[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Are you sure you want to cancel this scenario? Any changes made will be lost." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show];
}

- (void)swipeDetected:(UISwipeGestureRecognizer*)recognizer{
    //if(![_overlayView isHidden]) return;
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        //NSLog(@"Left");
        if ([_otherInjectionsTab.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            [self tabSelected:_otherInfusionsTab];
        else if ([_otherInfusionsTab.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            [self tabSelected:_ourInfusionsTab];
        else if ([_ourInfusionsTab.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            [self tabSelected:_staffTab];
        else if ([_staffTab.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            [self tabSelected:_chairsTab];
        else if ([_chairsTab.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            [self tabSelected:_scenarioInfoTab];
    }else if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
        //NSLog(@"Right - %@, %@", [_presentationSetupButton.backgroundColor description], [[Colors getInstance] lightBlueColor]);
        if ([_scenarioInfoTab.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            [self tabSelected:_chairsTab];
        else if ([_chairsTab.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            [self tabSelected:_staffTab];
        else if ([_staffTab.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            [self tabSelected:_ourInfusionsTab];
        else if ([_ourInfusionsTab.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            [self tabSelected:_otherInfusionsTab];
        else if ([_otherInfusionsTab.backgroundColor isEqual:[[Colors getInstance] lightBlueColor]])
            [self tabSelected:_otherInjectionsTab];
    }
}

#pragma mark - initialization
- (void)setNavTitle
{
    NSMutableString * title = [NSMutableString string];
    [title appendString:(_presentation.accountName) ? _presentation.accountName : @"New Presentation"];
    [title appendString:@" - "];
    [title appendString:(_presentation.presentationDate) ? [_dateFormatter stringFromDate:_presentation.presentationDate] : [_dateFormatter stringFromDate:[NSDate date]]];
    [title appendString:@" - "];
    [title appendString:(_scenario.name) ? _scenario.name : @"New Scenario"];
    [self setTitle:title];
}

- (void)initialize
{
    //Override back button
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(handleBackButton:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //Grab undo manager for managedObjectContext
    NSManagedObjectContext* context = _presentation.managedObjectContext;
    _undoManager = [context undoManager];
    
    //Start undo group
    [_undoManager beginUndoGrouping];
    
    //Create scenario if one is not present
    if(!_scenario){
        _scenario = [Scenario createScenarioForPresentation:_presentation];

        [RemicadeInfusion getRemicadeInfusionForScenario:_scenario];
        [SimponiAriaInfusion getSimponiAriaInfusionForScenario:_scenario];
        [StelaraInfusion getStelaraInfusionForScenario:_scenario];

        [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxA forScenario:_scenario];
        [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxB forScenario:_scenario];
        [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxC forScenario:_scenario];
        [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxD forScenario:_scenario];
        [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxE forScenario:_scenario];
        [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxF forScenario:_scenario];
        [OtherInjection getOtherInjectionOfType:OtherInjectionType1 forScenario:_scenario];
        [OtherInjection getOtherInjectionOfType:OtherInjectionType2 forScenario:_scenario];
    }
}

- (void)initializeFormControllers
{
    if(!_scenarioInfoFormController)
    {
        _scenarioInfoFormController = [_scenarioStoryboard instantiateViewControllerWithIdentifier:@"scenarioInfoForm"];
        _scenarioInfoFormController.scenario = _scenario;
    }
    
    if(!_chairsFormController)
    {
        _chairsFormController = [_scenarioStoryboard instantiateViewControllerWithIdentifier:@"chairsForm"];
        _chairsFormController.scenario = _scenario;
    }
    
    if (!_staffFormController) {
        _staffFormController = [_scenarioStoryboard instantiateViewControllerWithIdentifier:@"staffForm"];
        _staffFormController.scenario = _scenario;
    }
    
    if(!_ourInfusionsFormController){
        _ourInfusionsFormController = [_scenarioStoryboard instantiateViewControllerWithIdentifier:@"ourInfusionsForm"];
        _ourInfusionsFormController.scenario = _scenario;
    }
    
    if(!_otherInfusionsFormController){
        _otherInfusionsFormController = [_scenarioStoryboard instantiateViewControllerWithIdentifier:@"otherInfusionsForm"];
        _otherInfusionsFormController.scenario = _scenario;
    }
    
    if(!_otherInjectionsFormController){
        _otherInjectionsFormController = [_scenarioStoryboard instantiateViewControllerWithIdentifier:@"otherInjectionsForm"];
        _otherInjectionsFormController.scenario = _scenario;
    }
}

- (BOOL)isInputDataValid
{
    if (![_scenarioInfoFormController isInputDataValid]){
        [self tabSelected:_scenarioInfoTab];
        [_currentChildFormViewController showError];
        return NO;
    } else if (![_chairsFormController isInputDataValid]) {
        [self tabSelected:_chairsTab];
        [_currentChildFormViewController showError];
        return NO;
    } else if (![_staffFormController isInputDataValid]) {
        [self tabSelected:_staffTab];
        [_currentChildFormViewController showError];
        return NO;
    } else if (![_ourInfusionsFormController isInputDataValid]) {
        [self tabSelected:_ourInfusionsTab];
        [_currentChildFormViewController showError];
        return NO;
    } else if (![_otherInfusionsFormController isInputDataValid]) {
        [self tabSelected:_otherInfusionsTab];
        [_currentChildFormViewController showError];
        return NO;
    } else if (![_otherInjectionsFormController isInputDataValid]) {
        [self tabSelected:_otherInjectionsTab];
        [_currentChildFormViewController showError];
        return NO;
    }
    
    return YES;
}

- (void)saveEditingScenarioAndExit
{
    //Check input values are valid
    if ([self isInputDataValid]) {
        //Set last updated times stamp
        _scenario.lastUpdated = [NSDate date];
        _scenario.solutionDataNeedsToBeProcessed = @YES;
        
        //end undo grouping
        [_undoManager endUndoGrouping];
        
        //pop back
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"ALERT - Input is not valid!");
    }
}

- (void)highlightSelectedTab:(id)selectedTab
{
    [_scenarioInfoTab setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    [_chairsTab setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    [_staffTab setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    [_ourInfusionsTab setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    [_otherInfusionsTab setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    [_otherInjectionsTab setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    
    UIButton* selected = selectedTab;
    [selected setBackgroundColor:[[Colors getInstance] lightBlueColor]];
}

#pragma mark - ScenarioFormDataSource methods
- (Scenario*)scenarioForForm:(UIViewController *)formViewController
{
    return _scenario;
}

#pragma mark - IBActions
- (IBAction)tabSelected:(id)sender
{
    [self highlightSelectedTab:sender];
    
    if(_currentChildFormViewController)
    {
        [_currentChildFormViewController willMoveToParentViewController:nil];
        [_currentChildFormViewController.view removeFromSuperview];
        [_currentChildFormViewController removeFromParentViewController];
        _currentChildFormViewController = nil;
    }
    
    if(sender == _scenarioInfoTab)
    {
        _currentChildFormViewController = _scenarioInfoFormController;
    }
    else if(sender == _chairsTab)
    {
        _currentChildFormViewController = _chairsFormController;
    }
    else if(sender == _staffTab)
    {
        _currentChildFormViewController = _staffFormController;
    }
    else if(sender == _ourInfusionsTab)
    {
        _currentChildFormViewController = _ourInfusionsFormController;
    }
    else if(sender == _otherInfusionsTab)
    {
        _currentChildFormViewController = _otherInfusionsFormController;
    }
    else if(sender == _otherInjectionsTab)
    {
        _currentChildFormViewController = _otherInjectionsFormController;
    }
    
    
    [self addChildViewController:_currentChildFormViewController];
    UIView* newView = _currentChildFormViewController.view;
    [newView setFrame:CGRectMake(0, 0, _formContainerView.frame.size.width, _formContainerView.frame.size.height)];
    [_formContainerView addSubview:newView];
    [_currentChildFormViewController didMoveToParentViewController:self];
}

- (IBAction)saveButtonSelected:(id)sender
{
    [self saveEditingScenarioAndExit];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView cancelButtonIndex] == buttonIndex){
        //Nothing
    }else{
        //No saving, undo changes and pop back
        [_undoManager endUndoGrouping];
        [_undoManager undoNestedGroup];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSString*)analyticsIdentifier
{
    return @"scenario_editing";
}

@end
