//
//  Staff+Extension.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/5/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "Staff.h"

typedef NS_ENUM(NSInteger, StaffType){
    StaffTypeQHP = 0,
    StaffTypeAncillary = 1
};

@interface Staff (Extension)

+ (Staff*)createStaffEntityForScenario:(Scenario*)scenario;
- (Staff*)duplicatedStaff;
- (double)getTotalHoursForDay:(int)day;

- (int)getStartPeriodForDay:(int)day;
- (int)getEndPeriodForDay:(int)day;
- (int)getBreakStartPeriodForDay:(int)day;
- (int)getBreakEndPeriodForDay:(int)day;

@end
