//
//  SolutionStatistics.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/14/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SolutionData;

@interface SolutionStatistics : NSManagedObject

@property (nonatomic, retain) NSNumber * daysWithAtleastOneChairWithTime;
@property (nonatomic, retain) NSNumber * maxChairsPerStaff;
@property (nonatomic, retain) NSNumber * totalChairLimitOfStaffTypeAncillary;
@property (nonatomic, retain) NSNumber * totalChairLimitOfStaffTypeQHP;
@property (nonatomic, retain) NSNumber * totalChairs;
@property (nonatomic, retain) NSNumber * totalChairTime;
@property (nonatomic, retain) NSNumber * totalChairTimeUsedCurrentLoad;
@property (nonatomic, retain) NSNumber * totalChairTimeUsedFullLoad;
@property (nonatomic, retain) NSNumber * totalInfusion;
@property (nonatomic, retain) NSNumber * totalInjection;
@property (nonatomic, retain) NSNumber * totalMakeStaffAttentionUsedOfStaffTypeAncillaryCurrentLoad;
@property (nonatomic, retain) NSNumber * totalMakeStaffAttentionUsedOfStaffTypeAncillaryFullLoad;
@property (nonatomic, retain) NSNumber * totalMakeStaffAttentionUsedOfStaffTypeQHPCurrentLoad;
@property (nonatomic, retain) NSNumber * totalMakeStaffAttentionUsedOfStaffTypeQHPFullLoad;
@property (nonatomic, retain) NSNumber * totalPrimaryFocusOfStaffTypeAncillary;
@property (nonatomic, retain) NSNumber * totalPrimaryFocusOfStaffTypeQHP;
@property (nonatomic, retain) NSNumber * totalPrimaryFocusUsedOfStaffTypeAncillaryCurrentLoad;
@property (nonatomic, retain) NSNumber * totalPrimaryFocusUsedOfStaffTypeAncillaryFullLoad;
@property (nonatomic, retain) NSNumber * totalPrimaryFocusUsedOfStaffTypeQHPCurrentLoad;
@property (nonatomic, retain) NSNumber * totalPrimaryFocusUsedOfStaffTypeQHPFullLoad;
@property (nonatomic, retain) NSNumber * totalRemicadeCurrentLoad;
@property (nonatomic, retain) NSNumber * totalRemicadeFullLoad;
@property (nonatomic, retain) NSNumber * totalSimponiAriaCurrentLoad;
@property (nonatomic, retain) NSNumber * totalSimponiAriaFullLoad;
@property (nonatomic, retain) NSNumber * totalStelaraCurrentLoad;
@property (nonatomic, retain) NSNumber * totalStelaraFullLoad;
@property (nonatomic, retain) SolutionData *solutionData;

@end
