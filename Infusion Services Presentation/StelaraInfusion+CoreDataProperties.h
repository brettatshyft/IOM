//
//  StelaraInfusion+CoreDataProperties.h
//  
//
//  Created by Paul Jones on 11/13/17.
//
//

#import "StelaraInfusion+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface StelaraInfusion (CoreDataProperties)

+ (NSFetchRequest<StelaraInfusion *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *avgInfusionsPerMonth;
@property (nullable, nonatomic, copy) NSNumber *avgNewPatientsPerMonth;
@property (nullable, nonatomic, copy) NSNumber *infusionAdminTime;
@property (nullable, nonatomic, copy) NSNumber *postAncillary;
@property (nullable, nonatomic, copy) NSNumber *postTime;
@property (nullable, nonatomic, copy) NSNumber *prepAncillary;
@property (nullable, nonatomic, copy) NSNumber *prepTime;
@property (nullable, nonatomic, retain) Scenario *scenario;

+ (StelaraInfusion*)getStelaraInfusionForScenario:(Scenario *)scenario;

- (int)getTotalTime;

@end

NS_ASSUME_NONNULL_END
