//
//  DropdownDataSource.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/16/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "DropdownDataSource.h"

@implementation DropdownDataSource

- (id)initWithItems:(NSArray*)items andTitleForItemBlock:(titleForItem)titleForItem
{
    if(self = [super init]){
        _dropdownItems = items;
        _titleForItemBlock = titleForItem;
    }
    
    return self;
}

- (id)init
{
    if(self = [super init]){
        
    }
    
    return self;
}

- (CGSize)getPreferedDropdownContentSize
{
    CGFloat height = (_dropdownItems) ? MIN((44*_dropdownItems.count), 600.0f) : 600.0f;
    CGFloat width = (_preferredContentWidth) ? MAX(320.0f, [_preferredContentWidth floatValue]) : 320.0f;
    return CGSizeMake(width, height);
}

@end
