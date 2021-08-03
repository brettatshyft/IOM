//
//  IOMCustomFontLabel.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/30/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "IOMCustomFontLabel.h"
#import "UILabel+SuperscriptLabel.h"

@implementation IOMCustomFontLabel

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
    [self setSuperscriptForRegisteredTradeMarkSymbols];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setSuperscriptForRegisteredTradeMarkSymbols];
}

- (void)setCustomFont
{
    //Karbon Font
    UIFont* currentFont = [self font];
    UIFont* newFont = nil;
    
    if ([_bold boolValue]) {
        newFont = [UIFont fontWithName:@"Ubuntu-Bold" size:[currentFont pointSize]];
    } else {
        newFont = [UIFont fontWithName:@"Ubuntu" size:[currentFont pointSize]];
    }
    
    [self setFont:newFont];
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
