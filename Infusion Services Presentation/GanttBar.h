//
//  GanttBar.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/24/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GanttBarType){
    GanttBarTypePrepPost,
    GanttBarTypeSimponi,
    GanttBarTypeStelara,
    GanttBarTypeRemicade,
    GanttBarTypeSubcutaneous,
    GanttBarTypeAdditionalRemicade,
    GanttBarTypeAdditionalStelara,
    GanttBarTypeAdditionalSimponi,
    GanttBarTypeOtherIVInfusion
};

@interface GanttBar : NSObject

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *taskName;
@property (nonatomic) GanttBarType ganttBarType;

- (NSString*)getStatusString;

@end
