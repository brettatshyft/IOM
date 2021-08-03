//
//  IOMAnalyticsManager.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 11/2/17.
//  Copyright © 2017 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentation+Extension.h"

@protocol IOMAnalyticsIdentifiable<NSObject>

- (NSString*)analyticsIdentifier;

@optional
- (NSDictionary*)analyticsDictionary;

@end

@interface IOMAnalyticsManager : NSObject

+ (id)shared;

- (void)trackDidFinishLaunching;
- (void)trackScreenView:(id<IOMAnalyticsIdentifiable>)identifiableScreen;

@end
