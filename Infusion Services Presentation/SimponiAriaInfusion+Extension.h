//
//  SimponiAriaInfusion+Extension.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "SimponiAriaInfusion.h"

@interface SimponiAriaInfusion (Extension)

- (int)getTotalTime;
+ (SimponiAriaInfusion*)getSimponiAriaInfusionForScenario:(Scenario*)scenario;
- (SimponiAriaInfusion*)duplicateSimponiAriaInfusion;

@end
