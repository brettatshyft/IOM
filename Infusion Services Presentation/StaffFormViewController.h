//
//  StaffFormViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/13/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentationFormProtocol.h"
#import "ScenarioForm.h"

@interface StaffFormViewController : UIViewController <PresentationFormProtocol, ScenarioForm, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UIAlertViewDelegate>{
    
}



@end
