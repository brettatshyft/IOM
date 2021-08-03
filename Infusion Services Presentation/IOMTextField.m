//
//  IOMTextField.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/27/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "IOMTextField.h"


@interface IOMTextField(){
    
}

@end

static UIImage* customBackgroundImage = nil;
static UIImage* errorBackgroundImage = nil;
static UIEdgeInsets backgroundEdgeInsets;

@implementation IOMTextField

+ (void)initialize
{
    [super initialize];
    if(!customBackgroundImage){
        customBackgroundImage = [UIImage imageNamed:@"inputBackground2.png"];
    }
    if(!errorBackgroundImage){
        errorBackgroundImage = [UIImage imageNamed:@"errorInputBackground.png"];
    }
    backgroundEdgeInsets = UIEdgeInsetsMake(7, 36, 7, 36);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [self initializeCustomBackground];
    [self setCustomFont];
}

- (void)setCustomFont
{
    //@"Ubuntu-Medium"
    
    UIFont* newFont = [UIFont fontWithName:@"Ubuntu-Medium" size:[[self font] pointSize]];
    [self setFont:newFont];
}

- (void)initializeCustomBackground
{
    //Set custom background image
    if(customBackgroundImage && !UIEdgeInsetsEqualToEdgeInsets(backgroundEdgeInsets, UIEdgeInsetsZero)){
        [self setBorderStyle:UITextBorderStyleNone];
        [self setBackgroundImage:customBackgroundImage WithInsets:backgroundEdgeInsets];
    }
    //Set side insets
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, self.frame.size.height)];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, self.frame.size.height)];
}

- (void)setErrorBackgroundEnabled:(BOOL)enabled
{
    UIImage* newBackground = (enabled) ? errorBackgroundImage : customBackgroundImage;
    
    if(newBackground && !UIEdgeInsetsEqualToEdgeInsets(backgroundEdgeInsets, UIEdgeInsetsZero)){
        [self setBackgroundImage:newBackground WithInsets:backgroundEdgeInsets];
    }
}

- (void)setBackgroundImage:(UIImage*)image WithInsets:(UIEdgeInsets)insets
{
    UIImage* insetImage = [image resizableImageWithCapInsets:insets];
    [self setBackground:insetImage];
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
