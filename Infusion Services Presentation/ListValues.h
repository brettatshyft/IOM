//
//  ListValues.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/6/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//
//  Purpose: To define number values for list options throughout application.
//

#ifndef Infusion_Services_Presentation_ListValues_h
#define Infusion_Services_Presentation_ListValues_h

//Array of selection times for remicade infusions
#define LIST_VALUES_ARRAY_REM_PREP_TIME @[@1, @2, @3, @4, @5]
#define LIST_VALUES_ARRAY_REM_POST_TIME @[@1, @2, @3, @4, @5]

//Array of selection times for simponi aria infusions
#define LIST_VALUES_ARRAY_SIMPONI_PREP_TIME @[@1, @2, @3, @4, @5]
#define LIST_VALUES_ARRAY_SIMPONI_POST_TIME @[@1, @2, @3, @4, @5]
//#define LIST_VALUES_ARRAY_SIMPONI_INFUSION_TIME @[@3, @6, @9, @12, @15, @18, @21, @25, @28, @31]

#define LIST_VALUES_ARRAY_STELARA_PREP_TIME @[@1, @2, @3, @4, @5]
#define LIST_VALUES_ARRAY_STELARA_POST_TIME @[@1, @2, @3, @4, @5]

//Array of other injection frequency
#define LIST_VALUES_ARRAY_INJECTION_FREQUENCY @[@"weekly", @"bi-weekly", @"monthly"]

//#define LIST_VALUES_ARRAY_INJECTION_FREQUENCY_FOR_REPORT @[@"weekly", @"bi-weekly", @"monthly"]

//Array of other infusion selection times
#define LIST_VALUES_ARRAY_RX_PREP_TIME @[@1, @2, @3, @4, @5]
#define LIST_VALUES_ARRAY_RX_INFUSION_TIME @[@3, @6, @9, @12, @15, @18, @24, @30, @36]
#define LIST_VALUES_ARRAY_RX_POST_TIME @[@1, @2, @3, @4, @5]
#define LIST_VALUES_ARRAY_RX_WEEKS_BETWEEN @[@1, @2, @4, @6, @8, @12, @26, @52]
//NOT USED, PREP1 AND PREP2 COMBINED, POST1 AND POST2 COMBINED
//#define LIST_VALUES_ARRAY_RX_PREP2_TIME @[@10, @20, @30, @40, @50, @60]
//#define LIST_VALUES_ARRAY_RX_POST2_TIME @[@10, @20, @30, @40, @50, @60]

//Array of percentages
#define LIST_VALUES_ARRAY_TREATMENT_DURATION_PERCENTAGES @[@0, @5, @10, @15, @20, @25, @30, @35, @40, @45, @50, @55, @60, @65, @70, @75, @80, @85, @90, @95, @100]

//Array for max chairs per HCP
#define LIST_VALUES_ARRAY_MAX_CHAIRS_PER_HCP @[@1, @2, @3, @4, @5]

//Array for number of chairs to add in add menu
#define LIST_VALUES_ARRAY_NUMBER_OF_CHAIRS @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10]

//Array for number of staff to add in add menu
#define LIST_VALUES_ARRAY_NUMBER_OF_QHP_STAFF @[@0, @1, @2, @3, @4, @5]
#define LIST_VALUES_ARRAY_NUMBER_OF_ANC_STAFF @[@0, @1, @2, @3, @4, @5]

//Array for presentation types in Presentation Information Section
#define LIST_VALUES_ARRAY_PRESENTATION_TYPE @[@"Please select a presentation type.", @"RA IOI", @"GI IOI", @"HOPD", @"MIXED IOI", @"DERM IOI", @"OTHER"]

//Array for presentation sections in Presentation Information Section
#define LIST_VALUES_ARRAY_PRESENTATION_SECTIONS @[@"Infusion Services & Infusion Optimization", @"Infusion Services (only)", @"Infusion Optimization (only)"]

//Array for slide object SISI values
#define LIST_VALUES_ARRAY_SLIDE_SISI @[@"NONE", @"REMICADE", @"SIMPONI", @"BOTH", @"STELARA"]


#endif

#import <Foundation/Foundation.h>

@interface ListValues : NSObject

+ (NSDictionary*)listValuesForDictionaryPresentationTypes;
+ (NSDictionary*)listValuesForDictionaryIncludedPresentationTypes;

@end
