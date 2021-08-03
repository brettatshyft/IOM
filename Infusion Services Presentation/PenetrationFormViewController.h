//
//  PenetrationFormViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFormViewController.h"

@interface PenetrationFormViewController : BaseFormViewController <UITextFieldDelegate>{
    
}

@property (nonatomic) NSInteger totalDiseaseStatePatientPopulation;
@property (nonatomic) NSInteger totalPatients;

@end
