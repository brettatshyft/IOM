//
//  PayerMix+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/14/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "PayerMix+Extension.h"

@implementation PayerMix (Extension)

- (PayerMix*)duplicatePayerMix
{
    PayerMix * newPayerMix = [NSEntityDescription insertNewObjectForEntityForName:@"PayerMix" inManagedObjectContext:self.managedObjectContext];
    
    newPayerMix.order = [self.order copy];
    newPayerMix.payer = [self.payer copy];
    newPayerMix.spp  = [self.spp copy];
    newPayerMix.soc = [self.soc copy];
    
    return newPayerMix;
}

@end
