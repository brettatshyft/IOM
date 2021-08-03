//
//  SimponiAriaInfusionViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/23/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentationFormProtocol.h"
#import "ScenarioForm.h"
#import "DropdownDelegate.h"
#import "BaseFormViewController.h"
#import "StelaraInfusion+CoreDataClass.h"
#import "StelaraInfusion+CoreDataProperties.h"

@interface StelaraInfusionViewController : BaseFormViewController <PresentationFormProtocol, ScenarioForm, UITextFieldDelegate, DropdownDelegate>

@end
