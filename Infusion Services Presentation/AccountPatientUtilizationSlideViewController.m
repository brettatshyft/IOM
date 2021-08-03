//
//  AccountPatientUtilizationSlideViewController.m
//  Infusion Services Presentation
//
//  Created by InfAspire on 28/01/2014.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "AccountPatientUtilizationSlideViewController.h"
#import "GraphWebView.h"
#import "Presentation.h"
#import "Utilization.h"
#import "Presentation+Extension.h"

@interface AccountPatientUtilizationSlideViewController ()
{
    GraphWebView *_staticGraphView;
}
//@property (weak, nonatomic) IBOutlet GraphWebView *slideWebView;
@property (weak, nonatomic) IBOutlet UILabel *NoDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *remicadePercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *stelaraPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *subcutaneousNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *subcutaneousPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientPopulationLabel;
@property (weak, nonatomic) IBOutlet UIView *chartContainerView;
@property (weak, nonatomic) IBOutlet UIView *simponiLegendView;
@property (weak, nonatomic) IBOutlet UIView *stelaraPatientView;

@end

@implementation AccountPatientUtilizationSlideViewController

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
}

- (float) calculatePercent:(NSNumber *)amount ofTotal:(NSNumber *)total
{
    if ([total intValue]==0) return 0;
    else {
        float number=([amount floatValue]*100.0)/[total floatValue];
        return number;
    }
}

- (int) roundedNumber:(float)number
{
    return round((2.0f * number) / 2.0f);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    Utilization * _util = _presentation.utilization;
    
    if (([_presentation.presentationTypeID intValue]==2)||([_presentation.presentationTypeID intValue]==5))
    {
        _simponiLegendView.hidden=TRUE;
        _util.simponiAriaPatients=0;
    }
    else {
        _simponiLegendView.hidden=FALSE;
    }

    _stelaraPatientView.hidden = ![_presentation includeStelara];
    
    int simponi = [_util.simponiAriaPatients intValue];
    int remicade = [_util.remicadePatients intValue];
    int subcutaneous = [_util.subcutaneousPatients intValue];
    int stelara = [_util.stelaraPatients intValue];
    int other = [_util.otherIVBiologics intValue];
    int total=simponi+remicade+stelara+subcutaneous+other;
    
    /*
    simponi=99999;
    remicade=99999;
    subcutaneous=99999;
    other=99999;
    total=99999;
    */
    
    float simponiPercentf=0.0;
    float remicadePercentf=0.0;
    float subcutaneousPercentf=0.0;
    float stelaraPercentf=0.0;
    float otherPercentf=0.0;
    
    if (total>0) {
        simponiPercentf = [self calculatePercent:_util.simponiAriaPatients ofTotal:[NSNumber numberWithInt:total]];
        remicadePercentf = [self calculatePercent:_util.remicadePatients ofTotal:[NSNumber numberWithInt:total]];
        subcutaneousPercentf = [self calculatePercent:_util.subcutaneousPatients ofTotal:[NSNumber numberWithInt:total]];
        stelaraPercentf = [self calculatePercent:_util.stelaraPatients ofTotal:[NSNumber numberWithInt:total]];
        otherPercentf = [self calculatePercent:_util.otherIVBiologics ofTotal:[NSNumber numberWithInt:total]];
    }
    
    int roundSimponiPercent=[self roundedNumber:simponiPercentf];
    int roundRemicadePercent=[self roundedNumber:remicadePercentf];
    int roundSubcutaneousPercent=[self roundedNumber:subcutaneousPercentf];
    int roundStelaraPercent=[self roundedNumber:stelaraPercentf];
    int roundOtherPercent=[self roundedNumber:otherPercentf];
    
    float roundSimponiPercentd=fabsf(roundSimponiPercent-simponiPercentf);
    float roundRemicadePercentd=fabsf(roundRemicadePercent-remicadePercentf);
    float roundSubcutaneousPercentd=fabsf(roundSubcutaneousPercent-subcutaneousPercentf);
    float roundStelaraPercentd=fabsf(roundStelaraPercent-stelaraPercentf);
    float roundotherPercentd=fabsf(roundOtherPercent-otherPercentf);
    
    int totalPercent=roundSimponiPercent+roundRemicadePercent+roundSubcutaneousPercent+roundOtherPercent+roundStelaraPercent;
    NSLog(@"Total Percent Before: %d - %f, %f, %f, %f", totalPercent, roundSimponiPercentd, roundRemicadePercentd, roundSubcutaneousPercentd, roundotherPercentd);
    if (totalPercent!=100)
    {
        if (roundotherPercentd>=roundSimponiPercentd && roundotherPercentd>=roundRemicadePercentd && roundotherPercentd>=roundSubcutaneousPercentd) {
            roundOtherPercent+=(100-totalPercent);
        } else if (roundSubcutaneousPercentd>=roundSimponiPercentd && roundSubcutaneousPercentd>=roundRemicadePercentd && roundSubcutaneousPercentd>=roundotherPercentd) {
            roundSubcutaneousPercent+=(100-totalPercent);
        } else if (roundRemicadePercentd>=roundSimponiPercentd && roundRemicadePercentd>=roundSubcutaneousPercentd && roundRemicadePercentd>=roundotherPercentd) {
            roundRemicadePercent+=(100-totalPercent);
        } else {
            roundSimponiPercent+=(100-totalPercent);
        }
    }

    totalPercent=roundSimponiPercent+roundRemicadePercent+roundSubcutaneousPercent+roundOtherPercent+roundStelaraPercent;
    NSLog(@"Total Percent After: %d", totalPercent);

    
    /*
    simponiPercent=100;
    remicadePercent=100;
    subcutaneousPercent=100;
    otherPercent=100;
    */
    
    if (total==0)
    {
        _NoDataLabel.hidden=FALSE;
        roundOtherPercent=0.0;
    }
    else
        _NoDataLabel.hidden=TRUE;
    
    _simponiNumberLabel.text=[NSString stringWithFormat:@"%d", simponi];
    _remicadeNumberLabel.text=[NSString stringWithFormat:@"%d", remicade];
    _subcutaneousNumberLabel.text=[NSString stringWithFormat:@"%d", subcutaneous];
    _stelaraNumberLabel.text=[NSString stringWithFormat:@"%d", stelara];
    _otherNumberLabel.text=[NSString stringWithFormat:@"%d", other];
    _totalNumberLabel.text=[NSString stringWithFormat:@"%d", total];
    
    _simponiPercentLabel.text=[NSString stringWithFormat:@"%d%%", roundSimponiPercent];
    _remicadePercentLabel.text=[NSString stringWithFormat:@"%d%%", roundRemicadePercent];
    _stelaraPercentLabel.text=[NSString stringWithFormat:@"%d%%", roundStelaraPercent];
    _subcutaneousPercentLabel.text=[NSString stringWithFormat:@"%d%%", roundSubcutaneousPercent];
    _otherPercentLabel.text=[NSString stringWithFormat:@"%d%%", roundOtherPercent];
    
    [_patientPopulationLabel setText:[NSString stringWithFormat:@"(N=%d)", total]];
    
    _staticGraphView = [GraphWebView getStaticView];
    [_staticGraphView readyForReuse];
    [_staticGraphView setOpaque:NO];
    [_staticGraphView setBackgroundColor:[UIColor clearColor]];
    [_staticGraphView setFrame:CGRectMake(0, 0, _chartContainerView.bounds.size.width, _chartContainerView.bounds.size.height)];
    [_chartContainerView addSubview:_staticGraphView];
    
    GraphWebView * __weak weakGraph = _staticGraphView;
    if (!_staticGraphView.graphFilesLoaded) {
        [_staticGraphView loadGraphFilesWithCompletion:^{
            [weakGraph pieChartUtilizationWithSimponiAriaPatients:roundSimponiPercent remicadePatients:roundRemicadePercent stelaraPatients:roundStelaraPercent subcutaneousPatients:roundSubcutaneousPercent andOtherIVPatients:roundOtherPercent];
        }];
    } else {
        [_staticGraphView pieChartUtilizationWithSimponiAriaPatients:roundSimponiPercent remicadePatients:roundRemicadePercent stelaraPatients:roundStelaraPercent subcutaneousPatients:roundSubcutaneousPercent andOtherIVPatients:roundOtherPercent];
    }
    
/*    [_slideWebView loadGraphFilesWithCompletion:^{
        [_slideWebView pieChartUtilizationWithSimponiAriaPatients:roundSimponiPercent remicadePatients:roundRemicadePercent subcutaneousPatients:roundSubcutaneousPercent andOtherIVPatients:roundOtherPercent];
    }];*/
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_staticGraphView readyForReuse];
    _staticGraphView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
