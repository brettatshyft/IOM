//
//  PenetrationFormViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "PenetrationFormViewController.h"
#import "Presentation.h"
#import "Penetration.h"
#import "Utilization.h"

@interface PenetrationFormViewController (){
    
}

@property (nonatomic, weak) IBOutlet UITextField* totalDiseaseStatePatientPopulationTextField;
@property (nonatomic, weak) IBOutlet UILabel* totalBiologicPatientsLabel;
@property (nonatomic, weak) IBOutlet UILabel* totalNonBiologicDiseaseStatePatientsLabel;

@end

@implementation PenetrationFormViewController

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
    
    if(_totalDiseaseStatePatientPopulation != 0) [_totalDiseaseStatePatientPopulationTextField setText:[NSString stringWithFormat:@"%i", _totalDiseaseStatePatientPopulation]];
    [_totalBiologicPatientsLabel setText:[NSString stringWithFormat:@"%i", _totalPatients]];
    [self updateValueLabels];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateValueLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateValueLabels{
    [_totalBiologicPatientsLabel setText:[NSString stringWithFormat:@"%i", _totalPatients]];
    int totalNonBiologicDiseaseStatePop = _totalDiseaseStatePatientPopulation - _totalPatients;
    [_totalNonBiologicDiseaseStatePatientsLabel setText:[NSString stringWithFormat:@"%i", totalNonBiologicDiseaseStatePop]];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == _totalDiseaseStatePatientPopulationTextField){
        NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if([string rangeOfCharacterFromSet:nonDigits].location != NSNotFound){
            return NO;
        }
        
        NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        _totalDiseaseStatePatientPopulation = [newString integerValue];
        
        [self updateValueLabels];
    }
    
    return YES;
}

@end
