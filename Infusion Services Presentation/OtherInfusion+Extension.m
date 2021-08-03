//
//  OtherInfusion+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/6/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "OtherInfusion+Extension.h"
#import "Constants.h"
#import "Scenario+Extension.h"

@implementation OtherInfusion (Extension)

+ (OtherInfusion*)getOtherInfusionOfType:(OtherInfusionType)otherInfusionType forScenario:(Scenario*)scenario
{
    OtherInfusion* otherInfusion = nil;
    
    if(scenario && (id)scenario != [NSNull null]){
        NSPredicate* otherInfusionTypePredicate = [NSPredicate predicateWithFormat:@"otherInfusionTypeID == %@", [NSNumber numberWithInteger:otherInfusionType]];
        NSSet* filteredSet = [scenario.otherInfusions filteredSetUsingPredicate:otherInfusionTypePredicate];
        
        if(filteredSet.count > 0)
        {
            //should only be one OtherInfusion per type
            otherInfusion = [[filteredSet allObjects] objectAtIndex:0];
        }
        else
        {
            //Could not find infusion of this type, create one for scenario
            otherInfusion = [NSEntityDescription insertNewObjectForEntityForName:@"OtherInfusion" inManagedObjectContext:scenario.managedObjectContext];
            otherInfusion.otherInfusionTypeID = [NSNumber numberWithInteger:otherInfusionType];
            otherInfusion.displayOrder = [OtherInfusion displayOrderForOtherInfusionType:otherInfusionType];
            
            //Default values
            [OtherInfusion setDefaultValuesForOtherInfusion:otherInfusion];
            
            [scenario addOtherInfusionsObject:otherInfusion];
            [otherInfusion setScenario:scenario];
        }
    }
    
    return otherInfusion;
}

+ (NSNumber*)displayOrderForOtherInfusionType:(OtherInfusionType)otherInfusionType
{
    switch (otherInfusionType) {
        case OtherInfusionTypeRxA:
            return @0;
            break;
        case OtherInfusionTypeRxB:
            return @1;
            break;
        case OtherInfusionTypeRxC:
            return @2;
            break;
        case OtherInfusionTypeRxD:
            return @3;
            break;
        case OtherInfusionTypeRxE:
            return @4;
            break;
        case OtherInfusionTypeRxF:
            return @5;
            break;
        case OtherInfusionTypeRxG:
            return @6;
            break;
        case OtherInfusionTypeRxH:
            return @7;
            break;
        default:
            return @0;
            break;
    }
}

+ (void)setDefaultValuesForOtherInfusion:(OtherInfusion*)otherInfusion
{
    NSNumber* treatmentsPerMonth = @0;
    NSNumber* newPatientsPerMonth = @0;
    NSNumber* preInfusionTime = nil;
    NSNumber* infusionTime = nil;
    NSNumber* postInfusionTime = nil;
    NSNumber* weeksBetween = nil;
    
    switch ([otherInfusion.otherInfusionTypeID integerValue]) {
        case OtherInfusionTypeRxA:
            preInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXA_PREP1_TIME + DEFAULT_RXA_PREP2_TIME)];
            infusionTime = [NSNumber numberWithInt:(DEFAULT_RXA_INFUSION_MAKE_TIME)];
            postInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXA_POST1_TIME + DEFAULT_RXA_POST2_TIME)];
            weeksBetween = [NSNumber numberWithInt:DEFAULT_RXA_WEEKS_BETWEEN];
            break;
        case OtherInfusionTypeRxB:
            preInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXB_PREP1_TIME + DEFAULT_RXB_PREP2_TIME)];
            infusionTime = [NSNumber numberWithInt:(DEFAULT_RXB_INFUSION_MAKE_TIME)];
            postInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXB_POST1_TIME + DEFAULT_RXB_POST2_TIME)];
            weeksBetween = [NSNumber numberWithInt:DEFAULT_RXB_WEEKS_BETWEEN];
            break;
        case OtherInfusionTypeRxC:
            preInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXC_PREP1_TIME + DEFAULT_RXC_PREP2_TIME)];
            infusionTime = [NSNumber numberWithInt:(DEFAULT_RXC_INFUSION_MAKE_TIME)];
            postInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXC_POST1_TIME + DEFAULT_RXC_POST2_TIME)];
            weeksBetween = [NSNumber numberWithInt:DEFAULT_RXC_WEEKS_BETWEEN];
            break;
        case OtherInfusionTypeRxD:
            preInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXD_PREP1_TIME + DEFAULT_RXD_PREP2_TIME)];
            infusionTime = [NSNumber numberWithInt:(DEFAULT_RXD_INFUSION_MAKE_TIME)];
            postInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXD_POST1_TIME + DEFAULT_RXD_POST2_TIME)];
            weeksBetween = [NSNumber numberWithInt:DEFAULT_RXD_WEEKS_BETWEEN];
            break;
        case OtherInfusionTypeRxE:
            preInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXE_PREP1_TIME + DEFAULT_RXE_PREP2_TIME)];
            infusionTime = [NSNumber numberWithInt:(DEFAULT_RXE_INFUSION_MAKE_TIME)];
            postInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXE_POST1_TIME + DEFAULT_RXE_POST2_TIME)];
            weeksBetween = [NSNumber numberWithInt:DEFAULT_RXE_WEEKS_BETWEEN];
            break;
        case OtherInfusionTypeRxF:
            preInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXF_PREP1_TIME + DEFAULT_RXF_PREP2_TIME)];
            infusionTime = [NSNumber numberWithInt:(DEFAULT_RXF_INFUSION_MAKE_TIME)];
            postInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXF_POST1_TIME + DEFAULT_RXF_POST2_TIME)];
            weeksBetween = [NSNumber numberWithInt:DEFAULT_RXF_WEEKS_BETWEEN];
            break;
        case OtherInfusionTypeRxG:
            preInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXG_PREP1_TIME + DEFAULT_RXG_PREP2_TIME)];
            infusionTime = [NSNumber numberWithInt:(DEFAULT_RXG_INFUSION_MAKE_TIME)];
            postInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXG_POST1_TIME + DEFAULT_RXG_POST2_TIME)];
            weeksBetween = [NSNumber numberWithInt:DEFAULT_RXG_WEEKS_BETWEEN];
            break;
        case OtherInfusionTypeRxH:
            preInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXH_PREP1_TIME + DEFAULT_RXH_PREP2_TIME)];
            infusionTime = [NSNumber numberWithInt:(DEFAULT_RXH_INFUSION_MAKE_TIME)];
            postInfusionTime = [NSNumber numberWithInt:(DEFAULT_RXH_POST1_TIME + DEFAULT_RXH_POST2_TIME)];
            weeksBetween = [NSNumber numberWithInt:DEFAULT_RXH_WEEKS_BETWEEN];
            break;
        default:
            break;
    }
    
    otherInfusion.treatmentsPerMonth = treatmentsPerMonth;
    otherInfusion.avgNewPatientsPerMonth = newPatientsPerMonth;
    otherInfusion.prepTime = preInfusionTime;
    otherInfusion.infusionTime = infusionTime;
    otherInfusion.postTime = postInfusionTime;
    otherInfusion.weeksBetween = weeksBetween;
}

- (OtherInfusion*)duplicateOtherInfusion
{
    OtherInfusion* newOtherInfusion = [NSEntityDescription insertNewObjectForEntityForName:@"OtherInfusion" inManagedObjectContext:self.managedObjectContext];
    newOtherInfusion.displayOrder = [self.displayOrder copy];
    newOtherInfusion.infusionTime = [self.infusionTime copy];
    newOtherInfusion.avgNewPatientsPerMonth = [self.avgNewPatientsPerMonth copy];
    newOtherInfusion.otherInfusionTypeID = [self.otherInfusionTypeID copy];
    newOtherInfusion.postTime = [self.postTime copy];
    newOtherInfusion.prepTime = [self.prepTime copy];
    newOtherInfusion.treatmentsPerMonth = [self.treatmentsPerMonth copy];
    newOtherInfusion.weeksBetween = [self.weeksBetween copy];
    
    return newOtherInfusion;
}

- (int)getTotalTime
{
    return [self.prepTime intValue] + [self.infusionTime intValue] + [self.postTime intValue];
}

@end
