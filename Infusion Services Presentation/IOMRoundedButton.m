//
//  IOMRoundedButton.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/30/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "IOMRoundedButton.h"
#import <QuartzCore/QuartzCore.h>

@interface IOMRoundedButton() {
    UIColor* _mainBackgroundColor;
}

@end

@implementation IOMRoundedButton

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
    _mainBackgroundColor = self.backgroundColor;
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
}

- (void)setSelectionHighlightOn:(BOOL)isOn
{
    if (isOn) {
        [self setBackgroundColor:_highlightBackgroundColor];
    } else {
        [self setBackgroundColor:_mainBackgroundColor];
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
