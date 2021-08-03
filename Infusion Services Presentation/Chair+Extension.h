//
//  Chair+Extension.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/6/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "Chair.h"

@interface Chair (Extension)

+ (Chair*)createChairEntityForScenario:(Scenario*)scenario;
- (Chair*)duplicateChair;
- (double)getTotalHoursForDay:(int)day;
- (BOOL)hasHoursOnDay:(int)day;
- (int)getStartPeriodForDay:(int)day;
- (int)getEndPeriodForDay:(int)day;

@end
