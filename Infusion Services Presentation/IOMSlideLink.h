//
//  IOMSlideLink.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 1/30/16.
//  Copyright © 2016 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOMSlideLink : NSObject

@property (nonatomic, readonly) CGRect rectRelativeToSlide;
@property (nonatomic, readonly) NSString* resource;
@property (nonatomic, readonly) NSString* title;

- (instancetype)initWithJSONData:(NSDictionary*)dictionary;

@end
