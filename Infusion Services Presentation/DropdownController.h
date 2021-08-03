//
//  DropdownController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/16/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownDelegate.h"

@class DropdownDataSource;
@interface DropdownController : UITableViewController

@property (nonatomic, strong) DropdownDataSource* dataSource;
@property (nonatomic, weak) id<DropdownDelegate> delegate;

+ (UIPopoverController*)dropdownPopoverControllerForDropdownDataSource:(DropdownDataSource*)dataSource withDelegate:(id<DropdownDelegate>)delegate;
+ (UIPopoverController*)dropdownPopoverControllerForDropdownDataSource:(DropdownDataSource*)dataSource withDelegate:(id<DropdownDelegate>)delegate andContentSize:(CGSize)contentSize;

@end
