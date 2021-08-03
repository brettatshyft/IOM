//
//  PatientPopulationSlideViewController.m
//  Infusion Services Presentation
//
//  Created by InfAspire on 28/01/2014.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "PatientPopulationSlideViewController.h"
#import "GraphWebView.h"
#import "Presentation.h"
#import "Utilization.h"

@interface PatientPopulationSlideViewController ()
{
    GraphWebView *_staticGraphView;
}

@property (weak, nonatomic) IBOutlet UILabel *biologicPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *biologicNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nonBiologicPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nonBiologicNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *NoDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientPopulationLabel;
@property (weak, nonatomic) IBOutlet UIView *chartContainerView;

@end

@implementation PatientPopulationSlideViewController

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
    
    int biologic=[_util.remicadePatients intValue] + [_util.simponiAriaPatients intValue] + [_util.otherIVBiologics intValue] + [_util.subcutaneousPatients intValue];
    int nonBiologic=[_presentation.patientPopulation intValue] - biologic;
    int total=[_presentation.patientPopulation intValue];
    
    float biologicPercentf=0.0;
    float nonBiologicPercentf=0.0;
    
    if (total>0) {
        biologicPercentf = [self calculatePercent:[NSNumber numberWithInt:biologic] ofTotal:[NSNumber numberWithInt:total]];
        nonBiologicPercentf = [self calculatePercent:[NSNumber numberWithInt:nonBiologic] ofTotal:[NSNumber numberWithInt:total]];
    }
    
    int roundBiologicPercent=[self roundedNumber:biologicPercentf];
    int roundNonBiologicPercent=[self roundedNumber:nonBiologicPercentf];
    
    float roundBiologicPercentd=fabsf(roundBiologicPercent-biologicPercentf);
    float roundNonBiologicPercentd=fabsf(roundNonBiologicPercent-nonBiologicPercentf);
    
    int totalPercent=roundBiologicPercent+roundNonBiologicPercent;
    NSLog(@"Total Percent Before: %d - %f, %f, %f, %f", totalPercent, biologicPercentf, roundBiologicPercentd, nonBiologicPercentf, roundNonBiologicPercentd );

    if (totalPercent!=100)
    {
        if (roundNonBiologicPercentd>=roundBiologicPercentd) {
            roundNonBiologicPercent+=(100-totalPercent);
        } else {
            roundBiologicPercent+=(100-totalPercent);
        }
    }
    
    totalPercent=roundBiologicPercent+roundNonBiologicPercent;
    NSLog(@"Total Percent Before: %d - %f, %f, %f, %f", totalPercent, biologicPercentf, roundBiologicPercentd, nonBiologicPercentf, roundNonBiologicPercentd );
    
    /*
    int biologicPercent=0;
    if ([_presentation.patientPopulation intValue]>0) biologicPercent = (int)round((biologic*100)/[_presentation.patientPopulation intValue]);
    int nonBiologicPercent=0;
    if (biologicPercent>0)
        nonBiologicPercent = (100-biologicPercent);
    */
    
    if (biologic==0 && nonBiologic==0)
    {
        _NoDataLabel.hidden=FALSE;
        roundNonBiologicPercent=0.0;
    }
    else
        _NoDataLabel.hidden=TRUE;

    [_patientPopulationLabel setText:[NSString stringWithFormat:@"(N=%d)", [_presentation.patientPopulation intValue]]];
    
    _biologicPercentLabel.text=[NSString stringWithFormat:@"%d", roundBiologicPercent];
    _nonBiologicPercentLabel.text=[NSString stringWithFormat:@"%d", roundNonBiologicPercent];
    _biologicNumberLabel.text=[NSString stringWithFormat:@"Total Biologic Patients (n=%d)", biologic];
    _nonBiologicNumberLabel.text=[NSString stringWithFormat:@"patients (n=%d)", nonBiologic];
    
    _staticGraphView = [GraphWebView getStaticView];
    [_staticGraphView readyForReuse];
    [_staticGraphView setOpaque:NO];
    [_staticGraphView setBackgroundColor:[UIColor clearColor]];
    [_staticGraphView setFrame:CGRectMake(0, 0, _chartContainerView.bounds.size.width, _chartContainerView.bounds.size.height)];
    [_chartContainerView addSubview:_staticGraphView];
    
    GraphWebView * __weak weakGraph = _staticGraphView;
    if (!_staticGraphView.graphFilesLoaded) {
        [_staticGraphView loadGraphFilesWithCompletion:^{
            [weakGraph pieChartPopulationWithBiologic:roundBiologicPercent andNonBiologic:roundNonBiologicPercent];
        }];
    } else {
        [_staticGraphView pieChartPopulationWithBiologic:roundBiologicPercent andNonBiologic:roundNonBiologicPercent];
    }
    
    //[_accountNameLabel setText:_presentation.accountName];
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
