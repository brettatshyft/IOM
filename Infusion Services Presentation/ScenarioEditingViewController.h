//
//  ScenarioEditingViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/9/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScenarioFormDataSource.h"

@class Presentation, Scenario;
@interface ScenarioEditingViewController : UIViewController <ScenarioFormDataSource, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) Presentation* presentation;
@property (nonatomic, strong) Scenario* scenario;

@end
