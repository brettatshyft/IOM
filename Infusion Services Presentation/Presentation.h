//
//  Presentation.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PayerMix, Reimbursement, Scenario, Utilization, VialTrend;

@interface Presentation : NSManagedObject

@property (nonatomic, retain) NSString * accountID;
@property (nonatomic, retain) NSString * accountID2;
@property (nonatomic, retain) NSString * accountID3;
@property (nonatomic, retain) NSString * accountName;
@property (nonatomic, retain) NSNumber * isCompleted;
@property (nonatomic, retain) NSNumber * timeToCapacityReport;
@property (nonatomic, retain) NSNumber * patientPopulation;
@property (nonatomic, retain) NSDate * presentationDate;
@property (nonatomic, retain) NSNumber * presentationsIncluded;
@property (nonatomic, retain) NSNumber * presentationTypeID;
@property (nonatomic, retain) NSSet *payerMixes;
@property (nonatomic, retain) Reimbursement *reimbursement;
@property (nonatomic, retain) NSSet *scenarios;
@property (nonatomic, retain) Utilization *utilization;
@property (nonatomic, retain) NSSet *vialTrends;
@end

@interface Presentation (CoreDataGeneratedAccessors)

- (void)addPayerMixesObject:(PayerMix *)value;
- (void)removePayerMixesObject:(PayerMix *)value;
- (void)addPayerMixes:(NSSet *)values;
- (void)removePayerMixes:(NSSet *)values;

- (void)addScenariosObject:(Scenario *)value;
- (void)removeScenariosObject:(Scenario *)value;
- (void)addScenarios:(NSSet *)values;
- (void)removeScenarios:(NSSet *)values;

- (void)addVialTrendsObject:(VialTrend *)value;
- (void)removeVialTrendsObject:(VialTrend *)value;
- (void)addVialTrends:(NSSet *)values;
- (void)removeVialTrends:(NSSet *)values;

@end
