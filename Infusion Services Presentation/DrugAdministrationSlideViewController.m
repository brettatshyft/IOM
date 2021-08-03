//
//  DrugAdministrationSlideViewController.m
//  Infusion Services Presentation
//
//  Created by InfAspire on 28/01/2014.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "DrugAdministrationSlideViewController.h"
#import "Presentation.h"
#import "Colors.h"
#import "Reimbursement.h"

@interface DrugAdministrationSlideViewController ()
@property (weak, nonatomic) IBOutlet UILabel *amount96413Label;
@property (weak, nonatomic) IBOutlet UILabel *amount96415Label;
@property (weak, nonatomic) IBOutlet UILabel *amount96365Label;
@property (weak, nonatomic) IBOutlet UILabel *geographicAreaLowerLabel;



@end

@implementation DrugAdministrationSlideViewController

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _amount96413Label.text=[NSString stringWithFormat:@"$%.02f",[_presentation.reimbursement.reimbursementFor96413 doubleValue]];
    _amount96415Label.text=[NSString stringWithFormat:@"$%.02f",[_presentation.reimbursement.reimbursementFor96415 doubleValue]];
    _amount96365Label.text=[NSString stringWithFormat:@"$%.02f",[_presentation.reimbursement.reimbursementFor96365 doubleValue]];
    _geographicAreaLowerLabel.text=_presentation.reimbursement.geographicArea;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
