//
//  InfusionServicesViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentationFormProtocol.h"

@interface InfusionServicesViewController : UIViewController <PresentationFormProtocol> {
    
}

@property (nonatomic, weak) IBOutlet UIButton * vialTrendButton;
@property (nonatomic, weak) IBOutlet UIButton * reimbursementButton;
@property (nonatomic, weak) IBOutlet UIButton * payerMixButton;

- (void)updateVialTrends;
- (void)toggleButtonSelected:(id)sender;

@end
