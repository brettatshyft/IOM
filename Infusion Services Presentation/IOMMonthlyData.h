//
//  IOMMonthlyData.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 1/10/18.
//  Copyright © 2018 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IOMParsedVialTrend;
@class IOMParsedPatientEstimates;

@interface IOMMonthlyData : NSObject

@property (nonatomic, strong) IOMParsedVialTrend * remicadeVialTrends;
@property (nonatomic, strong) IOMParsedVialTrend * simponiAriaVialTrends;
@property (nonatomic, strong) IOMParsedVialTrend * stelaraVialTrends;
@property (nonatomic, strong) IOMParsedPatientEstimates * patientEstimates;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
