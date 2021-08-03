//
//  Scenario+Extension.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/5/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "Scenario.h"
#import "Staff+Extension.h"

@class SolutionWidgetInSchedule;
@class MultiDimensionalArray;
@interface Scenario (Extension)

- (BOOL)allowsAncillaryStaff;
- (BOOL)allowsStaffBreaks;

+ (Scenario*)createScenarioForPresentation:(Presentation*)presentation;
- (Scenario*)duplicateScenarioWithCopyTag:(BOOL)copyTag;
- (void)processSolutionDataIfNeeded;
- (MultiDimensionalArray*)getScenarioStaffArray;
- (MultiDimensionalArray*)getMachineArray;
- (NSArray<SolutionWidgetInSchedule*>*)getAllSolutionWidgetsInSchedule;
- (NSArray*)getAllChairsOrdered;
- (NSArray*)getAllStaffOrdered;
- (NSUInteger)getCountOfStaffForType:(StaffType)staffType;
- (int)getDaysWithAtleastOneChairAvailable;
- (float)getTotalChairHours;
- (float)getTotalChairHoursForDay:(int)day;
- (float)getTotalStaffHours;
- (float)getTotalStaffHoursForDay:(int)day;
- (float)getTotalStaffHoursForStaffType:(StaffType)staffType;
- (float)getTotalStaffHoursForStaffType:(StaffType)staffType onDay:(int)day;
- (float)getStaffFTE;
- (float)getStaffFTEForDay:(int)day;
- (float)getStaffFTEForStaffType:(StaffType)staffType;
- (float)getStaffFTEForStaffType:(StaffType)staffType onDay:(int)day;
- (NSInteger)totalNumberNewPatientsPerMonth;

- (BOOL)solutionDataIsGenerated;

- (BOOL)pdfIsAvailable;
- (NSString*)getPDFFilePrefix;
- (NSString*)getPDFFileName;
- (NSString*)getPDFFilePath;
+ (NSString*)getPathForPDFFileName:(NSString*)filename;
+ (void)deletePDFIfExists:(NSString*)filename;

@end
