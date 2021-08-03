//
//  PrescribingInformationViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/22/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "PrescribingInformationViewController.h"
#import "IOMAnalyticsManager.h"
#import <WebKit/WebKit.h>

@interface PrescribingInformationViewController ()<IOMAnalyticsIdentifiable>

@property (nonatomic, strong) WKWebView* webview;

@end

@implementation PrescribingInformationViewController

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
    _webview = [[WKWebView alloc]initWithFrame:CGRectMake(44, 0, self.view.bounds.size.width, self.view.bounds.size.height) configuration: [[WKWebViewConfiguration alloc] init]];
    [self.view addSubview:_webview];
    [self loadPDF];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
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

- (void)loadPDF{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"full_pi" ofType:@"pdf"];
    NSURL* url = [NSURL fileURLWithPath:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [_webview loadRequest:request];
    [_webview loadFileURL:url allowingReadAccessToURL:[url URLByDeletingLastPathComponent]];
}

#pragma mark - IBActions
- (IBAction)backButtonSelected:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString*)analyticsIdentifier
{
    return @"prescribing_information";
}

@end
