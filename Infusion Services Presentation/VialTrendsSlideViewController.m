//
//  VialTrendsSlideViewController.m
//  Infusion Services Presentation
//
//  Created by InfAspire on 28/01/2014.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "VialTrendsSlideViewController.h"
#import "GraphWebView.h"
#import "Presentation+Extension.h"
#import "Utilization+Extension.h"
#import "VialTrend+Extension.h"
#import "IOMRoundedArrowButton.h"
#import "UILabel+SuperscriptLabel.h"

@interface VialTrendsSlideViewController ()
{
    VialTrendType _selectedVialTrend;
    NSDateFormatter* monthNameDateFormatter;
    NSMutableArray *_vialDataArray;
    GraphWebView *_staticGraphView;
}

@property (weak, nonatomic) IBOutlet UIButton *simponiButton;
@property (weak, nonatomic) IBOutlet UIButton *remicadeButton;
@property (weak, nonatomic) IBOutlet UIButton *stelaraButton;
@property (weak, nonatomic) IBOutlet UILabel *NoDataLabel;
@property (nonatomic, weak) IBOutlet UIView *chartContainerView;

@end

@implementation VialTrendsSlideViewController

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
    // Do any additional setup after loading the view from its nib.
    
    monthNameDateFormatter = [[NSDateFormatter alloc] init];
    [monthNameDateFormatter setDateFormat:@"MM-yy"];
    
    _selectedVialTrend = VialTrendTypeRemicade;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _staticGraphView = [GraphWebView getStaticView];
    [_staticGraphView removeFromSuperview];
    [_staticGraphView clearView];
    [_staticGraphView setOpaque:NO];
    [_staticGraphView setBackgroundColor:[UIColor clearColor]];
    [_staticGraphView setFrame:CGRectMake(0, 0, _chartContainerView.bounds.size.width, _chartContainerView.bounds.size.height)];
    [_chartContainerView addSubview:_staticGraphView];

    switch (_presentation.presentationType) {
        case PresentationTypeRAIOI: {
            // no stelara
            _remicadeButton.hidden = NO;
            _stelaraButton.hidden = YES;
            _simponiButton.hidden = NO;
            break;
        }
        case PresentationTypeGIIOI: {
            // no simponi
            _remicadeButton.hidden = NO;
            _simponiButton.hidden = YES;
            _stelaraButton.hidden = NO;
            break;
        }
        case PresentationTypeDermIOI: {
            // only remicade
            _simponiButton.hidden = YES;
            _stelaraButton.hidden = YES;
            _remicadeButton.hidden = NO;
            break;
        }
        case PresentationTypeHOPD:
        case PresentationTypeMixedIOI:
        case PresentationTypeOther:
        default: {
            _remicadeButton.hidden = NO;
            _stelaraButton.hidden = NO;
            _simponiButton.hidden = NO;
            break;
        }
    }

    if (![_presentation includeSimponiAria])
    {

        [self remicadeSelected:nil];
    } else {
        _simponiButton.hidden=NO;
        if (_selectedVialTrend == VialTrendTypeRemicade)
            [self simponiSelected:nil];
        else
            [self remicadeSelected:nil];
    }

    [_simponiButton.titleLabel setSuperscriptForRegisteredTradeMarkSymbols];
    [_remicadeButton.titleLabel setSuperscriptForRegisteredTradeMarkSymbols];
    [_stelaraButton.titleLabel setSuperscriptForRegisteredTradeMarkSymbols];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_staticGraphView readyForReuse];
    _staticGraphView = nil;
}

- (void) updateView
{
    VialTrend * trend;

    BOOL hasVials=NO;

    if (_vialDataArray==nil)
        _vialDataArray = [[NSMutableArray alloc] init];
    else
        [_vialDataArray removeAllObjects];
    
    trend = [VialTrend getVialTrendOfType:_selectedVialTrend forPresentation:_presentation];
    
    if (trend == nil || trend.lastDataMonth == nil) // Add No Data label
    {
        _vialDataArray=nil;
    }
    else
    {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents* components = [[NSDateComponents alloc] init];
        components.month = -11;
        
        NSDate * lastDataMonth = trend.lastDataMonth ?: [NSDate date];
        
        NSDate* thisDataMonth = [gregorian dateByAddingComponents:components toDate:lastDataMonth options:0];
        
        components.month = 1;
        
        [_vialDataArray addObject:@{@"date":[monthNameDateFormatter stringFromDate:thisDataMonth], @"vials":trend.valueElevenMonthsBefore}];
        thisDataMonth = [gregorian dateByAddingComponents:components toDate:thisDataMonth options:0];
        if ([trend.valueElevenMonthsBefore intValue]>0) hasVials=TRUE;
        [_vialDataArray addObject:@{@"date":[monthNameDateFormatter stringFromDate:thisDataMonth], @"vials":trend.valueTenMonthsBefore}];
        thisDataMonth = [gregorian dateByAddingComponents:components toDate:thisDataMonth options:0];
        if ([trend.valueTenMonthsBefore intValue]>0) hasVials=TRUE;
        [_vialDataArray addObject:@{@"date":[monthNameDateFormatter stringFromDate:thisDataMonth], @"vials":trend.valueNineMonthsBefore}];
        thisDataMonth = [gregorian dateByAddingComponents:components toDate:thisDataMonth options:0];
        if ([trend.valueNineMonthsBefore intValue]>0) hasVials=TRUE;
        [_vialDataArray addObject:@{@"date":[monthNameDateFormatter stringFromDate:thisDataMonth], @"vials":trend.valueEightMonthsBefore}];
        thisDataMonth = [gregorian dateByAddingComponents:components toDate:thisDataMonth options:0];
        if ([trend.valueEightMonthsBefore intValue]>0) hasVials=TRUE;
        [_vialDataArray addObject:@{@"date":[monthNameDateFormatter stringFromDate:thisDataMonth], @"vials":trend.valueSevenMonthsBefore}];
        thisDataMonth = [gregorian dateByAddingComponents:components toDate:thisDataMonth options:0];
        if ([trend.valueSevenMonthsBefore intValue]>0) hasVials=TRUE;
        [_vialDataArray addObject:@{@"date":[monthNameDateFormatter stringFromDate:thisDataMonth], @"vials":trend.valueSixMonthsBefore}];
        thisDataMonth = [gregorian dateByAddingComponents:components toDate:thisDataMonth options:0];
        if ([trend.valueSixMonthsBefore intValue]>0) hasVials=TRUE;
        [_vialDataArray addObject:@{@"date":[monthNameDateFormatter stringFromDate:thisDataMonth], @"vials":trend.valueFiveMonthsBefore}];
        thisDataMonth = [gregorian dateByAddingComponents:components toDate:thisDataMonth options:0];
        if ([trend.valueFiveMonthsBefore intValue]>0) hasVials=TRUE;
        [_vialDataArray addObject:@{@"date":[monthNameDateFormatter stringFromDate:thisDataMonth], @"vials":trend.valueFourMonthsBefore}];
        thisDataMonth = [gregorian dateByAddingComponents:components toDate:thisDataMonth options:0];
        if ([trend.valueFourMonthsBefore intValue]>0) hasVials=TRUE;
        [_vialDataArray addObject:@{@"date":[monthNameDateFormatter stringFromDate:thisDataMonth], @"vials":trend.valueThreeMonthsBefore}];
        thisDataMonth = [gregorian dateByAddingComponents:components toDate:thisDataMonth options:0];
        if ([trend.valueThreeMonthsBefore intValue]>0) hasVials=TRUE;
        [_vialDataArray addObject:@{@"date":[monthNameDateFormatter stringFromDate:thisDataMonth], @"vials":trend.valueTwoMonthsBefore}];
        thisDataMonth = [gregorian dateByAddingComponents:components toDate:thisDataMonth options:0];
        if ([trend.valueTwoMonthsBefore intValue]>0) hasVials=TRUE;
        [_vialDataArray addObject:@{@"date":[monthNameDateFormatter stringFromDate:thisDataMonth], @"vials":trend.valueOneMonthBefore}];
        thisDataMonth = [gregorian dateByAddingComponents:components toDate:thisDataMonth options:0];
        if ([trend.valueOneMonthBefore intValue]>0) hasVials=TRUE;
        [_vialDataArray addObject:@{@"date":[monthNameDateFormatter stringFromDate:thisDataMonth], @"vials":trend.valueLastDataMonth}];
        thisDataMonth = [gregorian dateByAddingComponents:components toDate:thisDataMonth options:0];
        if ([trend.valueLastDataMonth intValue]>0) hasVials=TRUE;
    }
    
    GraphWebView * __weak weakGraph = _staticGraphView;
    [weakGraph stopLoading];
    [weakGraph clearView];
    
    if (_vialDataArray==nil) {
        _NoDataLabel.hidden=FALSE;
    } else if (!hasVials) {
        _NoDataLabel.hidden=FALSE;
        if (!weakGraph.graphFilesLoaded) {
            [weakGraph loadGraphFilesWithCompletion:^{
                [weakGraph lineGraphWithData:(NSArray*)[_vialDataArray copy] andInfusionType:0];
            }];
        } else {
            [weakGraph lineGraphWithData:(NSArray*)[_vialDataArray copy] andInfusionType:0];
        }
        
    } else {
        
        _NoDataLabel.hidden=TRUE;
        if (_selectedVialTrend == VialTrendTypeRemicade)
        {
            
            if (!weakGraph.graphFilesLoaded) {
                [weakGraph loadGraphFilesWithCompletion:^{
                    [weakGraph lineGraphWithData:(NSArray*)[_vialDataArray copy] andInfusionType:2];
                }];
            } else {
                [weakGraph lineGraphWithData:(NSArray*)[_vialDataArray copy] andInfusionType:2];
            }
            
        } else if (_selectedVialTrend == VialTrendTypeSimponiAria) {
            
            if (!weakGraph.graphFilesLoaded) {
                [weakGraph loadGraphFilesWithCompletion:^{
                    [weakGraph lineGraphWithData:(NSArray*)[_vialDataArray copy] andInfusionType:0];
                }];
            } else {
                [weakGraph lineGraphWithData:(NSArray*)[_vialDataArray copy] andInfusionType:0];
            }
            
        } else if (_selectedVialTrend == VialTrendTypeStelara) {

            if (!weakGraph.graphFilesLoaded) {
                [weakGraph loadGraphFilesWithCompletion:^{
                    [weakGraph lineGraphWithData:(NSArray*)[_vialDataArray copy] andInfusionType:1];
                }];
            } else {
                [weakGraph lineGraphWithData:(NSArray*)[_vialDataArray copy] andInfusionType:1];
            }

        }
    }
}

- (IBAction)simponiSelected:(id)sender
{
    
    [_simponiButton setSelected:TRUE];
    [_remicadeButton setSelected:FALSE];
    [_stelaraButton setSelected:FALSE];

    _selectedVialTrend = VialTrendTypeSimponiAria;
    
    [self updateView];
}

- (IBAction)remicadeSelected:(id)sender
{
    [_remicadeButton setSelected:TRUE];
    [_simponiButton setSelected:FALSE];
    [_stelaraButton setSelected:FALSE];
    
    _selectedVialTrend = VialTrendTypeRemicade;
    
    [self updateView];
}

- (IBAction)stelaraSelected:(id)sender
{
    [_simponiButton setSelected:FALSE];
    [_remicadeButton setSelected:FALSE];
    [_stelaraButton setSelected:TRUE];

    _selectedVialTrend = VialTrendTypeStelara;

    [self updateView];
}

@end
