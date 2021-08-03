//
//  GraphScreenshotQueue.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/11/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "GraphScreenshotQueue.h"

//---------------------------------
//  Class: ScreenshotQueueItem
//---------------------------------
@interface ScreenshotQueueItem()

@property (nonatomic, strong) UIView *screenshotView;
@property (nonatomic, copy) void (^viewSetupBlock)(void);
@property (nonatomic, copy) void (^viewScreenshotFinished)(UIImage* image);

- (id)init;

@end

@implementation ScreenshotQueueItem

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

@end

//---------------------------------
//  Class: GraphScreenshotQueue
//---------------------------------
@implementation GraphScreenshotQueue
{
    NSMutableArray *_queue;
    BOOL _cancelProcessing;
}

- (id)init
{
    self = [super init];
    if (self) {
        _queue = [[NSMutableArray alloc] init];
        _cancelProcessing = NO;
    }
    return self;
}

- (void)enqueueView:(UIView*)view setupBlock:(void (^)(void))viewSetupBlock andScreenshotFinishedBlock:(void (^)(UIImage* image))viewScreenshotFinished
{
    ScreenshotQueueItem * item = [[ScreenshotQueueItem alloc] init];
    item.screenshotView = view;
    item.viewSetupBlock = viewSetupBlock;
    item.viewScreenshotFinished = viewScreenshotFinished;
    [_queue addObject:item];
}

- (NSUInteger)getCount
{
    return [_queue count];
}

- (void)startProcessing
{
    [self dequeueAndTakeScreenshot];
}

- (void)cancelProcessing
{
    _cancelProcessing = YES;
}

- (void)clearQueue
{
    [_queue removeAllObjects];
}

- (void)dequeueAndTakeScreenshot
{
    if ([_queue count] == 0){
        if (_delegate && [_delegate respondsToSelector:@selector(graphScreenshotQueueProcessingFinished:)]) {
            [_delegate graphScreenshotQueueProcessingFinished:self];
        }
        return;
    }
    
    if ([self isProcessingCancelled]){
        return;
    }
    
    ScreenshotQueueItem * item = [_queue objectAtIndex:0];
    [_queue removeObjectAtIndex:0];
    
    if ([self isProcessingCancelled]){
        return;
    }
    
    item.viewSetupBlock();
    
    if ([self isProcessingCancelled]){
        return;
    }
    
    [self performSelector:@selector(takeScreenshotForItem:) withObject:item afterDelay:0.8];
}

- (void)takeScreenshotForItem:(ScreenshotQueueItem*)item
{
    if ([self isProcessingCancelled]){
        return;
    }

    if (item.screenshotView.frame.size.height == 0 || item.screenshotView.frame.size.width == 0){
        item.viewScreenshotFinished(nil);
        [self dequeueAndTakeScreenshot];
        return;
    }
    
    UIImage *image = nil;
    @autoreleasepool {
        UIView * view = item.screenshotView;
        
        //Take screenshot
        CGSize imageSize = view.bounds.size;
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        @autoreleasepool {
            UIImage *contextImage = UIGraphicsGetImageFromCurrentImageContext();
            image = [UIImage imageWithData:UIImagePNGRepresentation(contextImage)];
        }
        UIGraphicsEndImageContext();
    }
    
    item.viewScreenshotFinished(image);
    [self dequeueAndTakeScreenshot];
}

- (BOOL)isProcessingCancelled
{
    if (_cancelProcessing){
        if (_delegate && [_delegate respondsToSelector:@selector(graphScreenshotQueueProcessingCancelled:)]) {
            [_delegate graphScreenshotQueueProcessingCancelled:self];
        }
        return YES;
    }
    
    return NO;
}

@end