//
//  IOMDropdownButton.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/15/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "IOMDropdownButton.h"

@implementation IOMDropdownButton

static UIImage * customBackgroundImage = nil;
static UIEdgeInsets backgroundEdgeInsets;

+ (void)initialize
{
    [super initialize];
    if(!customBackgroundImage){
        customBackgroundImage = [UIImage imageNamed:@"dropdownButtonBackground.png"];
    }
    backgroundEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 42);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setInsetsAndCustomBackground];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setInsetsAndCustomBackground];
}

- (void)setInsetsAndCustomBackground
{
    //Set custom background image
    if(customBackgroundImage && !UIEdgeInsetsEqualToEdgeInsets(backgroundEdgeInsets, UIEdgeInsetsZero)){
        UIImage* customImageWithInsets = [customBackgroundImage resizableImageWithCapInsets:backgroundEdgeInsets];
        [self setBackgroundImage:customImageWithInsets forState:UIControlStateNormal];
    }
}

@end
