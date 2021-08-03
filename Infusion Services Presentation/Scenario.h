//
//  Scenario.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/14/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Chair, OtherInfusion, OtherInjection, Presentation, RemicadeInfusion, SimponiAriaInfusion, SolutionData, Staff, StelaraInfusion;

@interface Scenario : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSNumber * maxChairsPerStaff;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * solutionDataNeedsToBeProcessed;
@property (nonatomic, retain) NSSet *chairs;
@property (nonatomic, retain) NSSet *otherInfusions;
@property (nonatomic, retain) NSSet *otherInjections;
@property (nonatomic, retain) Presentation *presentation;
@property (nonatomic, retain) RemicadeInfusion *remicadeInfusion;
@property (nonatomic, retain) SimponiAriaInfusion *simponiAriaInfusion;
@property (nonatomic, retain) StelaraInfusion *stelaraInfusion;
@property (nonatomic, retain) SolutionData *solutionData;
@property (nonatomic, retain) NSSet *staff;
@end

@interface Scenario (CoreDataGeneratedAccessors)

- (void)addChairsObject:(Chair *)value;
- (void)removeChairsObject:(Chair *)value;
- (void)addChairs:(NSSet *)values;
- (void)removeChairs:(NSSet *)values;

- (void)addOtherInfusionsObject:(OtherInfusion *)value;
- (void)removeOtherInfusionsObject:(OtherInfusion *)value;
- (void)addOtherInfusions:(NSSet *)values;
- (void)removeOtherInfusions:(NSSet *)values;

- (void)addOtherInjectionsObject:(OtherInjection *)value;
- (void)removeOtherInjectionsObject:(OtherInjection *)value;
- (void)addOtherInjections:(NSSet *)values;
- (void)removeOtherInjections:(NSSet *)values;

- (void)addStaffObject:(Staff *)value;
- (void)removeStaffObject:(Staff *)value;
- (void)addStaff:(NSSet *)values;
- (void)removeStaff:(NSSet *)values;

@end
