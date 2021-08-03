//
//  Infusion+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/5/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "RemicadeInfusion+Extension.h"
#import "Constants.h"
#import "Scenario+Extension.h"

@implementation RemicadeInfusion (Extension)

- (int)infusionMakeTime
{
    //Add up default times for rem 3hr
    int totalTime = 0;
    totalTime += DEFAULT_REM3HR_PREP1_TIME;
    totalTime += DEFAULT_REM3HR_PREP2_TIME;
    totalTime += DEFAULT_REM3HR_INFUSION_MAKE_TIME;
    totalTime += DEFAULT_REM3HR_POST1_TIME;
    totalTime += DEFAULT_REM3HR_POST2_TIME;
    
    //Subtract input times
    int makeTime = totalTime - ([self.prepTime intValue] + [self.postTime intValue]);

    return makeTime;
}

- (int)infusionAdministrationTime
{
    return [self infusionMakeTime];
}

- (int)infusionMakeTime2HR
{
    return [self infusionMakeTime] - 6;
}

- (int)infusionMakeTime2_5HR
{
    return [self infusionMakeTime] - 3;
}

- (int)infusionMakeTime3HR
{
    return [self infusionMakeTime];
}

- (int)infusionMakeTime3_5HR
{
    return [self infusionMakeTime] + 3;
}

- (int)infusionMakeTime4HR
{
    return [self infusionMakeTime] + 6;
}

- (int)totalTreatmentDistributionPercentages
{
    return ([self.percent2hr intValue] + [self.percent2_5hr intValue] + [self.percent3hr intValue] + [self.percent3_5hr intValue] + [self.percent4hr intValue]);
}

- (BOOL)treatmentDistributionPercentagesAre100Percent
{
    return ([self.percent2hr intValue] + [self.percent2_5hr intValue] + [self.percent3hr intValue] + [self.percent3_5hr intValue] + [self.percent4hr intValue]) == 100;
}

- (int)numberPerMonth:(int)numberPerMonth byPercentage:(int)percentage
{
    if(numberPerMonth == 0 || percentage == 0) return 0;
    
    float numberPerMonthByType = ((float)numberPerMonth * percentage) / 100.0;
    float rounded = roundf(numberPerMonthByType);
    //NSLog(@"%f rounded = %f", numberPerMonthByType, rounded);
    
    return (int)MAX(1, rounded);
}

- (int)getTotalTime
{
    return [self.prepTime intValue] + [self.postTime intValue] + [self infusionAdministrationTime];
}

+ (RemicadeInfusion*)getRemicadeInfusionForScenario:(Scenario*)scenario
{
    if (scenario && (id)scenario != [NSNull null]) {
        if(!scenario.remicadeInfusion){
            RemicadeInfusion* infusion = [NSEntityDescription insertNewObjectForEntityForName:@"RemicadeInfusion" inManagedObjectContext:scenario.managedObjectContext];
            
            //Set defaults
            [self setDefaultValuesOnRemicadeInfusion:infusion];
            
            [scenario setRemicadeInfusion:infusion];
            [infusion setScenario:scenario];
        }
        
        return scenario.remicadeInfusion;
    }
    
    return nil;
}

- (RemicadeInfusion*)duplicateRemicadeInfusion
{
    RemicadeInfusion* newInfusion = [NSEntityDescription insertNewObjectForEntityForName:@"RemicadeInfusion" inManagedObjectContext:self.managedObjectContext];
    newInfusion.avgInfusionsPerMonth = [self.avgInfusionsPerMonth copy];
    newInfusion.avgNewPatientsPerMonthQ6 = [self.avgNewPatientsPerMonthQ6 copy];
    newInfusion.avgNewPatientsPerMonthQ8 = [self.avgNewPatientsPerMonthQ8 copy];
    newInfusion.percent2_5hr = [self.percent2_5hr copy];
    newInfusion.percent2hr = [self.percent2hr copy];
    newInfusion.percent3_5hr = [self.percent3_5hr copy];
    newInfusion.percent3hr = [self.percent3hr copy];
    newInfusion.percent4hr = [self.percent4hr copy];
    newInfusion.postTime = [self.postTime copy];
    newInfusion.postAncillary = [self.postAncillary copy];
    newInfusion.prepTime = [self.prepTime copy];
    newInfusion.prepAncillary = [self.prepAncillary copy];
    
    return newInfusion;
}

+ (void)setDefaultValuesOnRemicadeInfusion:(RemicadeInfusion*)infusion
{
    infusion.avgInfusionsPerMonth = @0;
    infusion.avgNewPatientsPerMonthQ6 = @0;
    infusion.avgNewPatientsPerMonthQ8 = @0;
    
    infusion.prepTime = [NSNumber numberWithInt:DEFAULT_REM3HR_PREP1_TIME + DEFAULT_REM3HR_PREP2_TIME];
    infusion.postTime = [NSNumber numberWithInt:DEFAULT_REM3HR_POST1_TIME + DEFAULT_REM3HR_POST2_TIME];
    infusion.percent2hr = @0;
    infusion.percent2_5hr = @0;
    infusion.percent3hr = @100;
    infusion.percent3_5hr = @0;
    infusion.percent4hr = @0;
}

@end
