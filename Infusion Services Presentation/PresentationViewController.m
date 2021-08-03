//
//  PresentationViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "PresentationViewController.h"
#import "NewPresentationViewController.h"
#import "AppDelegate.h"
#import "IOMSlideLink.h"
#import "IOMSlideLinkButton.h"
#import "IOMPDFViewController.h"
#import "Slide.h"
#import "ListValues.h"
#import "SISIViewController.h"
#import "DropdownDataSource.h"
#import "DropdownController.h"
#import "PresentationFormProtocol.h"
#import "Presentation.h"
#import "Presentation+Extension.h"
#import "PatientPopulationSlideViewController.h"
#import "AccountPatientUtilizationSlideViewController.h"
#import "VialTrendsSlideViewController.h"
#import "PayerMixSlideViewController.h"
#import "ScenarioReportOverlayViewController.h"
#import "ScenarioOverviewViewController.h"
#import "DrugAdministrationSlideViewController.h"
#import "ResourceUtilizationSlideViewController.h"
#import "Scenario+Extension.h"
#import "PDFGeneratorViewController.h"
#import "SolutionData+Extension.h"
#import "GraphWebView.h"
#import "UIDevice+Resolutions.h"
#import "IOMAnalyticsManager.h"
#import "UILabel+SuperscriptLabel.h"
#import "UIView+IOMExtensions.h"
#import "IOMBiologicalOverviewAccountSlideViewController.h"
#import "IOMLogoTriptych.h"

#define NUMBER_OF_SLIDES 59
#define BASE_SLIDE_KEY @"dynamicSlide"
#define ACCOUNT_NAME_SLIDE_KEY @"accountNameSlide"

@interface PresentationViewController ()<IOMAnalyticsIdentifiable>{
    NSInteger currentSlide;
    NSManagedObjectContext* context;
    
    UIStoryboard* _mainStoryboard;
    
    BOOL hasLoaded;
    UITapGestureRecognizer* tapGestureRecognizer;
    NSMutableArray *slideArray;
    
    NSMutableArray *chapterArray;
    NSMutableArray *chapterNumberArray;
    
    UIPopoverController* _slideNumberPopoverController;
    UITextField *_slideNumberTextField;
    
    UIPopoverController* _chaptersPopoverController;
    DropdownDataSource* _dropdownDataSource;
    
    SISIViewController* _SISIViewController;
    
    /*
    PatientPopulationSlideViewController * _PatientPopulationSlideViewController;
    AccountPatientUtilizationSlideViewController * _AccountPatientUtilizationSlideViewController;
    VialTrendsSlideViewController * _VialTrendsSlideViewController;
    PayerMixSlideViewController * _PayerMixSlideViewController;
    DrugAdministrationSlideViewController *_DrugAdministrationSlideViewController;
    ResourceUtilizationSlideViewController *_ResourceUtilizationSlideViewController;
    */
    
    ScenarioOverviewViewController * _ScenarioOverviewViewController;
    ScenarioReportOverlayViewController * _ScenarioReportOverlayViewController;
    
    UIViewController * _currentOverlayViewController;

    DropdownDataSource *_emailReportDropdownDataSource;
    UIPopoverController *_emailReportPopoverController;

    NSUInteger stelaraStart;
    NSUInteger stelaraEnd;
    NSUInteger simponiStart;
    NSUInteger simponiEnd;
    NSUInteger remicadeStart;
    NSUInteger remicadeEnd;
    
    NSUInteger firstInfusionOptimizationSlide;
    
    NSOperationQueue *operationQueue;
    NSUInteger operationIndex;
    
    UISwipeGestureRecognizer* swipeRightRecognizer;
    UISwipeGestureRecognizer* swipeLeftRecognizer;
    
    BOOL SISIExpanded;
    
    Scenario * _selectedEmailScenario;
}
@property (nonatomic, weak) IBOutlet UIImageView* slideImageView;
@property (nonatomic, weak) IBOutlet UILabel* slideNumberLabel;
@property (nonatomic, weak) IBOutlet UIView* overlayView;
@property (nonatomic, weak) IBOutlet UIView* dynamicOverlayView;
@property (weak, nonatomic) IBOutlet UIView *SISIOverlayView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *overlaySlideCounter;
@property (weak, nonatomic) IBOutlet UILabel *isiReferenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *emailReportsBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editPresentationBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *chaptersBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *spacerBarItem;
@property (weak, nonatomic) IBOutlet UIView *viewForLinkButtons;
@property (weak, nonatomic) IBOutlet UILabel *presentationNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dynamicOverlayBottomLayoutConstraint;

@property (strong, nonatomic) NSEnumerator *enumerator;


@end

@implementation PresentationViewController

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

    [[GraphWebView getStaticView] loadGraphFiles];
    
    _mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    AppDelegate* appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    context = [appDel managedObjectContext];

    swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeRightRecognizer setDelegate:self];
    swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeLeftRecognizer setDelegate:self];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:swipeRightRecognizer];
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    
    currentSlide = 1;
    
    _SISIViewController = [[SISIViewController alloc] init];
    [_SISIViewController.view setFrame:CGRectMake(0,512,1024,256)];
}

-(void) initiateScenarioProcessing
{
    operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.name = @"Scenario Processing Queue";
    [operationQueue setMaxConcurrentOperationCount:1];
    
    _enumerator = [[NSEnumerator alloc] init];
    _enumerator = [_presentation.scenarios objectEnumerator];
    
    operationIndex=0;
    
    [self processNextScenario];
}

-(void) processNextScenario
{
    Scenario * scenumerator = [_enumerator nextObject];
    if (scenumerator)
    {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                selector:@selector(processSolutionDataIfNeeded:)
                                                                                  object:scenumerator];
        [operationQueue addOperation:operation];
        operationIndex++;
    }
}

-(void) processSolutionDataIfNeeded:(Scenario *)scenario
{
    [(Scenario *)scenario processSolutionDataIfNeeded];
}

-(void) initSlideArray
{
    if (slideArray==nil) slideArray = [[NSMutableArray alloc] init];
    else [slideArray removeAllObjects];
    
    if (chapterArray==nil) chapterArray = [[NSMutableArray alloc] init];
    else [chapterArray removeAllObjects];
    
    if (chapterNumberArray==nil) chapterNumberArray = [[NSMutableArray alloc] init];
    else [chapterNumberArray removeAllObjects];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"slides" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    NSArray *arrayOfSlides = [[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil] objectForKey:@"Slides"];
    
    for (NSUInteger currentlyProcessingSlideNum = 0; currentlyProcessingSlideNum < [arrayOfSlides count]; currentlyProcessingSlideNum++) {
        NSDictionary * dictionaryOfJSONSlideData = [arrayOfSlides objectAtIndex:currentlyProcessingSlideNum];
        NSUInteger presentationSectionsValue = [LIST_VALUES_ARRAY_PRESENTATION_SECTIONS indexOfObject:[dictionaryOfJSONSlideData objectForKey:@"presentationSections"]];
        
        NSMutableArray * presentationTypesValue = [[NSMutableArray alloc] init];
        for (NSUInteger j=0; j<[[dictionaryOfJSONSlideData objectForKey:@"presentationTypes"] count]; j++)
        {
            [presentationTypesValue setObject:[NSNumber numberWithUnsignedInteger:[LIST_VALUES_ARRAY_PRESENTATION_TYPE indexOfObject:[[dictionaryOfJSONSlideData objectForKey:@"presentationTypes"] objectAtIndex:j]]] atIndexedSubscript:j];
        }
        
        NSArray* arrayOfJSONLinks = dictionaryOfJSONSlideData[@"links"];
        NSMutableArray<IOMSlideLink*>* arrayOfSlideLinkObjects = [NSMutableArray arrayWithCapacity:arrayOfJSONLinks.count];
        
        for (NSDictionary* linkDictionary in arrayOfJSONLinks)
        {
            [arrayOfSlideLinkObjects addObject:[[IOMSlideLink alloc] initWithJSONData:linkDictionary]];
        }
        
        NSUInteger SISIValue = [LIST_VALUES_ARRAY_SLIDE_SISI indexOfObject:[dictionaryOfJSONSlideData objectForKey:@"SISI"]];
        
        NSString *chapterTitle=[dictionaryOfJSONSlideData objectForKey:@"chapterTitle"];
        
        BOOL presentationSectionOK=TRUE;
        
        if (([presentationTypesValue count]==0 || [presentationTypesValue containsObject:_presentation.presentationTypeID])&&presentationSectionOK)
        {
            NSUInteger anotherSlideCount=1;
            
            if (([dictionaryOfJSONSlideData objectForKey:@"overlayIDs"]!=nil) && ([[dictionaryOfJSONSlideData objectForKey:@"overlayIDs"] count]>0) && [[[dictionaryOfJSONSlideData objectForKey:@"overlayIDs"] objectAtIndex:0] isEqualToString:@"infusionOptimizationInputSummary"]) {
                anotherSlideCount=[_presentation.scenarios count];
                firstInfusionOptimizationSlide=[slideArray count]+1;
            }
            
            while (anotherSlideCount!=0) {
                Slide* thisSlide = [[Slide alloc] initWithValues:(NSString *)[dictionaryOfJSONSlideData objectForKey:@"imageName"]
                                                    chapterTitle:(NSString *)chapterTitle
                                                      overlayIDs:(NSArray *)[dictionaryOfJSONSlideData objectForKey:@"overlayIDs"]
                                               presentationTypes:(NSArray *)presentationTypesValue
                                            presentationSections:(int)presentationSectionsValue
                                                            SISI:(int)SISIValue];
                if (arrayOfSlideLinkObjects.count > 0) {
                    thisSlide.slideLinks = arrayOfSlideLinkObjects;
                }
                [slideArray addObject:thisSlide];
                anotherSlideCount--;
            }

            if (![chapterTitle isEqualToString:@""])
            {
                [chapterArray addObject:chapterTitle];
                [chapterNumberArray addObject:[NSNumber numberWithUnsignedInteger:[slideArray count]]];

                switch (_presentation.presentationType) {
                    case PresentationTypeRAIOI: {
                        // no stelara
                        if ([chapterTitle isEqualToString:@"Important Safety Information for SIMPONI ARIA®"]) {
                            simponiStart=[slideArray count];
                        } else if ([chapterTitle isEqualToString:@"Important Safety Information for REMICADE®"]) {
                            simponiEnd=[slideArray count]-1;
                            remicadeStart=[slideArray count];
                        }
                        break;
                    }
                    case PresentationTypeGIIOI: {
                        if ([chapterTitle isEqualToString:@"Important Safety Information for STELARA®"]) {
                            stelaraStart=[slideArray count]-1;
                        } else if ([chapterTitle isEqualToString:@"Important Safety Information for REMICADE®"]) {
                            stelaraEnd=[slideArray count]-1;
                            remicadeStart=[slideArray count];
                        }
                        break;
                    }
                    case PresentationTypeDermIOI: {
                        // only remicade
                        if ([chapterTitle isEqualToString:@"Important Safety Information for REMICADE®"]) {
                            remicadeStart=[slideArray count];
                        }
                        break;
                    }
                    case PresentationTypeHOPD:
                    case PresentationTypeMixedIOI:
                    case PresentationTypeOther:
                    default: {
                        if ([chapterTitle isEqualToString:@"Important Safety Information for SIMPONI ARIA®"]) {
                            simponiStart=[slideArray count];
                        } else if ([chapterTitle isEqualToString:@"Important Safety Information for STELARA®"]) {
                            simponiEnd=[slideArray count]-1;
                            stelaraStart=[slideArray count];
                        } else if ([chapterTitle isEqualToString:@"Important Safety Information for REMICADE®"]) {
                            stelaraEnd=[slideArray count]-1;
                            remicadeStart=[slideArray count];
                        }
                        break;
                    }
                }


            }
        }
    }
    
    remicadeEnd=[slideArray count];
    
    //NSLog(@"%@", _presentation);

}

-(void) keyPressed:(NSNotification*) notification
{
    NSLog(@"%@", [[notification object]text]);
}

-(void) jumpToSimponiInfo:(NSNotification*) notification
{
    currentSlide=simponiStart;
    [self displaySlide];
}

-(void) jumpToRemicadeInfo:(NSNotification*) notification
{
    currentSlide=remicadeStart;
    [self displaySlide];
}

-(void) jumpToStelaraInfo:(NSNotification*) notification
{
    currentSlide=stelaraStart;
    [self displaySlide];
}

-(void) showPDFViewController:(NSNotification*) notification
{
    //NSLog([notification description]);

    [self performSegueWithIdentifier:@"ShowPDF" sender:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPDF" object:nil userInfo:[notification userInfo]];

}

-(void) enlargeSISI:(NSNotification*) notification
{
    if (!SISIExpanded)
    {
        SISIExpanded=TRUE;
        [_SISIViewController.view setFrame:CGRectMake(0,0,1024,768)];
        [self.view removeGestureRecognizer:swipeRightRecognizer];
        [self.view removeGestureRecognizer:swipeLeftRecognizer];
        [self.view removeGestureRecognizer:tapGestureRecognizer];


        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _dynamicOverlayView.alpha=0.0;
                         _slideImageView.alpha=0.0;
                     }
                     completion:^(BOOL finished) {
                         _dynamicOverlayView.hidden=TRUE;
                     }];
    }
}

-(void) shrinkSISI:(NSNotification*) notification
{
    if (SISIExpanded)
    {
        _dynamicOverlayView.hidden=FALSE;
        SISIExpanded=FALSE;

        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _dynamicOverlayView.alpha=1.0;
                         _slideImageView.alpha=1.0;
                     }
                     completion:^(BOOL finished) {
                         [_SISIViewController.view setFrame:CGRectMake(0,512,1024,256)];
                         [self.view addGestureRecognizer:swipeRightRecognizer];
                         [self.view addGestureRecognizer:swipeLeftRecognizer];
                         [self.view addGestureRecognizer:tapGestureRecognizer];
                     }];
    }
}

-(void) jumpToScenarioSlide:(NSNotification*) notification
{
    //NSLog([notification description]);
    
    NSUInteger scenarioID = [[[notification userInfo] objectForKey:SCENARIO_SELECTED] intValue];
    
    currentSlide=firstInfusionOptimizationSlide+scenarioID;
    [self displaySlide];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[IOMAnalyticsManager shared] trackScreenView:self];
    
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToSimponiInfo:) name:@"jumpToSimponiInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToRemicadeInfo:) name:@"jumpToRemicadeInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToStelaraInfo:) name:@"jumpToStelaraInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPDFViewController:) name:@"showPDFViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enlargeSISI:) name:@"enlargeSISI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shrinkSISI:) name:@"shrinkSISI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToScenarioSlide:) name:SCENARIO_LIST_OPTION_SELECTED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processNextScenario) name:SOLUTION_DATA_FINISHED_PROCESSING_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processNextScenario) name:SOLUTION_DATA_FAILED_PROCESSING_NOTIFICATION object:nil];
    
    _accountNameLabel.text=_presentation.accountName;
    _presentationNameLabel.text = _presentation.presentationTitle;
    
    [self initSlideArray];
    [self displaySlide];
    if (![_presentation includeInfusionOptimizationSection]) {
        [self hideEmailReportsBarButton];
    }
    
    if ([_presentation includeInfusionOptimizationSection]) {
        [self initiateScenarioProcessing];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    hasLoaded = YES;

    /*if(!hasLoaded){
        //preload slide 10 to fix scaling issue with graph
        currentSlide = 9;
        [self displayNextSlide];
        //reset to slide 1
        currentSlide = 0;
        [self displayNextSlide];
        hasLoaded = YES;
    }*/
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [operationQueue cancelAllOperations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) return YES;
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self releaseOverlays];
    // Dispose of any resources that can be recreated.
}

-(void)releaseOverlays
{
    if (_ScenarioOverviewViewController!=nil && (_currentOverlayViewController==nil || _currentOverlayViewController!=_ScenarioOverviewViewController)) { _ScenarioOverviewViewController=nil; NSLog(@"ScenarioOverview Released"); }
    if (_ScenarioReportOverlayViewController!=nil && (_currentOverlayViewController==nil || _currentOverlayViewController!=_ScenarioReportOverlayViewController)) { _ScenarioReportOverlayViewController=nil; NSLog(@"ScenarioReport Released"); }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"edit_presentation"]) {
        UINavigationController* controller = [segue destinationViewController];
        NewPresentationViewController* containedController = (NewPresentationViewController*)[controller topViewController];
        containedController.presentation = _presentation;
    } else if ([[segue identifier] isEqualToString:@"PDFGeneration"]) {
        PDFGeneratorViewController * controller = [segue destinationViewController];
        controller.scenario = _selectedEmailScenario;
        _selectedEmailScenario = nil;
    }
}
 
- (void)displayNextSlide{
    currentSlide++;
    [self displaySlide];
}

- (void)displayPreviousSlide{
    currentSlide--;
    [self displaySlide];
}

- (void)displaySlide{
    if(currentSlide < 1) currentSlide = 1;
    if(currentSlide > [slideArray count]) currentSlide = [slideArray count];
    @autoreleasepool {
        Slide* thisSlide = (Slide*)[slideArray objectAtIndex:currentSlide-1];
        
        if (thisSlide.imageName!=nil && !([thisSlide.imageName isEqualToString:@""]))
        {
            NSArray* split = [thisSlide.imageName componentsSeparatedByString:@"."];
            NSString* fileName = [split objectAtIndex:0];
            UIImage* slideImage = [UIImage imageNamed:fileName];

            NSLog(@"%@", fileName);

            [_slideImageView setImage:slideImage];
            _slideImageView.hidden=FALSE;
            
            for (UIView * linkButton in _viewForLinkButtons.subviews) {
                [linkButton removeFromSuperview];
            }
            
            if (thisSlide.slideLinks.count > 0) {
                _viewForLinkButtons.userInteractionEnabled = YES;
                for (IOMSlideLink* link in thisSlide.slideLinks) {
                    IOMSlideLinkButton * buttonForLink = [[IOMSlideLinkButton alloc] initWithSlideLink:link];
                    [buttonForLink setTitle:@"" forState:UIControlStateNormal];
                    [buttonForLink addTarget:self action:@selector(slideLinkButtonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
                    [_viewForLinkButtons addSubview:buttonForLink];
                }
            }
            else
            {
                _viewForLinkButtons.userInteractionEnabled = NO;
            }
        }
        else
        {
            _slideImageView.hidden=TRUE;
            [_slideImageView setImage:nil];
        }
        NSString *counterString=[NSString stringWithFormat:@"Slide %lu of %lu", currentSlide, [slideArray count]];
        [_slideNumberLabel setText:counterString];
        _overlaySlideCounter.title=counterString;
        _accountNameLabel.hidden=TRUE;
        _presentationNameLabel.hidden = YES;
    }
    
    [self setDynamicOverlayForSlide:currentSlide];
}

- (void)slideLinkButtonTouchedUpInside:(id)sender {
    [self performSegueWithIdentifier:@"ShowPDF" sender:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPDF" object:nil userInfo:nil];
    
    if ([sender isKindOfClass:[IOMSlideLinkButton class]])
    {
        IOMSlideLinkButton* slideLinkButton = (IOMSlideLinkButton*)sender;
        IOMSlideLink* slideLink = slideLinkButton.slideLink;
        [self performSegueWithIdentifier:@"ShowPDF" sender:nil];
        NSMutableDictionary* userInfo = [NSMutableDictionary new];
        userInfo[kIOMPDFViewControllerPushPDFNotificationUserInfoResourceKey] = slideLink.resource;
        userInfo[kIOMPDFViewControllerPushPDFNotificationUserInfoTitleKey] = slideLink.title;
        [[NSNotificationCenter defaultCenter] postNotificationName:kIOMPDFViewControllerPushPDFNotificationName object:nil userInfo:userInfo];
    }
}

- (void)hideEmailReportsBarButton
{
    [_bottomToolbar setItems:@[_chaptersBarButton, _spacerBarItem, _editPresentationBarButton,_spacerBarItem]];
}

#pragma mark - Gesture Recognizer Actions
- (void)swipeDetected:(UISwipeGestureRecognizer*)recognizer{
    if(![_overlayView isHidden]) return;
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
        [self displayNextSlide];
    }else if(recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        [self displayPreviousSlide];
    }
}

- (IBAction)tapHideShowSelected:(UIBarButtonItem *)sender {
    [self hideShowSelected:nil];
}

- (IBAction)hideShowSelected:(UIButton *)sender {
    
    BOOL hide = ![_overlayView isHidden];
    
    if(!hide) {
        [_overlayView setHidden:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideHTMLView" object:nil userInfo:nil];

        //[self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
            [self.view addGestureRecognizer:tapGestureRecognizer];
    }
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGFloat alpha = (hide) ? 0.0 : 1.0;
                         [_overlayView setAlpha:alpha];
                     }
                     completion:^(BOOL completed){
                         if(completed){
                             if(hide) {
                                 [_overlayView setHidden:YES];
                                 //[self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
                             }
                         }
                     }];
}

- (void)tapDetected:(UITapGestureRecognizer*)recognizer{
    
    if ([recognizer locationInView:_overlayView].x<100) [self displayPreviousSlide];
    else if ([recognizer locationInView:_overlayView].x>924) [self displayNextSlide];
    else {
        BOOL hide = ![_overlayView isHidden];
        
        if(!hide) {
            [_overlayView setHidden:NO];
        [self.view removeGestureRecognizer:tapGestureRecognizer];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideHTMLView" object:nil userInfo:nil];

            //[self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        } else if ([recognizer locationInView:_overlayView].y<44 || [recognizer locationInView:_overlayView].y>724) return;
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             CGFloat alpha = (hide) ? 0.0 : 1.0;
                             [_overlayView setAlpha:alpha];
                         }
                         completion:^(BOOL completed){
                             if(completed){
                                 if(hide) {
                                     [_overlayView setHidden:YES];
                                     //[self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
                                 }
                             }
                         }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == _slideNumberTextField) {
        [theTextField resignFirstResponder];
        [_slideNumberPopoverController dismissPopoverAnimated:YES];
        [self jumpToSelectedSlide];
    }
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    //NSLog(@"%@", [popoverController description]);
    [self jumpToSelectedSlide];
}
         


- (BOOL)prefersStatusBarHidden {
    return YES;
    //if ([_overlayView isHidden]) return YES;
    //else return NO;
}

#pragma mark - Gesture Recognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return ![touch.view isKindOfClass:[UIButton class]];
}

#pragma mark - IBActions
- (IBAction)homeButtonSelected:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editPresentationSelected:(id)sender{
    //[self performSegueWithIdentifier:@"edit_presentation" sender:nil];
    
    UINavigationController* controller = [_mainStoryboard instantiateViewControllerWithIdentifier:@"NewPresentation"];
    NewPresentationViewController* containedController = (NewPresentationViewController*)[controller topViewController];
    containedController.presentation = _presentation;
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)safetyInformationSelected:(id)sender{
    NSLog(@"Safety Information");
    if(![_overlayView isHidden]) return;
    currentSlide = 18;
    [self displaySlide];
}

- (IBAction)fullPrescribingInformationSelected:(id)sender{
    NSLog(@"Prescribing Information");
    if(![_overlayView isHidden]) return;
}

- (IBAction)chaptersButtonSelected:(UIButton *)sender {
    if (!_chaptersPopoverController) {
        _dropdownDataSource = [[DropdownDataSource alloc]
                               initWithItems:chapterArray
                               andTitleForItemBlock:^ NSString* (id item)
                               {
                                   return item;
                               }];
        
        _chaptersPopoverController = [DropdownController
                                      dropdownPopoverControllerForDropdownDataSource:_dropdownDataSource
                                      withDelegate:self andContentSize:CGSizeMake(460, [chapterArray count]*44)];
    }
    [_chaptersPopoverController presentPopoverFromRect:CGRectMake(50,730,10,10)
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionDown
                                              animated:YES];
    
}

- (void) jumpToSelectedSlide
{
    NSUInteger slideSelected = [_slideNumberTextField.text intValue];
    if (slideSelected>0 && slideSelected<[slideArray count])
    {
        currentSlide = slideSelected;
        [self displaySlide];
        [self hideShowSelected:nil];
    }
}

- (IBAction)slideNumberSelected:(UIButton *)sender {
    
    [self.view endEditing:TRUE];
    
    NSLog(@"slideNumberSelected");
    
    if (!_slideNumberPopoverController) {
        UIViewController *slideNumberController = [[UIViewController alloc] init];
        UIView *slideNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 64)];
        slideNumberController.view=slideNumberView;
        
        UILabel *jumpToLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,10,80,44)];
        jumpToLabel.text=@"Jump to:";
        [slideNumberView addSubview:jumpToLabel];
        
        _slideNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 11, 50, 44)];
        _slideNumberTextField.borderStyle=UITextBorderStyleRoundedRect;
        _slideNumberTextField.textAlignment=NSTextAlignmentCenter;
        _slideNumberTextField.keyboardType=UIKeyboardTypeDecimalPad;
        _slideNumberTextField.returnKeyType=UIReturnKeyGo;
        _slideNumberTextField.enablesReturnKeyAutomatically=YES;
        _slideNumberTextField.delegate=self;
        [slideNumberView addSubview:_slideNumberTextField];
        
        slideNumberController.preferredContentSize=CGSizeMake(160,64);
        _slideNumberPopoverController = [[UIPopoverController alloc] initWithContentViewController:slideNumberController];
        _slideNumberPopoverController.delegate = self;
    }
    
    _slideNumberTextField.text=@"";
    _slideNumberTextField.placeholder=[NSString stringWithFormat:@"%lu",currentSlide];
    
    [_slideNumberPopoverController presentPopoverFromRect:CGRectMake(900, 0, 124, 39)
                                                   inView:self.view
                                 permittedArrowDirections:UIPopoverArrowDirectionUp
                                                 animated:YES];
    [_slideNumberTextField becomeFirstResponder];
}

- (IBAction)emailReportsSelected:(id)sender
{
    if (!_emailReportDropdownDataSource) {
        NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray* scenarios = [[_presentation.scenarios allObjects] sortedArrayUsingDescriptors:@[nameSort]];
        _emailReportDropdownDataSource = [[DropdownDataSource alloc] initWithItems:scenarios andTitleForItemBlock:^NSString *(id item){
            Scenario *scenario = (Scenario*)item;
            return scenario.name;
        }];
    }
    
    if (!_emailReportPopoverController) {
        _emailReportPopoverController = [DropdownController dropdownPopoverControllerForDropdownDataSource:_emailReportDropdownDataSource withDelegate:self];
    }
    
    if ([_emailReportPopoverController isPopoverVisible]) {
        [_emailReportPopoverController dismissPopoverAnimated:YES];
    } else {
        [_emailReportPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}



#pragma mark - Dynamic Slides

- (void)setDynamicOverlayForSlide:(NSInteger)slideNumber{
    [[_dynamicOverlayView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    Slide* thisSlide = (Slide*)[slideArray objectAtIndex:slideNumber-1];
    _dynamicOverlayBottomLayoutConstraint.constant = 260;
    if ([thisSlide.overlayIDs count]>0) {
        for (NSString* overlayID in thisSlide.overlayIDs) {
            if ([overlayID isEqualToString:@"accountNameSlide"]){
                _accountNameLabel.hidden=FALSE;
            } else if ([overlayID isEqualToString:@"presentationNameSlide"]) {
                _presentationNameLabel.hidden = NO;
            } else if ([overlayID isEqualToString:@"patientPopulationSlide"]) {
                PatientPopulationSlideViewController *_PatientPopulationSlideViewController = [[PatientPopulationSlideViewController alloc] init];
                _PatientPopulationSlideViewController.presentation=_presentation;
                [_dynamicOverlayView addSubview:_PatientPopulationSlideViewController.view];
                _currentOverlayViewController=_PatientPopulationSlideViewController;
            } else if ([overlayID isEqualToString:@"accountPatientUtilizationSlide"]) {
                AccountPatientUtilizationSlideViewController *_AccountPatientUtilizationSlideViewController = [[AccountPatientUtilizationSlideViewController alloc] init];
                _AccountPatientUtilizationSlideViewController.presentation=_presentation;
                [_dynamicOverlayView addSubview:_AccountPatientUtilizationSlideViewController.view];
                [_AccountPatientUtilizationSlideViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
                [_AccountPatientUtilizationSlideViewController.view bindFrameToSuperviewBounds];
                _currentOverlayViewController=_AccountPatientUtilizationSlideViewController;
            } else if ([overlayID isEqualToString:@"vialTrendsSlide"]) {
                VialTrendsSlideViewController *_VialTrendsSlideViewController = [[VialTrendsSlideViewController alloc] init];
                _VialTrendsSlideViewController.presentation=_presentation;
                [_dynamicOverlayView addSubview:_VialTrendsSlideViewController.view];
                _currentOverlayViewController=_VialTrendsSlideViewController;
            } else if ([overlayID isEqualToString:@"payerMixSlide"]) {
                PayerMixSlideViewController *_PayerMixSlideViewController=[[PayerMixSlideViewController alloc] init];
                _PayerMixSlideViewController.presentation=_presentation;
                [_dynamicOverlayView addSubview:_PayerMixSlideViewController.view];
                _currentOverlayViewController=_PayerMixSlideViewController;
            } else if ([overlayID isEqualToString:@"drugAdministrationSlide"]) {
                DrugAdministrationSlideViewController *_DrugAdministrationSlideViewController = [[DrugAdministrationSlideViewController alloc] init];
                _DrugAdministrationSlideViewController.presentation=_presentation;
                [_dynamicOverlayView addSubview:_DrugAdministrationSlideViewController.view];
                _currentOverlayViewController=_DrugAdministrationSlideViewController;
            } else if ([overlayID isEqualToString:@"resourceUtilizationSlide"]) {
                ResourceUtilizationSlideViewController *_ResourceUtilizationSlideViewController = [[ResourceUtilizationSlideViewController alloc] init];
                _ResourceUtilizationSlideViewController.presentation=_presentation;
                [_dynamicOverlayView addSubview:_ResourceUtilizationSlideViewController.view];
                _currentOverlayViewController=_ResourceUtilizationSlideViewController;
            } else if ([overlayID isEqualToString:@"infusionOptimizationScenarios"]) {
                if (_ScenarioOverviewViewController==nil) {
                    _ScenarioOverviewViewController = [[UIStoryboard storyboardWithName:@"ScenarioOverviewStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"scenarioOverview"];
                }
                _ScenarioOverviewViewController.presentation=_presentation;
                [_ScenarioOverviewViewController.view setFrame:CGRectMake(0,0,1024,512)];
                [_dynamicOverlayView addSubview:_ScenarioOverviewViewController.view];
                _currentOverlayViewController=_ScenarioOverviewViewController;
            } else if ([overlayID isEqualToString:@"infusionOptimizationInputSummary"]) {
                if (_ScenarioReportOverlayViewController==nil) {
                    _ScenarioReportOverlayViewController = [[ScenarioReportOverlayViewController alloc] init];
                }
                NSSortDescriptor * nameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                NSArray* scenarios = [[_presentation.scenarios allObjects] sortedArrayUsingDescriptors:@[nameSort]];
                _ScenarioReportOverlayViewController.scenario=[scenarios objectAtIndex:slideNumber-firstInfusionOptimizationSlide];
                [_dynamicOverlayView addSubview:_ScenarioReportOverlayViewController.view];
                _currentOverlayViewController=_ScenarioReportOverlayViewController;
                _dynamicOverlayBottomLayoutConstraint.constant = 0;
            } else if ([overlayID isEqualToString:@"biologicalOverviewAccount"]) {
                IOMBiologicalOverviewAccountSlideViewController* biologicalOverviewAccountSlide = [[IOMBiologicalOverviewAccountSlideViewController alloc] init];
                biologicalOverviewAccountSlide.presentation=_presentation;
                [_dynamicOverlayView addSubview:biologicalOverviewAccountSlide.view];
                _currentOverlayViewController=biologicalOverviewAccountSlide;
            } else if ([overlayID isEqualToString:@"iomLogoTryptich"]) {
                IOMLogoTriptych* logoTriptych = [[IOMLogoTriptych alloc] init];
                logoTriptych.presentation=_presentation;
                [_dynamicOverlayView addSubview:logoTriptych.view];
                _currentOverlayViewController=logoTriptych;
            }
            else {
                _currentOverlayViewController=nil;
            }
        }
    } else {
        _currentOverlayViewController=nil;
    }
    
    [self releaseOverlays];
    
    [[_SISIOverlayView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (thisSlide.SISI==0)
    {
        _isiReferenceLabel.text=@"";
        [_dynamicOverlayView setFrame:CGRectMake(0,0,1024,768)];
    } else {
        [_dynamicOverlayView setFrame:CGRectMake(0,0,1024,512)];
        [_SISIOverlayView addSubview:_SISIViewController.view];
        _SISIViewController.SISIType.text=[LIST_VALUES_ARRAY_SLIDE_SISI objectAtIndex:thisSlide.SISI];
        _SISIViewController.SISIValue=thisSlide.SISI;
        
        if (thisSlide.SISI==1) {
            _isiReferenceLabel.text=[NSString stringWithFormat:@"Please see full important Safety Information for REMICADE® on slides %lu-%lu of this presentation.", remicadeStart, remicadeEnd];
        } else if (thisSlide.SISI==2) {
            _isiReferenceLabel.text=[NSString stringWithFormat:@"Please see full important Safety Information for SIMPONI ARIA® on slides %lu-%lu of this presentation.", simponiStart, simponiEnd];
        } else if (thisSlide.SISI == 4){
            _isiReferenceLabel.text=[NSString stringWithFormat:@"Please see full important Safety Information for STELARA® 130 mg on slides %lu-%lu of this presentation.", stelaraStart, stelaraEnd];
        } else {
            NSString* simponiString = [NSString stringWithFormat:@"SIMPONI ARIA® on slides %lu-%lu", simponiStart, simponiEnd];
            NSString* remicadeString = [NSString stringWithFormat:@"REMICADE® on slides %lu-%lu", remicadeStart, remicadeEnd];
            NSString* stelaraString = [NSString stringWithFormat:@"STELARA® 130 mg on slides %lu-%lu", stelaraStart, stelaraEnd];

            switch (_presentation.presentationType) {
                case PresentationTypeRAIOI: {
                    // no stelara
                    _isiReferenceLabel.text=[NSString stringWithFormat:@"Please see full important Safety Information for %@ and %@ of this presentation.", simponiString, remicadeString];
                    break;
                }
                case PresentationTypeGIIOI: {
                    // no simponi
                    _isiReferenceLabel.text=[NSString stringWithFormat:@"Please see full important Safety Information for %@ and %@ of this presentation.", remicadeString, stelaraString];
                    break;
                }
                case PresentationTypeDermIOI: {
                    // only remicade
                    _isiReferenceLabel.text=[NSString stringWithFormat:@"Please see full important Safety Information for %@ of this presentation.", remicadeString];
                    break;
                }
                case PresentationTypeHOPD:
                case PresentationTypeMixedIOI:
                case PresentationTypeOther:
                default: {
                    _isiReferenceLabel.text=[NSString stringWithFormat:@"Please see full important Safety Information for %@, %@, and %@ of this presentation.", simponiString, remicadeString, stelaraString];
                    break;
                }
            }
        }
    }

    _SISIViewController.presentation = _presentation;
    [_SISIViewController updateViewForSimponiStart:simponiStart
                                        simponiEnd:simponiEnd
                                     remicadeStart:remicadeStart
                                       remicadeEnd:remicadeEnd
                                      stelaraStart:stelaraStart
                                        stelaraEnd:stelaraEnd];
}

#pragma mark - DropdownDelegate Protocol Methods
- (void)dropdown:(DropdownController*)dropdown item:(id)item selectedAtIndex:(NSInteger)index fromDataSource:(DropdownDataSource *)dataSource
{
    if (dataSource == _dropdownDataSource) {
        
        if ([chapterArray containsObject:item])
        {
            NSUInteger currentSelection=[chapterArray indexOfObject:item];
            currentSlide=[[chapterNumberArray objectAtIndex:currentSelection] unsignedIntegerValue];
            [self displaySlide];
            [self hideShowSelected:nil];
        }
        [_chaptersPopoverController dismissPopoverAnimated:YES];
    } else if (dataSource == _emailReportDropdownDataSource){
        //Get selected scenario
        Scenario *scenario = [dataSource.dropdownItems objectAtIndex:index];
        if ([scenario solutionDataIsGenerated]) {
            _selectedEmailScenario = scenario;
            [self performSegueWithIdentifier:@"PDFGeneration" sender:nil];
        } else {
            _selectedEmailScenario = nil;
            //No data, alert user
            [[[UIAlertView alloc] initWithTitle:@"Not Ready" message:@"Scenario Data has not finished calculating. Please wait and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
        
        /*
        if ([scenario pdfIsAvailable]) {
            //email
            [self sendFileFromPath:[scenario getPDFFilePath] forScenario:scenario];
        } else if ([scenario solutionDataIsGenerated]) {
            reportIsGenerating = YES;
            _pdfGenerator = [[PDFGeneratorViewController alloc] init];
            _pdfGenerator.scenario = scenario;
            [self.view addSubview:_pdfGenerator.view];
            [_pdfGenerator.view setFrame:CGRectMake(_pdfGenerator.view.bounds.size.width * 2, 0, _pdfGenerator.view.bounds.size.width, _pdfGenerator.view.bounds.size.height)];
        } else {
        }
        */
        
        [_emailReportPopoverController dismissPopoverAnimated:YES];
    }
}

- (NSString*)analyticsIdentifier
{
    return @"presentation";
}

/*
#pragma mark - PDF Generation Notifications
- (void)reportGenerationCompletedNotification:(NSNotification*)notification
{
    [_pdfGenerator.view removeFromSuperview];
    _pdfGenerator = nil;
    
    NSDictionary *userInfo = [notification userInfo];
    Scenario *scenario = [userInfo objectForKey:PDF_GENERATION_SCENARIO_KEY];
    NSString *path = [userInfo objectForKey:PDF_GENERATION_PATH_KEY];
    
    [self sendFileFromPath:path forScenario:scenario];
    
    NSLog(@"generation completed!");
    reportIsGenerating = NO;
}

- (void)reportGenerationFailedNotification:(NSNotification*)notification
{
    NSLog(@"generation failed!");
    [_pdfGenerator.view removeFromSuperview];
    _pdfGenerator = nil;
    reportIsGenerating = NO;
}
 */



@end
