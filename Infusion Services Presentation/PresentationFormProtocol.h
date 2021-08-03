//
//  PresentationFormProtocol.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/2/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//
//  Purpose: Common interface for presentation editing forms.

#import <Foundation/Foundation.h>

@class Presentation;
@protocol PresentationFormProtocol <NSObject>

//Reference to presentation core data managed object
@property (nonatomic, strong) Presentation* presentation;

//Function to call to check if input data from forms is valid and can be saved
- (BOOL)isInputDataValid;
//Function to call before saving the presentation; to assign changes to object
- (void)willSavePresentation;
//Function to jump to location of an error
- (void)showError;


@end
