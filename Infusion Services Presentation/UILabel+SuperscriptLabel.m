//
//  UILabel+SuperscriptLabel.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/29/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "UILabel+SuperscriptLabel.h"

@implementation UILabel (SuperscriptLabel)

- (void)setSuperscriptForRegisteredTradeMarkSymbols
{
    [self setSuperscriptForContainedStrings:@[@"®", @"\u2122" ]];
}

- (void)setSuperscriptForContainedStrings:(NSArray*)strings
{
    if (self.text == nil || [self.text isEqualToString:@""]) {
        return;
    }

    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    for (NSString* string in strings) {
    
        NSUInteger count = 0, length = [mutableAttributedString length];
        NSRange range = NSMakeRange(0, length);
        
        while(range.location != NSNotFound)
        {
            range = [[mutableAttributedString string] rangeOfString:string options:0 range:range];
            if(range.location != NSNotFound) {
                [mutableAttributedString addAttribute:(NSString*)kCTSuperscriptAttributeName value:@"1" range:range];
                [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithDescriptor:self.font.fontDescriptor size:self.font.pointSize - 4] range:range];
                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                count++;
            }
        }
        
    }

    self.attributedText = mutableAttributedString;
}

@end

@implementation UITextView (SuperscriptTextView)

- (void)setSuperscriptForRegisteredTradeMarkSymbols
{
    [self setSuperscriptForContainedStrings:@[@"®", @"\u2122" ]];
}

- (void)setSuperscriptForContainedStrings:(NSArray*)strings
{
    if (self.text == nil || [self.text isEqualToString:@""]) {
        return;
    }

    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];

    for (NSString* string in strings) {

        NSUInteger count = 0, length = [mutableAttributedString length];
        NSRange range = NSMakeRange(0, length);

        while(range.location != NSNotFound)
        {
            range = [[mutableAttributedString string] rangeOfString:string options:0 range:range];
            if(range.location != NSNotFound) {
                [mutableAttributedString addAttribute:(NSString*)kCTSuperscriptAttributeName value:@"1" range:range];
                [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithDescriptor:self.font.fontDescriptor size:self.font.pointSize - 4] range:range];
                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                count++;
            }
        }

    }
    self.attributedText = mutableAttributedString;
}

@end
