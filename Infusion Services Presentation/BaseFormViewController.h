//
//  BaseFormViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Presentation;
@interface BaseFormViewController : UIViewController{

}

@property (strong, nonatomic) NSArray * textFieldArray;

- (void)textFieldDidEndEditing:(UITextField *)textField;
- (void)initKeyboardAccessory;

@end
