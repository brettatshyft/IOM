//
//  ScenarioStaff.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/7/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScenarioStaff : NSObject <NSCopying>

@property (nonatomic) int primaryFocus;
@property (nonatomic) double chairLimit;

- (id)init;

@end
