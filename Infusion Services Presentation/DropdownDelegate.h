//
//  DropdownDelegate.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/16/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DropdownController, DropdownDataSource;
@protocol DropdownDelegate <NSObject>

- (void)dropdown:(DropdownController*)dropdown item:(id)item selectedAtIndex:(NSInteger)index fromDataSource:(DropdownDataSource*)dataSource;

@end
