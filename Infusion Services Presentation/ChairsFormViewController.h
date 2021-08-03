//
//  ChairsViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/10/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentationFormProtocol.h"
#import "ScenarioForm.h"

@protocol ScenarioFormDataSource;
@interface ChairsFormViewController : UITableViewController <PresentationFormProtocol, ScenarioForm, UIPopoverControllerDelegate, UIAlertViewDelegate>{
    
}

@end
