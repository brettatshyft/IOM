//
//  IOMSlideLink.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 1/30/16.
//  Copyright © 2016 Local Wisdom Inc. All rights reserved.
//

#import "IOMSlideLink.h"

static const NSString* kIOMSlideLinkJSONRectKey = @"CGRect";
static const NSString* kIOMSlideLinkJSONResourceKey = @"resource";
static const NSString* kIOMSlideLinkJSONTitle = @"title";

@interface IOMSlideLink ()

@property (nonatomic, assign) CGRect rectRelativeToSlide;
@property (nonatomic, strong) NSString* resource;
@property (nonatomic, strong) NSString* title;
@end

@implementation IOMSlideLink

- (instancetype)initWithJSONData:(NSDictionary*)dictionary
{
    if (self = [super init])
    {
        self.resource = dictionary[kIOMSlideLinkJSONResourceKey];
        self.title = dictionary[kIOMSlideLinkJSONTitle];
        self.rectRelativeToSlide = CGRectFromString(dictionary[kIOMSlideLinkJSONRectKey]);
    }
    
    return self;
}

@end
