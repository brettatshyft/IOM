//
//  VialTrend+Extension.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/5/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "VialTrend+Extension.h"
#import "Presentation.h"
#import "ListValues.h"
#import "IOMParsedVialTrend.h"
#import "Presentation+Extension.h"

@implementation VialTrend (Extension)

+ (VialTrend*)getVialTrendOfType:(VialTrendType)trendType forPresentation:(Presentation*)presentation
{
    VialTrend* vTrend = nil;
    
    if(presentation && (id)presentation != [NSNull null] && presentation.vialTrends && (id)presentation.vialTrends != [NSNull null])
    {
        NSPredicate* trendPredicate = [NSPredicate predicateWithFormat:@"vialTrendTypeID == %@", [NSNumber numberWithInteger:trendType]];
        NSSet* results = [presentation.vialTrends filteredSetUsingPredicate:trendPredicate];
        if(results.count > 0)
        {
            //There should only be one trend of each type
            vTrend = [[results allObjects] objectAtIndex:0];
        }
        else
        {
            //Create single Vial trend of type and add it to the presentation
            vTrend = [NSEntityDescription insertNewObjectForEntityForName:@"VialTrend" inManagedObjectContext:presentation.managedObjectContext];
            vTrend.vialTrendTypeID = [NSNumber numberWithInteger:trendType];
            [presentation addVialTrendsObject:vTrend];
            vTrend.presentation = presentation;
        }
    }
    
    return vTrend;
}

+ (VialTrend*)getVialTrendFromParsed:(IOMParsedVialTrend*)parsed forPresentation:(Presentation*)presentation
{
    VialTrend* vTrend = nil;

    if(presentation && (id)presentation != [NSNull null] && presentation.vialTrends && (id)presentation.vialTrends != [NSNull null])
    {
        NSPredicate* trendPredicate = [NSPredicate predicateWithFormat:@"vialTrendTypeID == %@", parsed.vialTrendTypeID];
        NSSet* results = [presentation.vialTrends filteredSetUsingPredicate:trendPredicate];
        if(results.count > 0)
        {
            //There should only be one trend of each type
            vTrend = [[results allObjects] objectAtIndex:0];
        }
        else
        {
            //Create single Vial trend of type and add it to the presentation
            vTrend = [NSEntityDescription insertNewObjectForEntityForName:@"VialTrend" inManagedObjectContext:presentation.managedObjectContext];
            vTrend.vialTrendTypeID = parsed.vialTrendTypeID;
            [presentation addVialTrendsObject:vTrend];
            vTrend.presentation = presentation;
        }
    }

    vTrend.lastDataMonth = [parsed.lastDataMonth copy];
    vTrend.vialTrendTypeID = [parsed.vialTrendTypeID copy];
    vTrend.valueOneMonthBefore = [parsed.valueOneMonthBefore copy];
    vTrend.valueTwoMonthsBefore = [parsed.valueTwoMonthsBefore copy];
    vTrend.valueThreeMonthsBefore = [parsed.valueThreeMonthsBefore copy];
    vTrend.valueFourMonthsBefore = [parsed.valueFourMonthsBefore copy];
    vTrend.valueFiveMonthsBefore = [parsed.valueFiveMonthsBefore copy];
    vTrend.valueSixMonthsBefore = [parsed.valueSixMonthsBefore copy];
    vTrend.valueSevenMonthsBefore = [parsed.valueSevenMonthsBefore copy];
    vTrend.valueEightMonthsBefore = [parsed.valueEightMonthsBefore copy];
    vTrend.valueNineMonthsBefore = [parsed.valueNineMonthsBefore copy];
    vTrend.valueTenMonthsBefore = [parsed.valueTenMonthsBefore copy];
    vTrend.valueElevenMonthsBefore = [parsed.valueElevenMonthsBefore copy];
    vTrend.valueLastDataMonth = [parsed.valueLastDataMonth copy];

    return vTrend;
}

- (NSArray<NSNumber*>*)asArray
{
    return @[self.valueElevenMonthsBefore ?: @(0),
             self.valueTenMonthsBefore ?: @(0),
             self.valueNineMonthsBefore ?: @(0),
             self.valueEightMonthsBefore ?: @(0),
             self.valueSevenMonthsBefore ?: @(0),
             self.valueSixMonthsBefore ?: @(0),
             self.valueFiveMonthsBefore ?: @(0),
             self.valueFourMonthsBefore ?: @(0),
             self.valueThreeMonthsBefore ?: @(0),
             self.valueTwoMonthsBefore ?: @(0),
             self.valueOneMonthBefore ?: @(0),
             self.valueLastDataMonth];
}

+ (NSArray<NSNumber*>*)getSummedVialTrendForPresentation:(Presentation*)presentation
{
    NSMutableArray<NSNumber*>* summedVialTrend = [@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)] mutableCopy];
    NSMutableArray<NSNumber*>* trend = [[[VialTrend getVialTrendOfType:VialTrendTypeRemicade forPresentation:presentation] asArray] mutableCopy];
    if(trend){
        int currentIndex = 0;
        for (NSNumber* vial in trend) {
            [summedVialTrend setObject:@(vial.integerValue + summedVialTrend[currentIndex].integerValue) 
                    atIndexedSubscript:currentIndex];
            currentIndex++;
        }
    }
    NSMutableArray<NSNumber*>* trendSim = [[[VialTrend getVialTrendOfType:VialTrendTypeSimponiAria forPresentation:presentation] asArray] mutableCopy];
    if(trendSim && [presentation includeSimponiAria]){
        int currentIndex = 0;
        for (NSNumber* vial in trendSim) {
            [summedVialTrend setObject:@(vial.integerValue + summedVialTrend[currentIndex].integerValue)
                    atIndexedSubscript:currentIndex];
            currentIndex++;
        }
    }
    NSMutableArray<NSNumber*>* trendStelara = [[[VialTrend getVialTrendOfType:VialTrendTypeStelara forPresentation:presentation] asArray] mutableCopy];
    if(trendStelara && [presentation includeStelara]){
        int currentIndex = 0;
        for (NSNumber* vial in trendStelara) {
            [summedVialTrend setObject:@(vial.integerValue + summedVialTrend[currentIndex].integerValue)
                    atIndexedSubscript:currentIndex];
            currentIndex++;
        }
    }

    return summedVialTrend;
}

- (VialTrend*)duplicateVialTrend
{
    VialTrend* newVial = [NSEntityDescription insertNewObjectForEntityForName:@"VialTrend" inManagedObjectContext:self.managedObjectContext];
    
    newVial.lastDataMonth = [self.lastDataMonth copy];
    newVial.vialTrendTypeID = [self.vialTrendTypeID copy];
    newVial.valueLastDataMonth = [self.valueLastDataMonth copy];
    newVial.valueOneMonthBefore = [self.valueOneMonthBefore copy];
    newVial.valueTwoMonthsBefore = [self.valueTwoMonthsBefore copy];
    newVial.valueThreeMonthsBefore = [self.valueThreeMonthsBefore copy];
    newVial.valueFourMonthsBefore = [self.valueFourMonthsBefore copy];
    newVial.valueFiveMonthsBefore = [self.valueFiveMonthsBefore copy];
    newVial.valueSixMonthsBefore = [self.valueSixMonthsBefore copy];
    newVial.valueSevenMonthsBefore = [self.valueSevenMonthsBefore copy];
    newVial.valueEightMonthsBefore = [self.valueEightMonthsBefore copy];
    newVial.valueNineMonthsBefore = [self.valueNineMonthsBefore copy];
    newVial.valueTenMonthsBefore = [self.valueTenMonthsBefore copy];
    newVial.valueElevenMonthsBefore = [self.valueElevenMonthsBefore copy];
    
    return newVial;
}

@end
