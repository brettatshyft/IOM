//
//  Infusion+Extension.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/5/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "RemicadeInfusion.h"

@interface RemicadeInfusion (Extension)

- (int)infusionAdministrationTime;
- (int)infusionMakeTime2HR;
- (int)infusionMakeTime2_5HR;
- (int)infusionMakeTime3HR;
- (int)infusionMakeTime3_5HR;
- (int)infusionMakeTime4HR;
- (int)getTotalTime;
- (int)totalTreatmentDistributionPercentages;
- (BOOL)treatmentDistributionPercentagesAre100Percent;
- (int)numberPerMonth:(int)numberPerMonth byPercentage:(int)percentage;

+ (RemicadeInfusion*)getRemicadeInfusionForScenario:(Scenario*)scenario;
- (RemicadeInfusion*)duplicateRemicadeInfusion;

@end
