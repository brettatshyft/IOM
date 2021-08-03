//
//  GraphScreenshotQueue.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/11/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//-----------------------------------------
//  Protocol: GraphScreenshotQueueDelegate
//-----------------------------------------
@class GraphScreenshotQueue;
@protocol GraphScreenshotQueueDelegate <NSObject>

- (void)graphScreenshotQueueProcessingFinished:(GraphScreenshotQueue*)queue;
- (void)graphScreenshotQueueProcessingCancelled:(GraphScreenshotQueue*)queue;

@end

//-----------------------------------------
//  Class: ScreenshotQueueItem
//-----------------------------------------
@interface ScreenshotQueueItem : NSObject

@end

//-----------------------------------------
//  Class: GraphScreenshotQueue
//-----------------------------------------
@interface GraphScreenshotQueue : NSObject

@property (nonatomic, weak) id <GraphScreenshotQueueDelegate> delegate;

- (void)enqueueView:(UIView*)view setupBlock:(void (^)(void))viewSetupBlock andScreenshotFinishedBlock:(void (^)(UIImage* image))viewScreenshotFinished;
- (void)startProcessing;
- (void)clearQueue;
- (NSUInteger)getCount;

@end

