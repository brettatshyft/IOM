//
//  OtherInfusion.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/5/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Scenario;

@interface OtherInfusion : NSManagedObject

@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSNumber * infusionTime;
@property (nonatomic, retain) NSNumber * avgNewPatientsPerMonth;
@property (nonatomic, retain) NSNumber * otherInfusionTypeID;
@property (nonatomic, retain) NSNumber * postTime;
@property (nonatomic, retain) NSNumber * prepTime;
@property (nonatomic, retain) NSNumber * treatmentsPerMonth;
@property (nonatomic, retain) NSNumber * weeksBetween;
@property (nonatomic, retain) Scenario *scenario;

@end
