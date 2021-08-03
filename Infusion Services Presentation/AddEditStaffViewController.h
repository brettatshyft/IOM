//
//  AddEditStaffViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/26/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Scenario;
@interface AddEditStaffViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) UIPopoverController* containingPopover;
@property (nonatomic, strong) Scenario* scenario;
@property (nonatomic, strong) NSArray* staffToEdit;
@property (nonatomic) int currentNumberOfStaff;

//- (void)updateAllDetailLabels;

@end
