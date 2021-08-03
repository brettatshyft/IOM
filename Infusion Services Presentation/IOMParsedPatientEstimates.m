//
//  IOMParsedPatientEstimates.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 1/18/18.
//  Copyright © 2018 Local Wisdom Inc. All rights reserved.
//

#import "IOMParsedPatientEstimates.h"

#define IOMParsedPatientEstimatesFieldValueKey @"fieldValue"
#define IOMParsedPatientEstimatesHeaderNameKey @"headerName"

#define IOMDisplaynameKey @"displayname"
#define IOMJNJIdKey @"jnj_id"
#define IOMCotDetailKey @"cot - detail"
#define IOMStreetnameKey @"streetname"
#define IOMCityKey @"city"
#define IOMStateKey @"state"
#define IOMZipcodeKey @"zipcode"
#define IOMAbsKey @"abs"
#define IOMRheum_Patients_Potential_52WkKey @"rheum_patients_potential_52wk"
#define IOMGastro_Patients_Potential_52WkKey @"gastro_patients_potential_52wk"
#define IOMRemPatients52WkKey @"rem patients 52wk"
#define IOMRemPatients52X52ChgKey @"rem patients 52x52 chg"
#define IOMRemPatients52X52PctChgKey @"rem patients 52x52 pct chg"
#define IOMSimponiAriaPatients52WkKey @"simponi aria patients 52wk"
#define IOMSimponiAriaPatients52X52ChgKey @"simponi aria patients 52x52 chg"
#define IOMSimponiAriaPatients52X52PctChgKey @"simponi aria patients 52x52 pct chg"
#define IOMEnbPatients52WkKey @"enb patients 52wk"
#define IOMEnbPatients52X52ChgKey @"enb patients 52x52 chg"
#define IOMEnbPatients52X52PctChgKey @"enb patients 52x52 pct chg"
#define IOMHumPatients52WkKey @"hum patients 52wk"
#define IOMHumPatients52X52ChgKey @"hum patients 52x52 chg"
#define IOMHumPatients52X52PctChgKey @"hum patients 52x52 pct chg"
#define IOMOrePatients52WkKey @"ore patients 52wk"
#define IOMOrePatients52X52ChgKey @"ore patients 52x52 chg"
#define IOMOrePatients52X52PctChgKey @"ore patients 52x52 pct chg"
#define IOMActemraIvPatients52WkKey @"actemra iv patients 52wk"
#define IOMActemraIvPatients52X52ChgKey @"actemra iv patients 52x52 chg"
#define IOMActemraIvPatients52X52PctChgKey @"actemra iv patients 52x52 pct chg"
#define IOMCimziaPatients52WkKey @"cimzia patients 52wk"
#define IOMCimziaPatients52X52ChgKey @"cimzia patients 52x52 chg"
#define IOMCimziaPatients52X52PctChgKey @"cimzia patients 52x52 pct chg"
#define IOMXeljanzPatients52WkKey @"xeljanz patients 52 wk"
#define IOMXeljanzPatients52X52ChgKey @"xeljanz patients 52x52 chg"
#define IOMXeljanzPatients52X52PctChgKey @"xeljanz patients 52x52 pct chg"
#define IOMBioPatients52WkKey @"bio patients 52wk"
#define IOMBioPatients52X52ChgKey @"bio patients 52x52 chg"
#define IOMBioPatients52X52PctChgKey @"bio patients 52x52 pct chg"
#define IOMEntyvioPatients52WkKey @"entyvio patients 52wk"
#define IOMEntyvioPatients52X52ChgKey @"entyvio patients 52x52 chg"
#define IOMEntyvioPatients52X52PctChgKey @"entyvio patients 52x52 pct chg"
#define IOMInflectraPatients52WkKey @"inflectra patients 52wk"
#define IOMInflectraPatients52X52ChgKey @"inflectra patients 52x52 chg"
#define IOMInflectraPatients52X52PctChgKey @"inflectra patients 52x52 pct chg"
#define IOMRenflexisPatients52WkKey @"renflexis patients 52wk"
#define IOMRenflexisPatients52X52ChgKey @"renflexis patients 52x52 chg"
#define IOMRenflexisPatients52X52PctChgKey @"renflexis patients 52x52 pct chg"
#define IOMStelara130MgPatients52WkKey @"stelara 130mg patients 52wk"
#define IOMStelara130MgPatients52X52ChgKey @"stelara 130mg patients 52x52 chg"
#define IOMStelara130MgPatients52X52PctChgKey @"stelara 130mg patients 52x52 pct chg"

@implementation IOMParsedPatientEstimates

- (instancetype)initWithArray:(NSArray<NSDictionary*>*)array
{
    if (self = [super init]) {
        for (NSDictionary* currentDictionary in array) {
            NSString* fieldValue = currentDictionary[IOMParsedPatientEstimatesFieldValueKey];
            NSString* headerName = currentDictionary[IOMParsedPatientEstimatesHeaderNameKey];

            NSNumberFormatter *percentageNumberFormatter = [[NSNumberFormatter alloc] init];
            percentageNumberFormatter.numberStyle = NSNumberFormatterPercentStyle;

            if ([headerName isEqualToString:IOMDisplaynameKey]) {
                _displayname = fieldValue;
            }
            else if ([headerName isEqualToString:IOMJNJIdKey]) {
                _jnjId = fieldValue;
            }
            else if ([headerName isEqualToString:IOMCotDetailKey]) {
                _cotDetail = fieldValue;
            }
            else if ([headerName isEqualToString:IOMStreetnameKey]) {
                _streetname = fieldValue;
            }
            else if ([headerName isEqualToString:IOMCityKey]) {
                _city = fieldValue;
            }
            else if ([headerName isEqualToString:IOMStateKey]) {
                _state = fieldValue;
            }
            else if ([headerName isEqualToString:IOMZipcodeKey]) {
                _zipcode = fieldValue;
            }
            else if ([headerName isEqualToString:IOMAbsKey]) {
                _abs = fieldValue;
            }
            else if ([headerName isEqualToString:IOMRheum_Patients_Potential_52WkKey]) {
                _rheumPatientsPotential52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMGastro_Patients_Potential_52WkKey]) {
                _gastroPatientsPotential52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMRemPatients52WkKey]) {
                _remPatients52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMRemPatients52X52ChgKey]) {
                _remPatients52X52Chg = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMRemPatients52X52PctChgKey]) {
                _remPatients52X52PctChg = [percentageNumberFormatter numberFromString:fieldValue];
            }
            else if ([headerName isEqualToString:IOMSimponiAriaPatients52WkKey]) {
                _simponiAriaPatients52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMSimponiAriaPatients52X52ChgKey]) {
                _simponiAriaPatients52X52Chg = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMSimponiAriaPatients52X52PctChgKey]) {
                _simponiAriaPatients52X52PctChg = [percentageNumberFormatter numberFromString:fieldValue]; //
            }
            else if ([headerName isEqualToString:IOMEnbPatients52WkKey]) {
                _enbPatients52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMEnbPatients52X52ChgKey]) {
                _enbPatients52X52Chg = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMEnbPatients52X52PctChgKey]) {
                _enbPatients52X52PctChg = [percentageNumberFormatter numberFromString:fieldValue];
            }
            else if ([headerName isEqualToString:IOMHumPatients52WkKey]) {
                _humPatients52Wk = @([fieldValue floatValue]); //
            }
            else if ([headerName isEqualToString:IOMHumPatients52X52ChgKey]) {
                _humPatients52X52Chg = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMHumPatients52X52PctChgKey]) {
                _humPatients52X52PctChg = [percentageNumberFormatter numberFromString:fieldValue]; //
            }
            else if ([headerName isEqualToString:IOMOrePatients52WkKey]) {
                _orePatients52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMOrePatients52X52ChgKey]) {
                _orePatients52X52Chg = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMOrePatients52X52PctChgKey]) {
                _orePatients52X52PctChg = [percentageNumberFormatter numberFromString:fieldValue]; //
            }
            else if ([headerName isEqualToString:IOMActemraIvPatients52WkKey]) {
                _actemraIvPatients52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMActemraIvPatients52X52ChgKey]) {
                _actemraIvPatients52X52Chg = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMActemraIvPatients52X52PctChgKey]) {
                _actemraIvPatients52X52PctChg = [percentageNumberFormatter numberFromString:fieldValue]; //
            }
            else if ([headerName isEqualToString:IOMCimziaPatients52WkKey]) {
                _cimziaPatients52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMCimziaPatients52X52ChgKey]) {
                _cimziaPatients52X52Chg = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMCimziaPatients52X52PctChgKey]) {
                _cimziaPatients52X52PctChg = [percentageNumberFormatter numberFromString:fieldValue];
            }
            else if ([headerName isEqualToString:IOMXeljanzPatients52WkKey]) {
                _xeljanzPatients52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMXeljanzPatients52X52ChgKey]) {
                _xeljanzPatients52X52Chg = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMXeljanzPatients52X52PctChgKey]) {
                _xeljanzPatients52X52PctChg = [percentageNumberFormatter numberFromString:fieldValue];
            }
            else if ([headerName isEqualToString:IOMBioPatients52WkKey]) {
                _bioPatients52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMBioPatients52X52ChgKey]) {
                _bioPatients52X52Chg = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMBioPatients52X52PctChgKey]) {
                _bioPatients52X52PctChg = [percentageNumberFormatter numberFromString:fieldValue];
            }
            else if ([headerName isEqualToString:IOMEntyvioPatients52WkKey]) {
                _entyvioPatients52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMEntyvioPatients52X52ChgKey]) {
                _entyvioPatients52X52Chg = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMEntyvioPatients52X52PctChgKey]) {
                _entyvioPatients52X52PctChg = [percentageNumberFormatter numberFromString:fieldValue];
            }
            else if ([headerName isEqualToString:IOMInflectraPatients52WkKey]) {
                _inflectraPatients52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMInflectraPatients52X52ChgKey]) {
                _inflectraPatients52X52Chg = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMInflectraPatients52X52PctChgKey]) {
                _inflectraPatients52X52PctChg = [percentageNumberFormatter numberFromString:fieldValue];
            }
            else if ([headerName isEqualToString:IOMRenflexisPatients52WkKey]) {
                _renflexisPatients52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMRenflexisPatients52X52ChgKey]) {
                _renflexisPatients52X52Chg = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMRenflexisPatients52X52PctChgKey]) {
                _renflexisPatients52X52PctChg = [percentageNumberFormatter numberFromString:fieldValue];
            }
            else if ([headerName isEqualToString:IOMStelara130MgPatients52WkKey]) {
                _stelara130MgPatients52Wk = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMStelara130MgPatients52X52ChgKey]) {
                _stelara130MgPatients52X52Chg = @([fieldValue floatValue]);
            }
            else if ([headerName isEqualToString:IOMStelara130MgPatients52X52PctChgKey]) {
                _stelara130MgPatients52X52PctChg = [percentageNumberFormatter numberFromString:fieldValue];
            }
        }
    }

    return self;
}

@end
