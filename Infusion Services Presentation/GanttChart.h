//
//  GanttChart.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/24/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GANTT_PADDING_TOP 35.0f
#define GANTT_PADDING_BOTTOM 15.0f
#define GANTT_HEIGHT_CHAIR_ROW 60.0f

@class GanttBar, Scenario;
@interface GanttChart : NSObject

@property (nonatomic, readonly) int day;    //Returns the day this gantt chart represents 0-6 Sun-Sat
@property (nonatomic, strong, readonly) NSArray* ganttBars; //Array of gantt bars to be placed in chart
@property (nonatomic, readonly) BOOL isFullLoad;    //true if gantt chart represents the full load IOM Schedule
@property (nonatomic, readonly) CGFloat frameHeight;    //Height of the gantt chart that should be placed

- (id)initWithDay:(int)day scenario:(Scenario*)scenario isFullLoad:(BOOL)isFullLoad;
- (NSString*)getNameOfDay;
- (NSString*)getJavaScriptDataString;

@end
