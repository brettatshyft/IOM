//
//  UtilizationFormViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFormViewController.h"
#import "PresentationFormProtocol.h"

@interface UtilizationFormViewController : BaseFormViewController <UITextFieldDelegate, PresentationFormProtocol>{
    
}
@property (nonatomic) NSInteger patientPopulation;
@property (nonatomic) NSInteger remicadePatients;
@property (nonatomic) NSInteger simponiPatients;
@property (nonatomic) NSInteger stelaraPatients;
@property (nonatomic) NSInteger otherIVBiologics;
@property (nonatomic) NSInteger subcutaneousPatients;
@property (nonatomic) NSNumber* presentationType;

- (NSInteger)getTotalPatients;

@end
