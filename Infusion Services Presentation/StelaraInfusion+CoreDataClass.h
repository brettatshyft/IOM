//
//  StelaraInfusion+CoreDataClass.h
//  
//
//  Created by Paul Jones on 11/13/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Scenario;

NS_ASSUME_NONNULL_BEGIN

@interface StelaraInfusion : NSManagedObject

- (StelaraInfusion*)duplicateStelaraInfusion;

@end

NS_ASSUME_NONNULL_END

#import "StelaraInfusion+CoreDataProperties.h"
