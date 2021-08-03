//
//  IOMRoundedButton.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/30/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOMCustomFontButton.h"

@interface IOMRoundedButton : IOMCustomFontButton;

@property (assign) UIColor * highlightBackgroundColor;

- (void)setSelectionHighlightOn:(BOOL)isOn;

@end
