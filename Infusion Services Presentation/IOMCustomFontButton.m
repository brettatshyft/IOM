//
//  IOMCustomFontButton.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/2/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "IOMCustomFontButton.h"

@implementation IOMCustomFontButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setCustomFont];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setCustomFont];
}

- (void)setCustomFont
{
    UIFont* newFont = [UIFont fontWithName:@"Ubuntu-Medium" size:[[self.titleLabel font] pointSize]];
    [self.titleLabel setFont:newFont];
}

@end
