//
//  IOMCustomFontLabel.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/30/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "IOMCustomFontBoldLabel.h"
#import "UILabel+SuperscriptLabel.h"

@implementation IOMCustomFontBoldLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setCustomFont];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setSuperscriptForRegisteredTradeMarkSymbols];
}

- (void)awakeFromNib
{
    [self setCustomFont];
    [self setSuperscriptForRegisteredTradeMarkSymbols];
}

- (void)setCustomFont
{
    //Karbon Font
    UIFont* currentFont = [self font];
    UIFont* newFont = nil;
    
    newFont = [UIFont fontWithName:@"Ubuntu-Bold" size:[currentFont pointSize]];
    
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
