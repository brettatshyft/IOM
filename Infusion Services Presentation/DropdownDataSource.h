//
//  DropdownDataSource.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/16/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString* (^titleForItem)(id item);

@interface DropdownDataSource : NSObject

@property (nonatomic, strong) NSArray* dropdownItems;
@property (nonatomic, strong) titleForItem titleForItemBlock;
@property (nonatomic, strong) NSNumber* preferredContentWidth;

- (id)initWithItems:(NSArray*)items andTitleForItemBlock:(titleForItem)titleForItem;
- (CGSize)getPreferedDropdownContentSize;

@end
