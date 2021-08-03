//
//  IOMRoundedArrowButton.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/30/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "IOMRoundedArrowButton.h"
#import <QuartzCore/QuartzCore.h>

@interface IOMRoundedArrowButton()

@end

@implementation IOMRoundedArrowButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeProperties];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initializeProperties];
}

- (void)initializeProperties
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.clipsToBounds = YES;
    [self setBackgroundImage:[UIImage imageNamed:@"blue-arrow-button.png"] forState:UIControlStateSelected];
    //[self setBackgroundImage:[UIImage imageNamed:@"blue-arrow-button.png"] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:@"dark-blue-button.png"] forState:UIControlStateNormal];
}

- (void)setSelectionHighlightOn:(BOOL)isOn
{
    if (isOn) {
        [self setBackgroundImage:[UIImage imageNamed:@"blue-arrow-button.png"] forState:UIControlStateNormal];
    } else {
        [self setBackgroundImage:[UIImage imageNamed:@"dark-blue-button.png"] forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
