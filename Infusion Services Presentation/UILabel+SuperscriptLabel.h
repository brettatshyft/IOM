//
//  UILabel+SuperscriptLabel.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/29/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SuperscriptLabel)

- (void)setSuperscriptForRegisteredTradeMarkSymbols;
- (void)setSuperscriptForContainedStrings:(NSArray*)strings;

@end

@interface UITextView (SuperscriptLabel)

- (void)setSuperscriptForRegisteredTradeMarkSymbols;
- (void)setSuperscriptForContainedStrings:(NSArray*)strings;

@end
