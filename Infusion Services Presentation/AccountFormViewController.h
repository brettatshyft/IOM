//
//  AccountFormViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFormViewController.h"
#import "DropdownDelegate.h"
#import "Presentation+Extension.h"

@interface AccountFormViewController : BaseFormViewController <UITextFieldDelegate, UIPopoverControllerDelegate, DropdownDelegate, UIPickerViewDelegate, UIAlertViewDelegate>{
    
}

@property (nonatomic, copy) NSString* accountNameString;
@property (nonatomic, copy) NSString* accountName2String;
@property (nonatomic, copy) NSString* accountName3String;
@property (nonatomic, copy) NSString* presentationNameString;
@property (nonatomic, copy) NSString* presentationDateString;
@property (nonatomic, copy) NSString* presentationTypeString;
@property (nonatomic, copy) NSString* presentationSectionString;
@property (nonatomic) BOOL timeToCapacityReport;

- (void) showError;

@end
