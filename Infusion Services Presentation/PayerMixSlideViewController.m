//
//  PayerMixSlideViewController.m
//  Infusion Services Presentation
//
//  Created by InfAspire on 28/01/2014.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "PayerMixSlideViewController.h"
#import "GraphWebView.h"
#import "Presentation.h"
#import "PayerMix.h"
#import "Colors.h"

@interface PayerMixSlideViewController ()
@property (weak, nonatomic) IBOutlet UILabel *Payer1Label;
@property (weak, nonatomic) IBOutlet UILabel *Payer2Label;
@property (weak, nonatomic) IBOutlet UILabel *Payer3Label;
@property (weak, nonatomic) IBOutlet UILabel *Payer4Label;
@property (weak, nonatomic) IBOutlet UILabel *Payer5Label;
@property (weak, nonatomic) IBOutlet UILabel *Payer1SPPLabel;
@property (weak, nonatomic) IBOutlet UILabel *Payer2SPPLabel;
@property (weak, nonatomic) IBOutlet UILabel *Payer3SPPLabel;
@property (weak, nonatomic) IBOutlet UILabel *Payer4SPPLabel;
@property (weak, nonatomic) IBOutlet UILabel *Payer5SPPLabel;
@property (weak, nonatomic) IBOutlet UILabel *payer1SOCLabel;
@property (weak, nonatomic) IBOutlet UILabel *payer2SOCLabel;
@property (weak, nonatomic) IBOutlet UILabel *payer3SOCLabel;
@property (weak, nonatomic) IBOutlet UILabel *payer4SOCLabel;
@property (weak, nonatomic) IBOutlet UILabel *payer5SOCLabel;

@end

@implementation PayerMixSlideViewController

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
    
    NSMutableArray* mixes = [NSMutableArray arrayWithArray:[_presentation.payerMixes allObjects]];
    NSSortDescriptor* sortByOrder = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    [mixes sortUsingDescriptors:[NSArray arrayWithObject:sortByOrder]];
    
    NSArray* PayerSet = @[_Payer1Label, _Payer2Label, _Payer3Label, _Payer4Label, _Payer5Label];
    NSArray* SPPSet = @[_Payer1SPPLabel, _Payer2SPPLabel, _Payer3SPPLabel, _Payer4SPPLabel, _Payer5SPPLabel];
    NSArray* SOCSet = @[_payer1SOCLabel, _payer2SOCLabel, _payer3SOCLabel, _payer4SOCLabel, _payer5SOCLabel];
    
    for (int index=0; index<5; index++)
    {
        PayerMix * mix = [mixes objectAtIndex:index];
        NSLog(@"%d - %@", index, [mix description]);
        if (mix.payer==nil || [mix.payer isEqualToString:@""]) {
            ((UILabel *)[PayerSet objectAtIndex:index]).text=@"";
            ((UILabel *)[SPPSet objectAtIndex:index]).text=@"";
            ((UILabel *)[SOCSet objectAtIndex:index]).text=@"";
        }
        else
        {
            ((UILabel *)[PayerSet objectAtIndex:index]).text=mix.payer;
            if ([mix.spp boolValue]==TRUE) ((UILabel *)[SPPSet objectAtIndex:index]).text=@"YES";
            else ((UILabel *)[SPPSet objectAtIndex:index]).text=@"NO";

            if ([mix.soc boolValue]==TRUE) ((UILabel *)[SOCSet objectAtIndex:index]).text=@"YES";
            else ((UILabel *)[SOCSet objectAtIndex:index]).text=@"NO";
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
