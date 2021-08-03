//
//  StelaraInfusion+CoreDataProperties.m
//  
//
//  Created by Paul Jones on 11/13/17.
//
//

#import "StelaraInfusion+CoreDataProperties.h"
#import "Scenario.h"
#import "Constants.h"

@implementation StelaraInfusion (CoreDataProperties)

+ (NSFetchRequest<StelaraInfusion *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"StelaraInfusion"];
}

+ (StelaraInfusion*)getStelaraInfusionForScenario:(Scenario *)scenario
{
    if(!scenario.stelaraInfusion){
        StelaraInfusion* infusion = [NSEntityDescription insertNewObjectForEntityForName:@"StelaraInfusion" inManagedObjectContext:scenario.managedObjectContext];

        //default values
        [self setDefaultValuesOnStelaraInfusion:infusion];

        [scenario setStelaraInfusion:infusion];
        [infusion setScenario:scenario];
    }

    return scenario.stelaraInfusion;
}

+ (void)setDefaultValuesOnStelaraInfusion:(StelaraInfusion*)infusion
{
    infusion.avgInfusionsPerMonth = @0;
    infusion.avgNewPatientsPerMonth = @0;
    infusion.prepTime = [NSNumber numberWithInt:DEFAULT_STELARA_PREP1_TIME + DEFAULT_STELARA_PREP2_TIME];
    infusion.postTime = [NSNumber numberWithInt:DEFAULT_STELARA_POST1_TIME + DEFAULT_STELARA_POST2_TIME];
    infusion.infusionAdminTime = [NSNumber numberWithInt:DEFAULT_STELARA_INFUSION_MAKE_TIME];
    infusion.prepAncillary = @NO;
    infusion.postAncillary = @NO;
}

- (int)getTotalTime
{
    return [self.prepTime intValue] + [self.postTime intValue] + [self.infusionAdminTime intValue];
}

@dynamic avgInfusionsPerMonth;
@dynamic avgNewPatientsPerMonth;
@dynamic infusionAdminTime;
@dynamic postAncillary;
@dynamic postTime;
@dynamic prepAncillary;
@dynamic prepTime;
@dynamic scenario;

@end
