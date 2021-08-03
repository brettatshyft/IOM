//
//  SolutionScheduleItem.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/10/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SolutionData+Extension.h"
#import "Staff+Extension.h"

typedef NS_ENUM(NSInteger, PhaseType){
    PhaseTypeUnassigned,
    PhaseTypePrep,
    PhaseTypeMake,
    PhaseTypePost
};

@interface SolutionScheduleItem : NSObject

@property (nonatomic) WidgetType widgetType;
@property (nonatomic) int widgetIndex;
@property (nonatomic) StaffType staffType;
@property (nonatomic) PhaseType phaseType;
@property (nonatomic) float makeStaffAttention;
@property (nonatomic) BOOL isFullLoad;

- (id)init;

@end
