//
//  VialTrendFormViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "VialTrendFormViewController.h"
#import "Presentation+Extension.h"
#import "VialTrend.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UILabel+SuperscriptLabel.h"
#import "IOMAnalyticsManager.h"
#import "UIView+IOMExtensions.h"
#import "VialTrend+Extension.h"

@interface VialTrendFormViewController ()<IOMAnalyticsIdentifiable> {
    NSDateFormatter* dateFormatter;
    NSDateFormatter* monthNameDateFormatter;
    
    UIPopoverController* _lastMonthDatePopoverController;
    UIDatePicker* _lastMonthDatePicker;
}

@property (nonatomic, weak) IBOutlet TPKeyboardAvoidingScrollView* scrollView;

@property (weak, nonatomic) IBOutlet UIButton *lastMonthButton;

@property (nonatomic, weak) IBOutlet UITextField* lastDataMonthTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueLastDataMonthTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueOneMonthBeforeTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueTwoMonthsBeforeTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueThreeMonthsBeforeTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueFourMonthsBeforeTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueFiveMonthsBeforeTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueSixMonthsBeforeTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueSevenMonthsBeforeTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueEightMonthsBeforeTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueNineMonthsBeforeTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueTenMonthsBeforeTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueElevenMonthsBeforeTextField;

@property (nonatomic, weak) IBOutlet UILabel* lastDataMonthLabel;
@property (nonatomic, weak) IBOutlet UILabel* oneMonthBeforeLabel;
@property (nonatomic, weak) IBOutlet UILabel* twoMonthsBeforeLabel;
@property (nonatomic, weak) IBOutlet UILabel* threeMonthsBeforeLabel;
@property (nonatomic, weak) IBOutlet UILabel* fourMonthsBeforeLabel;
@property (nonatomic, weak) IBOutlet UILabel* fiveMonthsBeforeLabel;
@property (nonatomic, weak) IBOutlet UILabel* sixMonthsBeforeLabel;
@property (nonatomic, weak) IBOutlet UILabel* sevenMonthsBeforeLabel;
@property (nonatomic, weak) IBOutlet UILabel* eightMonthsBeforeLabel;
@property (nonatomic, weak) IBOutlet UILabel* nineMonthsBeforeLabel;
@property (nonatomic, weak) IBOutlet UILabel* tenMonthsBeforeLabel;
@property (nonatomic, weak) IBOutlet UILabel* elevenMonthsBeforeLabel;

@property (nonatomic, weak) IBOutlet UITextField* valueLastDataMonthSimTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueOneMonthBeforeSimTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueTwoMonthsBeforeSimTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueThreeMonthsBeforeSimTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueFourMonthsBeforeSimTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueFiveMonthsBeforeSimTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueSixMonthsBeforeSimTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueSevenMonthsBeforeSimTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueEightMonthsBeforeSimTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueNineMonthsBeforeSimTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueTenMonthsBeforeSimTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueElevenMonthsBeforeSimTextField;

@property (nonatomic, weak) IBOutlet UITextField* valueLastDataMonthStelaraTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueOneMonthBeforeStelaraTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueTwoMonthsBeforeStelaraTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueThreeMonthsBeforeStelaraTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueFourMonthsBeforeStelaraTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueFiveMonthsBeforeStelaraTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueSixMonthsBeforeStelaraTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueSevenMonthsBeforeStelaraTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueEightMonthsBeforeStelaraTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueNineMonthsBeforeStelaraTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueTenMonthsBeforeStelaraTextField;
@property (nonatomic, weak) IBOutlet UITextField* valueElevenMonthsBeforeStelaraTextField;

@property (nonatomic, weak) IBOutlet UILabel* lastDataMonthSimLabel;
@property (nonatomic, weak) IBOutlet UILabel* oneMonthBeforeSimLabel;
@property (nonatomic, weak) IBOutlet UILabel* twoMonthsBeforeSimLabel;
@property (nonatomic, weak) IBOutlet UILabel* threeMonthsBeforeSimLabel;
@property (nonatomic, weak) IBOutlet UILabel* fourMonthsBeforeSimLabel;
@property (nonatomic, weak) IBOutlet UILabel* fiveMonthsBeforeSimLabel;
@property (nonatomic, weak) IBOutlet UILabel* sixMonthsBeforeSimLabel;
@property (nonatomic, weak) IBOutlet UILabel* sevenMonthsBeforeSimLabel;
@property (nonatomic, weak) IBOutlet UILabel* eightMonthsBeforeSimLabel;
@property (nonatomic, weak) IBOutlet UILabel* nineMonthsBeforeSimLabel;
@property (nonatomic, weak) IBOutlet UILabel* tenMonthsBeforeSimLabel;
@property (nonatomic, weak) IBOutlet UILabel* elevenMonthsBeforeSimLabel;

@property (nonatomic, weak) IBOutlet UILabel* lastDataMonthStelaraLabel;
@property (nonatomic, weak) IBOutlet UILabel* oneMonthBeforeStelaraLabel;
@property (nonatomic, weak) IBOutlet UILabel* twoMonthsBeforeStelaraLabel;
@property (nonatomic, weak) IBOutlet UILabel* threeMonthsBeforeStelaraLabel;
@property (nonatomic, weak) IBOutlet UILabel* fourMonthsBeforeStelaraLabel;
@property (nonatomic, weak) IBOutlet UILabel* fiveMonthsBeforeStelaraLabel;
@property (nonatomic, weak) IBOutlet UILabel* sixMonthsBeforeStelaraLabel;
@property (nonatomic, weak) IBOutlet UILabel* sevenMonthsBeforeStelaraLabel;
@property (nonatomic, weak) IBOutlet UILabel* eightMonthsBeforeStelaraLabel;
@property (nonatomic, weak) IBOutlet UILabel* nineMonthsBeforeStelaraLabel;
@property (nonatomic, weak) IBOutlet UILabel* tenMonthsBeforeStelaraLabel;
@property (nonatomic, weak) IBOutlet UILabel* elevenMonthsBeforeStelaraLabel;

@property (weak, nonatomic) IBOutlet UILabel *remicadeVialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiVialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalVialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiVialsBeforeLabel;
@property (weak, nonatomic) IBOutlet UILabel *simponiVialsAfterLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *stelaraVialsLabel;

@property (weak, nonatomic) IBOutlet UIView *vialTrendView;
@property (weak, nonatomic) IBOutlet UILabel* remicadeLabel;
@property (weak, nonatomic) IBOutlet UILabel* simponiLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIStackView *simponiAriaStackView;
@property (unsafe_unretained, nonatomic) IBOutlet UIStackView *remicadeStackView;
@property (unsafe_unretained, nonatomic) IBOutlet UIStackView *stelaraStackView;

@end

@implementation VialTrendFormViewController

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

    [self.view setTranslatesAutoresizingMaskIntoConstraintsToAllSubviewsInHierarchy:NO];

    _scrollView.scrollEnabled=FALSE;

    [self updateLabels];

    self.textFieldArray = @[_valueElevenMonthsBeforeTextField,
                            _valueTenMonthsBeforeTextField,
                            _valueNineMonthsBeforeTextField,
                            _valueEightMonthsBeforeTextField,
                            _valueSevenMonthsBeforeTextField,
                            _valueSixMonthsBeforeTextField,
                            _valueFiveMonthsBeforeTextField,
                            _valueFourMonthsBeforeTextField,
                            _valueThreeMonthsBeforeTextField,
                            _valueTwoMonthsBeforeTextField,
                            _valueOneMonthBeforeTextField,
                            _valueLastDataMonthTextField, /* */
                            _valueElevenMonthsBeforeSimTextField,
                            _valueTenMonthsBeforeSimTextField,
                            _valueNineMonthsBeforeSimTextField,
                            _valueEightMonthsBeforeSimTextField,
                            _valueSevenMonthsBeforeSimTextField,
                            _valueSixMonthsBeforeSimTextField,
                            _valueFiveMonthsBeforeSimTextField,
                            _valueFourMonthsBeforeSimTextField,
                            _valueThreeMonthsBeforeSimTextField,
                            _valueTwoMonthsBeforeSimTextField,
                            _valueOneMonthBeforeSimTextField,
                            _valueLastDataMonthSimTextField, /* */
                            _valueElevenMonthsBeforeStelaraTextField,
                            _valueTenMonthsBeforeStelaraTextField,
                            _valueNineMonthsBeforeStelaraTextField,
                            _valueEightMonthsBeforeStelaraTextField,
                            _valueSevenMonthsBeforeStelaraTextField,
                            _valueSixMonthsBeforeStelaraTextField,
                            _valueFiveMonthsBeforeStelaraTextField,
                            _valueFourMonthsBeforeStelaraTextField,
                            _valueThreeMonthsBeforeStelaraTextField,
                            _valueTwoMonthsBeforeStelaraTextField,
                            _valueOneMonthBeforeStelaraTextField,
                            _valueLastDataMonthStelaraTextField
                            ];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self updateLabels];
}

- (void)updateLabels
{
    // Do any additional setup after loading the view.
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/yy"];
    monthNameDateFormatter = [[NSDateFormatter alloc] init];
    [monthNameDateFormatter setDateFormat:@"MMM yy"];

    [_remicadeLabel setSuperscriptForRegisteredTradeMarkSymbols];
    [_simponiLabel setSuperscriptForRegisteredTradeMarkSymbols];

    if(!_lastDataMonth){
        _lastDataMonth = [dateFormatter stringFromDate:[NSDate date]];
    }
    [self setLabels];
    [self setDateValue];

    //Set text fields
    [_valueLastDataMonthTextField setText:[NSString stringWithFormat:@"%li", _valueLastDataMonth]];
    [_valueOneMonthBeforeTextField setText:[NSString stringWithFormat:@"%li", _valueOneMonthBefore]];
    [_valueTwoMonthsBeforeTextField setText:[NSString stringWithFormat:@"%li", _valueTwoMonthsBefore]];
    [_valueThreeMonthsBeforeTextField setText:[NSString stringWithFormat:@"%li", _valueThreeMonthsBefore]];
    [_valueFourMonthsBeforeTextField setText:[NSString stringWithFormat:@"%li", _valueFourMonthsBefore]];
    [_valueFiveMonthsBeforeTextField setText:[NSString stringWithFormat:@"%li", _valueFiveMonthsBefore]];
    [_valueSixMonthsBeforeTextField setText:[NSString stringWithFormat:@"%li", _valueSixMonthsBefore]];
    [_valueSevenMonthsBeforeTextField setText:[NSString stringWithFormat:@"%li", _valueSevenMonthsBefore]];
    [_valueEightMonthsBeforeTextField setText:[NSString stringWithFormat:@"%li", _valueEightMonthsBefore]];
    [_valueNineMonthsBeforeTextField setText:[NSString stringWithFormat:@"%li", _valueNineMonthsBefore]];
    [_valueTenMonthsBeforeTextField setText:[NSString stringWithFormat:@"%li", _valueTenMonthsBefore]];
    [_valueElevenMonthsBeforeTextField setText:[NSString stringWithFormat:@"%li", _valueElevenMonthsBefore]];

    [_valueLastDataMonthSimTextField setText:[NSString stringWithFormat:@"%li", _valueLastDataMonthSim]];
    [_valueOneMonthBeforeSimTextField setText:[NSString stringWithFormat:@"%li", _valueOneMonthBeforeSim]];
    [_valueTwoMonthsBeforeSimTextField setText:[NSString stringWithFormat:@"%li", _valueTwoMonthsBeforeSim]];
    [_valueThreeMonthsBeforeSimTextField setText:[NSString stringWithFormat:@"%li", _valueThreeMonthsBeforeSim]];
    [_valueFourMonthsBeforeSimTextField setText:[NSString stringWithFormat:@"%li", _valueFourMonthsBeforeSim]];
    [_valueFiveMonthsBeforeSimTextField setText:[NSString stringWithFormat:@"%li", _valueFiveMonthsBeforeSim]];
    [_valueSixMonthsBeforeSimTextField setText:[NSString stringWithFormat:@"%li", _valueSixMonthsBeforeSim]];
    [_valueSevenMonthsBeforeSimTextField setText:[NSString stringWithFormat:@"%li", _valueSevenMonthsBeforeSim]];
    [_valueEightMonthsBeforeSimTextField setText:[NSString stringWithFormat:@"%li", _valueEightMonthsBeforeSim]];
    [_valueNineMonthsBeforeSimTextField setText:[NSString stringWithFormat:@"%li", _valueNineMonthsBeforeSim]];
    [_valueTenMonthsBeforeSimTextField setText:[NSString stringWithFormat:@"%li", _valueTenMonthsBeforeSim]];
    [_valueElevenMonthsBeforeSimTextField setText:[NSString stringWithFormat:@"%li", _valueElevenMonthsBeforeSim]];

    [_valueLastDataMonthStelaraTextField setText:[NSString stringWithFormat:@"%li", _valueLastDataMonthStelara]];
    [_valueOneMonthBeforeStelaraTextField setText:[NSString stringWithFormat:@"%li", _valueOneMonthBeforeStelara]];
    [_valueTwoMonthsBeforeStelaraTextField setText:[NSString stringWithFormat:@"%li", _valueTwoMonthsBeforeStelara]];
    [_valueThreeMonthsBeforeStelaraTextField setText:[NSString stringWithFormat:@"%li", _valueThreeMonthsBeforeStelara]];
    [_valueFourMonthsBeforeStelaraTextField setText:[NSString stringWithFormat:@"%li", _valueFourMonthsBeforeStelara]];
    [_valueFiveMonthsBeforeStelaraTextField setText:[NSString stringWithFormat:@"%li", _valueFiveMonthsBeforeStelara]];
    [_valueSixMonthsBeforeStelaraTextField setText:[NSString stringWithFormat:@"%li", _valueSixMonthsBeforeStelara]];
    [_valueSevenMonthsBeforeStelaraTextField setText:[NSString stringWithFormat:@"%li", _valueSevenMonthsBeforeStelara]];
    [_valueEightMonthsBeforeStelaraTextField setText:[NSString stringWithFormat:@"%li", _valueEightMonthsBeforeStelara]];
    [_valueNineMonthsBeforeStelaraTextField setText:[NSString stringWithFormat:@"%li", _valueNineMonthsBeforeStelara]];
    [_valueTenMonthsBeforeStelaraTextField setText:[NSString stringWithFormat:@"%li", _valueTenMonthsBeforeStelara]];
    [_valueElevenMonthsBeforeStelaraTextField setText:[NSString stringWithFormat:@"%li", _valueElevenMonthsBeforeStelara]];

    [self updateTotals];
}

- (NSInteger) totalRemicade {
    return (_valueLastDataMonth +
            _valueOneMonthBefore +
            _valueTwoMonthsBefore +
            _valueThreeMonthsBefore +
            _valueFourMonthsBefore +
            _valueFiveMonthsBefore +
            _valueSixMonthsBefore +
            _valueSevenMonthsBefore +
            _valueEightMonthsBefore +
            _valueNineMonthsBefore +
            _valueTenMonthsBefore +
            _valueElevenMonthsBefore);
    
}

- (NSInteger) totalSimponi {
    return (_valueLastDataMonthSim +
            _valueOneMonthBeforeSim +
            _valueTwoMonthsBeforeSim +
            _valueThreeMonthsBeforeSim +
            _valueFourMonthsBeforeSim +
            _valueFiveMonthsBeforeSim +
            _valueSixMonthsBeforeSim +
            _valueSevenMonthsBeforeSim +
            _valueEightMonthsBeforeSim +
            _valueNineMonthsBeforeSim +
            _valueTenMonthsBeforeSim +
            _valueElevenMonthsBeforeSim);
}

- (NSInteger) totalStelara {
    return (_valueLastDataMonthStelara +
            _valueOneMonthBeforeStelara +
            _valueTwoMonthsBeforeStelara +
            _valueThreeMonthsBeforeStelara +
            _valueFourMonthsBeforeStelara +
            _valueFiveMonthsBeforeStelara +
            _valueSixMonthsBeforeStelara +
            _valueSevenMonthsBeforeStelara +
            _valueEightMonthsBeforeStelara +
            _valueNineMonthsBeforeStelara +
            _valueTenMonthsBeforeStelara +
            _valueElevenMonthsBeforeStelara);
}


- (NSInteger) totalVials {
    if (_presentationType.integerValue == 2 || _presentationType.integerValue == 5)
        return [self totalRemicade] + [self totalStelara];
    else
        return ([self totalRemicade] + [self totalSimponi] + [self totalStelara]);
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateDisplay];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void)updateDisplay
{
    _simponiAriaStackView.hidden = ![Presentation includeSimponiAriaForPresentationTypeID:_presentationType];
    _stelaraStackView.hidden = ![Presentation includeStelaraForPresentationTypeID:_presentationType];

    [_totalVialsLabel setText:[NSString stringWithFormat:@"%li", [self totalVials]]];

}

- (void)setDateValue{
    NSDate* lastDataMonth = [dateFormatter dateFromString:_lastDataMonth];
    
    if(!lastDataMonth){
        lastDataMonth = [NSDate date];
    }
    
    [_lastMonthButton setTitle:[dateFormatter stringFromDate:lastDataMonth] forState:UIControlStateNormal];
}

- (void)setLabels{
    NSDate* lastDataMonth = [dateFormatter dateFromString:_lastDataMonth];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate* oneMonthBefore = [gregorian dateByAddingComponents:components toDate:lastDataMonth options:0];
    NSDate* twoMonthBefore = [gregorian dateByAddingComponents:components toDate:oneMonthBefore options:0];
    NSDate* threeMonthBefore = [gregorian dateByAddingComponents:components toDate:twoMonthBefore options:0];
    NSDate* fourMonthBefore = [gregorian dateByAddingComponents:components toDate:threeMonthBefore options:0];
    NSDate* fiveMonthBefore = [gregorian dateByAddingComponents:components toDate:fourMonthBefore options:0];
    NSDate* sixMonthBefore = [gregorian dateByAddingComponents:components toDate:fiveMonthBefore options:0];
    NSDate* sevenMonthBefore = [gregorian dateByAddingComponents:components toDate:sixMonthBefore options:0];
    NSDate* eightMonthBefore = [gregorian dateByAddingComponents:components toDate:sevenMonthBefore options:0];
    NSDate* nineMonthBefore = [gregorian dateByAddingComponents:components toDate:eightMonthBefore options:0];
    NSDate* tenMonthBefore = [gregorian dateByAddingComponents:components toDate:nineMonthBefore options:0];
    NSDate* elevenMonthBefore = [gregorian dateByAddingComponents:components toDate:tenMonthBefore options:0];
    
    [_lastDataMonthLabel setText:[monthNameDateFormatter stringFromDate:lastDataMonth]];
    [_oneMonthBeforeLabel setText:[monthNameDateFormatter stringFromDate:oneMonthBefore]];
    [_twoMonthsBeforeLabel setText:[monthNameDateFormatter stringFromDate:twoMonthBefore]];
    [_threeMonthsBeforeLabel setText:[monthNameDateFormatter stringFromDate:threeMonthBefore]];
    [_fourMonthsBeforeLabel setText:[monthNameDateFormatter stringFromDate:fourMonthBefore]];
    [_fiveMonthsBeforeLabel setText:[monthNameDateFormatter stringFromDate:fiveMonthBefore]];
    [_sixMonthsBeforeLabel setText:[monthNameDateFormatter stringFromDate:sixMonthBefore]];
    [_sevenMonthsBeforeLabel setText:[monthNameDateFormatter stringFromDate:sevenMonthBefore]];
    [_eightMonthsBeforeLabel setText:[monthNameDateFormatter stringFromDate:eightMonthBefore]];
    [_nineMonthsBeforeLabel setText:[monthNameDateFormatter stringFromDate:nineMonthBefore]];
    [_tenMonthsBeforeLabel setText:[monthNameDateFormatter stringFromDate:tenMonthBefore]];
    [_elevenMonthsBeforeLabel setText:[monthNameDateFormatter stringFromDate:elevenMonthBefore]];
    
    [_lastDataMonthSimLabel setText:[monthNameDateFormatter stringFromDate:lastDataMonth]];
    [_oneMonthBeforeSimLabel setText:[monthNameDateFormatter stringFromDate:oneMonthBefore]];
    [_twoMonthsBeforeSimLabel setText:[monthNameDateFormatter stringFromDate:twoMonthBefore]];
    [_threeMonthsBeforeSimLabel setText:[monthNameDateFormatter stringFromDate:threeMonthBefore]];
    [_fourMonthsBeforeSimLabel setText:[monthNameDateFormatter stringFromDate:fourMonthBefore]];
    [_fiveMonthsBeforeSimLabel setText:[monthNameDateFormatter stringFromDate:fiveMonthBefore]];
    [_sixMonthsBeforeSimLabel setText:[monthNameDateFormatter stringFromDate:sixMonthBefore]];
    [_sevenMonthsBeforeSimLabel setText:[monthNameDateFormatter stringFromDate:sevenMonthBefore]];
    [_eightMonthsBeforeSimLabel setText:[monthNameDateFormatter stringFromDate:eightMonthBefore]];
    [_nineMonthsBeforeSimLabel setText:[monthNameDateFormatter stringFromDate:nineMonthBefore]];
    [_tenMonthsBeforeSimLabel setText:[monthNameDateFormatter stringFromDate:tenMonthBefore]];
    [_elevenMonthsBeforeSimLabel setText:[monthNameDateFormatter stringFromDate:elevenMonthBefore]];

    [_lastDataMonthStelaraLabel setText:[monthNameDateFormatter stringFromDate:lastDataMonth]];
    [_oneMonthBeforeStelaraLabel setText:[monthNameDateFormatter stringFromDate:oneMonthBefore]];
    [_twoMonthsBeforeStelaraLabel setText:[monthNameDateFormatter stringFromDate:twoMonthBefore]];
    [_threeMonthsBeforeStelaraLabel setText:[monthNameDateFormatter stringFromDate:threeMonthBefore]];
    [_fourMonthsBeforeStelaraLabel setText:[monthNameDateFormatter stringFromDate:fourMonthBefore]];
    [_fiveMonthsBeforeStelaraLabel setText:[monthNameDateFormatter stringFromDate:fiveMonthBefore]];
    [_sixMonthsBeforeStelaraLabel setText:[monthNameDateFormatter stringFromDate:sixMonthBefore]];
    [_sevenMonthsBeforeStelaraLabel setText:[monthNameDateFormatter stringFromDate:sevenMonthBefore]];
    [_eightMonthsBeforeStelaraLabel setText:[monthNameDateFormatter stringFromDate:eightMonthBefore]];
    [_nineMonthsBeforeStelaraLabel setText:[monthNameDateFormatter stringFromDate:nineMonthBefore]];
    [_tenMonthsBeforeStelaraLabel setText:[monthNameDateFormatter stringFromDate:tenMonthBefore]];
    [_elevenMonthsBeforeStelaraLabel setText:[monthNameDateFormatter stringFromDate:elevenMonthBefore]];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(textField == _lastDataMonthTextField){
        _lastDataMonth = newString;
        
        NSDate* date = [dateFormatter dateFromString:newString];
        if(date){
            [self setLabels];
        }
    }else{
        if (([string length] != 0)&&[textField.text length]>3) return NO;
        
        NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if([string rangeOfCharacterFromSet:nonDigits].location != NSNotFound){
            return NO;
        }
        
        if(textField == _valueLastDataMonthTextField){
            _valueLastDataMonth = [newString integerValue];
        }else if(textField == _valueOneMonthBeforeTextField){
            _valueOneMonthBefore = [newString integerValue];
        }else if(textField == _valueTwoMonthsBeforeTextField){
            _valueTwoMonthsBefore = [newString integerValue];
        }else if(textField == _valueThreeMonthsBeforeTextField){
            _valueThreeMonthsBefore = [newString integerValue];
        }else if(textField == _valueFourMonthsBeforeTextField){
            _valueFourMonthsBefore = [newString integerValue];
        }else if(textField == _valueFiveMonthsBeforeTextField){
            _valueFiveMonthsBefore = [newString integerValue];
        }else if(textField == _valueSixMonthsBeforeTextField){
            _valueSixMonthsBefore = [newString integerValue];
        }else if(textField == _valueSevenMonthsBeforeTextField){
            _valueSevenMonthsBefore = [newString integerValue];
        }else if(textField == _valueEightMonthsBeforeTextField){
            _valueEightMonthsBefore = [newString integerValue];
        }else if(textField == _valueNineMonthsBeforeTextField){
            _valueNineMonthsBefore = [newString integerValue];
        }else if(textField == _valueTenMonthsBeforeTextField){
            _valueTenMonthsBefore = [newString integerValue];
        }else if(textField == _valueElevenMonthsBeforeTextField){
            _valueElevenMonthsBefore = [newString integerValue];
        }else if(textField == _valueLastDataMonthSimTextField){
            _valueLastDataMonthSim = [newString integerValue];
        }else if(textField == _valueOneMonthBeforeSimTextField){
            _valueOneMonthBeforeSim = [newString integerValue];
        }else if(textField == _valueTwoMonthsBeforeSimTextField){
            _valueTwoMonthsBeforeSim = [newString integerValue];
        }else if(textField == _valueThreeMonthsBeforeSimTextField){
            _valueThreeMonthsBeforeSim = [newString integerValue];
        }else if(textField == _valueFourMonthsBeforeSimTextField){
            _valueFourMonthsBeforeSim = [newString integerValue];
        }else if(textField == _valueFiveMonthsBeforeSimTextField){
            _valueFiveMonthsBeforeSim = [newString integerValue];
        }else if(textField == _valueSixMonthsBeforeSimTextField){
            _valueSixMonthsBeforeSim = [newString integerValue];
        }else if(textField == _valueSevenMonthsBeforeSimTextField){
            _valueSevenMonthsBeforeSim = [newString integerValue];
        }else if(textField == _valueEightMonthsBeforeSimTextField){
            _valueEightMonthsBeforeSim = [newString integerValue];
        }else if(textField == _valueNineMonthsBeforeSimTextField){
            _valueNineMonthsBeforeSim = [newString integerValue];
        }else if(textField == _valueTenMonthsBeforeSimTextField){
            _valueTenMonthsBeforeSim = [newString integerValue];
        }else if(textField == _valueElevenMonthsBeforeSimTextField){
            _valueElevenMonthsBeforeSim = [newString integerValue];
        }else if(textField == _valueLastDataMonthStelaraTextField){
            _valueLastDataMonthStelara = [newString integerValue];
        }else if(textField == _valueOneMonthBeforeStelaraTextField){
            _valueOneMonthBeforeStelara = [newString integerValue];
        }else if(textField == _valueTwoMonthsBeforeStelaraTextField){
            _valueTwoMonthsBeforeStelara = [newString integerValue];
        }else if(textField == _valueThreeMonthsBeforeStelaraTextField){
            _valueThreeMonthsBeforeStelara = [newString integerValue];
        }else if(textField == _valueFourMonthsBeforeStelaraTextField){
            _valueFourMonthsBeforeStelara = [newString integerValue];
        }else if(textField == _valueFiveMonthsBeforeStelaraTextField){
            _valueFiveMonthsBeforeStelara = [newString integerValue];
        }else if(textField == _valueSixMonthsBeforeStelaraTextField){
            _valueSixMonthsBeforeStelara = [newString integerValue];
        }else if(textField == _valueSevenMonthsBeforeStelaraTextField){
            _valueSevenMonthsBeforeStelara = [newString integerValue];
        }else if(textField == _valueEightMonthsBeforeStelaraTextField){
            _valueEightMonthsBeforeStelara = [newString integerValue];
        }else if(textField == _valueNineMonthsBeforeStelaraTextField){
            _valueNineMonthsBeforeStelara = [newString integerValue];
        }else if(textField == _valueTenMonthsBeforeStelaraTextField){
            _valueTenMonthsBeforeStelara = [newString integerValue];
        }else if(textField == _valueElevenMonthsBeforeStelaraTextField){
            _valueElevenMonthsBeforeStelara = [newString integerValue];
        }

        [self updateTotals];
    }
    
    if ([newString length]==0) return YES;
    
    NSString* removeLeadingZeros = [[NSNumber numberWithInt:[newString intValue]] stringValue];
    [textField setText:removeLeadingZeros];

    return NO;
}

- (void)updateTotals
{
    [_remicadeVialsLabel setText:[NSString stringWithFormat:@"%li", [self totalRemicade]]];
    [_stelaraVialsLabel setText:[NSString stringWithFormat:@"%li", [self totalStelara]]];
    [_simponiVialsLabel setText:[NSString stringWithFormat:@"%li", [self totalSimponi]]];
    [_totalVialsLabel setText:[NSString stringWithFormat:@"%li", [self totalVials]]];
}

- (IBAction)lastMonthButtonSelected:(UIButton *)sender {
    
    [self.view endEditing:TRUE];
    
    if (!_lastMonthDatePopoverController) {
        
        UIView *v = [[UIView alloc] init];
        CGRect pickerFrame = CGRectMake(0, 0, 320, 216);
        UIDatePicker *pView=[[UIDatePicker alloc] initWithFrame:pickerFrame];
        pView.datePickerMode = UIDatePickerModeDate;
        
        _lastMonthDatePicker = pView;
        [v addSubview:_lastMonthDatePicker];
        
        UIViewController *popoverContent = [[UIViewController alloc]init];
        popoverContent.view = v;
        
        //resize the popover view shown
        //in the current view to the view's size
        popoverContent.preferredContentSize = CGSizeMake(320, 216);
        
        //create a popover controller with my DatePickerViewController in it
        _lastMonthDatePopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        
        //Set the delegate to self to receive the data of the Datepicker in the popover
        _lastMonthDatePopoverController.delegate = self;
        
        //Adjust the popover Frame to appear where I want
        CGRect myFrame = sender.frame;//CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 320,     200);
        myFrame.origin.x = 260;
        myFrame.origin.y = 320;
        
    }
    
    //Present the popover
    [_lastMonthDatePopoverController presentPopoverFromRect:[sender frame]
                                                        inView:self.view
                                      permittedArrowDirections:UIPopoverArrowDirectionUp
                                                      animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [_lastMonthButton setTitle:[dateFormatter stringFromDate:_lastMonthDatePicker.date] forState:UIControlStateNormal];
    
    _lastDataMonth = _lastMonthButton.titleLabel.text;
    
    [self setLabels];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    //activeTextField = nil;
    if(textField == _lastDataMonthTextField){
        NSString* dateString = textField.text;
        NSDate* newDate = [dateFormatter dateFromString:dateString];
        if(newDate && (id)newDate != [NSNull null]){
            [self setLabels];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Invalid Date" message:@"The date entered is invalid. " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }
    [super textFieldDidEndEditing:textField];
}

-(NSString*)analyticsIdentifier
{
    return @"vial_trend_form";
}
 
@end
