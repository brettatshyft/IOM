//
//  ScenarioForm.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/16/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScenarioFormDataSource.h"

@class Scenario;
@protocol ScenarioForm <NSObject>

@property (nonatomic, strong) Scenario* scenario;

@end
