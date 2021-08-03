//
//  IOMMonthlyData.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 1/10/18.
//  Copyright © 2018 Local Wisdom Inc. All rights reserved.
//

#import "IOMMonthlyData.h"
#import "IOMParsedVialTrend.h"
#import "IOMParsedPatientEstimates.h"

#define IOMMonthlyDataRemicadeVialTrendsKey @"remicadeVialTrends"
#define IOMMonthlyDataStelaraVialTrendsKey @"stelaraVialTrends"
#define IOMMonthlyDataSimponiAriaVialTrendsKey @"simponiAriaVialTrends"
#define IOMMonthlyDataPatientEstimates @"mbpoPatientEstimates"
#define IOMMonthlyDataDataFieldKey @"DataFields"

/*
 VialTrendTypeRemicade = 0,
 VialTrendTypeSimponiAria = 1,
 VialTrendTypeStelara = 2
 */

@implementation IOMMonthlyData

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    BOOL foundSomething = NO;
    if (self = [super init]) {
        NSArray* remicade = (NSArray<NSDictionary*>*)[[dictionary objectForKey:IOMMonthlyDataRemicadeVialTrendsKey] objectForKey:IOMMonthlyDataDataFieldKey];
        NSArray* stelara = (NSArray<NSDictionary*>*)[[dictionary objectForKey:IOMMonthlyDataStelaraVialTrendsKey] objectForKey:IOMMonthlyDataDataFieldKey];
        NSArray* simponi = (NSArray<NSDictionary*>*)[[dictionary objectForKey:IOMMonthlyDataSimponiAriaVialTrendsKey] objectForKey:IOMMonthlyDataDataFieldKey];
        NSArray* patientEstimates = (NSArray<NSDictionary*>*)[[dictionary objectForKey:IOMMonthlyDataPatientEstimates] objectForKey:IOMMonthlyDataDataFieldKey];

        if (patientEstimates.count > 0) {
            _patientEstimates = [[IOMParsedPatientEstimates alloc] initWithArray:patientEstimates];
            foundSomething = YES;
        }

        if (stelara.count > 0) {
            _stelaraVialTrends = [[IOMParsedVialTrend alloc] initWithArray:stelara];
            _stelaraVialTrends.vialTrendTypeID = @2;
//            foundSomething = YES;
        }

        if (simponi.count > 0) {
            _simponiAriaVialTrends = [[IOMParsedVialTrend alloc] initWithArray:simponi];
            _simponiAriaVialTrends.vialTrendTypeID = @1;
//            foundSomething = YES;
        }

        if (remicade.count > 0) {
            _remicadeVialTrends = [[IOMParsedVialTrend alloc] initWithArray:remicade];
            _remicadeVialTrends.vialTrendTypeID = @0;
//            foundSomething = YES;
        }
    }

    if (foundSomething) {
        return self;
    } else {
        return nil;
    }
}

@end
