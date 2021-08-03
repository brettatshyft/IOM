//
//  ListValues.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/6/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "ListValues.h"
#import "Presentation+Extension.h"

@implementation ListValues

static NSDictionary* PRESENTATION_TYPE_LIST_DICTIONARY;
static NSDictionary* PRESENTATION_SECTIONS_INCLUDED_TYPE_LIST_DICTIONARY;
+ (NSDictionary*)listValuesForDictionaryPresentationTypes
{
    if (!PRESENTATION_TYPE_LIST_DICTIONARY){
        NSNumber* presentationTypeUnassigned = [NSNumber numberWithInt:PresentationTypeUnassigned];
        NSNumber* presentationTypeRA = [NSNumber numberWithInt:PresentationTypeRAIOI];
        NSNumber* presentationTypeGI = [NSNumber numberWithInt:PresentationTypeGIIOI];
        NSNumber* presentationTypeHOPD = [NSNumber numberWithInt:PresentationTypeHOPD];
        NSNumber* presentationTypeMixed = [NSNumber numberWithInt:PresentationTypeMixedIOI];
        NSNumber* presentationTypeDerm = [NSNumber numberWithInt:PresentationTypeDermIOI];
        NSNumber* presentationTypeOther = [NSNumber numberWithInt:PresentationTypeOther];
        
        NSArray* keys = LIST_VALUES_ARRAY_PRESENTATION_TYPE;
        
        PRESENTATION_TYPE_LIST_DICTIONARY = [NSDictionary dictionaryWithObjectsAndKeys:presentationTypeUnassigned, keys[0], presentationTypeRA, keys[1], presentationTypeGI, keys[2], presentationTypeHOPD, keys[3], presentationTypeMixed, keys[4], presentationTypeDerm, keys[5], presentationTypeOther, keys[6], nil];
    }
    
    return PRESENTATION_TYPE_LIST_DICTIONARY;
}

+ (NSDictionary*)listValuesForDictionaryIncludedPresentationTypes
{
    if (!PRESENTATION_SECTIONS_INCLUDED_TYPE_LIST_DICTIONARY) {
        NSNumber* presentationsTypeInfusionServices = [NSNumber numberWithInt:PresentationSectionsIncludedTypeInfusionServices];
        NSNumber* presentationsTypeInfusionOptimization = [NSNumber numberWithInt:PresentationSectionsIncludedTypeInfusionOptimization];
        NSNumber* presentationsTypeInfusionServicesAndInfusionOptimization = [NSNumber numberWithInt:PresentationSectionsIncludedTypeInfusionServicesAndInfusionOptimization];
        
        NSArray* keys = LIST_VALUES_ARRAY_PRESENTATION_SECTIONS;
        
        PRESENTATION_SECTIONS_INCLUDED_TYPE_LIST_DICTIONARY = [NSDictionary dictionaryWithObjectsAndKeys:presentationsTypeInfusionServicesAndInfusionOptimization, keys[0], presentationsTypeInfusionServices, keys[1], presentationsTypeInfusionOptimization, keys[2], nil];

    }
    
    return PRESENTATION_SECTIONS_INCLUDED_TYPE_LIST_DICTIONARY;
}

@end
