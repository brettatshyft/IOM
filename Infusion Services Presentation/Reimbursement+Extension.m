//
//  Reimbursement+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/14/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "Reimbursement+Extension.h"

@implementation Reimbursement (Extension)

- (Reimbursement*)duplicateReimbursement
{
    Reimbursement* newReimbursement = [NSEntityDescription insertNewObjectForEntityForName:@"Reimbursement" inManagedObjectContext:self.managedObjectContext];
    
    newReimbursement.geographicArea = [self.geographicArea copy];
    newReimbursement.reimbursementFor96365 = [self.reimbursementFor96365 copy];
    newReimbursement.reimbursementFor96413 = [self.reimbursementFor96413 copy];
    newReimbursement.reimbursementFor96415 = [self.reimbursementFor96415 copy];
    
    return newReimbursement;
}

@end
