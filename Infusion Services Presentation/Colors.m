//
//  Colors.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/27/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "Colors.h"

@implementation Colors

static Colors* instance;
+ (Colors*)getInstance
{
    //This may not be safe in multi-threaded program
    if(!instance){
        instance = [[Colors alloc] init];
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _lightBackgroundColor = [UIColor colorWithRed:238.0/255.0 green:244.0/255.0 blue:247.0/255.0 alpha:1.0];
        _defaultBackgroundColor = [UIColor colorWithRed:222.0/255.0 green:234.0/255.0 blue:240.0/255.0 alpha:1.0];
        _lightBlueColor = [UIColor colorWithRed:0 green:160.0/255.0 blue:233.0/255.0 alpha:1.0];
        _darkBlueColor = [UIColor colorWithRed:0 green:92.0/255.0 blue:130.0/255.0 alpha:1.0];
        _darkGrayColor = [UIColor colorWithRed:78.0/255.0 green:80.0/255.0 blue:84.0/255.0 alpha:1.0];
        _lightGrayColor = [UIColor colorWithRed:158.0/255.0 green:159.0/255.0 blue:162.0/255.0 alpha:1.0];
        _greenColor = [UIColor colorWithRed:90.0/255.0 green:135.0/255.0 blue:57.0/255.0 alpha:1.0];
        _redColor = [UIColor redColor];
        _altGreenColor = [UIColor colorWithRed:115.0/255.0 green:178.0/255.0 blue:46.0/255.0 alpha:1.0];
        _yellowColor = [UIColor colorWithRed:217.0/255.0 green:158.0/255.0 blue:49.0/255.0 alpha:1.0];
    }
    
    return self;
}

@end
