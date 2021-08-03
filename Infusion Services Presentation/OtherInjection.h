//
//  OtherInjection.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Scenario;

@interface OtherInjection : NSManagedObject

@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSNumber * otherInjectionTypeID;
@property (nonatomic, retain) NSNumber * treatmentsPerMonth;
@property (nonatomic, retain) NSString * frequency;
@property (nonatomic, retain) NSNumber * treatments;
@property (nonatomic, retain) Scenario * scenario;

@end
