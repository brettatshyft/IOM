//
//  IOMAnalyticsManager.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 11/2/17.
//  Copyright © 2017 Local Wisdom Inc. All rights reserved.
//

#import "IOMAnalyticsManager.h"

#import "NSUserDefaults+IOMMyInfoUserDefaults.h"

#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>
#import <GoogleAnalytics/GAIEcommerceFields.h>
#import <GoogleAnalytics/GAIEcommerceProduct.h>
#import <GoogleAnalytics/GAIEcommerceProductAction.h>
#import <GoogleAnalytics/GAIEcommercePromotion.h>
#import <GoogleAnalytics/GAIFields.h>
#import <GoogleAnalytics/GAILogger.h>
#import <GoogleAnalytics/GAITrackedViewController.h>
#import <GoogleAnalytics/GAITracker.h>

typedef NS_ENUM(NSUInteger, IOMAnalyticsEventCategoryUIActionTypeButtonTappedLabel) {
    IOMAnalyticsEventCategoryUIActionTypeButtonTappedLabelNone,
    IOMAnalyticsEventCategoryUIActionTypeButtonTappedLabelEmail
};

typedef NS_ENUM(NSUInteger, IOMAnalyticsEventCategoryPresentationAction) {
    IOMAnalyticsEventCategoryPresentationActionNone,
    IOMAnalyticsEventCategoryPresentationActionCreated,
    IOMAnalyticsEventCategoryPresentationActionOpened
};

/*
 Categories
 */
typedef NS_ENUM(NSUInteger, IOMAnalyticsEventCategory) {
    IOMAnalyticsEventCategoryNone,
    IOMAnalyticsEventCategoryUIAction,
    IOMAnalyticsEventCategoryPresentation,
    IOMAnalyticsEventCategoryLogOn
};

NSString * const IOMAnalyticsEventCategoryToString[] = {
    [IOMAnalyticsEventCategoryNone] = @"none",
    [IOMAnalyticsEventCategoryUIAction] = @"ui_action",
    [IOMAnalyticsEventCategoryPresentation] = @"presentation",
    [IOMAnalyticsEventCategoryLogOn] = @"log_on"
};

NSString* const IOMAnalyticsEventCategoryPresentationActionToString[] = {
    [IOMAnalyticsEventCategoryPresentationActionNone] = @"none",
    [IOMAnalyticsEventCategoryPresentationActionCreated] = @"created",
    [IOMAnalyticsEventCategoryPresentationActionOpened] = @"opened"
};

typedef NS_ENUM(NSUInteger, IOMAnalyticsEventCategoryUIActionType) {
    IOMAnalyticsEventCategoryUIActionTypeNone,
    IOMAnalyticsEventCategoryUIActionTypeButtonTapped
};

NSString * const IOMAnalyticsEventCategoryUIActionTypeToString[] = {
    [IOMAnalyticsEventCategoryUIActionTypeNone] = @"none",
    [IOMAnalyticsEventCategoryUIActionTypeButtonTapped] = @"button_tapped"
};

/*
 Button tapped labels
 */
NSString* const IOMAnalyticsEventCategoryUIActionTypeButtonTappedLabelToString[] = {
    [IOMAnalyticsEventCategoryUIActionTypeButtonTappedLabelNone] = @"none",
    [IOMAnalyticsEventCategoryUIActionTypeButtonTappedLabelEmail] = @"email"
};

static NSString * const IOMAnalyticsManagerDictionaryKeyEmail = @"email";
static NSString * const IOMAnalyticsManagerDictionaryKeyRDT = @"rdt";
static NSString * const IOMAnalyticsManagerDictionaryKeyWWID = @"wwid";

@interface IOMAnalyticsManager()

@property (nonatomic, strong) id<GAITracker> tracker;

@end

@implementation IOMAnalyticsManager

+ (id)shared {
    static IOMAnalyticsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        GAI *gai = [GAI sharedInstance];
        gai.trackUncaughtExceptions = YES;
//        gai.logger.logLevel = kGAILogLevelVerbose;
        self.tracker = [gai trackerWithTrackingId:@"UA-109177364-1"];
        [_tracker set:[GAIFields customDimensionForIndex:1]
                value:[NSUserDefaults iom_getMyInfoUserDefaultForType:IOMMyInfoDefaultsEmail] ?: @"n/a"];
        [_tracker set:[GAIFields customDimensionForIndex:2]
                value:[NSUserDefaults iom_getMyInfoUserDefaultForType:IOMMyInfoDefaultsRDT] ?: @"n/a"];
        [_tracker set:[GAIFields customDimensionForIndex:3]
                value:[NSUserDefaults iom_getMyInfoUserDefaultForType:IOMMyInfoDefaultsWWID] ?: @"n/a"];
    }

    return self;
}

- (void)trackScreenView:(id<IOMAnalyticsIdentifiable>)identifiableScreen
{
    [self.tracker set:kGAIScreenName value:identifiableScreen.analyticsIdentifier];
    GAIDictionaryBuilder* builder = [GAIDictionaryBuilder createScreenView];
    if ([identifiableScreen respondsToSelector:@selector(analyticsDictionary)]) {
        builder = [builder setAll:[identifiableScreen analyticsDictionary]];
    }
    NSMutableDictionary* dictionary = [builder build];
    [self.tracker send:dictionary];
}

- (void)trackDidFinishLaunching
{
    [self trackEventWithCategory:IOMAnalyticsEventCategoryLogOn action:@"log_on" andLabel:nil];
}

- (void)trackButtonTappedWithLabel:(IOMAnalyticsEventCategoryUIActionTypeButtonTappedLabel)label
{
    [self trackEventWithCategory:IOMAnalyticsEventCategoryUIAction
                          action:IOMAnalyticsEventCategoryUIActionTypeToString[IOMAnalyticsEventCategoryUIActionTypeButtonTapped]
                        andLabel:IOMAnalyticsEventCategoryUIActionTypeButtonTappedLabelToString[label]];
}

- (void)trackPresentationAction:(IOMAnalyticsEventCategoryPresentationAction)action withType:(IOMPresentationSectionsIncludedType)type
{
    [self trackEventWithCategory:IOMAnalyticsEventCategoryPresentation
                          action:IOMAnalyticsEventCategoryPresentationActionToString[action]
                        andLabel:IOMPresentationSectionsIncludedTypeToString[type]];
}

- (void)trackEventWithCategory:(IOMAnalyticsEventCategory)category action:(NSString*)action andLabel:(NSString*)label
{
    GAIDictionaryBuilder* builder = [GAIDictionaryBuilder createEventWithCategory:IOMAnalyticsEventCategoryToString[category]
                                                                           action:action
                                                                            label:label
                                                                            value:nil];
    NSDictionary* dictionary = [builder build];
    [self.tracker send:dictionary];
}

@end
