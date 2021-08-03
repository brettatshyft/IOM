//
//  StelaraInfusion+CoreDataClass.m
//  
//
//  Created by Paul Jones on 11/13/17.
//
//

#import "StelaraInfusion+CoreDataClass.h"

@implementation StelaraInfusion

- (StelaraInfusion*)duplicateStelaraInfusion
{
    StelaraInfusion* newInfusion = [NSEntityDescription insertNewObjectForEntityForName:@"StelaraInfusion" inManagedObjectContext:self.managedObjectContext];

    newInfusion.avgInfusionsPerMonth = [self.avgInfusionsPerMonth copy];
    newInfusion.avgNewPatientsPerMonth = [self.avgNewPatientsPerMonth copy];
    newInfusion.prepTime = [self.prepTime copy];
    newInfusion.infusionAdminTime = [self.infusionAdminTime copy];
    newInfusion.postTime = [self.postTime copy];
    newInfusion.prepAncillary = [self.prepAncillary copy];
    newInfusion.postAncillary = [self.postAncillary copy];

    return newInfusion;
}

@end
