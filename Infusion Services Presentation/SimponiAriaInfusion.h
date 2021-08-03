//
//  SimponiAriaInfusion.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Scenario;

@interface SimponiAriaInfusion : NSManagedObject

@property (nonatomic, retain) NSNumber * avgInfusionsPerMonth;
@property (nonatomic, retain) NSNumber * avgNewPatientsPerMonth;
@property (nonatomic, retain) NSNumber * prepTime;
@property (nonatomic, retain) NSNumber * infusionAdminTime;
@property (nonatomic, retain) NSNumber * postTime;
@property (nonatomic, retain) NSNumber * prepAncillary;
@property (nonatomic, retain) NSNumber * postAncillary;
@property (nonatomic, retain) Scenario *scenario;

@end
