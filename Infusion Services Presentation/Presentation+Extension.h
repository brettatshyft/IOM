//
//  Presentation+Extension.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/5/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "Presentation.h"
#import "PresentationType.h"

typedef NS_ENUM(NSInteger, IOMPresentationSectionsIncludedType){
    PresentationSectionsIncludedTypeInfusionServicesAndInfusionOptimization,
    PresentationSectionsIncludedTypeInfusionServices,
    PresentationSectionsIncludedTypeInfusionOptimization
};

extern NSString * const IOMPresentationSectionsIncludedTypeToString[];

@interface Presentation (Extension)

- (PresentationType)presentationType;
- (void)updateScenariosForPresentationType;
- (NSString*)presentationTitle;
- (BOOL)includeStelara;
- (NSArray<NSString*>*)drugTitlesForPresentationType;
- (BOOL)includeSimponiAria;
- (BOOL)includeInfusionServicesSection;
- (BOOL)includeInfusionOptimizationSection;
- (BOOL)verifyCompleted;
- (NSOperationQueue*)checkAndProcessAllScenarios;
- (Presentation*)duplicatePresentationWithCopyTag:(BOOL)copyTag;
- (void)flagAllScenariosAsNeedsProcessing;
+ (NSArray<NSString*>*) drugTitlesForPresentationType:(PresentationType)type;
+ (BOOL)includeStelaraForPresentationTypeID:(NSNumber*)presentationType;
+ (BOOL)includeSimponiAriaForPresentationTypeID:(NSNumber *)presentationType;

@end
