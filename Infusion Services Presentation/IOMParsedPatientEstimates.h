//
//  IOMParsedPatientEstimates.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 1/18/18.
//  Copyright © 2018 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOMParsedPatientEstimates : NSObject

@property (nonatomic, retain) NSString * displayname;
@property (nonatomic, retain) NSString * jnjId;
@property (nonatomic, retain) NSString * cotDetail;
@property (nonatomic, retain) NSString * streetname;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zipcode;
@property (nonatomic, retain) NSString * abs;
@property (nonatomic, retain) NSNumber * rheumPatientsPotential52Wk;
@property (nonatomic, retain) NSNumber * gastroPatientsPotential52Wk;
@property (nonatomic, retain) NSNumber * remPatients52Wk;
@property (nonatomic, retain) NSNumber * remPatients52X52Chg;
@property (nonatomic, retain) NSNumber * remPatients52X52PctChg;
@property (nonatomic, retain) NSNumber * simponiAriaPatients52Wk;
@property (nonatomic, retain) NSNumber * simponiAriaPatients52X52Chg;
@property (nonatomic, retain) NSNumber * simponiAriaPatients52X52PctChg;
@property (nonatomic, retain) NSNumber * enbPatients52Wk;
@property (nonatomic, retain) NSNumber * enbPatients52X52Chg;
@property (nonatomic, retain) NSNumber * enbPatients52X52PctChg;
@property (nonatomic, retain) NSNumber * humPatients52Wk;
@property (nonatomic, retain) NSNumber * humPatients52X52Chg;
@property (nonatomic, retain) NSNumber * humPatients52X52PctChg;
@property (nonatomic, retain) NSNumber * orePatients52Wk;
@property (nonatomic, retain) NSNumber * orePatients52X52Chg;
@property (nonatomic, retain) NSNumber * orePatients52X52PctChg;
@property (nonatomic, retain) NSNumber * actemraIvPatients52Wk;
@property (nonatomic, retain) NSNumber * actemraIvPatients52X52Chg;
@property (nonatomic, retain) NSNumber * actemraIvPatients52X52PctChg;
@property (nonatomic, retain) NSNumber * cimziaPatients52Wk;
@property (nonatomic, retain) NSNumber * cimziaPatients52X52Chg;
@property (nonatomic, retain) NSNumber * cimziaPatients52X52PctChg;
@property (nonatomic, retain) NSNumber * xeljanzPatients52Wk;
@property (nonatomic, retain) NSNumber * xeljanzPatients52X52Chg;
@property (nonatomic, retain) NSNumber * xeljanzPatients52X52PctChg;
@property (nonatomic, retain) NSNumber * bioPatients52Wk;
@property (nonatomic, retain) NSNumber * bioPatients52X52Chg;
@property (nonatomic, retain) NSNumber * bioPatients52X52PctChg;
@property (nonatomic, retain) NSNumber * entyvioPatients52Wk;
@property (nonatomic, retain) NSNumber * entyvioPatients52X52Chg;
@property (nonatomic, retain) NSNumber * entyvioPatients52X52PctChg;
@property (nonatomic, retain) NSNumber * inflectraPatients52Wk;
@property (nonatomic, retain) NSNumber * inflectraPatients52X52Chg;
@property (nonatomic, retain) NSNumber * inflectraPatients52X52PctChg;
@property (nonatomic, retain) NSNumber * renflexisPatients52Wk;
@property (nonatomic, retain) NSNumber * renflexisPatients52X52Chg;
@property (nonatomic, retain) NSNumber * renflexisPatients52X52PctChg;
@property (nonatomic, retain) NSNumber * stelara130MgPatients52Wk;
@property (nonatomic, retain) NSNumber * stelara130MgPatients52X52Chg;
@property (nonatomic, retain) NSNumber * stelara130MgPatients52X52PctChg;

- (instancetype)initWithArray:(NSArray<NSDictionary*>*)array;

@end
