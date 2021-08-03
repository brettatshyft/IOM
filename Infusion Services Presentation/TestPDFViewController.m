//
//  TestPDFViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/3/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "TestPDFViewController.h"
#import "InputSummaryReportViewController.h"

@interface TestPDFViewController (){
    InputSummaryReportViewController* _summaryController;
}

@end

@implementation TestPDFViewController

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
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    _summaryController = [[InputSummaryReportViewController alloc] initWithNibName:@"InputSummaryReportViewController" bundle:[NSBundle mainBundle]];
    [self.view addSubview:_summaryController.view];
    
    //Test PDF Rendering
    //NSString* path = [PDFRenderer getPDFFilePathForFileName:@"test.pdf"];
    //[PDFRenderer drawView:_summaryController.view ToPDFAtFilePath:path];
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self saveToPDF:nil];
}

/*
- (IBAction)saveToPDF:(id)sender{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    basePath = [basePath stringByAppendingPathComponent:@"chartjstest.pdf"];
    
    //Draw to pdf
    NSMutableData * pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    int maxHeight = (792.0f/612.0f) * _summaryController.page1View.layer.frame.size.width;
    int height = 500;
    
    UIGraphicsBeginImageContext(CGSizeMake(_summaryController.page1View.layer.frame.size.width, height));
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0f, -1.0f);
    
    [_summaryController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = [image CGImage];
    
    int pdfDrawHeight = 792 * (500.0f/1325.0f);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, 612, pdfDrawHeight), imageRef);
    
    UIGraphicsEndPDFContext();
    
    if(![pdfData writeToFile:basePath atomically:YES]){
        NSLog(@"WRITING TO PDF FAILED!");
    }else{
        NSLog(@"WRITING TO PDF FINISHED!");
        
    }
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
