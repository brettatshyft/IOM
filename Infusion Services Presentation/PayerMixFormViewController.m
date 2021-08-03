//
//  PayerMixFormViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "PayerMixFormViewController.h"
#import "Presentation.h"
#import "PayerMix.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "IOMAnalyticsManager.h"
#import "UIView+IOMExtensions.h"

@interface PayerMixFormViewController ()<IOMAnalyticsIdentifiable>{
    UITextField* activeTextField;
}

@property (nonatomic, weak) IBOutlet TPKeyboardAvoidingScrollView* scrollView;

@property (nonatomic, weak) IBOutlet UITextField* payer1TextField;
@property (nonatomic, weak) IBOutlet UITextField* payer2TextField;
@property (nonatomic, weak) IBOutlet UITextField* payer3TextField;
@property (nonatomic, weak) IBOutlet UITextField* payer4TextField;
@property (nonatomic, weak) IBOutlet UITextField* payer5TextField;

@property (weak, nonatomic) IBOutlet UISwitch *spp1Switch;
@property (weak, nonatomic) IBOutlet UISwitch *spp2Switch;
@property (weak, nonatomic) IBOutlet UISwitch *spp3Switch;
@property (weak, nonatomic) IBOutlet UISwitch *spp4Switch;
@property (weak, nonatomic) IBOutlet UISwitch *spp5Switch;

@property (weak, nonatomic) IBOutlet UISwitch *soc1Switch;
@property (weak, nonatomic) IBOutlet UISwitch *soc2Switch;
@property (weak, nonatomic) IBOutlet UISwitch *soc3Switch;
@property (weak, nonatomic) IBOutlet UISwitch *soc4Switch;
@property (weak, nonatomic) IBOutlet UISwitch *soc5Switch;

@end

@implementation PayerMixFormViewController

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

    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _scrollView.scrollEnabled=FALSE;
    
    if(_payer1String) [_payer1TextField setText:_payer1String];
    if(_payer2String) [_payer2TextField setText:_payer2String];
    if(_payer3String) [_payer3TextField setText:_payer3String];
    if(_payer4String) [_payer4TextField setText:_payer4String];
    if(_payer5String) [_payer5TextField setText:_payer5String];
    
    self.textFieldArray = @[_payer1TextField,
                            _payer2TextField,
                            _payer3TextField,
                            _payer4TextField,
                            _payer5TextField
                            ];
    
    [_spp1Switch setOn:_spp1Selected animated:NO];
    [_spp2Switch setOn:_spp2Selected animated:NO];
    [_spp3Switch setOn:_spp3Selected animated:NO];
    [_spp4Switch setOn:_spp4Selected animated:NO];
    [_spp5Switch setOn:_spp5Selected animated:NO];

    [_soc1Switch setOn:_soc1Selected animated:NO];
    [_soc2Switch setOn:_soc2Selected animated:NO];
    [_soc3Switch setOn:_soc3Selected animated:NO];
    [_soc4Switch setOn:_soc4Selected animated:NO];
    [_soc5Switch setOn:_soc5Selected animated:NO];
    
    [_spp1Switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [_spp2Switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [_spp3Switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [_spp4Switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [_spp5Switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

    [_soc1Switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [_soc2Switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [_soc3Switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [_soc4Switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [_soc5Switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSString* newString = @"";
    
    [self updateValues:textField withNewString:newString];
    
    return YES;
}

- (void)switchChanged:(UISwitch *)switchControl
{
    if (switchControl==_spp1Switch) { _spp1Selected = [switchControl isOn]; }
    else if (switchControl==_spp2Switch) { _spp2Selected = [switchControl isOn]; }
    else if (switchControl==_spp3Switch) { _spp3Selected = [switchControl isOn]; }
    else if (switchControl==_spp4Switch) { _spp4Selected = [switchControl isOn]; }
    else if (switchControl==_spp5Switch) { _spp5Selected = [switchControl isOn]; }
    else if (switchControl==_soc1Switch) { _soc1Selected = [switchControl isOn]; }
    else if (switchControl==_soc2Switch) { _soc2Selected = [switchControl isOn]; }
    else if (switchControl==_soc3Switch) { _soc3Selected = [switchControl isOn]; }
    else if (switchControl==_soc4Switch) { _soc4Selected = [switchControl isOn]; }
    else if (switchControl==_soc5Switch) { _soc5Selected = [switchControl isOn]; }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    [self updateValues:textField withNewString:newString];
    return YES;
}

- (void)updateValues:(UITextField *)textField withNewString:(NSString *) newString {
    
    if(textField == _payer1TextField){
        _payer1String = newString;
    }else if(textField == _payer2TextField){
        _payer2String = newString;
    }else if(textField == _payer3TextField){
        _payer3String = newString;
    }else if(textField == _payer4TextField){
        _payer4String = newString;
    }else if(textField == _payer5TextField){
        _payer5String = newString;
    }
    
}

-(NSString*)analyticsIdentifier
{
    return @"payer_mix_form";
}

@end
