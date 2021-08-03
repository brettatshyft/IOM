//
//  OtherInfusion+Extension.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/6/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "OtherInfusion.h"

typedef NS_ENUM(NSInteger, OtherInfusionType){
    OtherInfusionTypeRxA = 0,
    OtherInfusionTypeRxB = 1,
    OtherInfusionTypeRxC= 2,
    OtherInfusionTypeRxD = 3,
    OtherInfusionTypeRxE = 4,
    OtherInfusionTypeRxF = 5,
    OtherInfusionTypeRxG = 6,
    OtherInfusionTypeRxH = 7
};

@interface OtherInfusion (Extension)

+ (OtherInfusion*)getOtherInfusionOfType:(OtherInfusionType)otherInfusionType forScenario:(Scenario*)scenario;
- (OtherInfusion*)duplicateOtherInfusion;
- (int)getTotalTime;

@end
