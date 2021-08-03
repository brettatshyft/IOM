//
//  PDFSchedulePage.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/3/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IOMPDFSchedulePageNode;
@interface IOMPDFSchedulePage : NSObject

- (NSArray*)getPageNodes;
- (void)addPageNode:(IOMPDFSchedulePageNode*)pageNode;
- (void)removePageNode:(IOMPDFSchedulePageNode*)pageNode;

@end
