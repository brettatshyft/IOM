//
//  UIView+IOMExtensions.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 11/7/17.
//  Copyright © 2017 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IOMExtensions)

- (void) bindFrameToSuperviewBounds;
- (NSArray<UIView*>*)allSubviewsInHierarchy;
- (void)setTranslatesAutoresizingMaskIntoConstraintsToAllSubviewsInHierarchy:(BOOL)translates;

@end
