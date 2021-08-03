//
//  InfusionServicesViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "InfusionServicesViewController.h"
#import "AppDelegate.h"
#import "AccountFormViewController.h"
#import "UtilizationFormViewController.h"
#import "PenetrationFormViewController.h"
#import "PayerMixFormViewController.h"
#import "ReimbursementFormViewController.h"
#import "VialTrendFormViewController.h"
#import "Presentation+Extension.h"
#import "PayerMix+Extension.h"
#import "Reimbursement+Extension.h"
#import "VialTrend+Extension.h"
#import "Utilization+Extension.h"
#import "Colors.h"
#import "IOMAnalyticsManager.h"
#import "UIView+IOMExtensions.h"

@interface InfusionServicesViewController ()<IOMAnalyticsIdentifiable>{
    UIStoryboard *storyboard;
    AppDelegate* appDelegate;
    NSManagedObjectContext* context;
    
    NSDateFormatter* vialMonthsDateFormatter;
    
    UIViewController* _currentChildFormController;
}

@property (nonatomic, weak) IBOutlet UIView* formView;

@property (nonatomic, strong) PayerMixFormViewController* payerMixForm;
@property (nonatomic, strong) ReimbursementFormViewController* reimbursementForm;
@property (nonatomic, strong) VialTrendFormViewController* vialTrendForm;

- (IBAction)vialTrendButtonSelected:(id)sender;
- (IBAction)reimbursementButtonSelected:(id)sender;
- (IBAction)payerMixButtonSelected:(id)sender;

@end

@implementation InfusionServicesViewController
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
    
    vialMonthsDateFormatter = [[NSDateFormatter alloc] init];
    [vialMonthsDateFormatter setDateFormat:@"M/yy"];
    
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    [self initializePresentation];
    [self initializeForms];
    [self toggleButtonSelected:_vialTrendButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showError
{
    [self toggleButtonSelected:_reimbursementButton];
    [_reimbursementForm showError];
}

- (void)presentationTypeChangedNotification:(NSNotification*)notification
{
    NSNumber* presentationType = [[notification userInfo] objectForKey:@"presentationType"];
    _presentation.presentationTypeID = presentationType;
    _vialTrendForm.presentationType = _presentation.presentationTypeID;
    _reimbursementForm.presentationType = [_presentation.presentationTypeID integerValue];
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
    if (_reimbursementForm.geographicArea == nil || [_reimbursementForm.geographicArea isEqualToString:@""])
    {
        NSLog(@"%@", _reimbursementForm.geographicArea);
        return NO;
    }
    
    return YES;
}

- (void)willSavePresentation
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];

    NSDate* vialTrendDate = [vialMonthsDateFormatter dateFromString:_vialTrendForm.lastDataMonth];
    //Vial Trend Form Data
    VialTrend * trend = [VialTrend getVialTrendOfType:VialTrendTypeRemicade forPresentation:_presentation];
    
    trend.lastDataMonth = vialTrendDate;
    trend.valueLastDataMonth = [NSNumber numberWithInteger:_vialTrendForm.valueLastDataMonth];
    trend.valueOneMonthBefore = [NSNumber numberWithInteger:_vialTrendForm.valueOneMonthBefore];
    trend.valueTwoMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueTwoMonthsBefore];
    trend.valueThreeMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueThreeMonthsBefore];
    trend.valueFourMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueFourMonthsBefore];
    trend.valueFiveMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueFiveMonthsBefore];
    trend.valueSixMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueSixMonthsBefore];
    trend.valueSevenMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueSevenMonthsBefore];
    trend.valueEightMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueEightMonthsBefore];
    trend.valueNineMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueNineMonthsBefore];
    trend.valueTenMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueTenMonthsBefore];
    trend.valueElevenMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueElevenMonthsBefore];
    
    VialTrend * trendSim = [VialTrend getVialTrendOfType:VialTrendTypeSimponiAria forPresentation:_presentation];
    trendSim.lastDataMonth = vialTrendDate;
    trendSim.valueLastDataMonth = [NSNumber numberWithInteger:_vialTrendForm.valueLastDataMonthSim];
    trendSim.valueOneMonthBefore = [NSNumber numberWithInteger:_vialTrendForm.valueOneMonthBeforeSim];
    trendSim.valueTwoMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueTwoMonthsBeforeSim];
    trendSim.valueThreeMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueThreeMonthsBeforeSim];
    trendSim.valueFourMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueFourMonthsBeforeSim];
    trendSim.valueFiveMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueFiveMonthsBeforeSim];
    trendSim.valueSixMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueSixMonthsBeforeSim];
    trendSim.valueSevenMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueSevenMonthsBeforeSim];
    trendSim.valueEightMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueEightMonthsBeforeSim];
    trendSim.valueNineMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueNineMonthsBeforeSim];
    trendSim.valueTenMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueTenMonthsBeforeSim];
    trendSim.valueElevenMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueElevenMonthsBeforeSim];

    VialTrend * trendStelara = [VialTrend getVialTrendOfType:VialTrendTypeStelara forPresentation:_presentation];
    trendStelara.lastDataMonth = vialTrendDate;
    trendStelara.valueLastDataMonth = [NSNumber numberWithInteger:_vialTrendForm.valueLastDataMonthStelara];
    trendStelara.valueOneMonthBefore = [NSNumber numberWithInteger:_vialTrendForm.valueOneMonthBeforeStelara];
    trendStelara.valueTwoMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueTwoMonthsBeforeStelara];
    trendStelara.valueThreeMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueThreeMonthsBeforeStelara];
    trendStelara.valueFourMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueFourMonthsBeforeStelara];
    trendStelara.valueFiveMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueFiveMonthsBeforeStelara];
    trendStelara.valueSixMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueSixMonthsBeforeStelara];
    trendStelara.valueSevenMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueSevenMonthsBeforeStelara];
    trendStelara.valueEightMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueEightMonthsBeforeStelara];
    trendStelara.valueNineMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueNineMonthsBeforeStelara];
    trendStelara.valueTenMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueTenMonthsBeforeStelara];
    trendStelara.valueElevenMonthsBefore = [NSNumber numberWithInteger:_vialTrendForm.valueElevenMonthsBeforeStelara];
    
    //Reimbursement form data
    if(!_presentation.reimbursement){
        Reimbursement* reimbursement = [NSEntityDescription insertNewObjectForEntityForName:@"Reimbursement" inManagedObjectContext:context];
        _presentation.reimbursement = reimbursement;
    }
    _presentation.reimbursement.reimbursementFor96413 = [NSNumber numberWithFloat:_reimbursementForm.reimbursement96413];
    _presentation.reimbursement.reimbursementFor96415 = [NSNumber numberWithFloat:_reimbursementForm.reimbursement96415];
    _presentation.reimbursement.reimbursementFor96365 = [NSNumber numberWithFloat:_reimbursementForm.reimbursement96365];
    _presentation.reimbursement.geographicArea = _reimbursementForm.geographicArea;
    
    //Payer mix form data
    while ([_presentation.payerMixes count] < 5) {
        PayerMix* pm = [NSEntityDescription insertNewObjectForEntityForName:@"PayerMix" inManagedObjectContext:context];
        [_presentation addPayerMixesObject:pm];
    }
    
    PayerMix *pm1 = [[_presentation.payerMixes allObjects] objectAtIndex:0];
    PayerMix *pm2 = [[_presentation.payerMixes allObjects] objectAtIndex:1];
    PayerMix *pm3 = [[_presentation.payerMixes allObjects] objectAtIndex:2];
    PayerMix *pm4 = [[_presentation.payerMixes allObjects] objectAtIndex:3];
    PayerMix *pm5 = [[_presentation.payerMixes allObjects] objectAtIndex:4];
    pm1.order = [NSNumber numberWithInt:0];
    pm2.order = [NSNumber numberWithInt:1];
    pm3.order = [NSNumber numberWithInt:2];
    pm4.order = [NSNumber numberWithInt:3];
    pm5.order = [NSNumber numberWithInt:4];
    pm1.payer = _payerMixForm.payer1String;
    pm2.payer = _payerMixForm.payer2String;
    pm3.payer = _payerMixForm.payer3String;
    pm4.payer = _payerMixForm.payer4String;
    pm5.payer = _payerMixForm.payer5String;
    //percents have been removed
    /*pm1.percentOfRemicade = [NSNumber numberWithInt:_payerMixForm.percentOfRem1];
     pm2.percentOfRemicade = [NSNumber numberWithInt:_payerMixForm.percentOfRem2];
     pm3.percentOfRemicade = [NSNumber numberWithInt:_payerMixForm.percentOfRem3];
     pm4.percentOfRemicade = [NSNumber numberWithInt:_payerMixForm.percentOfRem4];
     pm5.percentOfRemicade = [NSNumber numberWithInt:_payerMixForm.percentOfRem5];
     */
    pm1.spp = [NSNumber numberWithBool:_payerMixForm.spp1Selected];
    pm2.spp = [NSNumber numberWithBool:_payerMixForm.spp2Selected];
    pm3.spp = [NSNumber numberWithBool:_payerMixForm.spp3Selected];
    pm4.spp = [NSNumber numberWithBool:_payerMixForm.spp4Selected];
    pm5.spp = [NSNumber numberWithBool:_payerMixForm.spp5Selected];

    pm1.soc = [NSNumber numberWithBool:_payerMixForm.soc1Selected];
    pm2.soc = [NSNumber numberWithBool:_payerMixForm.soc2Selected];
    pm3.soc = [NSNumber numberWithBool:_payerMixForm.soc3Selected];
    pm4.soc = [NSNumber numberWithBool:_payerMixForm.soc4Selected];
    pm5.soc = [NSNumber numberWithBool:_payerMixForm.soc5Selected];
}

- (void) initializePresentation{
    if(!_presentation){
        _presentation = [NSEntityDescription insertNewObjectForEntityForName:@"Presentation" inManagedObjectContext:context];
        //_presentation.order = [appDelegate getPresentationOrderNumber];
    }
}

- (void)updateVialTrends
{
    _vialTrendForm.presentationType = _presentation.presentationTypeID;
    
    VialTrend* trend = [VialTrend getVialTrendOfType:VialTrendTypeRemicade forPresentation:_presentation];
    if(trend){
        _vialTrendForm.lastDataMonth = [vialMonthsDateFormatter stringFromDate:trend.lastDataMonth];
        _vialTrendForm.valueLastDataMonth = [trend.valueLastDataMonth integerValue];
        _vialTrendForm.valueOneMonthBefore = [trend.valueOneMonthBefore integerValue];
        _vialTrendForm.valueTwoMonthsBefore = [trend.valueTwoMonthsBefore integerValue];
        _vialTrendForm.valueThreeMonthsBefore = [trend.valueThreeMonthsBefore integerValue];
        _vialTrendForm.valueFourMonthsBefore = [trend.valueFourMonthsBefore integerValue];
        _vialTrendForm.valueFiveMonthsBefore = [trend.valueFiveMonthsBefore integerValue];
        _vialTrendForm.valueSixMonthsBefore = [trend.valueSixMonthsBefore integerValue];
        _vialTrendForm.valueSevenMonthsBefore = [trend.valueSevenMonthsBefore integerValue];
        _vialTrendForm.valueEightMonthsBefore = [trend.valueEightMonthsBefore integerValue];
        _vialTrendForm.valueNineMonthsBefore = [trend.valueNineMonthsBefore integerValue];
        _vialTrendForm.valueTenMonthsBefore = [trend.valueTenMonthsBefore integerValue];
        _vialTrendForm.valueElevenMonthsBefore = [trend.valueElevenMonthsBefore integerValue];
    }
    VialTrend* trendSim = [VialTrend getVialTrendOfType:VialTrendTypeSimponiAria forPresentation:_presentation];
    if(trendSim){
        //_vialTrendForm.lastDataMonth = [vialMonthsDateFormatter stringFromDate:trendSim.lastDataMonth];
        _vialTrendForm.valueLastDataMonthSim = [trendSim.valueLastDataMonth integerValue];
        _vialTrendForm.valueOneMonthBeforeSim = [trendSim.valueOneMonthBefore integerValue];
        _vialTrendForm.valueTwoMonthsBeforeSim = [trendSim.valueTwoMonthsBefore integerValue];
        _vialTrendForm.valueThreeMonthsBeforeSim = [trendSim.valueThreeMonthsBefore integerValue];
        _vialTrendForm.valueFourMonthsBeforeSim = [trendSim.valueFourMonthsBefore integerValue];
        _vialTrendForm.valueFiveMonthsBeforeSim = [trendSim.valueFiveMonthsBefore integerValue];
        _vialTrendForm.valueSixMonthsBeforeSim = [trendSim.valueSixMonthsBefore integerValue];
        _vialTrendForm.valueSevenMonthsBeforeSim = [trendSim.valueSevenMonthsBefore integerValue];
        _vialTrendForm.valueEightMonthsBeforeSim = [trendSim.valueEightMonthsBefore integerValue];
        _vialTrendForm.valueNineMonthsBeforeSim = [trendSim.valueNineMonthsBefore integerValue];
        _vialTrendForm.valueTenMonthsBeforeSim = [trendSim.valueTenMonthsBefore integerValue];
        _vialTrendForm.valueElevenMonthsBeforeSim = [trendSim.valueElevenMonthsBefore integerValue];
    }

    VialTrend* trendStelara = [VialTrend getVialTrendOfType:VialTrendTypeStelara forPresentation:_presentation];
    if(trendStelara){
        //_vialTrendForm.lastDataMonth = [vialMonthsDateFormatter stringFromDate:trendStelara.lastDataMonth];
        _vialTrendForm.valueLastDataMonthStelara = [trendStelara.valueLastDataMonth integerValue];
        _vialTrendForm.valueOneMonthBeforeStelara = [trendStelara.valueOneMonthBefore integerValue];
        _vialTrendForm.valueTwoMonthsBeforeStelara = [trendStelara.valueTwoMonthsBefore integerValue];
        _vialTrendForm.valueThreeMonthsBeforeStelara = [trendStelara.valueThreeMonthsBefore integerValue];
        _vialTrendForm.valueFourMonthsBeforeStelara = [trendStelara.valueFourMonthsBefore integerValue];
        _vialTrendForm.valueFiveMonthsBeforeStelara = [trendStelara.valueFiveMonthsBefore integerValue];
        _vialTrendForm.valueSixMonthsBeforeStelara = [trendStelara.valueSixMonthsBefore integerValue];
        _vialTrendForm.valueSevenMonthsBeforeStelara = [trendStelara.valueSevenMonthsBefore integerValue];
        _vialTrendForm.valueEightMonthsBeforeStelara = [trendStelara.valueEightMonthsBefore integerValue];
        _vialTrendForm.valueNineMonthsBeforeStelara = [trendStelara.valueNineMonthsBefore integerValue];
        _vialTrendForm.valueTenMonthsBeforeStelara = [trendStelara.valueTenMonthsBefore integerValue];
        _vialTrendForm.valueElevenMonthsBeforeStelara = [trendStelara.valueElevenMonthsBefore integerValue];
    }
}

- (void)initializeForms
{
    if(!_vialTrendForm){
        self.vialTrendForm = [storyboard instantiateViewControllerWithIdentifier:@"vialTrendForm"];
        [self updateVialTrends];
    }
    if(!_reimbursementForm){
        self.reimbursementForm = [storyboard instantiateViewControllerWithIdentifier:@"reimbursementForm"];
        //_reimbursementForm.context = context;
        if(_presentation.reimbursement){
            _reimbursementForm.reimbursement96413 = [_presentation.reimbursement.reimbursementFor96413 floatValue];
            _reimbursementForm.reimbursement96415 = [_presentation.reimbursement.reimbursementFor96415 floatValue];
            _reimbursementForm.reimbursement96365 = [_presentation.reimbursement.reimbursementFor96365 floatValue];
            _reimbursementForm.geographicArea = _presentation.reimbursement.geographicArea;
        }
    }
    if(!_payerMixForm){
        self.payerMixForm = [storyboard instantiateViewControllerWithIdentifier:@"payerMixForm"];
        //_payerMixForm.context = context;
        if([_presentation.payerMixes count] > 0){
            PayerMix* pm1 = nil;
            PayerMix* pm2 = nil;
            PayerMix* pm3 = nil;
            PayerMix* pm4 = nil;
            PayerMix* pm5 = nil;
            
            NSMutableArray* mixes = [NSMutableArray arrayWithArray:[_presentation.payerMixes allObjects]];
            NSSortDescriptor* sortByOrder = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
            [mixes sortUsingDescriptors:[NSArray arrayWithObject:sortByOrder]];
            int count = 0;
            for(PayerMix *pm in mixes){
                switch(count){
                    case 0:
                        pm1 = pm;
                        break;
                    case 1:
                        pm2 = pm;
                        break;
                    case 2:
                        pm3 = pm;
                        break;
                    case 3:
                        pm4 = pm;
                        break;
                    case 4:
                        pm5 = pm;
                        break;
                }
                
                count++;
            }
            
            if(pm1){
                _payerMixForm.payer1String = pm1.payer;
                _payerMixForm.percentOfRem1 = 0;// This is being removed from the app [pm1.percentOfRemicade integerValue];
                _payerMixForm.spp1Selected = [pm1.spp boolValue];
                _payerMixForm.soc1Selected = [pm1.soc boolValue];
            }
            
            if (pm2){
                _payerMixForm.payer2String = pm2.payer;
                _payerMixForm.percentOfRem2 = 0;// This is being removed from the app [pm2.percentOfRemicade integerValue];
                _payerMixForm.spp2Selected = [pm2.spp boolValue];
                _payerMixForm.soc2Selected = [pm2.soc boolValue];
            }
            
            if (pm3){
                _payerMixForm.payer3String = pm3.payer;
                _payerMixForm.percentOfRem3 = 0;// This is being removed from the app [pm3.percentOfRemicade integerValue];
                _payerMixForm.spp3Selected = [pm3.spp boolValue];
                _payerMixForm.soc3Selected = [pm3.soc boolValue];
            }
            
            if (pm4){
                _payerMixForm.payer4String = pm4.payer;
                _payerMixForm.percentOfRem4 = 0;// This is being removed from the app [pm4.percentOfRemicade integerValue];
                _payerMixForm.spp4Selected = [pm4.spp boolValue];
                _payerMixForm.soc4Selected = [pm4.soc boolValue];
            }
            
            if (pm5){
                _payerMixForm.payer5String = pm5.payer;
                _payerMixForm.percentOfRem5 = 0;// This is being removed from the app [pm5.percentOfRemicade integerValue];
                _payerMixForm.spp5Selected = [pm5.spp boolValue];
                _payerMixForm.soc5Selected = [pm5.soc boolValue];
            }
        }
    }
}

#pragma mark - IBActions
- (IBAction)vialTrendButtonSelected:(id)sender
{
    [self toggleButtonSelected:sender];
}

- (IBAction)reimbursementButtonSelected:(id)sender
{
    [self toggleButtonSelected:sender];
}

- (IBAction)payerMixButtonSelected:(id)sender
{
    [self toggleButtonSelected:sender];
}

- (void)toggleButtonSelected:(id)sender
{
    //Remove old child view controller
    if (_currentChildFormController) {
        [_currentChildFormController willMoveToParentViewController:nil];
        [_currentChildFormController.view removeFromSuperview];
        [_currentChildFormController removeFromParentViewController];
    }
    
    if (sender == _vialTrendButton) {
        _currentChildFormController = _vialTrendForm;
    } else if (sender == _reimbursementButton) {
        _currentChildFormController = _reimbursementForm;
    } else if (sender == _payerMixButton) {
        _currentChildFormController = _payerMixForm;
    }
    
    
    [self addChildViewController:_currentChildFormController];
    [_formView addSubview:_currentChildFormController.view];
    [_currentChildFormController didMoveToParentViewController:self];
    [_currentChildFormController.view bindFrameToSuperviewBounds];
    [self highlightButton:sender];
}

- (void)highlightButton:(UIButton*)button
{
    [_vialTrendButton setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    [_reimbursementButton setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    [_payerMixButton setBackgroundColor:[[Colors getInstance] darkBlueColor]];
    
    [button setBackgroundColor:[[Colors getInstance] lightBlueColor]];
}

-(NSString*)analyticsIdentifier
{
    return @"infusion_services";
}

@end
