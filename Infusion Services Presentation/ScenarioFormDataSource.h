//
//  ScenarioFormDataSource.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/16/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Scenario;
@protocol ScenarioFormDataSource <NSObject>

- (Scenario*)scenarioForForm:(UIViewController*)formViewController;

@end
