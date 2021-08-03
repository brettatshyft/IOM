//
//  Penetration.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Presentation;

@interface Penetration : NSManagedObject

@property (nonatomic, retain) NSNumber * totalDiseaseStatePatientPopulation;
@property (nonatomic, retain) Presentation *presentation;

@end
