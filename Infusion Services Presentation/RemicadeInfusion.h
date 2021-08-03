//
//  RemicadeInfusion.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/24/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Scenario;

@interface RemicadeInfusion : NSManagedObject

@property (nonatomic, retain) NSNumber * avgInfusionsPerMonth;
@property (nonatomic, retain) NSNumber * avgNewPatientsPerMonthQ6; // 6 weeks inbetween drugs
@property (nonatomic, retain) NSNumber * avgNewPatientsPerMonthQ8; // 6 weeks inbetween infusions
@property (nonatomic, retain) NSNumber * percent2_5hr;
@property (nonatomic, retain) NSNumber * percent2hr;
@property (nonatomic, retain) NSNumber * percent3_5hr;
@property (nonatomic, retain) NSNumber * percent3hr;
@property (nonatomic, retain) NSNumber * percent4hr;
@property (nonatomic, retain) NSNumber * postAncillary;
@property (nonatomic, retain) NSNumber * postTime;
@property (nonatomic, retain) NSNumber * prepAncillary;
@property (nonatomic, retain) NSNumber * prepTime;
@property (nonatomic, retain) Scenario *scenario;

@end
