//
//  Scenario+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/5/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "Scenario+Extension.h"
#import "Presentation+Extension.h"
#import "Staff+Extension.h"
#import "Chair+Extension.h"
#import "RemicadeInfusion+Extension.h"
#import "SimponiAriaInfusion+Extension.h"
#import "OtherInfusion+Extension.h"
#import "OtherInjection+Extension.h"
#import "ScenarioStaff.h"
#import "ScenarioWidget+Extension.h"
#import "SolutionData+Extension.h"
#import "Constants.h"
#import "MultiDimensionalArray.h"
#import "StelaraInfusion+CoreDataClass.h"

@implementation Scenario (Extension)

- (BOOL)allowsAncillaryStaff
{
    NSPredicate* ancillaryPredicate = [NSPredicate predicateWithFormat:@"staffTypeID == %@", [NSNumber numberWithInt:StaffTypeQHP]];
    NSSet* filteredSet = [self.staff filteredSetUsingPredicate:ancillaryPredicate];
    return filteredSet.count > 0;
}

- (BOOL)allowsStaffBreaks
{
    NSPredicate* breakPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary* bindings)
    {
        if([evaluatedObject objectForKey:@"breakEndTime0"] != nil && [evaluatedObject objectForKey:@"breakEndTime0"] != [NSNull null]) return true;
        else if([evaluatedObject objectForKey:@"breakEndTime1"] != nil && [evaluatedObject objectForKey:@"breakEndTime1"] != [NSNull null]) return true;
        else if([evaluatedObject objectForKey:@"breakEndTime2"] != nil && [evaluatedObject objectForKey:@"breakEndTime2"] != [NSNull null]) return true;
        else if([evaluatedObject objectForKey:@"breakEndTime3"] != nil && [evaluatedObject objectForKey:@"breakEndTime3"] != [NSNull null]) return true;
        else if([evaluatedObject objectForKey:@"breakEndTime4"] != nil && [evaluatedObject objectForKey:@"breakEndTime4"] != [NSNull null]) return true;
        else if([evaluatedObject objectForKey:@"breakEndTime5"] != nil && [evaluatedObject objectForKey:@"breakEndTime5"] != [NSNull null]) return true;
        else if([evaluatedObject objectForKey:@"breakEndTime6"] != nil && [evaluatedObject objectForKey:@"breakEndTime6"] != [NSNull null]) return true;
        else if([evaluatedObject objectForKey:@"breakStartTime0"] != nil && [evaluatedObject objectForKey:@"breakStartTime0"] != [NSNull null]) return true;
        else if([evaluatedObject objectForKey:@"breakStartTime1"] != nil && [evaluatedObject objectForKey:@"breakStartTime1"] != [NSNull null]) return true;
        else if([evaluatedObject objectForKey:@"breakStartTime2"] != nil && [evaluatedObject objectForKey:@"breakStartTime2"] != [NSNull null]) return true;
        else if([evaluatedObject objectForKey:@"breakStartTime3"] != nil && [evaluatedObject objectForKey:@"breakStartTime3"] != [NSNull null]) return true;
        else if([evaluatedObject objectForKey:@"breakStartTime4"] != nil && [evaluatedObject objectForKey:@"breakStartTime4"] != [NSNull null]) return true;
        else if([evaluatedObject objectForKey:@"breakStartTime5"] != nil && [evaluatedObject objectForKey:@"breakStartTime5"] != [NSNull null]) return true;
        else if([evaluatedObject objectForKey:@"breakStartTime6"] != nil && [evaluatedObject objectForKey:@"breakStartTime6"] != [NSNull null]) return true;
        return false;
    }];
    
    NSSet* filteredSet = [self.staff filteredSetUsingPredicate:breakPredicate];
    return filteredSet.count > 0;
}

+ (Scenario*)createScenarioForPresentation:(Presentation*)presentation
{
    Scenario* scenario = [NSEntityDescription insertNewObjectForEntityForName:@"Scenario" inManagedObjectContext:presentation.managedObjectContext];
    
    //Defaults
    scenario.dateCreated = [NSDate date];
    scenario.lastUpdated = [NSDate date];
    scenario.solutionDataNeedsToBeProcessed = @YES;
    
    [scenario setPresentation:presentation];
    [presentation addScenariosObject:scenario];
    return scenario;
}

- (Scenario*)duplicateScenarioWithCopyTag:(BOOL)copyTag
{
    //Create new scenario record
    Scenario* newScenario = [NSEntityDescription insertNewObjectForEntityForName:@"Scenario" inManagedObjectContext:self.managedObjectContext];
    newScenario.dateCreated = [NSDate date];
    newScenario.lastUpdated = [NSDate date];
    newScenario.maxChairsPerStaff = [NSNumber numberWithInt:[self.maxChairsPerStaff intValue]];
    newScenario.solutionDataNeedsToBeProcessed = @YES;
    newScenario.name = (copyTag) ? [NSString stringWithFormat:@"%@ copy", self.name] : [self.name copy];
    
    //Create new chair object for each chair object belonging to scenario
    for (Chair* chair in self.chairs)
    {
        Chair *newChair = [chair duplicateChair];
        [newScenario addChairsObject:newChair];
        [newChair setScenario:newScenario];
    }
    
    //Create new staff object for each staff object belonging to scenario
    for (Staff* staff in self.staff)
    {
        Staff * newStaff = [staff duplicatedStaff];
        [newScenario addStaffObject:newStaff];
        [newStaff setScenario:newScenario];
    }
    
    //Create new remicade infusion object
    if(self.remicadeInfusion)
    {
        RemicadeInfusion* newInfusion = [self.remicadeInfusion duplicateRemicadeInfusion];
        [newScenario setRemicadeInfusion:newInfusion];
        [newInfusion setScenario:newScenario];
    }
    
    //Create new simponi aria object
    if(self.simponiAriaInfusion){
        SimponiAriaInfusion* newSimponiInfusion = [self.simponiAriaInfusion duplicateSimponiAriaInfusion];
        [newScenario setSimponiAriaInfusion:newSimponiInfusion];
        [newSimponiInfusion setScenario:newScenario];
    }

    if (self.stelaraInfusion) {
        StelaraInfusion* newStelaraInfusion = [self.stelaraInfusion duplicateStelaraInfusion];
        [newScenario setStelaraInfusion:newStelaraInfusion];
        [newStelaraInfusion setScenario:newScenario];
    }

    //Create new OtherInfusion object for each OtherInfusion object belonging to scenario
    for (OtherInfusion* otherInfusion in self.otherInfusions)
    {
        OtherInfusion* newOtherInfusion = [otherInfusion duplicateOtherInfusion];
        [newScenario addOtherInfusionsObject:newOtherInfusion];
        [newOtherInfusion setScenario:newScenario];
    }
    
    //Create new OtherInjection object for each OtherInjection object belonging to scenario
    for (OtherInjection* otherInjection in self.otherInjections)
    {
        OtherInjection* newOtherInjection = [otherInjection duplicateOtherInjection];
        [newScenario addOtherInjectionsObject:newOtherInjection];
        [newOtherInjection setScenario:newScenario];
    }
    
    return newScenario;
}

- (MultiDimensionalArray*)createScenarioStaffArray
{
    //NSMutableDictionary* scenarioStaffArray = [NSMutableDictionary dictionary];
    MultiDimensionalArray* scenarioStaffArray = [[MultiDimensionalArray alloc] initWithDimensionsX:NUMBER_OF_STAFF_TYPE Y:NUMBER_OF_DAYS Z:NUMBER_OF_TEN_MINUTE_PERIODS_IN_DAY];
    
    for (int i = 0; i < NUMBER_OF_STAFF_TYPE; i++) {
        for (int j = 0; j < NUMBER_OF_DAYS; j++) {
            for (int k = 0; k < NUMBER_OF_TEN_MINUTE_PERIODS_IN_DAY; k++) {
                ScenarioStaff * scenarioStaff = [[ScenarioStaff alloc] init];
                [scenarioStaffArray addObject:scenarioStaff AtX:i Y:j Z:k];
                //[scenarioStaffArray insertObject:scenarioStaff atDimensions:3, i, j, k, nil];
            }
        }
    }
    
    return scenarioStaffArray;
}

//Processes solution data for PDF reports if needs to be processed
- (void)processSolutionDataIfNeeded
{
    if (!self.solutionData || [self.solutionDataNeedsToBeProcessed boolValue]) {
        //Delete old PDF file
        [[self class] deletePDFIfExists:[self getPDFFileName]];
        [SolutionData processSolutionDataForScenario:self];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SOLUTION_DATA_FAILED_PROCESSING_NOTIFICATION object:nil];
        });
    }
}

/*
 *  Returns NSMutableDictionary+MockMultiDimensionalArray which mocks a three-dimensional array of ScenarioStaff Objects
 *  Represents staff availability during 10 minute periods each day, each index of the array has a ScenarioStaff object
 *  [StaffType, Day, Time]
 *  StaffType - (0-1) 0 - QHP, 1 - Ancillary
 *  Day - (0-6) Sun - Sat
 *  Time - (1-143) 144 10 minute periods throughout each day
 */
- (MultiDimensionalArray*)getScenarioStaffArray
{
    //NSMutableDictionary* scenarioStaffArray = [self createScenarioStaffArray];
    MultiDimensionalArray *scenarioStaffArray = [self createScenarioStaffArray];
    
    //iterate over staff input
    for (Staff* staff in [self getAllStaffOrdered]) {
        StaffType staffType = [staff.staffTypeID integerValue];
        //QHP - 0, Ancillary - 1
        int staffTypeIndex = (staffType == StaffTypeQHP) ? 0 : 1;
        
        for (int d = 0; d < NUMBER_OF_DAYS; d++) {
            //Get start period (convert start time to number of minutes and divide by 10)
            //Do same for end time, break start, and break end
            int startTimePeriod = [staff getStartPeriodForDay:d];
            int endTimePeriod = [staff getEndPeriodForDay:d];
            int breakStartTimePeriod = [staff getBreakStartPeriodForDay:d];
            int breakEndTimePeriod = [staff getBreakEndPeriodForDay:d];
            
            //add primary focus and chair limit between work start and end
            int t = startTimePeriod;
            while (t < endTimePeriod) {
                ScenarioStaff *sStaff = [scenarioStaffArray getObjectAtX:staffTypeIndex Y:d Z:t];   //[scenarioStaffArray objectAtDimensions:3, staffTypeIndex, d, t, nil];
                sStaff.primaryFocus++;
                sStaff.chairLimit++;
                t++;
            }
            
            //remove primary focus and chail limit between break start and end
            int tBreak = breakStartTimePeriod;
            while (tBreak < breakEndTimePeriod) {
                ScenarioStaff *sStaff = [scenarioStaffArray getObjectAtX:staffTypeIndex Y:d Z:tBreak];   //[scenarioStaffArray objectAtDimensions:3, staffTypeIndex, d, tBreak, nil];
                sStaff.primaryFocus--;
                sStaff.chairLimit--;
                tBreak++;
            }
        }
    }
    
    /*
    //Test Log
    for (int i = 0; i < NUMBER_OF_STAFF_TYPE; i++) {
        for (int j = 0; j < NUMBER_OF_DAYS; j++) {
            for (int k = 0; k < NUMBER_OF_TEN_MINUTE_PERIODS_IN_DAY; k++) {
                ScenarioStaff *sStaff = [scenarioStaffArray objectAtDimensions:3, i, j, k, nil];
                NSLog(@"[%i,%i,%i] - (%i, %f)", i, j, k, sStaff.primaryFocus, sStaff.chairLimit);
            }
        }
    }
    */
    
    return scenarioStaffArray;
}

/*
 *  Returns an NSMutableDictionary+MockMultiDimensionalArray which mocks a three-dimensional array
 *  Represents machine(chair) availability. If a chair is available at a certain day and time, it will have a @1(NSNumber) at [Day, Time, Machine#]
 *  [Day, Time, Chair]
 *  Day - (0-6) - (Sun - Sat)
 *  Time - (0-143) - 144 10 minute periods in each day
 *  Chair - (0-Number of chairs)
 */
- (MultiDimensionalArray*)getMachineArray
{
    NSArray* chairArray = [self getAllChairsOrdered];
    int maxChairs = [chairArray count];
    
    //NSMutableDictionary* machineArray = [NSMutableDictionary dictionary];
    MultiDimensionalArray *machineArray = [[MultiDimensionalArray alloc] initWithDimensionsX:NUMBER_OF_DAYS Y:NUMBER_OF_TEN_MINUTE_PERIODS_IN_DAY Z:maxChairs];

    for (int chairNum = 0; chairNum < maxChairs; chairNum++) {
        Chair * chair = [chairArray objectAtIndex:chairNum];
        
        for (int d = 0; d < NUMBER_OF_DAYS; d++) {
            int startTimePeriod = [chair getStartPeriodForDay:d];
            int endTimePeriod = [chair getEndPeriodForDay:d];
            
            int t = startTimePeriod;
            while (t < endTimePeriod) {
                [machineArray addObject:@1 AtX:d Y:t Z:chairNum];
                //[machineArray insertObject:@1 atDimensions:3, d, t, chairNum, nil];
                t++;
            }
        }
    }
    
    return machineArray;
}

- (NSArray<SolutionWidgetInSchedule*>*)getAllSolutionWidgetsInSchedule
{
    NSMutableArray* arrayOfSolutionWidgets = [NSMutableArray array];
    for (ScenarioWidget* scenarioWidget in self.solutionData.scenarioWidgets){
        [arrayOfSolutionWidgets addObjectsFromArray:[scenarioWidget.solutionWidgetsInSchedule allObjects]];
    }
    
    NSSortDescriptor* indexSort = [NSSortDescriptor sortDescriptorWithKey:@"indexNum" ascending:YES];
    
    return [arrayOfSolutionWidgets sortedArrayUsingDescriptors:@[indexSort]];
}

- (NSArray*)getAllChairsOrdered
{
    NSSortDescriptor* chairSort = [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES];
    return [[self.chairs allObjects] sortedArrayUsingDescriptors:@[chairSort]];
}

- (NSArray*)getAllStaffOrdered
{
    NSSortDescriptor* staffSort = [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES];
    return [[self.staff allObjects] sortedArrayUsingDescriptors:@[staffSort]];
}

- (NSUInteger)getCountOfStaffForType:(StaffType)staffType
{
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"staffTypeID == %@", [NSNumber numberWithInteger:staffType]];
    NSPredicate *scenarioPredicate = [NSPredicate predicateWithFormat:@"scenario = %@", self];
    NSPredicate *staffSearchPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[typePredicate, scenarioPredicate]];
    NSFetchRequest * staffCountRequest = [NSFetchRequest fetchRequestWithEntityName:@"Staff"];
    [staffCountRequest setPredicate:staffSearchPredicate];
    [staffCountRequest setIncludesPropertyValues:NO];
    [staffCountRequest setIncludesSubentities:NO];
    
    NSError * error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:staffCountRequest error:&error];
    
    if (error){
        NSLog(@"Error fetching staff type count: %@", error);
        return 0;
    }
    
    return count;
}

- (int)getDaysWithAtleastOneChairAvailable
{
    int daysWithAtleastOneChairWithTime = 0;  //Values 0-7. If day has at least one chair with a time > 0, inc
    for (int i = 0 ; i < 7; i++) {
        for (Chair* chair in self.chairs) {
            if ([chair hasHoursOnDay:i]) {
                daysWithAtleastOneChairWithTime++;
                break;
            }
        }
    }
    
    return daysWithAtleastOneChairWithTime;
}

- (NSInteger)totalNumberNewPatientsPerMonth
{
    return @(self.stelaraInfusion.avgNewPatientsPerMonth.integerValue +
    self.remicadeInfusion.avgNewPatientsPerMonthQ6.integerValue +
    self.remicadeInfusion.avgNewPatientsPerMonthQ8.integerValue +
    self.simponiAriaInfusion.avgNewPatientsPerMonth.integerValue).integerValue;
}

- (float)getTotalChairHours
{
    float totalChairHours = 0;
    for (int i = 0; i < 7; i++) {
        totalChairHours += [self getTotalChairHoursForDay:i];
    }
    
    return totalChairHours;
}

- (float)getTotalChairHoursForDay:(int)day
{
    //day is 0-6
    if(day < 0 || day > 6) return 0;
    
    
    float totalChairHours = 0;
    for (Chair* chair in self.chairs) {
        totalChairHours += [chair getTotalHoursForDay:day];
    }
    
    return totalChairHours;
}

- (float)getTotalStaffHours
{
    float totalStaffHours = 0;
    for (int i = 0; i < 7; i++) {
        totalStaffHours += [self getTotalStaffHoursForDay:i];
    }
    
    return totalStaffHours;
}

- (float)getTotalStaffHoursForDay:(int)day
{
    if (day < 0 || day > 6) return 0;
    
    return [self getTotalStaffHoursForStaffType:StaffTypeQHP onDay:day] + [self getTotalStaffHoursForStaffType:StaffTypeAncillary onDay:day];
}

- (float)getTotalStaffHoursForStaffType:(StaffType)staffType
{
    float totalStaffHours = 0;
    for (int i = 0; i < 7; i++) {
        totalStaffHours += [self getTotalStaffHoursForStaffType:staffType onDay:i];
    }
    
    return totalStaffHours;
}

- (float)getTotalStaffHoursForStaffType:(StaffType)staffType onDay:(int)day
{
    if (day < 0 || day > 6) return 0;
    
    float totalStaffHours = 0;
    for (Staff* staff in self.staff) {
        if([staff.staffTypeID integerValue] == staffType){
            totalStaffHours += [staff getTotalHoursForDay:day];
        }
    }
    
    return totalStaffHours;
}

- (float)getStaffFTE
{
    float staffHours = [self getTotalStaffHours];
    
    return staffHours/40.0f;    //40 hours per week per employee
}

- (float)getStaffFTEForDay:(int)day
{
    if (day < 0 || day > 6) return 0;
    
    float staffHours = [self getTotalStaffHoursForDay:day];
    
    return staffHours/8.0f; //8 hours in normal work day
}

- (float)getStaffFTEForStaffType:(StaffType)staffType
{
    float staffHours = [self getTotalStaffHoursForStaffType:staffType];
    
    return staffHours/40.0f;    //40 hours per week per employee
}

- (float)getStaffFTEForStaffType:(StaffType)staffType onDay:(int)day
{
    if (day < 0 || day > 6) return 0;
    
    float staffHours = [self getTotalStaffHoursForStaffType:staffType onDay:day];
    
    return staffHours/8.0f; //8 hours in normal work day
}


 - (BOOL)solutionDataIsGenerated
{
    return self.solutionData && (![self.solutionDataNeedsToBeProcessed boolValue]);
}


#pragma mark - PDF Methods
- (BOOL)pdfIsAvailable
{
    if ([self.solutionDataNeedsToBeProcessed boolValue]) {
        return NO;
    } else {
        NSFileManager * fm = [NSFileManager defaultManager];
        
        NSString* path = [self getPDFFilePath];
        if ([fm fileExistsAtPath:path]) {
            return YES;
        }
    }
    
    return NO;
}

//Returns the file name of the scenario PDF
- (NSString*)getPDFFilePrefix
{
    NSUInteger hash = [[[self objectID] URIRepresentation] hash];
    return [NSString stringWithFormat:@"%i", hash];
}

//Returns the file name of the scenario PDF
- (NSString*)getPDFFileName
{
    return [NSString stringWithFormat:@"%@.pdf", [self getPDFFilePrefix]];
}

- (NSString*)getPDFFilePath
{
    return [[self class] getPathForPDFFileName:[self getPDFFileName]];
}

+ (NSString*)getPathForPDFFileName:(NSString*)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return [basePath stringByAppendingPathComponent:filename];
}

+ (void)deletePDFIfExists:(NSString*)filename
{
    NSString* path = [self getPathForPDFFileName:filename];
    
    NSFileManager * fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]) {
        NSError *error = nil;
        if (![fm removeItemAtPath:path error:&error]) {
            NSLog(@"Failed to delete PDF at path: %@. \n Error: %@", path, error);
        }
    }
}

@end
