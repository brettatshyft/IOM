//
//  PDFSchedulePage.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/3/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "IOMPDFSchedulePage.h"
#import "IOMPDFSchedulePageNode.h"

@implementation IOMPDFSchedulePage{
    NSMutableArray * _nodeArray;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _nodeArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray*)getPageNodes
{
    return [NSArray arrayWithArray:_nodeArray];
}

- (void)addPageNode:(IOMPDFSchedulePageNode*)pageNode
{
    if (_nodeArray) {
        [_nodeArray addObject:pageNode];
    }
}

- (void)removePageNode:(IOMPDFSchedulePageNode*)pageNode
{
    if (_nodeArray && [_nodeArray containsObject:pageNode]) {
        [_nodeArray removeObject:pageNode];
    }
}

@end
