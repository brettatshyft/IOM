//
//  IOMPDFSchedulePageNode.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/3/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOMPDFSchedulePageNode : NSObject

@property (nonatomic, weak) UIView *view;
@property (nonatomic) CGFloat cropTopY;
@property (nonatomic) CGFloat cropBottomY;
@property (nonatomic) CGFloat xOffsetOrigin;
@property (nonatomic) BOOL needsToBeCropped;

@end
