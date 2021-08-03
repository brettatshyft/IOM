//
//  VialTrend+Extension.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/5/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "VialTrend.h"

@class IOMParsedVialTrend;

typedef NS_ENUM(NSInteger, VialTrendType){
    VialTrendTypeRemicade = 0,
    VialTrendTypeSimponiAria = 1,
    VialTrendTypeStelara = 2
};

@class Presentation;
@interface VialTrend (Extension)

+ (VialTrend*)getVialTrendOfType:(VialTrendType)trendType forPresentation:(Presentation*)presentation;
+ (VialTrend*)getVialTrendFromParsed:(IOMParsedVialTrend*)parsed forPresentation:(Presentation*)presentation;
+ (NSArray<NSNumber*>*)getSummedVialTrendForPresentation:(Presentation*)presentation;
- (VialTrend*)duplicateVialTrend;

@end
