//
//  UIView+IOMExtensions.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 11/7/17.
//  Copyright © 2017 Local Wisdom Inc. All rights reserved.
//

#import "UIView+IOMExtensions.h"

@implementation UIView (IOMExtensions)

- (void) bindFrameToSuperviewBounds {
    UIView *superView = self.superview;
    if (superView == nil){
        NSLog(@"Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.");
        return;
    }

    UIView *subview = self;
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subview]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(subview) ]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[subview]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(subview) ]];
}

- (NSArray<UIView*>*)allSubviewsInHierarchy
{
    NSMutableArray<UIView*> *arr=[[NSMutableArray alloc] init];
    [arr addObject:self];
    for (UIView *subview in self.subviews)
    {
        [arr addObjectsFromArray:(NSArray*)[subview allSubviewsInHierarchy]];
    }
    return arr;
}

- (void)setTranslatesAutoresizingMaskIntoConstraintsToAllSubviewsInHierarchy:(BOOL)translates {
    for (UIView* view in [self allSubviewsInHierarchy]) {
        [view setTranslatesAutoresizingMaskIntoConstraints:translates];
    }
}

@end
