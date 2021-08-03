//
//  IOMParsedVialTrend.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 1/10/18.
//  Copyright © 2018 Local Wisdom Inc. All rights reserved.
//

#import "IOMParsedVialTrend.h"

#define IOMParsedVialTrendHeaderName @"headerName"
#define IOMParsedVialTrendFieldValue @"fieldValue"

@implementation IOMParsedVialTrend

- (instancetype)initWithArray:(NSArray<NSDictionary*>*)array
{
    if (self = [super init]) {
        NSInteger count = 0;
        for (NSDictionary* dictionary in array) {
            NSNumber* value = @([[dictionary objectForKey:IOMParsedVialTrendFieldValue] integerValue]);
            switch (count) {
                case 0:
                    _valueElevenMonthsBefore = value;
                    break;
                case 1:
                    _valueTenMonthsBefore = value;
                    break;
                case 2:
                    _valueNineMonthsBefore = value;
                    break;
                case 3:
                    _valueEightMonthsBefore = value;
                    break;
                case 4:
                    _valueSevenMonthsBefore = value;
                    break;
                case 5:
                    _valueSixMonthsBefore = value;
                    break;
                case 6:
                    _valueFiveMonthsBefore = value;
                    break;
                case 7:
                    _valueFourMonthsBefore = value;
                    break;
                case 8:
                    _valueThreeMonthsBefore = value;
                    break;
                case 9:
                    _valueTwoMonthsBefore = value;
                    break;
                case 10:
                    _valueOneMonthBefore = value;
                    break;
                case 11: {
                    _valueLastDataMonth = value;
                    NSArray<NSString*>* components = [[dictionary objectForKey:IOMParsedVialTrendHeaderName] componentsSeparatedByString:@" - "];
                    if ([components count] >= 2) {
                        NSString* dateString = [components objectAtIndex:1];
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setDateFormat:@"MMM yy"];
                        NSDate* date = [dateFormat dateFromString:dateString];
                        _lastDataMonth = date;
                    }
                    break;
                }
                default:
                    break;
            }

            count++;
        }
    }

    return self;
}

@end
