//
//  Staff.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Scenario;

@interface Staff : NSManagedObject

@property (nonatomic, retain) NSDate * breakEndTime0;
@property (nonatomic, retain) NSDate * breakEndTime1;
@property (nonatomic, retain) NSDate * breakEndTime2;
@property (nonatomic, retain) NSDate * breakEndTime3;
@property (nonatomic, retain) NSDate * breakEndTime4;
@property (nonatomic, retain) NSDate * breakEndTime5;
@property (nonatomic, retain) NSDate * breakEndTime6;
@property (nonatomic, retain) NSDate * breakStartTime0;
@property (nonatomic, retain) NSDate * breakStartTime1;
@property (nonatomic, retain) NSDate * breakStartTime2;
@property (nonatomic, retain) NSDate * breakStartTime3;
@property (nonatomic, retain) NSDate * breakStartTime4;
@property (nonatomic, retain) NSDate * breakStartTime5;
@property (nonatomic, retain) NSDate * breakStartTime6;
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSNumber * staffTypeID;
@property (nonatomic, retain) NSDate * workEndTime0;
@property (nonatomic, retain) NSDate * workEndTime1;
@property (nonatomic, retain) NSDate * workEndTime2;
@property (nonatomic, retain) NSDate * workEndTime3;
@property (nonatomic, retain) NSDate * workEndTime4;
@property (nonatomic, retain) NSDate * workEndTime5;
@property (nonatomic, retain) NSDate * workEndTime6;
@property (nonatomic, retain) NSDate * workStartTime0;
@property (nonatomic, retain) NSDate * workStartTime1;
@property (nonatomic, retain) NSDate * workStartTime2;
@property (nonatomic, retain) NSDate * workStartTime3;
@property (nonatomic, retain) NSDate * workStartTime4;
@property (nonatomic, retain) NSDate * workStartTime5;
@property (nonatomic, retain) NSDate * workStartTime6;
@property (nonatomic, retain) Scenario *scenario;

@end
