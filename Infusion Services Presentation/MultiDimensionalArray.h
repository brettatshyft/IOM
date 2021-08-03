//
//  MultiDimensionalArray.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/6/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiDimensionalArray : NSObject

- (id)initWithDimensionsX:(NSUInteger)x Y:(NSUInteger)y Z:(NSUInteger)z;
- (void)addObject:(id)object AtX:(NSUInteger)x Y:(NSUInteger)y Z:(NSUInteger)z;
- (void)removeObjectAtX:(NSUInteger)x Y:(NSUInteger)y Z:(NSUInteger)z;
- (id)getObjectAtX:(NSUInteger)x Y:(NSUInteger)y Z:(NSUInteger)z;

@end
