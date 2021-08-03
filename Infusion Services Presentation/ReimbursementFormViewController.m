//
//  ReimbursementFormViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "ReimbursementFormViewController.h"
#import "Presentation.h"
#import "Reimbursement.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "IOMTextField.h"
#import "Formatters.h"
#import "IOMAnalyticsManager.h"
#import "UIView+IOMExtensions.h"
#import <SafariServices/SafariServices.h>

@interface ReimbursementFormViewController ()<IOMAnalyticsIdentifiable>{
    //UITextField* activeTextField;
    NSString* localCurrencySymbol;
    NSString* localGroupingSeparator;
    NSNumberFormatter* currencyFormatter;
    NSNumberFormatter* basicFormatter;
    NSCharacterSet* nonNumberSet;
}

@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property (nonatomic, weak) IBOutlet UITextField* reimbursement96413TextField;
@property (nonatomic, weak) IBOutlet UITextField* reimbursement96415TextField;
@property (weak, nonatomic) IBOutlet UITextField* reimbursement96365TextField;
@property (nonatomic, weak) IBOutlet UITextField* geographicAreaTextField;
@property (weak, nonatomic) IBOutlet UILabel *reimbursement96365Label;

@end

@implementation ReimbursementFormViewController

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
    
    NSLocale* locale = [NSLocale currentLocale];
    localCurrencySymbol = [locale objectForKey:NSLocaleCurrencySymbol];
    localGroupingSeparator = [locale objectForKey:NSLocaleGroupingSeparator];
    
    currencyFormatter = [Formatters currencyFormatter];
    basicFormatter = [Formatters basicFormatter];
    
    //set up the reject character set
    NSMutableCharacterSet *numberSet = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];
    [numberSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    [numberSet removeCharactersInString:@"."];
    nonNumberSet = [numberSet invertedSet];

    [self.view setTranslatesAutoresizingMaskIntoConstraintsToAllSubviewsInHierarchy:NO];

    if(_reimbursement96413 != 0) [_reimbursement96413TextField setText:[NSString stringWithFormat:@"$%.02f", _reimbursement96413]];
    if(_reimbursement96415 != 0) [_reimbursement96415TextField setText:[NSString stringWithFormat:@"$%.02f", _reimbursement96415]];
    if(_reimbursement96365 != 0) [_reimbursement96365TextField setText:[NSString stringWithFormat:@"$%.02f", _reimbursement96365]];
    if(_geographicArea) [_geographicAreaTextField setText:_geographicArea];

    self.textFieldArray = @[_geographicAreaTextField,
                            _reimbursement96413TextField,
                            _reimbursement96415TextField,
                            _reimbursement96365TextField
                            ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateDisplay];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void)updateDisplay
{

}

- (void) showError
{
    if ([_geographicAreaTextField text]==nil || [[_geographicAreaTextField text] isEqualToString:@""]) {
        [((IOMTextField*)_geographicAreaTextField) setErrorBackgroundEnabled:YES];
        [((IOMTextField*)_geographicAreaTextField) setPlaceholder:@"Please indicate a geographic area."];
        [[[UIAlertView alloc] initWithTitle:@"Information Missing" message:@"Please indicate a geographic area." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    } else {
        [((IOMTextField*)_geographicAreaTextField) setErrorBackgroundEnabled:NO];
    }
}

- (IBAction)physicianFeeScheduleButtonTouchUpInside:(id)sender {
    SFSafariViewController* sfsvc = [[SFSafariViewController alloc] initWithURL: [NSURL URLWithString:@"https://www.cms.gov/apps/physician-fee-schedule/search/search-criteria.aspx"]];
    [self.navigationController presentViewController:sfsvc animated:YES completion:nil];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSString* newString = @"0";
    
    [self updateValues:textField withNewString:newString];
    
    return YES;
}

- (void)updateValues:(UITextField *)textField withNewString:(NSString *) newString {
    
    if(textField == _reimbursement96413TextField ||
       textField == _reimbursement96415TextField ||
       textField == _reimbursement96365TextField) {
        
        if(textField == _reimbursement96413TextField){
            _reimbursement96413 = ([newString length] > 1) ? [[newString substringFromIndex:1] floatValue] : 0;
        }else if(textField == _reimbursement96415TextField){
            _reimbursement96415 = ([newString length] > 1) ? [[newString substringFromIndex:1] floatValue] : 0;
        }
        else if (textField == _reimbursement96365TextField){
            _reimbursement96365 = ([newString length] > 1) ? [[newString substringFromIndex:1] floatValue] : 0;
        }
    }else if(textField == _geographicAreaTextField){
        _geographicArea = newString;
    }

}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(textField != _geographicAreaTextField){
        if ([textField.text isEqualToString:@"$0"] && ![string isEqualToString:@"."] && [string length]>0) {
            newString=@"$0";
        } else if ([newString isEqualToString:@"$"] && [string length]==0) {
            [textField setText:@""];
            newString=@"";
        } else {
            NSMutableCharacterSet* digits = [NSMutableCharacterSet decimalDigitCharacterSet];
            [digits addCharactersInString:@"."];
            NSCharacterSet* nonDigits = [digits invertedSet];
            
            NSString* cleanString=[newString
                                   stringByReplacingOccurrencesOfString:@"$"
                                   withString:@""];
            
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{0,7}(\\.\\d{0,2}?)?$"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:NULL];
            NSUInteger numberOfMatches = [regex numberOfMatchesInString:cleanString
                                                                options:NSMatchingAnchored
                                                                  range:NSMakeRange(0, [cleanString length])];
            
            if(!([string rangeOfCharacterFromSet:nonDigits].location != NSNotFound||numberOfMatches==0)) {
                [textField setText:[NSString stringWithFormat:@"$%@",cleanString]];
            }
        }
        [self updateValues:textField withNewString:[textField text]];
        return NO;
    }
    else
    {
        [self updateValues:textField withNewString:newString];
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _geographicAreaTextField) {
        if ([textField text]==nil || [[textField text] isEqualToString:@""])
            [((IOMTextField*)textField) setErrorBackgroundEnabled:YES];
        else {
            [((IOMTextField*)textField) setErrorBackgroundEnabled:NO];
        }
        
        [self showError];
    }
    [super textFieldDidEndEditing:textField];
}

-(NSString*)analyticsIdentifier
{
    return @"reimbursement_form";
}

@end
