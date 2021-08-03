//
//  PDFViewController.m
//  Infusion Services Presentation
//
//  Created by InfAspire on 25/01/2014.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "IOMPDFViewController.h"
#import "IOMAnalyticsManager.h"
#import <WebKit/WebKit.h>

NSString *const kIOMPDFViewControllerPushPDFNotificationName = @"pushPDF";
NSString *const kIOMPDFViewControllerPushPDFNotificationUserInfoResourceKey = @"resource";
NSString *const kIOMPDFViewControllerPushPDFNotificationUserInfoTitleKey = @"title";

@interface IOMPDFViewController ()<IOMAnalyticsIdentifiable, WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *PDFWebView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *TitleBarButtonItem;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation IOMPDFViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPDF:) name:@"showPDF" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPDF:) name:kIOMPDFViewControllerPushPDFNotificationName object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

-(void) pushPDF:(NSNotification*) notification
{
    if (_PDFWebView==nil){
        [self initWebView];
    }
    
    _PDFWebView.alpha=0;
    _PDFWebView.navigationDelegate = self;
    
    NSString* resource = [[notification userInfo] objectForKey:kIOMPDFViewControllerPushPDFNotificationUserInfoResourceKey];
    NSString* title = [[notification userInfo] objectForKey:kIOMPDFViewControllerPushPDFNotificationUserInfoTitleKey];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:resource ofType:@"pdf"];
    
    if (!filePath || !title) {
        return;
    }
    
    _TitleBarButtonItem.title=title;
    NSURL *pdfUrl = [NSURL fileURLWithPath:filePath];
    NSURLRequest *pdfURL = [NSURLRequest requestWithURL:pdfUrl];
    [_PDFWebView loadRequest:pdfURL];
}

-(void) showPDF:(NSNotification*) notification
{
    //NSLog(@"Show PDF");
    
    if (_PDFWebView==nil){
        [self initWebView];
    }
    _PDFWebView.alpha=0;
    _PDFWebView.navigationDelegate = self;
    
    int showPDFType = [[[notification userInfo] objectForKey:@"showPDFType"] intValue];
    
    NSString *filePath;
    
    if (showPDFType==1) {
        filePath = [[NSBundle mainBundle] pathForResource:@"simponi_full_pi" ofType:@"pdf"];
        _TitleBarButtonItem.title=@"FULL PRESCRIBING INFORMATION";
    } else if (showPDFType==0) {
        filePath = [[NSBundle mainBundle] pathForResource:@"remicade_full_pi" ofType:@"pdf"];
        _TitleBarButtonItem.title=@"FULL PRESCRIBING INFORMATION";
    } else if (showPDFType==2) {
        filePath = [[NSBundle mainBundle] pathForResource:@"stelara_full_pi" ofType:@"pdf"];
        _TitleBarButtonItem.title=@"FULL PRESCRIBING INFORMATION";
    } else if (showPDFType==3){
        filePath = [[NSBundle mainBundle] pathForResource:@"remicade_clinicalpathway" ofType:@"pdf"];
        _TitleBarButtonItem.title=@"SUGGESTED CLINICAL PATHWAY FOR REMICADE®";
    }
    
    NSURL *pdfUrl = [NSURL fileURLWithPath:filePath];
    
    NSURLRequest *pdfURL = [NSURLRequest requestWithURL:pdfUrl];
    
    [_PDFWebView loadRequest:pdfURL];
}

- (void) initWebView{
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    _PDFWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolbar.frame), self.view.frame.size.width, self.view.frame.size.height) configuration:wkWebConfig];
    [self.view addSubview:_PDFWebView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [UIView animateWithDuration:0.65 delay:0.1 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        _PDFWebView.alpha=1;
    }
                     completion:^(BOOL finished) {
    }];
}

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

- (IBAction)backArrowSelected:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSString*)analyticsIdentifier
{
    return @"pdf";
}

@end
