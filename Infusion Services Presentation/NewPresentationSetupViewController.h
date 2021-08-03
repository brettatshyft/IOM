//
//  NewPresentationSetupViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentationFormProtocol.h"

@class NewPresentationSetupViewController;

@protocol NewPresentationSetupViewControllerDelegate

- (void)newPresentationSetupViewController:(NewPresentationSetupViewController*)newPresentationSetupViewController didSelectToggleButton:(UIButton*)toggleButton;

@end

@interface NewPresentationSetupViewController : UIViewController <PresentationFormProtocol> {
    
}

@property (nonatomic, weak) id<NewPresentationSetupViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIButton * accountButton;
@property (nonatomic, weak) IBOutlet UIButton * utilizationButton;

- (void)updateUtilizationForm;
- (BOOL)currentFormIsAccountForm;
- (void)toggleButtonSelected:(id)sender;

@end
