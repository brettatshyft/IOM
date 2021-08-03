//
//  ResourceUtilizationSlideViewController.m
//  Infusion Services Presentation
//
//  Created by InfAspire on 28/01/2014.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "ResourceUtilizationSlideViewController.h"
#import "Presentation.h"
#import "IOMRoundedArrowButton.h"
#import "UIDevice+Resolutions.h"

@interface ResourceUtilizationSlideViewController ()

@property (weak, nonatomic) IBOutlet UIButton *twoHourButton;
@property (weak, nonatomic) IBOutlet UIButton *longShortButton;
@property (weak, nonatomic) IBOutlet UIImageView *infusionImageView;
@property (weak, nonatomic) IBOutlet UIButton *thirtyMinuteInfusionButton;

@end

@implementation ResourceUtilizationSlideViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self thirtyMinuteInfusion:nil];
}

- (IBAction)twoHourButtonSelected:(id)sender {
    
    [_twoHourButton setSelected:TRUE];
    [_thirtyMinuteInfusionButton setSelected:NO];
    [_longShortButton setSelected:FALSE];
    [_infusionImageView setImage:[UIImage imageNamed:@"2hr"]];
}

- (IBAction)longShortButtonSelected:(id)sender {
    [_twoHourButton setSelected:NO];
    [_thirtyMinuteInfusionButton setSelected:NO];
    [_longShortButton setSelected:YES];
    [_infusionImageView setImage:[UIImage imageNamed:@"long-short"]];
}

- (IBAction)thirtyMinuteInfusion:(id)sender {
    [_thirtyMinuteInfusionButton setSelected:YES];
    [_longShortButton setSelected:NO];
    [_twoHourButton setSelected:NO];
    [_infusionImageView setImage:[UIImage imageNamed:@"30-min"]];
}

@end
