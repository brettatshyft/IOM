//
//  PresentationViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownDelegate.h"

@class Presentation;
@interface PresentationViewController : UIViewController <UIGestureRecognizerDelegate, UIPopoverControllerDelegate, DropdownDelegate, UITextFieldDelegate>{
    
}

@property (nonatomic, strong) Presentation* presentation;

@end
