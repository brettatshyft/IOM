//
//  Presentation+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/5/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "Presentation+Extension.h"
#import "PayerMix+Extension.h"
#import "Reimbursement+Extension.h"
#import "VialTrend+Extension.h"
#import "Utilization+Extension.h"
#import "Scenario+Extension.h"
#import "SolutionData+Extension.h"
#import "StelaraInfusion+CoreDataClass.h"
#import "SimponiAriaInfusion.h"

NSString * const IOMPresentationSectionsIncludedTypeToString[] = {
    [PresentationSectionsIncludedTypeInfusionServicesAndInfusionOptimization] = @"infusion_services_and_infusion_optimization",
    [PresentationSectionsIncludedTypeInfusionServices] = @"infusion_services",
    [PresentationSectionsIncludedTypeInfusionOptimization] = @"infusion_optimization"
};

@implementation Presentation (Extension)

- (NSString*)presentationTitle
{
    NSMutableString* string = [NSMutableString new];

    if ([self includeSimponiAria]) {
        [string appendString:@"SIMPONI ARIA® (golimumab)"];

        if ([self includeStelara]) {
            [string appendString:@", "];
        } else {
            [string appendString:@" and "];
        }
    }

    [string appendString:@"REMICADE® (infliximab)"];

    if ([self includeStelara]) {
        if ([self includeSimponiAria]) {
            [string appendString:@", and "];
        } else {
            [string appendString:@" and "];
        }

        [string appendString:@"STELARA® (ustekinumab)"];
    }

    [string appendString:@" Infusion Services Review"];

    return [string copy];
}

- (NSArray<NSString*>*)drugTitlesForPresentationType
{
    return [Presentation drugTitlesForPresentationType:[self presentationType]];
}

+(NSArray<NSString*>*) drugTitlesForPresentationType:(PresentationType)type
{
    switch (type) {
        case PresentationTypeRAIOI: {
            // no stelara
            return @[@"SIMPONI ARIA® (golimumab)", @"REMICADE® (infliximab)"];
            break;
        }
        case PresentationTypeGIIOI: {
            // no simponi
            return @[@"REMICADE® (infliximab)", @"STELARA® 130 mg (ustekinumab)"];
            break;
        }
        case PresentationTypeDermIOI: {
            // only remicade
            return @[@"REMICADE® (infliximab)"];
            break;
        }
        case PresentationTypeHOPD:
        case PresentationTypeMixedIOI:
        case PresentationTypeOther:
        default: {
            return @[@"SIMPONI ARIA® (golimumab)", @"REMICADE® (infliximab)", @"STELARA® 130 mg (ustekinumab)"];
            break;
        }
    }

    return @[];
}

- (BOOL)includeStelara
{
    NSNumber* presentationType = self.presentationTypeID;
    return [Presentation includeStelaraForPresentationTypeID:presentationType];
}

+(BOOL)includeStelaraForPresentationTypeID:(NSNumber*)presentationType
{
    if(!presentationType || (id)presentationType == [NSNull null]) {
        return NO;
    }
    if([presentationType integerValue] == PresentationTypeRAIOI || [presentationType integerValue] == PresentationTypeDermIOI) {
        return NO;

    }
    return YES;
}

- (BOOL)includeSimponiAria
{
    NSNumber* presentationType = self.presentationTypeID;
    return [Presentation includeSimponiAriaForPresentationTypeID:presentationType];
}

+ (BOOL)includeSimponiAriaForPresentationTypeID:(NSNumber *)presentationType
{
    if(!presentationType || (id)presentationType == [NSNull null]) return NO;
    if([presentationType integerValue] == PresentationTypeGIIOI || [presentationType integerValue] == PresentationTypeDermIOI) return NO;
    return YES;
}

- (PresentationType)presentationType
{
    NSNumber* presentationType = self.presentationTypeID;
    if(!presentationType || (id)presentationType == [NSNull null]) {
        return PresentationTypeUnassigned;
    }

    PresentationType type = (PresentationType)presentationType.integerValue;
    return type;
}

- (void)updateScenariosForPresentationType
{
    switch ([self presentationType]) {
        case PresentationTypeRAIOI: {
            // no stelara
            for (Scenario* scenario in self.scenarios.allObjects) {
                StelaraInfusion* stelaraInfusion;
                if ((stelaraInfusion = scenario.stelaraInfusion)) {
                    [self.managedObjectContext deleteObject:stelaraInfusion];
                    scenario.stelaraInfusion = nil;
                }
            }
            break;
        }
        case PresentationTypeGIIOI: {
            // no simponi
            for (Scenario* scenario in self.scenarios.allObjects) {
                SimponiAriaInfusion* simponiInfusion;
                if ((simponiInfusion = scenario.simponiAriaInfusion)) {
                    [self.managedObjectContext deleteObject:simponiInfusion];
                    scenario.simponiAriaInfusion = nil;
                }
            }
            break;
        }
        case PresentationTypeDermIOI: {
            // only remicade
            for (Scenario* scenario in self.scenarios.allObjects) {
                SimponiAriaInfusion* simponiInfusion;
                if ((simponiInfusion = scenario.simponiAriaInfusion)) {
                    [self.managedObjectContext deleteObject:simponiInfusion];
                    scenario.simponiAriaInfusion = nil;
                }

                StelaraInfusion* stelaraInfusion;
                if ((stelaraInfusion = scenario.stelaraInfusion)) {
                    [self.managedObjectContext deleteObject:stelaraInfusion];
                    scenario.stelaraInfusion = nil;
                }
            }
            break;
        }
        case PresentationTypeHOPD:
        case PresentationTypeMixedIOI:
        case PresentationTypeOther:
        default: {
            break;
        }
    }
}

- (BOOL)includeInfusionServicesSection
{
    if(!self.presentationsIncluded || (id)self.presentationsIncluded == [NSNull null]) return YES;
    
    IOMPresentationSectionsIncludedType type = [self.presentationsIncluded integerValue];
    switch (type) {
        case PresentationSectionsIncludedTypeInfusionServices:
        case PresentationSectionsIncludedTypeInfusionServicesAndInfusionOptimization:
            return YES;
            break;
            
        default:
            return NO;
    }
}

- (BOOL)includeInfusionOptimizationSection
{
    if(!self.presentationsIncluded || (id)self.presentationsIncluded == [NSNull null]) return YES;
    
    IOMPresentationSectionsIncludedType type = [self.presentationsIncluded integerValue];
    switch (type) {
        case PresentationSectionsIncludedTypeInfusionOptimization:
        case PresentationSectionsIncludedTypeInfusionServicesAndInfusionOptimization:
            return YES;
            break;
            
        default:
            return NO;
    }
}

- (BOOL)verifyCompleted
{
    //Check has account name
    if (!self.accountName || (id)self.accountName == [NSNull null]) {
        return NO;
    }
    //Check has presentation type
    if (!self.presentationTypeID || (id)self.presentationTypeID == [NSNull null]) {
        return NO;
    }
    //If Infusion Services, Check geographic area
    NSInteger presentationsIncluded = [self.presentationsIncluded integerValue];
    if(presentationsIncluded == PresentationSectionsIncludedTypeInfusionServices
       || presentationsIncluded == PresentationSectionsIncludedTypeInfusionServicesAndInfusionOptimization) {
        
        if (!self.reimbursement.geographicArea ||
            (id)self.reimbursement.geographicArea == [NSNull null] ||
            [self.reimbursement.geographicArea isEqualToString:@""]) {
            return NO;
        }
        
    }
    //If IOM, check has scenarios
    if(presentationsIncluded == PresentationSectionsIncludedTypeInfusionOptimization
       || presentationsIncluded == PresentationSectionsIncludedTypeInfusionServicesAndInfusionOptimization) {
        
        if ([self.scenarios count] == 0) {
            return NO;
        }
        
    }
    
    return YES;
}

- (NSNumber*)isCompleted
{
    BOOL comp = [self verifyCompleted];
    return [NSNumber numberWithBool:comp];
}

- (NSOperationQueue*)checkAndProcessAllScenarios
{
    NSOperationQueue * operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.name = @"Scenario Processing Queue";
    [operationQueue setMaxConcurrentOperationCount:1];

    for (Scenario* scenario in self.scenarios) {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:scenario
                                                selector:@selector(processSolutionDataIfNeeded)
                                                                                  object:nil];
        [operationQueue addOperation:operation];
    }
    return operationQueue;
}

- (void)checkAndProcessScenario:(int)indexNum
{
    [[self.scenarios.allObjects objectAtIndex:indexNum] processSolutionDataIfNeeded];
}

- (void)flagAllScenariosAsNeedsProcessing
{
    for (Scenario* scenario in self.scenarios) {
        scenario.solutionDataNeedsToBeProcessed = @YES;
    }
}

- (Presentation*)duplicatePresentationWithCopyTag:(BOOL)copyTag
{
    Presentation* newPresentation = [NSEntityDescription insertNewObjectForEntityForName:@"Presentation" inManagedObjectContext:self.managedObjectContext];
    newPresentation.accountID = [self.accountID copy];
    newPresentation.accountID2 = [self.accountID2 copy];
    newPresentation.accountID3 = [self.accountID3 copy];
    newPresentation.accountName = (copyTag) ? [NSString stringWithFormat:@"%@ copy", self.accountName] : [self.accountName copy];
    newPresentation.isCompleted = [self.isCompleted copy];
    newPresentation.patientPopulation = [self.patientPopulation copy];
    newPresentation.presentationDate = [NSDate date];
    newPresentation.presentationsIncluded = [self.presentationsIncluded copy];
    newPresentation.presentationTypeID = [self.presentationTypeID copy];
    
    //Copy payer Mixes
    for (PayerMix* payerMix in self.payerMixes) {
        PayerMix* newPayerMix = [payerMix duplicatePayerMix];
        [newPresentation addPayerMixesObject:newPayerMix];
        [newPayerMix setPresentation:newPresentation];
    }
    
    //reimbursements
    if (self.reimbursement) {
        Reimbursement* newReimbursement = [self.reimbursement duplicateReimbursement];
        [newReimbursement setPresentation:newPresentation];
        [newPresentation setReimbursement:newReimbursement];
    }
    
    //Utilization
    if (self.utilization) {
        Utilization* newUtil = [self.utilization duplicateUtilization];
        [newUtil setPresentation:newPresentation];
        [newPresentation setUtilization:newUtil];
    }
    
    //Vial Trends
    for (VialTrend* vTrend in self.vialTrends) {
        VialTrend* newVial = [vTrend duplicateVialTrend];
        [newVial setPresentation: newPresentation];
        [newPresentation addVialTrendsObject:newVial];
    }
    
    //Scenarios
    for (Scenario* scenario in self.scenarios) {
        Scenario* newScenario = [scenario duplicateScenarioWithCopyTag:NO];
        [newScenario setPresentation:newPresentation];
        [newPresentation addScenariosObject:newScenario];
    }
    
    return newPresentation;
}

@end
