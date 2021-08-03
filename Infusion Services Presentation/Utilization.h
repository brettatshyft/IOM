//
//  Utilization.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Presentation;

@interface Utilization : NSManagedObject

@property (nonatomic, retain) NSNumber * otherIVBiologics;
@property (nonatomic, retain) NSNumber * remicadePatients;
@property (nonatomic, retain) NSNumber * simponiAriaPatients;
@property (nonatomic, retain) NSNumber * subcutaneousPatients;
@property (nonatomic, retain) NSNumber * stelaraPatients;
@property (nonatomic, retain) NSNumber * previous52WeeksIVPatients;
@property (nonatomic, retain) NSNumber * previous52WeeksSubcutaneousPatients;
@property (nonatomic, retain) Presentation *presentation;

@end
