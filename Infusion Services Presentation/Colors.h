//
//  Colors.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/27/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colors : NSObject

@property (nonatomic, strong, readonly) UIColor* lightBackgroundColor;
@property (nonatomic, strong, readonly) UIColor* defaultBackgroundColor;
@property (nonatomic, strong, readonly) UIColor* lightBlueColor;
@property (nonatomic, strong, readonly) UIColor* darkBlueColor;
@property (nonatomic, strong, readonly) UIColor* darkGrayColor;
@property (nonatomic, strong, readonly) UIColor* lightGrayColor;
@property (nonatomic, strong, readonly) UIColor* greenColor;
@property (nonatomic, strong, readonly) UIColor* redColor;
@property (nonatomic, strong, readonly) UIColor* altGreenColor;
@property (nonatomic, strong, readonly) UIColor* yellowColor;

+ (Colors*)getInstance;

@end
