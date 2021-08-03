//
//  VialTrend.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Presentation;

@interface VialTrend : NSManagedObject

@property (nonatomic, retain) NSDate * lastDataMonth;
@property (nonatomic, retain) NSNumber * valueEightMonthsBefore;
@property (nonatomic, retain) NSNumber * valueElevenMonthsBefore;
@property (nonatomic, retain) NSNumber * valueFiveMonthsBefore;
@property (nonatomic, retain) NSNumber * valueFourMonthsBefore;
@property (nonatomic, retain) NSNumber * valueLastDataMonth;
@property (nonatomic, retain) NSNumber * valueNineMonthsBefore;
@property (nonatomic, retain) NSNumber * valueOneMonthBefore;
@property (nonatomic, retain) NSNumber * valueSevenMonthsBefore;
@property (nonatomic, retain) NSNumber * valueSixMonthsBefore;
@property (nonatomic, retain) NSNumber * valueTenMonthsBefore;
@property (nonatomic, retain) NSNumber * valueThreeMonthsBefore;
@property (nonatomic, retain) NSNumber * valueTwoMonthsBefore;
@property (nonatomic, retain) NSNumber * vialTrendTypeID;
@property (nonatomic, retain) Presentation *presentation;

@end
