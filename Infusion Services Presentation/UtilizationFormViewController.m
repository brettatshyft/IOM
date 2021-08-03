//
//  UtilizationFormViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "UtilizationFormViewController.h"
#import "Presentation+Extension.h"
#import "Utilization+Extension.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UILabel+SuperscriptLabel.h"
#import "IOMAnalyticsManager.h"
#import "UIView+IOMExtensions.h"

@interface UtilizationFormViewController ()<IOMAnalyticsIdentifiable>


@property (weak, nonatomic) IBOutlet UITextField *patientPopulationTextField;
@property (nonatomic, weak) IBOutlet UITextField* remicadePatientsTextField;
@property (weak, nonatomic) IBOutlet UITextField *simponiPatientsTextField;
@property (nonatomic, weak) IBOutlet UITextField* otherIVBiologicsTextField;
@property (nonatomic, weak) IBOutlet UITextField* subcutaneousPatientsTextField;
@property (weak, nonatomic) IBOutlet UITextField *stelaraPatientsTextField;

@property (weak, nonatomic) IBOutlet UILabel *ivBiologicLabel;
@property (weak, nonatomic) IBOutlet UILabel *nonBiologicLabel;

@property (weak, nonatomic) IBOutlet UILabel* remicadeLabel;
@property (weak, nonatomic) IBOutlet UILabel* simponiLabel;
@property (weak, nonatomic) IBOutlet UILabel* stelaraLabel;

@end

@implementation UtilizationFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_remicadeLabel setSuperscriptForRegisteredTradeMarkSymbols];
    [_simponiLabel setSuperscriptForRegisteredTradeMarkSymbols];
    
    self.textFieldArray = @[_patientPopulationTextField, _simponiPatientsTextField, _remicadePatientsTextField, _stelaraPatientsTextField, _otherIVBiologicsTextField, _subcutaneousPatientsTextField];

    for (UIView* view in self.view.allSubviewsInHierarchy) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[IOMAnalyticsManager shared] trackScreenView:self];

    [_patientPopulationTextField setText:[NSString stringWithFormat:@"%li", (long)_patientPopulation]];
    [_remicadePatientsTextField setText:[NSString stringWithFormat:@"%li", _remicadePatients]];
    [_simponiPatientsTextField setText:[NSString stringWithFormat:@"%li", _simponiPatients]];
    [_otherIVBiologicsTextField setText:[NSString stringWithFormat:@"%li", _otherIVBiologics]];
    [_subcutaneousPatientsTextField setText:[NSString stringWithFormat:@"%li", _subcutaneousPatients]];
    [_stelaraPatientsTextField setText:[NSString stringWithFormat:@"%li", _stelaraPatients]];
    
    [self updateTotal];
    
    [self updateDisplay];
}

- (void)updateDisplay
{
    _simponiPatientsTextField.hidden = ![Presentation includeSimponiAriaForPresentationTypeID:_presentationType];
    _simponiLabel.hidden = ![Presentation includeSimponiAriaForPresentationTypeID:_presentationType];
    _stelaraPatientsTextField.hidden = ![Presentation includeStelaraForPresentationTypeID:_presentationType];
    _stelaraLabel.hidden = ![Presentation includeStelaraForPresentationTypeID:_presentationType];
}

- (void) updateTotal
{
    NSInteger totalIV = self.getTotalPatients;
    [_ivBiologicLabel setText:[NSString stringWithFormat:@"%li", totalIV]];

    NSInteger totalNonBiologic = _patientPopulation - totalIV;
    [_nonBiologicLabel setText:[NSString stringWithFormat:@"%li", totalNonBiologic]];
}

- (NSInteger)getTotalPatients
{
    NSInteger totalPatients = _remicadePatients + _otherIVBiologics + _subcutaneousPatients;

    if ([Presentation includeStelaraForPresentationTypeID:_presentationType]) {
        totalPatients += _stelaraPatients;
    }

    if ([Presentation includeSimponiAriaForPresentationTypeID:_presentationType]) {
        totalPatients += _simponiPatients;
    }

    return totalPatients;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self showError];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if([string rangeOfCharacterFromSet:nonDigits].location != NSNotFound){
        return NO;
    }
    
    if (([string length] != 0)&&[textField.text length]>3) return NO;

    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    [self updateValues:textField withNewString:newString];
    
    if ([newString length]==0) return YES;
    
    NSString* removeLeadingZeros = [[NSNumber numberWithInt:[newString intValue]] stringValue];
    [textField setText:removeLeadingZeros];
    
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSString* newString = @"0";
    
    [self updateValues:textField withNewString:newString];
    
    return YES;
}

- (void)updateValues:(UITextField *)textField withNewString:(NSString *) newString {
    
    if(textField == _patientPopulationTextField){
        _patientPopulation = [newString integerValue];
    }else if(textField == _remicadePatientsTextField){
        _remicadePatients = [newString integerValue];
    }else if(textField == _simponiPatientsTextField){
        _simponiPatients = [newString integerValue];
    }else if(textField == _otherIVBiologicsTextField){
        _otherIVBiologics = [newString integerValue];
    }else if(textField == _subcutaneousPatientsTextField){
        _subcutaneousPatients = [newString integerValue];
    } else if (textField == _stelaraPatientsTextField) {
        _stelaraPatients = [newString integerValue];
    }
    
    [self updateTotal];
}

#pragma mark - PresentationForm Protocol Methods
- (BOOL)isInputDataValid
{
    BOOL totalNotBiologicIsPositive = ((_patientPopulation - [self getTotalPatients]) >= 0);
    return totalNotBiologicIsPositive;
}

- (void)showError
{
    BOOL totalNotBiologicIsPositive = ((_patientPopulation - [self getTotalPatients]) >= 0);

    if (!totalNotBiologicIsPositive) {
        [[[UIAlertView alloc] initWithTitle:@"Input Error" message:@"Total Non-biologic Patient Population cannot be negative." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)willSavePresentation {

}

-(NSString*)analyticsIdentifier
{
    return @"utilization_form";
}

@end
