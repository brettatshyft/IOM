//
//  OtherInjection+Extension.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/6/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "OtherInjection.h"

typedef NS_ENUM(NSInteger, OtherInjectionType){
    OtherInjectionType1 = 0,
    OtherInjectionType2 = 1,
    OtherInjectionType3 = 2,
    OtherInjectionType4 = 3,
    OtherInjectionType5 = 4,
    OtherInjectionType6 = 5,
    OtherInjectionType7 = 6
};

@interface OtherInjection (Extension)

+ (OtherInjection*)getOtherInjectionOfType:(OtherInjectionType)otherInjectionType forScenario:(Scenario*)scenario;
- (OtherInjection*)duplicateOtherInjection;
+ (int)getPrepTimeForOtherInjectionType:(OtherInjectionType)otherInjectionType;
+ (int)getPostTimeForOtherInjectionType:(OtherInjectionType)otherInjectionType;
+ (int)getInfusionTimeForOtherInjectionType:(OtherInjectionType)otherInjectionType;
- (int)getTotalTime;
- (void)calculateTotalTreatmentsPerMonth;

@end
