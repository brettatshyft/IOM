//
//  MultiDimensionalArray.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/6/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "MultiDimensionalArray.h"

@implementation MultiDimensionalArray
{
    NSArray * _array;
    NSUInteger _x;
    NSUInteger _y;
    NSUInteger _z;
}

- (id)initWithDimensionsX:(NSUInteger)x Y:(NSUInteger)y Z:(NSUInteger)z
{
    self = [super init];
    if (self) {
        
        _x = x;
        _y = y;
        _z = z;
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:x];
        for (int i = 0; i < x; i++) {
            NSMutableArray * column = [NSMutableArray arrayWithCapacity:y];
            for (int j = 0; j < y; j++) {
                NSMutableArray * depth = [NSMutableArray arrayWithCapacity:z];
                for (int k = 0; k < z; k++) {
                    [depth addObject:[NSNull null]];
                }
                [column addObject:depth];
            }
            [array addObject:[NSArray arrayWithArray:column]];
        }
        _array = [NSArray arrayWithArray:array];
    }
    
    return self;
}

- (void)addObject:(id)object AtX:(NSUInteger)x Y:(NSUInteger)y Z:(NSUInteger)z
{
    NSAssert(x < _x, @"X index out of bounds!: %i, [0..%i]", x, _x - 1);
    NSAssert(y < _y, @"Y index out of bounds!: %i, [0..%i]", y, _y - 1);
    NSAssert(z < _z, @"Z index out of bounds!: %i, [0..%i]", z, _z - 1);
    
    NSArray * column = [_array objectAtIndex:x];
    NSMutableArray * depth = [column objectAtIndex:y];
    
    [depth removeObjectAtIndex:z];
    [depth insertObject:object atIndex:z];
}

- (void)removeObjectAtX:(NSUInteger)x Y:(NSUInteger)y Z:(NSUInteger)z
{
    NSAssert(x < _x, @"X index out of bounds!: %i, [0..%i]", x, _x - 1);
    NSAssert(y < _y, @"Y index out of bounds!: %i, [0..%i]", y, _y - 1);
    NSAssert(z < _z, @"Z index out of bounds!: %i, [0..%i]", z, _z - 1);
    
    [self addObject:[NSNull null] AtX:x Y:y Z:z];
}

- (id)getObjectAtX:(NSUInteger)x Y:(NSUInteger)y Z:(NSUInteger)z
{
    NSAssert(x < _x, @"X index out of bounds!: %i, [0..%i]", x, _x - 1);
    NSAssert(y < _y, @"Y index out of bounds!: %i, [0..%i]", y, _y - 1);
    NSAssert(z < _z, @"Z index out of bounds!: %i, [0..%i]", z, _z - 1);
    
    NSArray * column = [_array objectAtIndex:x];
    NSMutableArray * depth = [column objectAtIndex:y];
    
    return [depth objectAtIndex:z];
}

@end
