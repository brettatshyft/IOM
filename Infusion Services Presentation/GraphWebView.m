//
//  GraphWebView.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/23/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "GraphWebView.h"
#import "Colors.h"
#import "GraphLoadQueue.h"

@interface GraphWebView ()
{
    LoadCompletion _loadCompletionHandler;
}

@end

@implementation GraphWebView

+ (GraphWebView*)getStaticView
{
    static GraphWebView* webViewStatic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webViewStatic = [[GraphWebView alloc] initWithFrame:CGRectZero configuration:[[WKWebViewConfiguration alloc]init]];
    });
    
    return webViewStatic;
}

+ (GraphWebView*)getStaticCurrentScheduleWebView
{
    static GraphWebView* currentScheduleWebViewStatic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentScheduleWebViewStatic = [[GraphWebView alloc] initWithFrame:CGRectZero configuration:[[WKWebViewConfiguration alloc]init]];
    });
    
    return currentScheduleWebViewStatic;
}

+ (GraphWebView*)getStaticFullScheduleWebView
{
    static GraphWebView* fullScheduleWebViewStatic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fullScheduleWebViewStatic = [[GraphWebView alloc] initWithFrame:CGRectZero configuration:[[WKWebViewConfiguration alloc]init]];
    });
    
    return fullScheduleWebViewStatic;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration{
    self = [super initWithFrame:frame configuration:configuration];
    if (self){
        
    }
    return self;
}

- (void)loadGraphFilesWithCompletion:(LoadCompletion)loadCompletion
{
    if(!_graphFilesLoaded) {
        self.userInteractionEnabled = NO;
        self.navigationDelegate = self;
        _loadCompletionHandler = loadCompletion;
        
        if (_loadQueue) {
            [_loadQueue addLoadRequestForGraphWebView:self];
        } else {
            //No queue, start load
            [self loadGraphFiles];
        }
    }
}

- (void)loadGraphFiles
{
    if(!_graphFilesLoaded) {
        self.userInteractionEnabled = NO;
        self.navigationDelegate = self;
        //NSURL *url = [NSURL URLWithString:@"http://ms.lwclients.com/d3/"];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"IOM_Charts"]];
        //NSLog(@"Loading index.html at path: %@", [url path]);
        [self loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)clearView
{
    [self evaluateJavaScript:@"removeSVG();" completionHandler:NULL];
}

- (void)readyForReuse
{
    [self stopLoading];
    [self clearView];
    [self removeFromSuperview];
}

- (void)cleanup
{
    if (_loadQueue) {
        [_loadQueue removeLoadRequestForGraphWebView:self];
        _loadQueue = nil;
    }
    [self stopLoading];
    [self loadHTMLString:@"" baseURL:nil];
    _graphFilesLoaded = NO;
}

- (void)pieChartPopulationWithBiologic:(int)biologic andNonBiologic:(int)nonBiologic
{
    NSString* js = [NSString stringWithFormat:@"pieChartPopulation(%i,%i);", biologic, nonBiologic];
    [self evaluateJavaScript:js completionHandler:NULL];
}

- (void)pieChartUtilizationWithSimponiAriaPatients:(int)simponiAriaPatients remicadePatients:(int)remicadePatients stelaraPatients:(int)stelaraPatients subcutaneousPatients:(int)subcutaneousPatients andOtherIVPatients:(int)otherIVPatients
{
    NSString* js = [NSString stringWithFormat:@"pieChartUtilization(%i,%i,%i,%i,%i);", simponiAriaPatients, stelaraPatients, remicadePatients, subcutaneousPatients, otherIVPatients];
    [self evaluateJavaScript:js completionHandler:NULL];
}

- (void)lineGraphWithData:(NSArray*)dataArray andInfusionType:(int)type
{
    //type 0 - simponi
    //time 1 - remicade
    
    //if(_graphLoaded) return;
    
    /*
     var data = [
     {"date":"1-13","vials":150},
     {"date":"2-13","vials":53},
     {"date":"3-13","vials":167},
     {"date":"4-13","vials":89},
     {"date":"5-13","vials":199},
     {"date":"6-13","vials":130},
     {"date":"7-13","vials":166},
     {"date":"8-13","vials":234},
     {"date":"9-13","vials":155},
     {"date":"10-13","vials":343},
     {"date":"11-13","vials":200},
     {"date":"12-13","vials":443}
     ];
     lineGraph(data,0);
     */
    
    if (dataArray != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString* dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString* jsString = [NSString stringWithFormat:@"var type=%i; var data = %@; lineGraphVialTrends(data,type);", type, dataString];
        
        [self evaluateJavaScript:jsString completionHandler:NULL];
    }
}

- (void)barGraphCapacityUsageWithData:(NSArray*)dataArray largeText:(BOOL)largeText
{
    //if(_graphLoaded) return;
    
    /*
     var data = [
     {"Types":"Chair Hours Occupied","Current Patient Load":10,"Full Load Schedule":13},
     {"Types":"Staff Hours Utilized","Current Patient Load":4.6,"Full Load Schedule":5.9}
     ];
     barGraphCapacityUsage(data);
     */
    
    if (dataArray != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString* dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        int large = (largeText) ? 1 : 0;
        NSString* jsString = [NSString stringWithFormat:@"var data = %@; barGraphCapacityUsage(data, %i);", dataString, large];
        
        [self evaluateJavaScript:jsString completionHandler:NULL];
    }
}

- (void)pieChartWithSubcut:(NSInteger)subcut andOther:(NSInteger)other
{
    [self evaluateJavaScript:[NSString stringWithFormat:@"pieChartSubcutOther(%li, %li);", (long)subcut, (long)other] completionHandler:NULL];
}

- (void)barGraphInfusionsPerWeekWithData:(NSArray*)dataArray andInfusionType:(int)type largeText:(BOOL)largeText
{
    if (dataArray != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString* dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        int large = (largeText) ? 1 : 0;
        NSString* jsString = [NSString stringWithFormat:@"var type=%i; var data=%@; barGraphInfusionsPerWeek(data,type,%i);", type, dataString, large];
        
        [self evaluateJavaScript:jsString completionHandler:NULL];
    }
}

-(void)timeToCapacityReportWithVialData:(NSArray<NSNumber*>*)vialData availableCapacity:(NSNumber*)availableCapacity andTotalWidgetsInCurrentSchedule:(NSNumber*)totalWidgetsInCurrentSchedule
{
    NSMutableString* dataParameterString = [@"[" mutableCopy];
    
    int currentMonth = 0;
    for (NSNumber* vial in vialData) {
        [dataParameterString appendString:[NSString stringWithFormat:@"{'month':'%i','vials':%i},", currentMonth, vial.intValue]];
        currentMonth++;
    }
    [dataParameterString deleteCharactersInRange:NSMakeRange([dataParameterString length]-1, 1)];
    [dataParameterString appendString:@"]"];
    
    NSString* js = [NSString stringWithFormat:@"lineGraphTimeToCapacity(%@, %i, %i);", dataParameterString, totalWidgetsInCurrentSchedule.intValue, availableCapacity.intValue];
    
    [self evaluateJavaScript:js completionHandler:NULL];
}

- (int)ganttChartWithData:(NSString*)dataString andDayString:(NSString*)dayString includeSpacing:(BOOL)includeSpacing
{
    int spacing = (includeSpacing) ? 1 : 0;
    NSString* jsString = [NSString stringWithFormat:@"var day=\"%@\"; %@ gantChart(data,day,%i);", dayString, dataString, spacing];
    NSString *result = [self stringByEvaluatingJavaScriptFromString:jsString];
    return [result intValue];
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script {
    __block NSString *resultString = nil;
    __block BOOL finished = NO;

    [self evaluateJavaScript:script completionHandler:^(id result, NSError *error) {
        if (error == nil) {
            if (result != nil) {
                resultString = [NSString stringWithFormat:@"%@", result];
            }
        } else {
            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
        }
        finished = YES;
    }];

    while (!finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }

    return resultString;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    _graphFilesLoaded = YES;
    
    //Run load completion handler
    if( _loadCompletionHandler ) {
        _loadCompletionHandler();
        _loadCompletionHandler = nil;
    }
    
    //alert queue that loading has finished
    if (_loadQueue) {
        [_loadQueue loadNextGraph];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"Graph Web View did fail load: %@", error);
    _loadCompletionHandler = nil;
    
    //alert queue that loading has finished
    if (_loadQueue) {
        [_loadQueue loadNextGraph];
    }
}

@end
