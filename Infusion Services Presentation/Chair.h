//
//  Chair.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Scenario;

@interface Chair : NSManagedObject

@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSDate * endTime0;
@property (nonatomic, retain) NSDate * endTime1;
@property (nonatomic, retain) NSDate * endTime2;
@property (nonatomic, retain) NSDate * endTime3;
@property (nonatomic, retain) NSDate * endTime4;
@property (nonatomic, retain) NSDate * endTime5;
@property (nonatomic, retain) NSDate * endTime6;
@property (nonatomic, retain) NSDate * startTime0;
@property (nonatomic, retain) NSDate * startTime1;
@property (nonatomic, retain) NSDate * startTime2;
@property (nonatomic, retain) NSDate * startTime3;
@property (nonatomic, retain) NSDate * startTime4;
@property (nonatomic, retain) NSDate * startTime5;
@property (nonatomic, retain) NSDate * startTime6;
@property (nonatomic, retain) Scenario *scenario;

@end
