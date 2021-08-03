//
//  SISIViewController.m
//  Infusion Services Presentation
//
//  Created by InfAspire on 24/01/2014.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "SISIViewController.h"
#import "UIView+IOMExtensions.h"
#import "Presentation+Extension.h"
#import "UILabel+SuperscriptLabel.h"
#import <WebKit/WebKit.h>

@interface SISIViewController () {
    UIPopoverController* _PDFPopoverController;
    BOOL SISIExpanded;
}

@property (weak, nonatomic) IBOutlet UIView *SISIView;
@property (strong, nonatomic) IBOutlet UIView *RemicadeView;
@property (strong, nonatomic) IBOutlet UIView *SimponiView;
@property (strong, nonatomic) IBOutlet UIView *BothView;
@property (strong, nonatomic) IBOutlet UIView *StelaraView;
@property (strong, nonatomic) IBOutlet UIView *RemicadeHTMLView;
@property (strong, nonatomic) IBOutlet UIView *stelaraHTMLView;
@property (strong, nonatomic) IBOutlet UIView *SimponiHTMLView;
@property (weak, nonatomic) IBOutlet UIView *remicadeWebViewContainer;
@property (weak, nonatomic) IBOutlet UIView *simponiWebViewContainer;
@property (weak, nonatomic) IBOutlet UIView *stelaraWebViewContainer;

@property (strong, nonatomic) WKWebView *RemicadeWebView;
@property (strong, nonatomic) WKWebView *SimponiWebView;
@property (strong, nonatomic) WKWebView *stelaraWebView;

@property (weak, nonatomic) IBOutlet UITextView *RemicadeTextView;
@property (weak, nonatomic) IBOutlet UITextView *SimponiTextView;
@property (weak, nonatomic) IBOutlet UITextView *StelaraTextView;

@property (weak, nonatomic) IBOutlet UITextView *RemicadeHalfTextView;
@property (weak, nonatomic) IBOutlet UITextView *SimponiHalfTextView;
@property (weak, nonatomic) IBOutlet UITextView *StelaraHalfTextView;

@property (weak, nonatomic) IBOutlet UIStackView *remicadeContainerStackView;
@property (weak, nonatomic) IBOutlet UIStackView *simponiAriaContainerStackView;
@property (weak, nonatomic) IBOutlet UIStackView *stelaraContainerStackView;
@property (weak, nonatomic) IBOutlet UIView *simponiAriaSeperatorView;
@property (weak, nonatomic) IBOutlet UIView *stelaraSeperatorView;

@end

@implementation SISIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addWebViews];
    
    _SimponiHTMLView.hidden=TRUE;
    _RemicadeHTMLView.hidden=TRUE;
    _stelaraHTMLView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHTMLView:) name:@"hideHTMLView" object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateView];
}

-(void) addWebViews{
    _SimponiWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, _simponiWebViewContainer.bounds.size.width, _simponiWebViewContainer.bounds.size.height + 30) configuration: [[WKWebViewConfiguration alloc] init]];
    _RemicadeWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, _simponiWebViewContainer.bounds.size.width, _remicadeWebViewContainer.bounds.size.height + 30) configuration: [[WKWebViewConfiguration alloc] init]];
    _stelaraWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, _stelaraWebViewContainer.bounds.size.width, _simponiWebViewContainer.bounds.size.height + 30) configuration: [[WKWebViewConfiguration alloc] init]];
    [_simponiWebViewContainer addSubview:_SimponiWebView];
    [_remicadeWebViewContainer addSubview:_RemicadeWebView];
    [_stelaraWebViewContainer addSubview:_stelaraWebView];
}

-(void) hideHTMLView:(NSNotification*) notification
{
    NSLog(@"hide");
    if (![_SimponiHTMLView isHidden]) [self hideSimponiHTMLView:nil];
    if (![_RemicadeHTMLView isHidden]) [self hideRemicadeHTMLView:nil];
}

-(void) updateView
{
    if (_SISIValue==0) {
        self.view.hidden=TRUE;
    } else if (_SISIValue==1) {
        self.view.hidden=FALSE;
        [[_SISIView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_SISIView addSubview:_RemicadeView];
    } else if (_SISIValue==2) {
        self.view.hidden=FALSE;
        [[_SISIView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_SISIView addSubview:_SimponiView];
    } else if (_SISIValue==4) {
        [[_SISIView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_SISIView addSubview:_StelaraView];
    } else {
        [[_SISIView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_SISIView addSubview:_BothView];
        self.view.hidden=FALSE;
        
        switch (_presentation.presentationType) {
            case PresentationTypeRAIOI: {
                // no stelara
                _simponiAriaContainerStackView.hidden = NO;
                _remicadeContainerStackView.hidden = NO;
                _stelaraContainerStackView.hidden = YES;
                _stelaraSeperatorView.hidden = YES;
                _simponiAriaSeperatorView.hidden = NO;
                break;
            }
            case PresentationTypeGIIOI: {
                // no simponi
                [[_SISIView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [_SISIView addSubview:_BothView];
                _simponiAriaContainerStackView.hidden = YES;
                _remicadeContainerStackView.hidden = NO;
                _stelaraContainerStackView.hidden = NO;
                _stelaraSeperatorView.hidden = NO;
                _simponiAriaSeperatorView.hidden = YES;
                break;
            }
            case PresentationTypeDermIOI: {
                // only remicade
                [[_SISIView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [_SISIView addSubview:_RemicadeView];
                break;
            }
            case PresentationTypeHOPD:
            case PresentationTypeMixedIOI:
            case PresentationTypeOther:
            default: {
                _simponiAriaContainerStackView.hidden = NO;
                _remicadeContainerStackView.hidden = NO;
                _stelaraContainerStackView.hidden = NO;
                _stelaraSeperatorView.hidden = NO;
                _simponiAriaSeperatorView.hidden = NO;
                break;
            }
        }
    }
}

-(void) updateViewForSimponiStart:(NSInteger)start simponiEnd:(NSInteger)simponiEnd remicadeStart:(NSInteger)remicadeStart remicadeEnd:(NSInteger)remicadeEnd stelaraStart:(NSInteger)stelaraStart stelaraEnd:(NSInteger)stelaraEnd
{
    [self updateView];
    
    [[self SimponiTextView] setText:[NSString stringWithFormat:@"SELECTED IMPORTANT SAFETY INFORMATION\n\nSerious and sometimes fatal side effects have been reported with SIMPONI ARIA® (golimumab), including infections due to tuberculosis, invasive fungal infections (eg, histoplasmosis), bacterial, viral, or other opportunistic pathogens. Prior to initiating SIMPONI ARIA® and periodically during therapy, evaluate patients for active tuberculosis and test for latent infection. Lymphoma, including a rare and fatal cancer called hepatosplenic T-cell lymphoma, and other malignancies can occur and can be fatal. Other serious risks include melanoma and Merkel cell carcinoma, heart failure, demyelinating disorders, lupus-like syndrome, hypersensitivity reactions, and hepatitis B reactivation. Prior to initiating SIMPONI ARIA®, test patients for hepatitis B viral infection. Please see related and other Important Safety Information on pages %li-%li.", (long)start, (long)simponiEnd]];
    
    [[self RemicadeTextView] setText:[NSString stringWithFormat:@"SELECTED IMPORTANT SAFETY INFORMATION\nSerious and sometimes fatal side effects have been reported with REMICADE® (infliximab). Infections due to bacterial, mycobacterial, invasive fungal, viral, or other opportunistic pathogens (eg, TB, histoplasmosis) have been reported. Lymphoma, including cases of fatal hepatosplenic T-cell lymphoma (HSTCL), and other malignancies have been reported, including in children and young adult patients. Due to the risk of HSTCL, mostly reported in Crohn’s disease and ulcerative colitis, assess the risk/benefit, especially if the patient is male and is receiving azathioprine or 6-mercaptopurine treatment.REMICADE® is contraindicated at doses >5 mg/kg in patients with moderate or severe heart failure and in patients with severe hypersensitivity reactions to REMICADE®. Other serious side effects reported include melanoma, Merkel cell carcinoma, invasive cervical cancer, hepatitis B reactivation, hepatotoxicity, hematological events, hypersensitivity, cardiovascular and cerebrovascular reactions during and after infusion, neurological events, and lupus-like syndrome. Please see related and other Important Safety Information on pages %li-%li.", (long)remicadeStart, (long)remicadeEnd]];
    
    [[self StelaraTextView] setText:[NSString stringWithFormat:@"SELECTED IMPORTANT SAFETY INFORMATION\n\nSTELARA® is contraindicated in patients with clinically significant hypersensitivity to ustekinumab or excipients. Serious adverse reactions have been reported in STELARA®-treated patients, including bacterial, mycobacterial, fungal, and viral infections, malignancies, hypersensitivity reactions,  Posterior Reversible Encephalopathy Syndrome (PRES), and noninfectious pneumonia. STELARA® should not be given to patients with any clinically important active infection. Patients should be evaluated for tuberculosis prior to initiating treatment with STELARA®. Live vaccines should not be given to patients receiving  STELARA®. If PRES is suspected or if noninfectious pneumonia is confirmed, discontinue STELARA®.  Please see related and other Important Safety Information on pages %li-%li.", (long)stelaraStart, (long)stelaraEnd]];
    
    [[self SimponiHalfTextView] setText:[NSString stringWithFormat:@"SELECTED IMPORTANT SAFETY INFORMATION\n\nSerious and sometimes fatal side effects have been reported with SIMPONI ARIA® (golimumab), including infections due to tuberculosis, invasive fungal infections (eg, histoplasmosis), bacterial, viral, or other opportunistic pathogens. Prior to initiating SIMPONI ARIA® and periodically during therapy, evaluate patients for active tuberculosis and test for latent infection. Lymphoma, including a rare and fatal cancer called hepatosplenic T-cell lymphoma, and other malignancies can occur and can be fatal. Other serious risks include melanoma and Merkel cell carcinoma, heart failure, demyelinating disorders, lupus-like syndrome, hypersensitivity reactions, and hepatitis B reactivation. Prior to initiating SIMPONI ARIA®, test patients for hepatitis B viral infection. Please see related and other Important Safety Information on pages %li-%li.", (long)start, (long)simponiEnd]];
    
    [[self RemicadeHalfTextView] setText:[NSString stringWithFormat:@"SELECTED IMPORTANT SAFETY INFORMATION\nSerious and sometimes fatal side effects have been reported with REMICADE® (infliximab). Infections due to bacterial, mycobacterial, invasive fungal, viral, or other opportunistic pathogens (eg, TB, histoplasmosis) have been reported. Lymphoma, including cases of fatal hepatosplenic T-cell lymphoma (HSTCL), and other malignancies have been reported, including in children and young adult patients. Due to the risk of HSTCL, mostly reported in Crohn’s disease and ulcerative colitis, assess the risk/benefit, especially if the patient is male and is receiving azathioprine or 6-mercaptopurine treatment.REMICADE® is contraindicated at doses >5 mg/kg in patients with moderate or severe heart failure and in patients with severe hypersensitivity reactions to REMICADE®. Other serious side effects reported include melanoma, Merkel cell carcinoma, invasive cervical cancer, hepatitis B reactivation, hepatotoxicity, hematological events, hypersensitivity, cardiovascular and cerebrovascular reactions during and after infusion, neurological events, and lupus-like syndrome. Please see related and other Important Safety Information on pages %li-%li.", (long)remicadeStart, (long)remicadeEnd]];
    
    [[self StelaraHalfTextView] setText:[NSString stringWithFormat:@"SELECTED IMPORTANT SAFETY INFORMATION\n\nSTELARA® is contraindicated in patients with clinically significant hypersensitivity to ustekinumab or excipients. Serious adverse reactions have been reported in STELARA®-treated patients, including bacterial, mycobacterial, fungal, and viral infections, malignancies, hypersensitivity reactions,  Posterior Reversible Encephalopathy Syndrome (PRES), and noninfectious pneumonia. STELARA® should not be given to patients with any clinically important active infection. Patients should be evaluated for tuberculosis prior to initiating treatment with STELARA®. Live vaccines should not be given to patients receiving  STELARA®. If PRES is suspected or if noninfectious pneumonia is confirmed, discontinue STELARA®.  Please see related and other Important Safety Information on pages %li-%li.", (long)stelaraStart, (long)stelaraEnd]];
    
    [[self RemicadeTextView] setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:15]];
    [[self SimponiTextView] setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:15]];
    [[self StelaraTextView] setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:15]];
    [[self RemicadeHalfTextView] setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:13]];
    [[self SimponiHalfTextView] setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:13]];
    [[self StelaraHalfTextView] setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:13]];
    
    [[self RemicadeTextView] setSuperscriptForRegisteredTradeMarkSymbols];
    [[self SimponiTextView] setSuperscriptForRegisteredTradeMarkSymbols];
    [[self StelaraTextView] setSuperscriptForRegisteredTradeMarkSymbols];
    [[self RemicadeHalfTextView] setSuperscriptForRegisteredTradeMarkSymbols];
    [[self SimponiHalfTextView] setSuperscriptForRegisteredTradeMarkSymbols];
    [[self StelaraHalfTextView] setSuperscriptForRegisteredTradeMarkSymbols];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showRemicadePDF:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPDFViewController" object:nil userInfo:@{@"showPDFType":[NSNumber numberWithBool:NO]}];
}

- (IBAction)showSimponiPDF:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPDFViewController" object:nil userInfo:@{@"showPDFType":[NSNumber numberWithBool:YES]}];
}

- (IBAction)showStelaraPDF:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPDFViewController" object:nil userInfo:@{@"showPDFType":[NSNumber numberWithInteger:2]}];
}

- (IBAction)showSimponiHTMLView:(id)sender {
    if (_SimponiHTMLView.hidden)
    {
        _SISIView.hidden = YES;
        _SimponiHTMLView.hidden=FALSE;
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"simponi" ofType:@"html" inDirectory:@"IOM_Charts"]];
        [_SimponiWebView loadRequest:[NSURLRequest requestWithURL:url]];
        //[[self parentViewController].view setFrame:CGRectMake(0, 0, 1024, 728)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"enlargeSISI" object:nil userInfo:nil];
        [_SimponiHTMLView setFrame:CGRectMake(0, 768, 1024, 728)];
        [self.view addSubview:_SimponiHTMLView];
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            [_SimponiHTMLView setFrame:CGRectMake(0, 0, 1024, 728)];
        }
                         completion:^(BOOL finished) {
        }];
    }
}

- (IBAction)showRemicadeHTMLView:(id)sender {
    if (_RemicadeHTMLView.hidden)
    {
        _SISIView.hidden = YES;
        _RemicadeHTMLView.hidden=FALSE;
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"remicade" ofType:@"html" inDirectory:@"IOM_Charts"]];
        [_RemicadeWebView loadRequest:[NSURLRequest requestWithURL:url]];
        //[[self parentViewController].view setFrame:CGRectMake(0, 0, 1024, 728)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"enlargeSISI" object:nil userInfo:nil];
        [_RemicadeHTMLView setFrame:CGRectMake(0, 768, 1024, 728)];
        [self.view addSubview:_RemicadeHTMLView];
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            [_RemicadeHTMLView setFrame:CGRectMake(0, 0, 1024, 728)];
        }
                         completion:^(BOOL finished) {
        }];
    }
}

- (IBAction)hideSimponiHTMLView:(id)sender {
    if (!_SimponiHTMLView.hidden)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shrinkSISI" object:nil userInfo:nil];
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            [_SimponiHTMLView setFrame:CGRectMake(0, 768, 1024, 728)];
        }
                         completion:^(BOOL finished) {
            [_SimponiHTMLView removeFromSuperview];
            _SimponiHTMLView.hidden=TRUE;
            _SISIView.hidden = NO;
            //[[self parentViewController].view setFrame:CGRectMake(0, 0, 1024, 256)];
        }];
    }
}

- (IBAction)hideRemicadeHTMLView:(id)sender {
    if (!_RemicadeHTMLView.hidden)
    {
        SISIExpanded=FALSE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shrinkSISI" object:nil userInfo:nil];
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            [_RemicadeHTMLView setFrame:CGRectMake(0, 768, 1024, 728)];
        }
                         completion:^(BOOL finished) {
            [_RemicadeHTMLView removeFromSuperview];
            _RemicadeHTMLView.hidden=TRUE;
            _SISIView.hidden = NO;
            //[[self parentViewController].view setFrame:CGRectMake(0, 0, 1024, 256)];
        }];
    }
}

- (IBAction)showStelaraHTMLView:(id)sender {
    UIAlertController *controller = [[UIAlertController alloc] init];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    if (_stelaraHTMLView.hidden)
    {
        _SISIView.hidden = YES;
        _stelaraHTMLView.hidden=FALSE;
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"stelara" ofType:@"html" inDirectory:@"IOM_Charts"]];
        [_stelaraWebView loadRequest:[NSURLRequest requestWithURL:url]];
        //[[self parentViewController].view setFrame:CGRectMake(0, 0, 1024, 728)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"enlargeSISI" object:nil userInfo:nil];
        [_stelaraHTMLView setFrame:CGRectMake(0, 768, 1024, 728)];
        [self.view addSubview:_stelaraHTMLView];
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            [_stelaraHTMLView setFrame:CGRectMake(0, 0, 1024, 728)];
        }
                         completion:^(BOOL finished) {
        }];
    }
}

- (IBAction)hideStelaraHTMLView:(id)sender {
    if (!_stelaraHTMLView.hidden)
    {
        SISIExpanded=FALSE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shrinkSISI" object:nil userInfo:nil];
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            [_stelaraHTMLView setFrame:CGRectMake(0, 768, 1024, 728)];
            _SISIView.hidden = NO;
        }
                         completion:^(BOOL finished) {
            [_stelaraHTMLView removeFromSuperview];
            _stelaraHTMLView.hidden=TRUE;
            //[[self parentViewController].view setFrame:CGRectMake(0, 0, 1024, 256)];
        }];
    }
}

- (IBAction)jumpToSimponiInfo:(id)sender {
    [self hideSimponiHTMLView:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToSimponiInfo" object:nil userInfo:nil];
}

- (IBAction)jumpToRemicadeInfo:(id)sender {
    [self hideRemicadeHTMLView:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToRemicadeInfo" object:nil userInfo:nil];
}

-(IBAction)jumpToStelaraInfo:(id)sender {
    [self hideStelaraHTMLView:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToStelaraInfo" object:nil userInfo:nil];
}
@end
