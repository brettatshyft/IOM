//
//  OtherInfusionsFormViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/13/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentationFormProtocol.h"
#import "ScenarioForm.h"
#import "DropdownDelegate.h"
#import "BaseFormViewController.h"

@interface OtherInfusionsFormViewController : BaseFormViewController <PresentationFormProtocol, ScenarioForm, DropdownDelegate, UIPopoverControllerDelegate, UITextFieldDelegate>{
    
}

@property (nonatomic, weak) IBOutlet UILabel * totalTimeRxALabel;
@property (nonatomic, weak) IBOutlet UILabel * totalTimeRxBLabel;
@property (nonatomic, weak) IBOutlet UILabel * totalTimeRxCLabel;
@property (nonatomic, weak) IBOutlet UILabel * totalTimeRxDLabel;
@property (nonatomic, weak) IBOutlet UILabel * totalTimeRxELabel;
@property (nonatomic, weak) IBOutlet UILabel * totalTimeRxFLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeRxGLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeRxHLabel;

@property (nonatomic, weak) IBOutlet UILabel * treatmentsPerMonthLabel;

@property (nonatomic, weak) IBOutlet UITextField * treatmentsPerMonthRxATextField;
@property (nonatomic, weak) IBOutlet UITextField * treatmentsPerMonthRxBTextField;
@property (nonatomic, weak) IBOutlet UITextField * treatmentsPerMonthRxCTextField;
@property (nonatomic, weak) IBOutlet UITextField * treatmentsPerMonthRxDTextField;
@property (nonatomic, weak) IBOutlet UITextField * treatmentsPerMonthRxETextField;
@property (nonatomic, weak) IBOutlet UITextField * treatmentsPerMonthRxFTextField;
@property (weak, nonatomic) IBOutlet UITextField *treatmentsPerMonthRxGTextField;
@property (weak, nonatomic) IBOutlet UITextField *treatmentsPerMonthRxHTextField;

@property (nonatomic, weak) IBOutlet UITextField * rxANewPatientsPerMonthTextField;
@property (nonatomic, weak) IBOutlet UITextField * rxBNewPatientsPerMonthTextField;
@property (nonatomic, weak) IBOutlet UITextField * rxCNewPatientsPerMonthTextField;
@property (nonatomic, weak) IBOutlet UITextField * rxDNewPatientsPerMonthTextField;
@property (nonatomic, weak) IBOutlet UITextField * rxENewPatientsPerMonthTextField;
@property (nonatomic, weak) IBOutlet UITextField * rxFNewPatientsPerMonthTextField;
@property (weak, nonatomic) IBOutlet UITextField *rxGNewPatientsPerMonthTextField;
@property (weak, nonatomic) IBOutlet UITextField *rxHNewPatientsPerMonthTextField;

@property (nonatomic, weak) IBOutlet UIButton * preInfusionTimeRxAButton;
@property (nonatomic, weak) IBOutlet UIButton * preInfusionTimeRxBButton;
@property (nonatomic, weak) IBOutlet UIButton * preInfusionTimeRxCButton;
@property (nonatomic, weak) IBOutlet UIButton * preInfusionTimeRxDButton;
@property (nonatomic, weak) IBOutlet UIButton * preInfusionTimeRxEButton;
@property (nonatomic, weak) IBOutlet UIButton * preInfusionTimeRxFButton;
@property (weak, nonatomic) IBOutlet UIButton *preInfusionTimeRxGButton;
@property (weak, nonatomic) IBOutlet UIButton *preInfusionTimeRxHButton;

@property (nonatomic, weak) IBOutlet UIButton * infusionAdminTimeRxAButton;
@property (nonatomic, weak) IBOutlet UIButton * infusionAdminTimeRxBButton;
@property (nonatomic, weak) IBOutlet UIButton * infusionAdminTimeRxCButton;
@property (nonatomic, weak) IBOutlet UIButton * infusionAdminTimeRxDButton;
@property (nonatomic, weak) IBOutlet UIButton * infusionAdminTimeRxEButton;
@property (nonatomic, weak) IBOutlet UIButton * infusionAdminTimeRxFButton;
@property (weak, nonatomic) IBOutlet UIButton *infusionAdminTimeRxGButton;
@property (weak, nonatomic) IBOutlet UIButton *infusionAdminTimeRxHButton;

@property (nonatomic, weak) IBOutlet UIButton * postInfusionTimeRxAButton;
@property (nonatomic, weak) IBOutlet UIButton * postInfusionTimeRxBButton;
@property (nonatomic, weak) IBOutlet UIButton * postInfusionTimeRxCButton;
@property (nonatomic, weak) IBOutlet UIButton * postInfusionTimeRxDButton;
@property (nonatomic, weak) IBOutlet UIButton * postInfusionTimeRxEButton;
@property (nonatomic, weak) IBOutlet UIButton * postInfusionTimeRxFButton;
@property (weak, nonatomic) IBOutlet UIButton *postInfusionTimeRxGButton;
@property (weak, nonatomic) IBOutlet UIButton *postInfusionTimeRxHButton;

@property (nonatomic, weak) IBOutlet UIButton * weeksBetweenRxAButton;
@property (nonatomic, weak) IBOutlet UIButton * weeksBetweenRxBButton;
@property (nonatomic, weak) IBOutlet UIButton * weeksBetweenRxCButton;
@property (nonatomic, weak) IBOutlet UIButton * weeksBetweenRxDButton;
@property (nonatomic, weak) IBOutlet UIButton * weeksBetweenRxEButton;
@property (nonatomic, weak) IBOutlet UIButton * weeksBetweenRxFButton;
@property (weak, nonatomic) IBOutlet UIButton *weeksBetweenRxGButton;
@property (weak, nonatomic) IBOutlet UIButton *weeksBetweenRxHButton;

@end
