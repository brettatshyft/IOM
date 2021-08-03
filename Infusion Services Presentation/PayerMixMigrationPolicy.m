//
//  PayerMixMigrationPolicy.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "PayerMixMigrationPolicy.h"

@implementation PayerMixMigrationPolicy

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError *__autoreleasing *)error
{
    NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:[mapping destinationEntityName] inManagedObjectContext:[manager destinationContext]];
    
    //TODO update spp correctly based on client feedback
    [newObject setValue:[NSNumber numberWithBool:NO] forKey:@"spp"];
    [newObject setValue:[sInstance valueForKey:@"order"] forKey:@"order"];
    [newObject setValue:[sInstance valueForKey:@"payer"] forKey:@"payer"];
    
    [manager associateSourceInstance:sInstance withDestinationInstance:newObject forEntityMapping:mapping];
    
    return YES;
}

@end
