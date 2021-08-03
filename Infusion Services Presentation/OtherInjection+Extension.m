//
//  OtherInjection+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/6/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "OtherInjection+Extension.h"
#import "Constants.h"
#import "Scenario+Extension.h"

@implementation OtherInjection (Extension)

+ (OtherInjection*)getOtherInjectionOfType:(OtherInjectionType)otherInjectionType forScenario:(Scenario*)scenario
{
    OtherInjection* otherInjection = nil;
    
    if (scenario && (id)scenario != [NSNull null])
    {
        NSPredicate* injectionTypePredicate = [NSPredicate predicateWithFormat:@"otherInjectionTypeID == %@", [NSNumber numberWithInteger:otherInjectionType]];
        NSSet* filteredSet = [scenario.otherInjections filteredSetUsingPredicate:injectionTypePredicate];
        
        if(filteredSet.count > 0)
        {
            //Should only be one OtherInjection per type
            otherInjection = [[filteredSet allObjects] objectAtIndex:0];
            if (otherInjection.frequency == NULL){
                otherInjection.frequency = @"weekly";
            }
        }
        else
        {
            //Could not find injection of this type, create one for scenario
            otherInjection = [NSEntityDescription insertNewObjectForEntityForName:@"OtherInjection" inManagedObjectContext:scenario.managedObjectContext];
            otherInjection.otherInjectionTypeID = [NSNumber numberWithInteger:otherInjectionType];
            otherInjection.displayOrder = [self displayOrderForOtherInjectionType:otherInjectionType];
            //Default values
            otherInjection.treatmentsPerMonth = @0;
            otherInjection.treatments = @0;
            otherInjection.frequency = @"weekly";
            [scenario addOtherInjectionsObject:otherInjection];
            [otherInjection setScenario:scenario];
        }
    }
    
    return otherInjection;
}

+ (NSNumber*)displayOrderForOtherInjectionType:(OtherInjectionType)otherInjectionType
{
    switch (otherInjectionType) {
        case OtherInjectionType1:
            return @0;
            break;
        case OtherInjectionType2:
            return @1;
            break;
        case OtherInjectionType3:
            return @2;
            break;
        case OtherInjectionType4:
            return @3;
            break;
        case OtherInjectionType5:
            return @4;
            break;
        case OtherInjectionType6:
            return @5;
            break;
        case OtherInjectionType7:
            return @6;
            break;
            
        default:
            return @0;
            break;
    }
}

- (OtherInjection*)duplicateOtherInjection
{
    OtherInjection* newOtherInjection = [NSEntityDescription insertNewObjectForEntityForName:@"OtherInjection" inManagedObjectContext:self.managedObjectContext];
    newOtherInjection.otherInjectionTypeID = [self.otherInjectionTypeID copy];
    newOtherInjection.treatmentsPerMonth = [self.treatmentsPerMonth copy];
    newOtherInjection.displayOrder = [self.displayOrder copy];
    newOtherInjection.frequency = [self.frequency copy];
    newOtherInjection.treatments = [self.treatments copy];
    
    return newOtherInjection;
}

+ (int)getPrepTimeForOtherInjectionType:(OtherInjectionType)otherInjectionType
{
    switch (otherInjectionType) {
        case OtherInjectionType1:
            return (DEFAULT_INJECTION1_PREP1_TIME + DEFAULT_INJECTION1_PREP2_TIME);
        case OtherInjectionType2:
            return (DEFAULT_INJECTION2_PREP1_TIME + DEFAULT_INJECTION2_PREP2_TIME);
        case OtherInjectionType3:
            return (DEFAULT_INJECTION3_PREP1_TIME + DEFAULT_INJECTION3_PREP2_TIME);
        case OtherInjectionType4:
            return (DEFAULT_INJECTION4_PREP1_TIME + DEFAULT_INJECTION4_PREP2_TIME);
        case OtherInjectionType5:
            return (DEFAULT_INJECTION5_PREP1_TIME + DEFAULT_INJECTION5_PREP2_TIME);
        case OtherInjectionType6:
            return (DEFAULT_INJECTION6_PREP1_TIME + DEFAULT_INJECTION6_PREP2_TIME);
        case OtherInjectionType7:
            return (DEFAULT_INJECTION7_PREP1_TIME + DEFAULT_INJECTION7_PREP2_TIME);
        default:
            return 0;
    }
}

+ (int)getPostTimeForOtherInjectionType:(OtherInjectionType)otherInjectionType
{
    switch (otherInjectionType) {
        case OtherInjectionType1:
            return (DEFAULT_INJECTION1_POST1_TIME + DEFAULT_INJECTION1_POST2_TIME);
        case OtherInjectionType2:
            return (DEFAULT_INJECTION2_POST1_TIME + DEFAULT_INJECTION2_POST2_TIME);
        case OtherInjectionType3:
            return (DEFAULT_INJECTION3_POST1_TIME + DEFAULT_INJECTION3_POST2_TIME);
        case OtherInjectionType4:
            return (DEFAULT_INJECTION4_POST1_TIME + DEFAULT_INJECTION4_POST2_TIME);
        case OtherInjectionType5:
            return (DEFAULT_INJECTION5_POST1_TIME + DEFAULT_INJECTION5_POST2_TIME);
        case OtherInjectionType6:
            return (DEFAULT_INJECTION6_POST1_TIME + DEFAULT_INJECTION6_POST2_TIME);
        case OtherInjectionType7:
            return (DEFAULT_INJECTION7_POST1_TIME + DEFAULT_INJECTION7_POST2_TIME);
        default:
            return 0;
    }
}

+ (int)getInfusionTimeForOtherInjectionType:(OtherInjectionType)otherInjectionType
{
    
    switch (otherInjectionType) {
        case OtherInjectionType1:
            return (DEFAULT_INJECTION1_INFUSION_MAKE_TIME);
        case OtherInjectionType2:
            return (DEFAULT_INJECTION2_INFUSION_MAKE_TIME);
        case OtherInjectionType3:
            return (DEFAULT_INJECTION3_INFUSION_MAKE_TIME);
        case OtherInjectionType4:
            return (DEFAULT_INJECTION4_INFUSION_MAKE_TIME);
        case OtherInjectionType5:
            return (DEFAULT_INJECTION5_INFUSION_MAKE_TIME);
        case OtherInjectionType6:
            return (DEFAULT_INJECTION6_INFUSION_MAKE_TIME);
        case OtherInjectionType7:
            return (DEFAULT_INJECTION7_INFUSION_MAKE_TIME);
        default:
            return 0;
    }
}

- (int)getTotalTime
{
    int total = 0;
    switch ([self.otherInjectionTypeID integerValue]) {
        case OtherInjectionType1:
            total = DEFAULT_INJECTION1_PREP1_TIME + DEFAULT_INJECTION1_PREP2_TIME + DEFAULT_INJECTION1_INFUSION_MAKE_TIME + DEFAULT_INJECTION1_POST1_TIME + DEFAULT_INJECTION1_POST2_TIME;
            break;
        case OtherInjectionType2:
            total = DEFAULT_INJECTION2_PREP1_TIME + DEFAULT_INJECTION2_PREP2_TIME + DEFAULT_INJECTION2_INFUSION_MAKE_TIME + DEFAULT_INJECTION2_POST1_TIME + DEFAULT_INJECTION2_POST2_TIME;
            break;
        case OtherInjectionType3:
            total = DEFAULT_INJECTION3_PREP1_TIME + DEFAULT_INJECTION3_PREP2_TIME + DEFAULT_INJECTION3_INFUSION_MAKE_TIME + DEFAULT_INJECTION3_POST1_TIME + DEFAULT_INJECTION3_POST2_TIME;
            break;
        case OtherInjectionType4:
            total = DEFAULT_INJECTION4_PREP1_TIME + DEFAULT_INJECTION4_PREP2_TIME + DEFAULT_INJECTION4_INFUSION_MAKE_TIME + DEFAULT_INJECTION4_POST1_TIME + DEFAULT_INJECTION4_POST2_TIME;
            break;
        case OtherInjectionType5:
            total = DEFAULT_INJECTION5_PREP1_TIME + DEFAULT_INJECTION5_PREP2_TIME + DEFAULT_INJECTION5_INFUSION_MAKE_TIME + DEFAULT_INJECTION5_POST1_TIME + DEFAULT_INJECTION5_POST2_TIME;
            break;
        case OtherInjectionType6:
            total = DEFAULT_INJECTION6_PREP1_TIME + DEFAULT_INJECTION6_PREP2_TIME + DEFAULT_INJECTION6_INFUSION_MAKE_TIME + DEFAULT_INJECTION6_POST1_TIME + DEFAULT_INJECTION6_POST2_TIME;
            break;
        case OtherInjectionType7:
            total = DEFAULT_INJECTION7_PREP1_TIME + DEFAULT_INJECTION7_PREP2_TIME + DEFAULT_INJECTION7_INFUSION_MAKE_TIME + DEFAULT_INJECTION7_POST1_TIME + DEFAULT_INJECTION7_POST2_TIME;
            break;
    }
    
    return total;
}

- (void)calculateTotalTreatmentsPerMonth{
    if ([self.frequency isEqualToString:@"weekly"]){
        self.treatmentsPerMonth = [[NSNumber alloc]initWithDouble:[self.treatments doubleValue] * 4.3];
    }else if ([self.frequency isEqualToString:@"bi-weekly"]){
        self.treatmentsPerMonth = [[NSNumber alloc]initWithDouble:[self.treatments doubleValue] * 2.16];
    }else{
        self.treatmentsPerMonth = self.treatments;
    }
}

@end
