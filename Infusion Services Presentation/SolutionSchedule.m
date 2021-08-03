//
//  SolutionSchedule.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/13/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "SolutionSchedule.h"
#import "Scenario+Extension.h"
#import "SolutionData+Extension.h"
#import "SolutionWidgetInSchedule+Extension.h"
#import "SolutionStatistics+Extension.h"
#import "ScenarioWidget+Extension.h"
#import "SolutionScheduleItem.h"
#import "ScenarioStaff.h"
#import "Constants.h"
#import "MultiDimensionalArray.h"

@implementation SolutionSchedule

- (id)initWithScenario:(Scenario*)scenario
{
    self = [super init];
    if (self) {
        _scenario = scenario;
        _totalRemicadeInCurrentSchedule = 0;
        _totalRemicadeInFullLoad = 0;
        _totalSimponiAriaInCurrentSchedule = 0;
        _totalSimponiAriaInFullSchedule = 0;
        _totalInfusion = 0;
        _totalInjection = 0;
        _scheduleItems = nil;
        _totalStelaraInCurrentSchedule = 0;
        _totalStelaraInFullSchedule = 0;
        
        [self initializeSolutionScheduleWithScenario:scenario];
    }
    
    return self;
}

- (void)initializeSolutionScheduleWithScenario:(Scenario*)scenario
{
    NSInteger numberOfMachines = [scenario.chairs count];
    
    if (!_scheduleItems) {
        _scheduleItems = [[MultiDimensionalArray alloc] initWithDimensionsX:NUMBER_OF_DAYS Y:NUMBER_OF_TEN_MINUTE_PERIODS_IN_DAY Z:numberOfMachines];
    }
    
    //Create solution schedule items
    for (int x = 0; x < NUMBER_OF_DAYS; x++)
    {
        for (int y = 0; y < NUMBER_OF_TEN_MINUTE_PERIODS_IN_DAY; y++)
        {
            for (int z = 0; z < numberOfMachines; z++)
            {
                SolutionScheduleItem * item = [[SolutionScheduleItem alloc] init];
                [_scheduleItems addObject:item AtX:x Y:y Z:z];
                //[_scheduleItems insertObject:item atDimensions:3, x, y, z, nil];
            }
        }
    }
    
    //Get all solutionWidgetsInShedule for scenario
    NSArray* solutionWidgetsInSchedule = [scenario getAllSolutionWidgetsInSchedule];
    
    for (SolutionWidgetInSchedule* solutionWidgetInSchedule in solutionWidgetsInSchedule) {
        [self addSolutionWidget:solutionWidgetInSchedule];
    }
}

- (void)addSolutionWidget:(SolutionWidgetInSchedule*)solutionWidgetInSchedule
{
    int scheduleDay = [solutionWidgetInSchedule.scheduleDay intValue];
    int scheduleMachine = [solutionWidgetInSchedule.scheduleMachine intValue];
    
    for (int i = 0; i < [solutionWidgetInSchedule.scenarioWidget totalTime]; i++) {
        int scheduleTime = [solutionWidgetInSchedule.scheduleTime intValue] + i;
        
        ScenarioWidget* scenarioWidget = solutionWidgetInSchedule.scenarioWidget;
        
        SolutionScheduleItem * item = [_scheduleItems getObjectAtX:scheduleDay Y:scheduleTime Z:scheduleMachine]; //[_scheduleItems objectAtDimensions:3, scheduleDay, scheduleTime, scheduleMachine, nil];
        
        item.widgetType = [solutionWidgetInSchedule.widgetType integerValue];
        item.widgetIndex = [solutionWidgetInSchedule.indexNum intValue];
        item.makeStaffAttention = [scenarioWidget.makeStaffAttention floatValue];
        item.isFullLoad = [solutionWidgetInSchedule.isFullLoad boolValue];
        
        if (i < [scenarioWidget.prepTime intValue])    //prep
        {
            item.phaseType = PhaseTypePrep;
            item.staffType = [solutionWidgetInSchedule.prepStaffTypeID integerValue];
        }
        else if (i < ([scenarioWidget.prepTime intValue] + [scenarioWidget.makeTime intValue])) //make
        {
            item.phaseType = PhaseTypeMake;
            item.staffType = [solutionWidgetInSchedule.makeStaffTypeID integerValue];
        }
        else if (i < ([scenarioWidget.prepTime intValue] + [scenarioWidget.makeTime intValue] + [scenarioWidget.postTime intValue]))    //post
        {
            item.phaseType = PhaseTypePost;
            item.staffType = [solutionWidgetInSchedule.postStaffTypeID integerValue];
        }
    }
    
    WidgetType widgetType = [solutionWidgetInSchedule.widgetType integerValue];
    if (widgetType == WidgetTypeRemicade2HR || widgetType == WidgetTypeRemicade2_5HR || widgetType == WidgetTypeRemicade3HR || widgetType == WidgetTypeRemicade3_5HR || widgetType == WidgetTypeRemicade4HR) {
        //Remidcade
        _totalRemicadeInFullLoad++;
        if (![solutionWidgetInSchedule.isFullLoad boolValue]) {
            _totalRemicadeInCurrentSchedule++;
        }
    } else if (widgetType == WidgetTypeSimponiAria) {
        _totalSimponiAriaInFullSchedule++;
        if (![solutionWidgetInSchedule.isFullLoad boolValue]) {
            _totalSimponiAriaInCurrentSchedule++;
        }
    } else if (widgetType == WidgetTypeStelara) {
        _totalStelaraInFullSchedule++;
        if (![solutionWidgetInSchedule.isFullLoad boolValue]) {
            _totalStelaraInCurrentSchedule++;
        }
    } else if (widgetType == WidgetTypeOtherInfusionRxA || widgetType == WidgetTypeOtherInfusionRxB || widgetType == WidgetTypeOtherInfusionRxC || widgetType == WidgetTypeOtherInfusionRxD || widgetType == WidgetTypeOtherInfusionRxE || widgetType == WidgetTypeOtherInfusionRxF) {
        //Other infusion
        _totalInfusion++;
    } else if(widgetType == WidgetTypeOtherInjection1 || widgetType == WidgetTypeOtherInjection2 || widgetType == WidgetTypeOtherInjection3 || widgetType == WidgetTypeOtherInjection4 || widgetType == WidgetTypeOtherInjection5) {
        //other injection
        _totalInjection++;
    }
}

- (void)setMachineScheduleInfoForSolutionStatistics:(SolutionStatistics*)solutionStatistics dayStart:(int)dayStart timeStart:(int)timeStart dayStop:(int)dayStop timeStop:(int)timeStop
{
    Scenario* scenario = [[solutionStatistics solutionData] scenario];
    if(!scenario) return;
    
    //NSMutableDictionary* machinesArray = [scenario getMachineArray];
    MultiDimensionalArray *machinesArray = [scenario getMachineArray];
    
    int totalMachineTimeScheduled = 0;
    int totalMachineTimeUsedCurrentLoad = 0;
    int totalMachineTimeUsedFullLoad = 0;
    
    int machinesCount = [scenario.chairs count];
    
    for (int d = dayStart; d <= dayStop; d++)   // d <= because could be looking at a time span on the same day
    {
        int tStart = 0;
        int tStop = 144;
        
        if (d == dayStart)
        {
            tStart = timeStart;
        }
        else if (d == dayStop)
        {
            tStop = timeStop;
        }
        
        
        for (int t = tStart; t < tStop; t++)
        {
            for (int m = 0; m < machinesCount; m++)
            {
                id machineObj = [machinesArray getObjectAtX:d Y:t Z:m]; //[machinesArray objectAtDimensions:3, d,t,m,nil];
                if(machineObj && (id)machineObj != [NSNull null])
                {
                    totalMachineTimeScheduled++;
                    
                    SolutionScheduleItem *scheduleItem = [_scheduleItems getObjectAtX:d Y:t Z:m]; //[_scheduleItems objectAtDimensions:3, d,t,m,nil];
                    //check if scheduleItem was assigned a phase
                    if (scheduleItem.phaseType != PhaseTypeUnassigned)
                    {
                        totalMachineTimeUsedFullLoad++; //always inc full load no matter what
                        if(!scheduleItem.isFullLoad)    //not full load
                        {
                            totalMachineTimeUsedCurrentLoad++;  // int machine time used
                        }
                    }
                }
            }
        }
    }
    
    solutionStatistics.totalChairTime = [NSNumber numberWithInt:totalMachineTimeScheduled];
    solutionStatistics.totalChairTimeUsedCurrentLoad = [NSNumber numberWithInt:totalMachineTimeUsedCurrentLoad];
    solutionStatistics.totalChairTimeUsedFullLoad = [NSNumber numberWithInt:totalMachineTimeUsedFullLoad];
}

- (void)setStaffScheduleInfoForSolutionStatistics:(SolutionStatistics*)solutionStatistics staffType:(StaffType)staffType dayStart:(int)dayStart timeStart:(int)timeStart dayStop:(int)dayStop timeStop:(int)timeStop
{
    Scenario* scenario = [[solutionStatistics solutionData] scenario];
    if(!scenario) return;
    
    //NSMutableDictionary* scenarioStaffArray = [scenario getScenarioStaffArray];
    MultiDimensionalArray *scenarioStaffArray = [scenario getScenarioStaffArray];
    
    int totalPrimaryFocusUsedCurrentPatientLoad = 0;
    int totalPrimaryFocusUsedFullPatientLoad = 0;
    double totalMakeStaffAttentionUsedCurrentPatientLoad = 0;
    double totalMakeStaffAttentionUsedFullPatientLoad = 0;
    int totalPrimaryFocusStaffTypeID = 0;
    int totalChairLimitStaffTypeID = 0;

    for (int d = dayStart; d <= dayStop; d++)   //d <= because could be looking at a time span on the same day
    {
        int tStart = 0;
        int tStop = 144;
        
        if (d == dayStart)
        {
            tStart = timeStart;
        }
        else if (d == dayStop)
        {
            tStop = timeStop;
        }
        
        for (int t = tStart; t < tStop; t++)
        {
            int machinesCount = [scenario.chairs count];
            
            int staffTypeID = (staffType == StaffTypeQHP) ? 0 : 1;
            ScenarioStaff * sStaff = [scenarioStaffArray getObjectAtX:staffTypeID Y:d Z:t];       //[scenarioStaffArray objectAtDimensions:3, staffTypeID, d, t, nil];
            totalPrimaryFocusStaffTypeID += sStaff.primaryFocus;
            totalChairLimitStaffTypeID += sStaff.chairLimit;
            
            for (int m = 0; m < machinesCount; m++)
            {
                SolutionScheduleItem *scheduleItem = [_scheduleItems getObjectAtX:d Y:t Z:m];           //[_scheduleItems objectAtDimensions:3, d,t,m,nil];
                if (scheduleItem.staffType == staffType) {  //staff type matches
                    if(scheduleItem.phaseType != PhaseTypeUnassigned && scheduleItem.phaseType != PhaseTypeMake)
                    {   //primary focus is used on anything except make and unassigned
                        totalPrimaryFocusUsedFullPatientLoad++;
                        //check is full load
                        if (!scheduleItem.isFullLoad)
                        {   //false - inc current load
                            totalPrimaryFocusUsedCurrentPatientLoad++;
                        }
                    }
                    
                    if(scheduleItem.phaseType != PhaseTypeUnassigned)
                    {
                        //add to full load no matter what
                        totalMakeStaffAttentionUsedFullPatientLoad += scheduleItem.makeStaffAttention;
                        //check is full load
                        if(!scheduleItem.isFullLoad)
                        {   //false - inc current load
                            totalMakeStaffAttentionUsedCurrentPatientLoad+= scheduleItem.makeStaffAttention;
                        }
                    }
                }
            }
        }
    }
    
    if (staffType == StaffTypeQHP)
    {
        solutionStatistics.totalPrimaryFocusOfStaffTypeQHP = [NSNumber numberWithInt:totalPrimaryFocusStaffTypeID];
        solutionStatistics.totalPrimaryFocusUsedOfStaffTypeQHPCurrentLoad = [NSNumber numberWithInt:totalPrimaryFocusUsedCurrentPatientLoad];
        solutionStatistics.totalPrimaryFocusUsedOfStaffTypeQHPFullLoad = [NSNumber numberWithInt:totalPrimaryFocusUsedFullPatientLoad];
        
        solutionStatistics.totalMakeStaffAttentionUsedOfStaffTypeQHPCurrentLoad = [NSNumber numberWithDouble:totalMakeStaffAttentionUsedCurrentPatientLoad];
        solutionStatistics.totalMakeStaffAttentionUsedOfStaffTypeQHPFullLoad = [NSNumber numberWithDouble:totalMakeStaffAttentionUsedFullPatientLoad];
        solutionStatistics.totalChairLimitOfStaffTypeQHP = [NSNumber numberWithInt:totalChairLimitStaffTypeID];
    }
    else
    {
        solutionStatistics.totalPrimaryFocusOfStaffTypeAncillary = [NSNumber numberWithInt:totalPrimaryFocusStaffTypeID];
        solutionStatistics.totalPrimaryFocusUsedOfStaffTypeAncillaryCurrentLoad = [NSNumber numberWithInt:totalPrimaryFocusUsedCurrentPatientLoad];
        solutionStatistics.totalPrimaryFocusUsedOfStaffTypeAncillaryFullLoad = [NSNumber numberWithInt:totalPrimaryFocusUsedFullPatientLoad];
        
        solutionStatistics.totalMakeStaffAttentionUsedOfStaffTypeAncillaryCurrentLoad = [NSNumber numberWithDouble:totalMakeStaffAttentionUsedCurrentPatientLoad];
        solutionStatistics.totalMakeStaffAttentionUsedOfStaffTypeAncillaryFullLoad = [NSNumber numberWithDouble:totalMakeStaffAttentionUsedFullPatientLoad];
        solutionStatistics.totalChairLimitOfStaffTypeAncillary = [NSNumber numberWithInt:totalChairLimitStaffTypeID];
    }
}

@end
