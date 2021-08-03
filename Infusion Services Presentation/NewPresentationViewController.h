//
//  NewPresentationViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOMBackupManager.h"

@class Presentation;
@interface NewPresentationViewController : UIViewController <UIAlertViewDelegate, UIGestureRecognizerDelegate, IOMBackupManagerDelegate>{
    
}

@property (nonatomic, strong) Presentation* presentation;
@property (nonatomic) BOOL hideCancelButton;

@end
