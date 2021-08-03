//
//  GanttChart.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/24/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "GanttChart.h"
#import "GanttBar.h"
#import "Scenario+Extension.h"
#import "SolutionData+Extension.h"
#import "ScenarioWidget+Extension.h"
#import "SolutionWidgetInSchedule+Extension.h"


@interface GanttChart ()
{
    NSDate* _dayStartDate;
    NSDateFormatter* _dateFormatter;
}

@end

@implementation GanttChart

- (id)initWithDay:(int)day scenario:(Scenario*)scenario isFullLoad:(BOOL)isFullLoad
{
    self = [super init];
    if (self != nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"h:mm a"];
        _dayStartDate = [_dateFormatter dateFromString:@"12:00 am"];
        
        _day = day;
        _isFullLoad = isFullLoad;
        [self processGanttChartForScenario:scenario];
    }
    
    return self;
}

- (void)processGanttChartForScenario:(Scenario*)scenario
{
    NSArray* inScheduleWidgets = [scenario getAllSolutionWidgetsInSchedule];
    if([inScheduleWidgets count] == 0) return;
    
    int numberOfChairs = [scenario.chairs count];
    NSMutableArray* ganttBarArray = [NSMutableArray array];
    
    //Filter out full load schedule widgets if not presenting a full load schedule
    NSPredicate * currentLoadPredicate = [NSPredicate predicateWithFormat:@"isFullLoad == %@", [NSNumber numberWithBool:NO]];
    if(!_isFullLoad){
        inScheduleWidgets = [inScheduleWidgets filteredArrayUsingPredicate:currentLoadPredicate];
    }
    
    //Get earliest and latest widgets
    NSComparator comp = ^NSComparisonResult(id obj1, id obj2) {
        SolutionWidgetInSchedule* wid1 = obj1;
        SolutionWidgetInSchedule* wid2 = obj2;
        
        int val1 = ([wid1.scheduleTime intValue] + [wid1.scenarioWidget totalTime]);
        int val2 = ([wid2.scheduleTime intValue] + [wid2.scenarioWidget totalTime]);

        if (val1 < val2) {
            return  NSOrderedAscending;
        } else if (val1 > val2) {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
    };
    
    NSArray *sorted = sorted = [inScheduleWidgets sortedArrayUsingComparator:comp];
    
    SolutionWidgetInSchedule * firstWidget = [sorted objectAtIndex:0];
    SolutionWidgetInSchedule * lastWidget = [sorted objectAtIndex:[sorted count] - 1];
    int widgetEarliestTime = [firstWidget.scheduleTime intValue];
    //Make earliest time a whole hour
    widgetEarliestTime = widgetEarliestTime - (widgetEarliestTime % 6);     //6 10-minute periods = 1 hour.
    int widgetLastTime = ([lastWidget.scheduleTime intValue] + [lastWidget.scenarioWidget totalTime]);
    //Make latest time a whole hour
    widgetLastTime = widgetLastTime + (10 - (widgetLastTime % 6));
    NSDate *earliestDate = [_dayStartDate dateByAddingTimeInterval:(widgetEarliestTime * 10 * 60)];
    NSDate *lastDate = [_dayStartDate dateByAddingTimeInterval:(widgetLastTime * 10 * 60)];
    
    
    //Loop over chair count
    for (int m = 0; m < numberOfChairs; m++) {
        NSString* taskName = [NSString stringWithFormat:@"%i", m + 1];  //Chair number + 1, since it is zero based.
        
        //Add blank bars (to be sure all chair fields show, regardless of whether they have actual bars)
        //Start
        GanttBar* startBar = [[GanttBar alloc] init];
        startBar.startDate = earliestDate;
        startBar.endDate = earliestDate;
        //*10 to convert to total minutes, *60 to conver to seconds;
        startBar.taskName = taskName;
        startBar.ganttBarType = GanttBarTypePrepPost;
        //End
        GanttBar* endBar = [[GanttBar alloc] init];
        endBar.startDate = lastDate;
        endBar.endDate = lastDate;
        //*10 to convert to total minutes, *60 to conver to seconds;
        endBar.taskName = taskName;
        endBar.ganttBarType = GanttBarTypePrepPost;
        [ganttBarArray addObjectsFromArray:@[startBar, endBar]];
        
        //Filter widgets for day and chair
        NSPredicate * dayPredicate = [NSPredicate predicateWithFormat:@"scheduleDay = %@", [NSNumber numberWithInt:_day]];
        NSPredicate * machinePredicate = [NSPredicate predicateWithFormat:@"scheduleMachine = %@", [NSNumber numberWithInt:m]];
        NSPredicate * widgetFilterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[dayPredicate, machinePredicate]];
        NSArray* filteredWidgets = [inScheduleWidgets filteredArrayUsingPredicate:widgetFilterPredicate];
        
        //Loop through widgets for this chair on this day
        for (SolutionWidgetInSchedule * widget in filteredWidgets) {
            int widgetStartTime = [widget.scheduleTime intValue]; //number of 10 minute intervals into day this widget starts
            
            //Add Prep
            GanttBar* prepBar = [[GanttBar alloc] init];
            prepBar.startDate = [_dayStartDate dateByAddingTimeInterval:(widgetStartTime * 10 * 60)];
            prepBar.endDate = [prepBar.startDate dateByAddingTimeInterval:([widget.scenarioWidget.prepTime intValue] * 10 * 60)];
            //*10 to convert to total minutes, *60 to conver to seconds;
            prepBar.taskName = taskName;
            prepBar.ganttBarType = [[self class] getPrepPostBarTypeForWidgetType:[widget.widgetType integerValue]];
            
            //Add Make
            GanttBar* makeBar = [[GanttBar alloc] init];
            makeBar.startDate = [prepBar.endDate copy];
            makeBar.endDate = [makeBar.startDate dateByAddingTimeInterval:([widget.scenarioWidget.makeTime intValue] * 10 * 60)];
            //*10 to convert to total minutes, *60 to conver to seconds;
            makeBar.taskName = taskName;
            makeBar.ganttBarType = [[self class] getGanttBarTypeForWidgetType:[widget.widgetType intValue] isFullLoad:[widget.isFullLoad boolValue]];
            
            //Add Post
            GanttBar* postBar = [[GanttBar alloc] init];
            postBar.startDate = [makeBar.endDate copy];
            postBar.endDate = [postBar.startDate dateByAddingTimeInterval:([widget.scenarioWidget.postTime intValue] * 10 * 60)];
            //*10 to convert to total minutes, *60 to conver to seconds;
            postBar.taskName = taskName;
            postBar.ganttBarType = [[self class] getPrepPostBarTypeForWidgetType:[widget.widgetType integerValue]];;
            
            //Add bars
            [ganttBarArray addObjectsFromArray:@[prepBar, makeBar, postBar]];
        }
    }
    
    _ganttBars = [NSArray arrayWithArray:ganttBarArray];
    
    //Set frame height
    _frameHeight = GANTT_PADDING_TOP + (numberOfChairs * GANTT_HEIGHT_CHAIR_ROW) + GANTT_PADDING_BOTTOM;
}

- (NSString*)getNameOfDay
{
    return [[self class] getNameOfDayForDay:_day];
}

- (NSString*)getJavaScriptDataString
{
    NSMutableString* jsString = [NSMutableString string];
    [jsString appendString:@"var data = ["];
    
    //loop over bars
    for (int i = 0; i < [_ganttBars count]; i++) {
        if (i != 0) {
            [jsString appendString:@","];
        }
        GanttBar *bar = _ganttBars[i];
        [jsString appendString:@"{"];
        [jsString appendString:[NSString stringWithFormat:@"\"startDate\":new Date(%lli),", [@(floor([bar.startDate timeIntervalSince1970] * 1000)) longLongValue]]];
        [jsString appendString:[NSString stringWithFormat:@"\"endDate\":new Date(%lli),", [@(floor([bar.endDate timeIntervalSince1970] * 1000)) longLongValue]]];
        [jsString appendString:[NSString stringWithFormat:@"\"taskName\":\"%@\",", bar.taskName]];
        [jsString appendString:[NSString stringWithFormat:@"\"status\":\"%@\"", [bar getStatusString]]];
        [jsString appendString:@"}"];
    }
    
    [jsString appendString:@"];"];
    
    return [NSString stringWithString:jsString];
}

+ (GanttBarType)getGanttBarTypeForWidgetType:(WidgetType)widgetType isFullLoad:(BOOL)isFullLoad
{
    switch (widgetType) {
        case WidgetTypeRemicade2HR:
        case WidgetTypeRemicade2_5HR:
        case WidgetTypeRemicade3HR:
        case WidgetTypeRemicade3_5HR:
        case WidgetTypeRemicade4HR:
            if(isFullLoad) {
                return GanttBarTypeAdditionalRemicade;
            }
            return GanttBarTypeRemicade;
        case WidgetTypeSimponiAria:
            if(isFullLoad) {
                return GanttBarTypeAdditionalSimponi;
            }
            return GanttBarTypeSimponi;
        case WidgetTypeStelara:
            if(isFullLoad) {
                return GanttBarTypeAdditionalStelara;
            }
            return GanttBarTypeStelara;
        case WidgetTypeOtherInfusionRxA:
        case WidgetTypeOtherInfusionRxB:
        case WidgetTypeOtherInfusionRxC:
        case WidgetTypeOtherInfusionRxD:
        case WidgetTypeOtherInfusionRxE:
        case WidgetTypeOtherInfusionRxF:
            return GanttBarTypeOtherIVInfusion;
        case WidgetTypeOtherInjection1:
        case WidgetTypeOtherInjection2:
        case WidgetTypeOtherInjection3:
        case WidgetTypeOtherInjection4:
        case WidgetTypeOtherInjection5:
            return GanttBarTypeSubcutaneous;
        default:
            //SHOULD NEVER GET HERE
            return GanttBarTypeAdditionalRemicade;
    }
}

+ (GanttBarType)getPrepPostBarTypeForWidgetType:(WidgetType)widgetType
{
    switch (widgetType) {
        case WidgetTypeOtherInjection1:
        case WidgetTypeOtherInjection2:
        case WidgetTypeOtherInjection3:
        case WidgetTypeOtherInjection4:
        case WidgetTypeOtherInjection5:
            return GanttBarTypeSubcutaneous;
        default:
            return GanttBarTypePrepPost;
    }
}

+ (NSString*)getNameOfDayForDay:(int)day
{
    switch (day) {
        case 0:
            return @"Sunday";
        case 1:
            return @"Monday";
        case 2:
            return @"Tuesday";
        case 3:
            return @"Wednesday";
        case 4:
            return @"Thursday";
        case 5:
            return @"Friday";
        case 6:
            return @"Saturday";
    }
    
    return @"";
}

@end
