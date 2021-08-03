//
//  IOMLinkButton.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 1/30/16.
//  Copyright © 2016 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IOMSlideLink;

@interface IOMSlideLinkButton : UIButton

@property (nonatomic, strong) IOMSlideLink* slideLink;

- (instancetype)initWithSlideLink:(IOMSlideLink*)slideLink;

@end
