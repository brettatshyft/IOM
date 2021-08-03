//
//  ScrollImageViewController.m
//  Infusion Services Presentation
//
//  Created by InfAspire on 25/01/2014.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "ScrollImageViewController.h"
#import "UIDevice+Resolutions.h"
#import "IOMAnalyticsManager.h"

@interface ScrollImageViewController ()<IOMAnalyticsIdentifiable>

@property (weak, nonatomic) IBOutlet UIScrollView *clinicalPathwayScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *clinicalPathwayImage;
@end

@implementation ScrollImageViewController

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
    [_clinicalPathwayScrollView setContentSize:CGSizeMake(1024,1325)];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[IOMAnalyticsManager shared] trackScreenView:self];
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"remicade_clinicalpathway" ofType:@"png"];

    if ([UIDevice currentResolution] == UIDevice_iPadHiRes)
        fileName = [[NSBundle mainBundle] pathForResource:@"remicade_clinicalpathway@2x" ofType:@"png"];
    
    UIImage* clinicalPathwayImage = [UIImage imageWithContentsOfFile:fileName];
    [_clinicalPathwayImage setImage:clinicalPathwayImage];

    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPDF:) name:@"showPDF" object:nil];
    /*if (_PDFWebView==nil) _PDFWebView = [[UIWebView alloc] init];
    _PDFWebView.alpha=0;
    _PDFWebView.scalesPageToFit = YES;
    _PDFWebView.delegate = self;*/
}

/*-(void) showPDF:(NSNotification*) notification
{
    //NSLog(@"Show PDF");
    
    if (_PDFWebView==nil) _PDFWebView = [[UIWebView alloc] init];
    _PDFWebView.alpha=0;
    _PDFWebView.scalesPageToFit = YES;
    _PDFWebView.delegate = self;

    int showPDFType = [[[notification userInfo] objectForKey:@"showPDFType"] intValue];
    
    NSString *filePath;
    
    if (showPDFType==1) {
        filePath = [[NSBundle mainBundle] pathForResource:@"simponi_full_pi" ofType:@"pdf"];        _TitleBarButtonItem.title=@"INDICATIONS AND IMPORTANT SAFETY INFORMATION";
    } else if (showPDFType==0) {
        filePath = [[NSBundle mainBundle] pathForResource:@"remicade_full_pi" ofType:@"pdf"];
        _TitleBarButtonItem.title=@"INDICATIONS AND IMPORTANT SAFETY INFORMATION";
    }  else {
        filePath = [[NSBundle mainBundle] pathForResource:@"remicade_clinicalpathway" ofType:@"pdf"];
        _TitleBarButtonItem.title=@"SUGGESTED CLINICAL PATHWAY FOR REMICADE®";
    }
    
    NSURL *pdfUrl = [NSURL fileURLWithPath:filePath];
    
    NSURLRequest *pdfURL = [NSURLRequest requestWithURL:pdfUrl];
    
    [_PDFWebView loadRequest:pdfURL];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [UIView animateWithDuration:0.65 delay:0.1 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _PDFWebView.alpha=1;
                     }
                     completion:^(BOOL finished) {
                     }];
}*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (IBAction)backSelected:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSString*)analyticsIdentifier
{
    return @"suggested_clinical_pathway";
}

@end
