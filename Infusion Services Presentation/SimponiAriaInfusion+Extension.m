//
//  SimponiAriaInfusion+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "SimponiAriaInfusion+Extension.h"
#import "Scenario+Extension.h"
#import "Constants.h"

@implementation SimponiAriaInfusion (Extension)

- (int)getTotalTime
{
    return [self.prepTime intValue] + [self.postTime intValue] + [self.infusionAdminTime intValue];
}

+ (SimponiAriaInfusion*)getSimponiAriaInfusionForScenario:(Scenario *)scenario
{
    if(!scenario.simponiAriaInfusion){
        SimponiAriaInfusion* infusion = [NSEntityDescription insertNewObjectForEntityForName:@"SimponiAriaInfusion" inManagedObjectContext:scenario.managedObjectContext];
        
        //default values
        [self setDefaultValuesOnSimponiAriaInfusion:infusion];
        
        [scenario setSimponiAriaInfusion:infusion];
        [infusion setScenario:scenario];
    }
    
    return scenario.simponiAriaInfusion;
}

- (SimponiAriaInfusion*)duplicateSimponiAriaInfusion
{
    SimponiAriaInfusion* newInfusion = [NSEntityDescription insertNewObjectForEntityForName:@"SimponiAriaInfusion" inManagedObjectContext:self.managedObjectContext];
    
    newInfusion.avgInfusionsPerMonth = [self.avgInfusionsPerMonth copy];
    newInfusion.avgNewPatientsPerMonth = [self.avgNewPatientsPerMonth copy];
    newInfusion.prepTime = [self.prepTime copy];
    newInfusion.infusionAdminTime = [self.infusionAdminTime copy];
    newInfusion.postTime = [self.postTime copy];
    newInfusion.prepAncillary = [self.prepAncillary copy];
    newInfusion.postAncillary = [self.postAncillary copy];
    
    return newInfusion;
}

+ (void)setDefaultValuesOnSimponiAriaInfusion:(SimponiAriaInfusion*)infusion
{
    infusion.avgInfusionsPerMonth = @0;
    infusion.avgNewPatientsPerMonth = @0;
    infusion.prepTime = [NSNumber numberWithInt:DEFAULT_SIMPONI_ARIA_PREP1_TIME + DEFAULT_SIMPONI_ARIA_PREP2_TIME];
    infusion.postTime = [NSNumber numberWithInt:DEFAULT_SIMPONI_ARIA_POST1_TIME + DEFAULT_SIMPONI_ARIA_POST2_TIME];
    infusion.infusionAdminTime = [NSNumber numberWithInt:DEFAULT_SIMPONI_ARIA_INFUSION_MAKE_TIME];
    infusion.prepAncillary = @NO;
    infusion.postAncillary = @NO;
}

@end
