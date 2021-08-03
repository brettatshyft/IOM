//
//  ReimbursementFormViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFormViewController.h"

@interface ReimbursementFormViewController : BaseFormViewController <UITextFieldDelegate>{
    
}

@property (nonatomic) CGFloat reimbursement96413;
@property (nonatomic) CGFloat reimbursement96415;
@property (nonatomic) CGFloat reimbursement96365;
@property (nonatomic, copy) NSString * geographicArea;

@property (nonatomic) NSInteger presentationType;

- (void) showError;

@end
