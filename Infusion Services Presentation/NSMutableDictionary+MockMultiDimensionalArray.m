//
//  NSMutableDictionary+MockMultiDimensionalArray.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/7/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "NSMutableDictionary+MockMultiDimensionalArray.h"

@implementation NSMutableDictionary (MockMultiDimensionalArray)

- (void)insertObject:(id)obj atDimensions:(int)dimensions, ...
{
    va_list dimensionList;
    va_start(dimensionList, dimensions);
    NSString* key = [self getKeyForDimension:dimensions withDimensionList:dimensionList];;
    va_end(dimensionList);
    
    //NSLog(@"INSERTING OBJECT: %@", key);
    
    [self setObject:obj forKey:key];
}

- (id)objectAtDimensions:(int)dimensions, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list dimensionList;
    va_start(dimensionList, dimensions);
    NSString* key = [self getKeyForDimension:dimensions withDimensionList:dimensionList];;
    va_end(dimensionList);
    
    //NSLog(@"Getting OBJECT: %@", key);
    
    return [self objectForKey:key];
}

- (void)removeObjectAtDimensions:(int)dimensions, ...  NS_REQUIRES_NIL_TERMINATION
{
    va_list dimensionList;
    va_start(dimensionList, dimensions);
    NSString* key = [self getKeyForDimension:dimensions withDimensionList:dimensionList];;
    va_end(dimensionList);
    
    //NSLog(@"Removing OBJECT: %@", key);
    
    [self removeObjectForKey:key];
}

- (NSString*)getKeyForDimension:(int)numberOfDimensions withDimensionList:(va_list)dimensionList
{
    //First val is number of dimensions
    NSMutableString* key = [NSMutableString stringWithFormat:@""];
    
    for (int i = 0; i < numberOfDimensions; i++) {
        @autoreleasepool {
            int dimensionNum = va_arg(dimensionList, int);
            if (i != 0) {
                [key appendString:@"-"];
            }
            NSString* dimenString = [NSString stringWithFormat:@"%@", [[NSNumber numberWithInt:dimensionNum] stringValue]];
            [key appendString:dimenString];
        }
    }
    
    return [NSString stringWithString:key];
}

@end
