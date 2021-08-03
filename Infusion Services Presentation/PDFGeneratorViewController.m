//
//  PDFGeneratorViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/30/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "PDFGeneratorViewController.h"
#import "ReportCoverPageViewController.h"
#import "InputSummaryReportViewController.h"
#import "OutputSummaryReportViewController.h"
#import "ScheduleReportViewController.h"
#import "Scenario+Extension.h"
#import "Presentation+Extension.h"
#import "IOMReportProtocol.h"
#import "GraphWebView.h"
#import "GanttChart.h"
#import "IOMPDFPage.h"
#import <QuartzCore/QuartzCore.h>

@interface PDFGeneratorViewController () {
    ReportCoverPageViewController * _reportCoverViewController;
    InputSummaryReportViewController* _inputSummaryViewController;
    OutputSummaryReportViewController* _outputSummaryViewController;
    ScheduleReportViewController* _currentLoadScheduleViewController;
    ScheduleReportViewController* _fullLoadScheduleViewController;
    
    GraphScreenshotQueue *_graphScreenshotQueue;
    GraphScreenshotQueue *_currentSGraphScreenShotQueue;
    GraphScreenshotQueue *_fullSGraphScreenShotQueue;

    BOOL _responsePosted;
    
    NSString *coverPathPrefix;
    NSString *inputPathPrefix;
    NSString *summaryPathPrefix;
    NSString *currentPathPrefix;
    NSString *fullPathPrefix;
    
    NSMutableArray *schedulePaths;
    
    NSDateFormatter *_dateFormatter;
    
    NSString * pdfFilePath;
}

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation PDFGeneratorViewController

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
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"M/d/YYYY"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _responsePosted = NO;
    
    _graphScreenshotQueue = [[GraphScreenshotQueue alloc] init];
    [_graphScreenshotQueue setDelegate:self];
    
    _currentSGraphScreenShotQueue = [[GraphScreenshotQueue alloc] init];
    [_currentSGraphScreenShotQueue setDelegate:self];
    _fullSGraphScreenShotQueue = [[GraphScreenshotQueue alloc] init];
    [_fullSGraphScreenShotQueue setDelegate:self];
    
    [self loadReports];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self displayReports];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_graphScreenshotQueue clearQueue];
    _graphScreenshotQueue = nil;
    
    [_currentSGraphScreenShotQueue clearQueue];
    _currentSGraphScreenShotQueue = nil;
    [_fullSGraphScreenShotQueue clearQueue];
    _fullSGraphScreenShotQueue = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSFileManager * fm = [NSFileManager defaultManager];
    //Delete single page file
    NSError * error = nil;
    if (![fm removeItemAtPath:pdfFilePath error:&error]) {
        NSLog(@"Failed to delete final PDF file: %@", error);
        error = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Creating PDF
- (void)createPDF
{
    NSLog(@"Creating PDFs");
    //Get PDF prefix and final PDF path
    NSString* pdfPrefix = [_scenario getPDFFilePrefix];
    
    //Create paths for intermediate PDFs from prefix
    coverPathPrefix = [Scenario getPathForPDFFileName:[NSString stringWithFormat:@"%@-cover", pdfPrefix]];
    inputPathPrefix = [Scenario getPathForPDFFileName:[NSString stringWithFormat:@"%@-input", pdfPrefix]];
    summaryPathPrefix = [Scenario getPathForPDFFileName:[NSString stringWithFormat:@"%@-summary", pdfPrefix]];
    currentPathPrefix = [Scenario getPathForPDFFileName:[NSString stringWithFormat:@"%@-current", pdfPrefix]];
    fullPathPrefix = [Scenario getPathForPDFFileName:[NSString stringWithFormat:@"%@-full", pdfPrefix]];
    
    //Draw cover
    @autoreleasepool {
        NSLog(@"Report Cover");
        [self pdfDrawViewController:_reportCoverViewController withFilePathPrefix:coverPathPrefix];
    }
    
    //Draw input summary to a pdf
    @autoreleasepool {
        NSLog(@"Input summary");
        [self pdfDrawInputSummaryWithFilePathPrefix:inputPathPrefix];
        //[self pdfDrawViewController:_inputSummaryViewController withFilePathPrefix:inputPathPrefix];
        //[self pdfDrawView:_inputSummaryViewController.view withFilePathPrefix:inputPathPrefix];
    }
    
    //Draw summary report to a pdf
    @autoreleasepool {
        NSLog(@"Summary Report");
        [self pdfDrawSummaryReportWithFilePathPrefix:summaryPathPrefix];
        //[self pdfDrawViewController:_outputSummaryViewController withFilePathPrefix:summaryPathPrefix];
        //[self pdfDrawView:_outputSummaryViewController.view withFilePathPrefix:summaryPathPrefix];
    }
    
    //Draw current schedule to a pdf
    @autoreleasepool {
        NSLog(@"Current Schedule");
        [self pdfDrawSchedule:_currentLoadScheduleViewController withFilePathPrefix:currentPathPrefix andScreenshotQueue:_currentSGraphScreenShotQueue];
    }
}

- (void)pdfDrawInputSummaryWithFilePathPrefix:(NSString*)filePathPrefix
{
    [self pdfDrawView:_inputSummaryViewController.view withFilePathPrefix:filePathPrefix];
}

- (void)pdfDrawSummaryReportWithFilePathPrefix:(NSString*)filePathPrefix
{
    [self pdfDrawView:_outputSummaryViewController.view withFilePathPrefix:filePathPrefix];
}

- (void)pdfDrawViewController:(UIViewController <IOMReportProtocol>*)controller withFilePathPrefix:(NSString*)filePathPrefix
{
    NSString *path = [NSString stringWithFormat:@"%@.pdf", filePathPrefix];
    
    if (UIGraphicsBeginPDFContextToFile(path, CGRectZero, nil)) {
        CGFloat viewWidth = controller.view.bounds.size.width;
        CGFloat pageHeight = ((792.0f/612.0f) * viewWidth) - (PDF_PADDING*2);
        CGFloat widthRatio = (612.0/viewWidth);
        CGFloat pdfPageHeight = pageHeight * widthRatio;
        
        NSArray *pages = [controller getPDFPageDataForPageHeight:pageHeight];
        
        for (IOMPDFPage * page in pages) {
            CGFloat height = page.pageEnd - page.pageStart;
            
            CGSize imageSize = CGSizeMake(viewWidth, height);
            
            UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, -page.pageStart);
            [controller.view drawViewHierarchyInRect:controller.view.bounds afterScreenUpdates:YES];
            UIImage *image = [UIImage imageWithData:UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext())];
            UIGraphicsEndImageContext();
            
            CGFloat pdfDrawHeight = 792.0f * (height/pageHeight);
            
            //draw image to pdf
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, 792);
            CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0f, -1.0f);
            CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, (PDF_PADDING * widthRatio) + (pdfPageHeight - pdfDrawHeight), 612, pdfDrawHeight), [image CGImage]);
        }
        
        UIGraphicsEndPDFContext();
    }
}

- (void)pdfDrawView:(UIView*)view withFilePathPrefix:(NSString*)filePathPrefix
{
    CGSize sizeOfView = view.bounds.size;
    CGFloat ratio = (612.0/sizeOfView.width);   //Because width of PDF we are drawing to is 612
    CGSize sizeOfScreenshot = CGSizeMake(sizeOfView.width, ((792.0 - (PDF_PADDING * ratio * 2)) / ratio));  //Because height of PDF we are drawing to is 792
    
    //Number of pages in PDF view
    int numberOfPages = ceilf((sizeOfView.height / sizeOfScreenshot.height));
    NSMutableArray *pageFilePaths = [NSMutableArray array];
    
    for (int p = 0; p < numberOfPages; p++) {
        //Take screenshot
        @autoreleasepool {
            UIGraphicsBeginImageContextWithOptions(sizeOfScreenshot, NO, 0.0);
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, (-sizeOfScreenshot.height * p));
            [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
            UIImage *image = [UIImage imageWithData:UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext())];
            UIGraphicsEndImageContext();
            
            //Create PDF
            NSString * filePath = [NSString stringWithFormat:@"%@-%i.pdf", filePathPrefix, p];
            [pageFilePaths addObject:filePath];
            if (UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil)) {
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
                CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, 792);
                CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0f, -1.0f);
                CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, PDF_PADDING * ratio, sizeOfScreenshot.width * ratio, sizeOfScreenshot.height * ratio), [image CGImage]);
                UIGraphicsEndPDFContext();
            }
        }
    }
    
    NSFileManager * fm = [NSFileManager defaultManager];
    
    //Combine schedule pages into one pdf
    NSString *finalScheduleFilePath = [NSString stringWithFormat:@"%@.pdf", filePathPrefix];
    // Create the output context
    CFURLRef finalURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:finalScheduleFilePath]);
    CGContextRef writeContext = CGPDFContextCreateWithURL(finalURL, NULL, NULL);
    
    CGPDFPageRef page;
    CGRect mediaBox;
    
    for (NSString* path in pageFilePaths) {
        CFURLRef fileURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:path]);
        CGPDFDocumentRef pdfFile = CGPDFDocumentCreateWithURL(fileURL);
        NSInteger numberOfPages = CGPDFDocumentGetNumberOfPages(pdfFile);
        
        for (int i = 1; i <= numberOfPages; i++) {
            page = CGPDFDocumentGetPage(pdfFile, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
        
        // Release from memory
        CFRelease(fileURL);
        CGPDFDocumentRelease(pdfFile);
        
        //Delete single page file
        NSError * error = nil;
        if (![fm removeItemAtPath:path error:&error]) {
            NSLog(@"Failed to delete single page PDF file: %@", error);
        }
    }
    
    // Finalize the output file
    CGPDFContextClose(writeContext);
    CFRelease(finalURL);
    CGContextRelease(writeContext);
}

- (void)pdfDrawSchedule:(ScheduleReportViewController*)schedule withFilePathPrefix:(NSString*)filePathPrefix andScreenshotQueue:(GraphScreenshotQueue*)screenshotQueue
{
    schedulePaths = [[NSMutableArray alloc] init];
    
    //Grab image of header
    UIView *scheduleHeader = schedule.headerView;
    CGFloat pageRatio = (612.0/scheduleHeader.bounds.size.width);   //Because width of PDF we are drawing to is 612
    
    CGSize headerImageSize = scheduleHeader.bounds.size;
    UIGraphicsBeginImageContextWithOptions(headerImageSize, NO, 0.0);
    [scheduleHeader drawViewHierarchyInRect:scheduleHeader.bounds afterScreenUpdates:YES];
    UIImage *headerImage = [UIImage imageWithData:UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext())];
    UIGraphicsEndImageContext();
    
    //Start page
    NSNumber * pageCount = [NSNumber numberWithInt:0];
    NSNumber * remainingPageHeight = @(792.0 - (PDF_PADDING * pageRatio * 2));
    NSNumber * drawY = @(792.0 - (PDF_PADDING * pageRatio));
    
    NSString * filePath = [NSString stringWithFormat:@"%@-%i.pdf", filePathPrefix, [pageCount intValue]];
    [schedulePaths addObject:filePath];
    if (UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil)) {
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, 792);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0f, -1.0f);
        //draw header
        drawY = @([drawY floatValue] - (headerImageSize.height * pageRatio)); //Full page height - top padding - size of image to draw (origin of drawing is lower left corner).
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, [drawY floatValue], headerImageSize.width * pageRatio, headerImageSize.height * pageRatio), [headerImage CGImage]);
        remainingPageHeight = @([remainingPageHeight floatValue] - (headerImageSize.height * pageRatio));
    } else {
        NSLog(@"could not begin PDF context at path: %@", filePath);
        return;
    }
    
    //start loading charts
    GraphWebView *graphView = [GraphWebView getStaticView];
    __weak GraphWebView *weakGraphView = graphView;
    __block NSNumber * weakRemainingPageHeight = remainingPageHeight;
    __block NSNumber * weakDrawY = drawY;
    __block NSNumber * weakPageCount = pageCount;
    CGFloat chartContainerX = schedule.chartContainerView.frame.origin.x;
    CGFloat chartContainerWidth = schedule.chartContainerView.bounds.size.width;
    
    //Load and set image for capacity usage graph
    NSArray * ganttCharts = schedule.ganttChartArray;
//    NSArray * drawObjects = [ganttCharts arrayByAddingObject:schedule.footerView];
    for (id obj in ganttCharts) {
        
        UIView* drawView = nil;
        __weak GanttChart* weakChart = nil;
        void (^setup)(void) = nil;
        
        
        if ([obj isKindOfClass:[GanttChart class]]) {
            //Graph view
            drawView = graphView;
            weakChart = obj;
            
            setup = ^void(void){
                [weakGraphView readyForReuse];
                [weakGraphView setFrame:CGRectMake(0, 0, chartContainerWidth, 100)];
                if (!weakGraphView.graphFilesLoaded) {
                    [weakGraphView loadGraphFilesWithCompletion:^{
                        NSString * dayString = [weakChart getNameOfDay];
                        NSString * dataString = [weakChart getJavaScriptDataString];
                        int height = [weakGraphView ganttChartWithData:dataString andDayString:dayString includeSpacing:NO];
                        [weakGraphView setFrame:CGRectMake(0, 0, chartContainerWidth, height)];
                    }];
                } else {
                    NSString * dayString = [weakChart getNameOfDay];
                    NSString * dataString = [weakChart getJavaScriptDataString];
                    int height = [weakGraphView ganttChartWithData:dataString andDayString:dayString includeSpacing:NO];
                    [weakGraphView setFrame:CGRectMake(0, 0, chartContainerWidth, height)];
                }
            };
            
        } else {
            //Footer view
            drawView = obj;
            setup = ^void(void){};
            chartContainerX = 0;
            chartContainerWidth = schedule.view.bounds.size.width;
        }
        
       // __weak GraphScreenshotQueue * weakQueue = screenshotQueue;
        [screenshotQueue enqueueView:drawView
                          setupBlock:setup
          andScreenshotFinishedBlock:^(UIImage *image){
              if (image == nil) return;
              
              //Draw image to PDF
              CGSize imageSize = image.size;
              CGFloat imageRatio = ((chartContainerWidth * pageRatio) / imageSize.width);
              
              if (imageSize.height * imageRatio <= [weakRemainingPageHeight floatValue]) {
                  NSLog(@"Place full image, it fits");
                  //Draw Full image to PDF
                  weakDrawY = @([weakDrawY floatValue] - (imageSize.height * imageRatio));
                  CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(chartContainerX * pageRatio, [weakDrawY floatValue], imageSize.width * imageRatio, imageSize.height * imageRatio), [image CGImage]);
                  weakRemainingPageHeight = @([weakRemainingPageHeight floatValue] - ((imageSize.height * imageRatio) + 20));   //20 for padding
                  //Add padding between charts
                  weakDrawY = @([weakDrawY floatValue] - 20);
                  
              } else {
                  //Start new PDF
                  UIGraphicsEndPDFContext();
                  weakPageCount = @([weakPageCount intValue]+1);
                  NSString * filePath = [NSString stringWithFormat:@"%@-%i.pdf", filePathPrefix, [weakPageCount intValue]];
                  [schedulePaths addObject:filePath];
                  UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
                  UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
                  CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, 792);
                  CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0f, -1.0f);
                  weakDrawY = @(792.0 - (PDF_PADDING * pageRatio));
                  weakRemainingPageHeight = @(792.0 - (PDF_PADDING * pageRatio * 2));
                  
                  //Draw Full image to PDF
                  weakDrawY = @([weakDrawY floatValue] - (imageSize.height * imageRatio));
                  CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(chartContainerX * pageRatio, [weakDrawY floatValue], imageSize.width * imageRatio, imageSize.height * imageRatio), [image CGImage]);
                  weakRemainingPageHeight = @([weakRemainingPageHeight floatValue] - ((imageSize.height * imageRatio) + 20));   //20 for padding
                  //Add padding between items
                  weakDrawY = @([weakDrawY floatValue] - 20);
              }
              
              if (weakRemainingPageHeight <= 0){
                  NSLog(@"No page height left, new page");
                  //Start next page
                  weakPageCount = @([weakPageCount intValue]+1);
                  NSString * filePath = [NSString stringWithFormat:@"%@-%i.pdf", filePathPrefix, [weakPageCount intValue]];
                  [schedulePaths addObject:filePath];
                  UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
                  UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
                  CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, 792);
                  CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0f, -1.0f);
                  weakDrawY = @(792.0 - (PDF_PADDING * pageRatio));
                  weakRemainingPageHeight = @(792.0 - (PDF_PADDING * pageRatio * 2));
              }
          }];
    }
    
    [screenshotQueue startProcessing];
}

- (void)combineSchedulePDFsWithPrefix:(NSString*)filePathPrefix
{
    NSFileManager * fm = [NSFileManager defaultManager];
    
    //Combine schedule pages into one pdf
    NSString *finalScheduleFilePath = [NSString stringWithFormat:@"%@.pdf", filePathPrefix];
    // Create the output context
    CFURLRef finalURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:finalScheduleFilePath]);
    CGContextRef writeContext = CGPDFContextCreateWithURL(finalURL, NULL, NULL);
    
    CGPDFPageRef page;
    CGRect mediaBox;
    
    for (NSString* path in schedulePaths) {
        CFURLRef fileURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:path]);
        CGPDFDocumentRef pdfFile = CGPDFDocumentCreateWithURL(fileURL);
        NSInteger numberOfPages = CGPDFDocumentGetNumberOfPages(pdfFile);
        
        for (int i = 1; i <= numberOfPages; i++) {
            page = CGPDFDocumentGetPage(pdfFile, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
        
        // Release from memory
        CFRelease(fileURL);
        CGPDFDocumentRelease(pdfFile);
        
        //Delete single page file
        NSError * error = nil;
        if (![fm removeItemAtPath:path error:&error]) {
            NSLog(@"Failed to delete single page PDF file: %@", error);
        }
    }
    
    // Finalize the output file
    CGPDFContextClose(writeContext);
    CFRelease(finalURL);
    CGContextRelease(writeContext);
}

- (NSString*)combinePDFsWithPrefix:(NSString*)pdfPrefix
{
    
    NSString *finalPath = [_scenario getPDFFilePath];
    @autoreleasepool {
        
        // Create the output context
        CFURLRef finalURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:finalPath]);
        CGContextRef writeContext = CGPDFContextCreateWithURL(finalURL, NULL, NULL);
        
        CGPDFPageRef page;
        CGRect mediaBox;
        
        //Cover
        NSString *coverPath = [Scenario getPathForPDFFileName:[NSString stringWithFormat:@"%@-cover.pdf", pdfPrefix]];
        CFURLRef coverURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:coverPath]);
        CGPDFDocumentRef pdfCover = CGPDFDocumentCreateWithURL(coverURL);
        NSInteger numberOfPagesCover = CGPDFDocumentGetNumberOfPages(pdfCover);
        for (int i = 1; i <= numberOfPagesCover; i++) {
            page = CGPDFDocumentGetPage(pdfCover, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
        CGPDFDocumentRelease(pdfCover);
        CFRelease(coverURL);
        
        //Inputs
        NSString *inputPath = [Scenario getPathForPDFFileName:[NSString stringWithFormat:@"%@-input.pdf", pdfPrefix]];
        CFURLRef inputURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:inputPath]);
        CGPDFDocumentRef pdfInput = CGPDFDocumentCreateWithURL(inputURL);
        NSInteger numberOfPagesInput = CGPDFDocumentGetNumberOfPages(pdfInput);
        for (int i = 1; i <= numberOfPagesInput; i++) {
            page = CGPDFDocumentGetPage(pdfInput, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
        CGPDFDocumentRelease(pdfInput);
        CFRelease(inputURL);
        
        //Current schedule
        NSString *currentPath = [Scenario getPathForPDFFileName:[NSString stringWithFormat:@"%@-current.pdf", pdfPrefix]];
        CFURLRef currentURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:currentPath]);
        CGPDFDocumentRef pdfCurrent = CGPDFDocumentCreateWithURL(currentURL);
        NSInteger numberOfPagesCurrent = CGPDFDocumentGetNumberOfPages(pdfCurrent);
        for (int i = 1; i <= numberOfPagesCurrent; i++) {
            page = CGPDFDocumentGetPage(pdfCurrent, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
        CGPDFDocumentRelease(pdfCurrent);
        CFRelease(currentURL);
        
        //Full schedule
        NSString *fullPath = [Scenario getPathForPDFFileName:[NSString stringWithFormat:@"%@-full.pdf", pdfPrefix]];
        CFURLRef fullURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:fullPath]);
        CGPDFDocumentRef pdfFull = CGPDFDocumentCreateWithURL(fullURL);
        NSInteger numberOfPagesFull = CGPDFDocumentGetNumberOfPages(pdfFull);
        for (int i = 1; i <= numberOfPagesFull; i++) {
            page = CGPDFDocumentGetPage(pdfFull, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
        CGPDFDocumentRelease(pdfFull);
        CFRelease(fullURL);
        
        
        //Summary report
        NSString *summaryPath = [Scenario getPathForPDFFileName:[NSString stringWithFormat:@"%@-summary.pdf", pdfPrefix]];
        CFURLRef summaryURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:summaryPath]);
        CGPDFDocumentRef pdfSummary = CGPDFDocumentCreateWithURL(summaryURL);
        NSInteger numberOfPagesSummary = CGPDFDocumentGetNumberOfPages(pdfSummary);
        for (int i = 1; i <= numberOfPagesSummary; i++) {
            page = CGPDFDocumentGetPage(pdfSummary, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
        CGPDFDocumentRelease(pdfSummary);
        CFRelease(summaryURL);
        
        
        //Remicade ISI
        NSString *remISIPath = [[NSBundle mainBundle] pathForResource:@"rem_isi" ofType:@"pdf"];
        CFURLRef remISIURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:remISIPath]);
        CGPDFDocumentRef pdfremISI = CGPDFDocumentCreateWithURL(remISIURL);
        NSInteger numberOfPagesremISI = CGPDFDocumentGetNumberOfPages(pdfremISI);
        for (int i = 1; i <= numberOfPagesremISI; i++) {
            page = CGPDFDocumentGetPage(pdfremISI, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
        CGPDFDocumentRelease(pdfremISI);
        CFRelease(remISIURL);
        
        
        //Simponi ISI
        if ([_scenario.presentation includeSimponiAria]) {
            NSString *simponiISIPath = [[NSBundle mainBundle] pathForResource:@"simp_isi" ofType:@"pdf"];
            CFURLRef simponiISIURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:simponiISIPath]);
            CGPDFDocumentRef pdfSimponiISI = CGPDFDocumentCreateWithURL(simponiISIURL);
            NSInteger numberOfPagesSimponiISI = CGPDFDocumentGetNumberOfPages(pdfSimponiISI);
            for (int i = 1; i <= numberOfPagesSimponiISI; i++) {
                page = CGPDFDocumentGetPage(pdfSimponiISI, i);
                mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
                CGContextBeginPage(writeContext, &mediaBox);
                CGContextDrawPDFPage(writeContext, page);
                CGContextEndPage(writeContext);
            }
            CGPDFDocumentRelease(pdfSimponiISI);
            CFRelease(simponiISIURL);
        }

        if ([_scenario.presentation includeStelara]) {
            NSString *stelaraISIPath = [[NSBundle mainBundle] pathForResource:@"stelara_isi" ofType:@"pdf"];
            CFURLRef stelaraISIUrl = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:stelaraISIPath]);
            CGPDFDocumentRef pdfStelaraISI = CGPDFDocumentCreateWithURL(stelaraISIUrl);
            NSInteger numberOfPages = CGPDFDocumentGetNumberOfPages(pdfStelaraISI);
            for (int i = 1; i <= numberOfPages; i++) {
                page = CGPDFDocumentGetPage(pdfStelaraISI, i);
                mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
                CGContextBeginPage(writeContext, &mediaBox);
                CGContextDrawPDFPage(writeContext, page);
                CGContextEndPage(writeContext);
            }
            CGPDFDocumentRelease(pdfStelaraISI);
            CFRelease(stelaraISIUrl);
        }
         
        // Finalize the output file
        CGPDFContextClose(writeContext);
        
        // Release from memory
        CFRelease(finalURL);
        CGContextRelease(writeContext);
        
        
        NSFileManager * fm = [NSFileManager defaultManager];
        //Delete single page file
        NSError * error = nil;
        if (![fm removeItemAtPath:coverPath error:&error]) {
            NSLog(@"Failed to delete Cover PDF file: %@", error);
            error = nil;
        }
        
        if (![fm removeItemAtPath:inputPath error:&error]) {
            NSLog(@"Failed to delete Input PDF file: %@", error);
            error = nil;
        }
        
        if (![fm removeItemAtPath:summaryPath error:&error]) {
            NSLog(@"Failed to delete Summary PDF file: %@", error);
            error = nil;
        }
        
        if (![fm removeItemAtPath:currentPath error:&error]) {
            NSLog(@"Failed to delete Current Schedule PDF file: %@", error);
            error = nil;
        }
        
        if (![fm removeItemAtPath:fullPath error:&error]) {
            NSLog(@"Failed to delete Full Schedule PDF file: %@", error);
            error = nil;
        }
    }
    return finalPath;
}

#pragma mark - Loading Reports
- (void)loadReports
{
    //Create the reports
    
    //Report Cover
    _reportCoverViewController = [[ReportCoverPageViewController alloc] initWithNibName:@"ReportCoverPageViewController" bundle:[NSBundle mainBundle]];
    _reportCoverViewController.scenario = _scenario;
    
    //Input summary
    _inputSummaryViewController = [[InputSummaryReportViewController alloc] initWithNibName:@"InputSummaryReportViewController" bundle:[NSBundle mainBundle]];
    _inputSummaryViewController.scenario = _scenario;
    
    //Report summary
    _outputSummaryViewController = [[OutputSummaryReportViewController alloc] initWithNibName:@"OutputSummaryReportViewController" bundle:[NSBundle mainBundle]];
    _outputSummaryViewController.scenario = _scenario;
    _outputSummaryViewController.screenshotQueue = _graphScreenshotQueue;
    _outputSummaryViewController.isPDF = NO;
    
    //Current Schedule
    _currentLoadScheduleViewController = [[ScheduleReportViewController alloc] initWithNibName:@"ScheduleReportViewController" bundle:[NSBundle mainBundle]];
    _currentLoadScheduleViewController.scenario = _scenario;
    _currentLoadScheduleViewController.isFullLoad = NO;
    _currentLoadScheduleViewController.isPDF = YES;
    
    //Full Load Schedule
    _fullLoadScheduleViewController = [[ScheduleReportViewController alloc] initWithNibName:@"ScheduleReportViewController" bundle:[NSBundle mainBundle]];
    _fullLoadScheduleViewController.scenario = _scenario;
    _fullLoadScheduleViewController.isFullLoad = YES;
    _fullLoadScheduleViewController.isPDF = YES;
}

- (void)displayReports
{
    //Report Cover
    [self addChildViewController:_reportCoverViewController];
    CGRect frame = _reportCoverViewController.view.frame;
    frame.origin = CGPointMake(frame.size.width, 0);
    [_reportCoverViewController.view setFrame:frame];
    [self.view addSubview:_reportCoverViewController.view];
    [_reportCoverViewController didMoveToParentViewController:self];
    
    //Add input summary
    [self addChildViewController:_inputSummaryViewController];
    frame = _inputSummaryViewController.view.frame;
    frame.origin = CGPointMake(frame.size.width, 0);
    [_inputSummaryViewController.view setFrame:frame];
    [self.view addSubview:_inputSummaryViewController.view];
    [_inputSummaryViewController didMoveToParentViewController:self];
    
    //add current schedule
    [self addChildViewController:_currentLoadScheduleViewController];
    frame = _currentLoadScheduleViewController.view.frame;
    frame.origin = CGPointMake(frame.size.width, 0);
    [_currentLoadScheduleViewController.view setFrame:frame];
    [self.view addSubview:_currentLoadScheduleViewController.view];
    [_currentLoadScheduleViewController didMoveToParentViewController:self];
    
    //add full schedule
    [self addChildViewController:_fullLoadScheduleViewController];
    frame = _fullLoadScheduleViewController.view.frame;
    frame.origin = CGPointMake(frame.size.width, 0);
    [_fullLoadScheduleViewController.view setFrame:frame];
    [self.view addSubview:_fullLoadScheduleViewController.view];
    [_fullLoadScheduleViewController didMoveToParentViewController:self];
    
    //add report summary
    [self addChildViewController:_outputSummaryViewController];
    frame = _outputSummaryViewController.view.frame;
    frame.origin = CGPointMake(frame.size.width, 0);
    [_outputSummaryViewController.view setFrame:frame];
    [self.view addSubview:_outputSummaryViewController.view];
    [_outputSummaryViewController didMoveToParentViewController:self];
    
    [_graphScreenshotQueue startProcessing];
}

#pragma mark - GraphScreenshotQueue Delegate
- (void)graphScreenshotQueueProcessingFinished:(GraphScreenshotQueue *)queue
{
    if (queue == _graphScreenshotQueue) {
        [self performSelector:@selector(createPDF) withObject:nil afterDelay:5];
    } else if (queue == _currentSGraphScreenShotQueue) {
        //end PDF
        UIGraphicsEndPDFContext();
        [self combineSchedulePDFsWithPrefix:currentPathPrefix];
        
        //Start full PDF
        //Draw full schedule to a pdf
        @autoreleasepool {
            NSLog(@"Full Schedule");
            [self pdfDrawSchedule:_fullLoadScheduleViewController withFilePathPrefix:fullPathPrefix andScreenshotQueue:_fullSGraphScreenShotQueue];
        }
        
    } else if (queue == _fullSGraphScreenShotQueue) {
        //end PDF
        UIGraphicsEndPDFContext();
        [self combineSchedulePDFsWithPrefix:fullPathPrefix];
        
        //Combine PDFs
        NSString* finalPath = [self combinePDFsWithPrefix:[_scenario getPDFFilePrefix]];
        
        if (!_responsePosted) {
            _responsePosted = YES;
            [self pdfFinishedGeneratingWithPath:finalPath];
        }
    }
}

- (void)graphScreenshotQueueProcessingCancelled:(GraphScreenshotQueue *)queue
{
    [self alertErrorWithTitle:@"PDF Generation Failed" andMessage:@"PDF generation failed due to processing queue being cancelled"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Finished
- (void)pdfFinishedGeneratingWithPath:(NSString*)path
{
    pdfFilePath = path;
    [_activityIndicator stopAnimating];
    [self sendFileFromPath:path];
}

- (void)alertErrorWithTitle:(NSString*)title andMessage:(NSString*)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

#pragma mark - Send Email
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (error) {
        NSLog(@"Email error: %@", error);
        [self alertErrorWithTitle:@"Send Error" andMessage:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //FINISHED! pop back
        [self dismissViewControllerAnimated:YES completion:NULL];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)sendFileFromPath:(NSString*)path
{
    
    NSError * error = nil;
    NSString * pathToContent = nil;

    switch (_scenario.presentation.presentationType) {
        case PresentationTypeRAIOI:
            pathToContent = [[NSBundle mainBundle] pathForResource:@"iom_email_rem_simp" ofType:@"html"];
            break;
        case PresentationTypeGIIOI:
            pathToContent = [[NSBundle mainBundle] pathForResource:@"iom_email_rem_stel" ofType:@"html"];
            break;
        case PresentationTypeHOPD:
            pathToContent = [[NSBundle mainBundle] pathForResource:@"iom_email_rem_simp_stel" ofType:@"html"];
            break;
        case PresentationTypeMixedIOI:
            pathToContent = [[NSBundle mainBundle] pathForResource:@"iom_email_rem_simp_stel" ofType:@"html"];
            break;
        case PresentationTypeOther:
            pathToContent = [[NSBundle mainBundle] pathForResource:@"iom_email_rem_simp_stel" ofType:@"html"];
            break;
        case PresentationTypeDermIOI:
            pathToContent = [[NSBundle mainBundle] pathForResource:@"iom_email_rem" ofType:@"html"];
            break;
        default:
            pathToContent = [[NSBundle mainBundle] pathForResource:@"iom_email_rem_simp" ofType:@"html"];
            break;
    }

    NSString * emailContent = [NSString stringWithContentsOfFile:pathToContent encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error pulling email content: %@", error);
    }
    
    if ([MFMailComposeViewController canSendMail]){
    
        [self.parentViewController resignFirstResponder];
        
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:[NSString stringWithFormat:@"%@ - Business Review Follow-up", [_dateFormatter stringFromDate:_scenario.presentation.presentationDate]]];
        [mailController setMessageBody:emailContent isHTML:YES];
        
        //Get PDF data
        NSData *fileData = [NSData dataWithContentsOfFile:path];
        [mailController addAttachmentData:fileData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@.pdf", _scenario.name]];

        //Get Remicade data
        NSData *remicadeData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"remicade_full_pi" ofType:@"pdf"]];
        [mailController addAttachmentData:remicadeData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"Remicade Full Prescribing Information.pdf"]];

        switch (_scenario.presentation.presentationType) {
            case PresentationTypeRAIOI: {
                NSData *simponi = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"simponi_full_pi" ofType:@"pdf"]];
                [mailController addAttachmentData:simponi mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"Simponi Full Prescribing Information.pdf"]];
                break;
            }
            case PresentationTypeGIIOI: {
                NSData *simponi = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stelara_full_pi" ofType:@"pdf"]];
                [mailController addAttachmentData:simponi mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"Stelara Full Prescribing Information.pdf"]];
                break;
            }
            case PresentationTypeHOPD: {
                NSData *simponi = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"simponi_full_pi" ofType:@"pdf"]];
                [mailController addAttachmentData:simponi mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"Simponi Full Prescribing Information.pdf"]];
                NSData *stelara = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stelara_full_pi" ofType:@"pdf"]];
                [mailController addAttachmentData:stelara mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"Stelara Full Prescribing Information.pdf"]];
                break;
            }
            case PresentationTypeMixedIOI: {
                NSData *simponi = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"simponi_full_pi" ofType:@"pdf"]];
                [mailController addAttachmentData:simponi mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"Simponi Full Prescribing Information.pdf"]];
                NSData *stelara = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stelara_full_pi" ofType:@"pdf"]];
                [mailController addAttachmentData:stelara mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"Stelara Full Prescribing Information.pdf"]];
                break;
            }
            case PresentationTypeOther: {
                NSData *simponi = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"simponi_full_pi" ofType:@"pdf"]];
                [mailController addAttachmentData:simponi mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"Simponi Full Prescribing Information.pdf"]];
                NSData *stelara = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stelara_full_pi" ofType:@"pdf"]];
                [mailController addAttachmentData:stelara mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"Stelara Full Prescribing Information.pdf"]];
                break;
            }
            case PresentationTypeDermIOI: {
                break;
            }
            default: {
                NSData *simponi = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"simponi_full_pi" ofType:@"pdf"]];
                [mailController addAttachmentData:simponi mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"Simponi Full Prescribing Information.pdf"]];
                break;
            }
        }
        
        [self presentViewController:mailController animated:YES completion:NULL];
        [mailController becomeFirstResponder];
    } else {
        [self alertErrorWithTitle:@"E-Mail Error" andMessage:@"There is no email account found this device. Please register an email account in Settings > Mail, Contacts, Calendars on your device."];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
