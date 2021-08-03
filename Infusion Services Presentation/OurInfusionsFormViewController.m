//
//  OurInfusionsFormViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/13/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "OurInfusionsFormViewController.h"
#import "RemicadeInfusionViewController.h"
#import "StelaraInfusionViewController.h"
#import "SimponiAriaInfusionViewController.h"
#import "Scenario+Extension.h"
#import "Presentation+Extension.h"
#import "UILabel+SuperscriptLabel.h"
#import "IOMAnalyticsManager.h"
#import "UIView+IOMExtensions.h"

@interface OurInfusionsFormViewController ()<IOMAnalyticsIdentifiable>{
    UIStoryboard * _scenarioStoryboard;
    
    UIViewController<PresentationFormProtocol> * _currentChildController;
    RemicadeInfusionViewController * _remicadeInfusionViewController;
    SimponiAriaInfusionViewController * _simponiAriaInfusionViewController;
    StelaraInfusionViewController * _stelaraInfusionViewController;
}

@property (nonatomic, weak) IBOutlet UIButton * remicadeToggleButton;
@property (nonatomic, weak) IBOutlet UIButton * simponiAriaToggleButton;
@property (nonatomic, weak) IBOutlet UIView * childControllerContainerView;
@property (weak, nonatomic) IBOutlet UIButton *stelaraToggleButton;

@end

@implementation OurInfusionsFormViewController
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
    
    //[_remicadeToggleButton.titleLabel setSuperscriptForRegisteredTradeMarkSymbols];
    //[_simponiAriaToggleButton.titleLabel setSuperscriptForRegisteredTradeMarkSymbols];
    
    _scenarioStoryboard = [UIStoryboard storyboardWithName:@"ScenariosStoryboard" bundle:[NSBundle mainBundle]];
    
    [self initializeChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
    NSLog(@"P Type: %@", _scenario.presentation.presentationTypeID);
    [_simponiAriaToggleButton setHidden:![_scenario.presentation includeSimponiAria]];
    [_stelaraToggleButton setHidden:![_scenario.presentation includeStelara]];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([_scenario.presentation includeSimponiAria]) {
        [self formToggleButtonSelected:_simponiAriaToggleButton];
    } else {
        [self formToggleButtonSelected:_remicadeToggleButton];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeChildViewControllers
{
    if(!_remicadeInfusionViewController){
        _remicadeInfusionViewController = [_scenarioStoryboard instantiateViewControllerWithIdentifier:@"remicadeInfusionForm"];
        _remicadeInfusionViewController.scenario = _scenario;
    }
    if(!_simponiAriaInfusionViewController){
        _simponiAriaInfusionViewController = [_scenarioStoryboard instantiateViewControllerWithIdentifier:@"simponiAriaInfusionForm"];
        _simponiAriaInfusionViewController.scenario = _scenario;
    }
    if (!_stelaraInfusionViewController) {
        _stelaraInfusionViewController = [_scenarioStoryboard instantiateViewControllerWithIdentifier:@"stelaraInfusionForm"];
        _stelaraInfusionViewController.scenario = _scenario;
    }
}

#pragma mark - IBActions
- (IBAction)formToggleButtonSelected:(id)sender
{
    [_remicadeToggleButton setSelected:FALSE];
    [_simponiAriaToggleButton setSelected:FALSE];
    [_stelaraToggleButton setSelected:FALSE];

    [sender setSelected:TRUE];
    
    if(_currentChildController){
        [_currentChildController willMoveToParentViewController:nil];
        [_currentChildController.view removeFromSuperview];
        [_currentChildController removeFromParentViewController];
        _currentChildController = nil;
    }
    
    if(sender == _remicadeToggleButton){
        _currentChildController = _remicadeInfusionViewController;
    }else if(sender == _simponiAriaToggleButton){
        _currentChildController = _simponiAriaInfusionViewController;
    } else if (sender == _stelaraToggleButton) {
        _currentChildController = _stelaraInfusionViewController;
    }
    
    [self addChildViewController:_currentChildController];
    [_childControllerContainerView addSubview:_currentChildController.view];
    [_currentChildController.view bindFrameToSuperviewBounds];
    [_currentChildController didMoveToParentViewController:self];
}

#pragma mark - ChildViewController Methods
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil) {
        //removed
    } else {
        //Added
    }
}

#pragma mark - PresentationForm Protocol Methods
- (BOOL)isInputDataValid
{
    return [_remicadeInfusionViewController isInputDataValid] && [_simponiAriaInfusionViewController isInputDataValid] && [_stelaraInfusionViewController isInputDataValid];
}

- (void)willSavePresentation
{
    
}

- (void)showError
{
    if (![_remicadeInfusionViewController isInputDataValid]){
        [self formToggleButtonSelected:_remicadeToggleButton];
        [_currentChildController showError];
    } else if (![_simponiAriaInfusionViewController isInputDataValid]) {
        [self formToggleButtonSelected:_simponiAriaInfusionViewController];
        [_currentChildController showError];
    } else if (![_stelaraInfusionViewController isInputDataValid]) {
        [self formToggleButtonSelected:_stelaraInfusionViewController];
        [_currentChildController showError];
    }
}

-(NSString*)analyticsIdentifier
{
    return @"our_infusions_form";
}

@end
