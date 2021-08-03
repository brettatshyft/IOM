//
//  IOMBiologicalOverviewAccountSlideViewController.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 12/14/17.
//  Copyright © 2017 Local Wisdom Inc. All rights reserved.
//

#import "IOMBiologicalOverviewAccountSlideViewController.h"
#import "GraphWebView.h"
#import "Presentation+Extension.h"
#import "Utilization+Extension.h"

@interface IOMBiologicalOverviewAccountSlideViewController ()

@property (strong, nonatomic) GraphWebView *previousGraphWebView;
@property (strong, nonatomic) GraphWebView *currentGraphWebView;
@property (weak, nonatomic) IBOutlet UIView *previousGraphWebViewContainer;
@property (weak, nonatomic) IBOutlet UIView *currentGraphWebViewContainer;

@property (weak, nonatomic) IBOutlet UILabel *previousSubcutaneousPatientLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousIVPatientLabel;

@property (weak, nonatomic) IBOutlet UILabel *previousSubcutaneousPatientPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousIVPatientPercentageLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentSubcutaneousPatientLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentIVPatientLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentSubcutaneousPatientPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentIVPatientPercentageLabel;


@end

@implementation IOMBiologicalOverviewAccountSlideViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSNumberFormatter* pf = [NSNumberFormatter new];
    pf.numberStyle = NSNumberFormatterPercentStyle;
    
    [self loadWebViews];

    float previousIV = _presentation.utilization.previous52WeeksIVPatients.floatValue;
    float previousSubcut = _presentation.utilization.previous52WeeksSubcutaneousPatients.floatValue;
    float previousTotal = previousIV + previousSubcut;

    _previousIVPatientLabel.text = [NSString stringWithFormat:@"%.f", previousIV];
    _previousSubcutaneousPatientLabel.text = [NSString stringWithFormat:@"%.f", previousSubcut];

    if (previousTotal != 0) {
        _previousIVPatientPercentageLabel.text = [pf stringFromNumber: @(previousIV / previousTotal)];
        _previousSubcutaneousPatientPercentageLabel.text = [pf stringFromNumber: @(previousSubcut / previousTotal)];
    } else {
        _previousIVPatientPercentageLabel.text = [pf stringFromNumber: @(0)];
        _previousSubcutaneousPatientPercentageLabel.text = [pf stringFromNumber: @(0)];
    }

    float currentSubcut = _presentation.utilization.subcutaneousPatients.floatValue;
    float currentIVPatients = (_presentation.utilization.remicadePatients.floatValue +
                               _presentation.utilization.simponiAriaPatients.floatValue +
                               _presentation.utilization.stelaraPatients.floatValue +
                               _presentation.utilization.otherIVBiologics.floatValue);
    float currentTotal = currentSubcut + currentIVPatients;

    _currentSubcutaneousPatientLabel.text = [NSString stringWithFormat:@"%.f", currentSubcut];
    _currentIVPatientLabel.text = [NSString stringWithFormat:@"%.f", currentIVPatients];

    if (currentTotal != 0) {
        _currentIVPatientPercentageLabel.text = [pf stringFromNumber: @(currentIVPatients / currentTotal)];
        _currentSubcutaneousPatientPercentageLabel.text = [pf stringFromNumber: @(currentSubcut / currentTotal)];
    } else {
        _currentIVPatientPercentageLabel.text = [pf stringFromNumber: @(0)];
        _currentSubcutaneousPatientPercentageLabel.text = [pf stringFromNumber: @(0)];
    }

    [_previousGraphWebView loadGraphFilesWithCompletion:^{
        [_previousGraphWebView pieChartWithSubcut:_presentation.utilization.previous52WeeksSubcutaneousPatients.integerValue
            andOther:_presentation.utilization.previous52WeeksIVPatients.integerValue];
    }];

    [_currentGraphWebView loadGraphFilesWithCompletion:^{
        [_currentGraphWebView pieChartWithSubcut:_presentation.utilization.subcutaneousPatients.integerValue
                                        andOther:currentIVPatients];
    }];

}

- (void)loadWebViews{
    self.currentGraphWebView = [[GraphWebView alloc]initWithFrame:self.currentGraphWebViewContainer.bounds configuration:[[WKWebViewConfiguration alloc]init]];
    self.currentGraphWebView.backgroundColor = [UIColor clearColor];
    self.previousGraphWebView = [[GraphWebView alloc]initWithFrame:self.previousGraphWebViewContainer.bounds configuration:[[WKWebViewConfiguration alloc]init]];
    self.currentGraphWebView.backgroundColor = [UIColor clearColor];
    [self.currentGraphWebViewContainer addSubview:self.currentGraphWebView];
    [self.previousGraphWebViewContainer addSubview:self.previousGraphWebView];
}

@end
