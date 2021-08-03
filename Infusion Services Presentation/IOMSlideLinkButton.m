//
//  IOMLinkButton.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 1/30/16.
//  Copyright © 2016 Local Wisdom Inc. All rights reserved.
//

#import "IOMSlideLinkButton.h"
#import "IOMSlideLink.h"

@implementation IOMSlideLinkButton

- (instancetype)initWithSlideLink:(IOMSlideLink *)slideLink
{
    if (self = [super initWithFrame:slideLink.rectRelativeToSlide])
    {
        self.slideLink = slideLink;
    }
    
    return self;
}

@end
