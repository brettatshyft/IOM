//
//  GraphLoadQueue.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/6/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "GraphLoadQueue.h"
#import "GraphWebView.h"

@implementation GraphLoadQueue
{
    BOOL _cancelProcessing;
    NSMutableArray * _queue;
}

-(id)init
{
    self = [super init];
    if (self) {
        _cancelProcessing = NO;
        _queue = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addLoadRequestForGraphWebView:(GraphWebView*)graphView
{
    [_queue addObject:graphView];
}

- (void)removeLoadRequestForGraphWebView:(GraphWebView*)graphView
{
    [_queue removeObject:graphView];
}

- (void)clearQueue
{
    [_queue removeAllObjects];
}

- (void)startLoadingGraphs
{
    [self loadNextGraph];
}

- (void)cancelProcessing
{
    _cancelProcessing = YES;
}

- (void)loadNextGraph
{
    if ([self isProcessingCancelled]){
        return;
    }
    
    if([_queue count] == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(graphLoadQueueHasFinished:)]) {
            [_delegate graphLoadQueueHasFinished:self];
        }
        return;
    }
    
    if ([self isProcessingCancelled]){
        return;
    }
    
    GraphWebView* webView = [_queue objectAtIndex:0];
    [_queue removeObject:webView];
    
    [webView loadGraphFiles];
}

- (BOOL)isProcessingCancelled
{
    if (_cancelProcessing){
        if (_delegate && [_delegate respondsToSelector:@selector(graphLoadQueueCancelled:)]) {
            [_delegate graphLoadQueueCancelled:self];
        }
        return YES;
    }
    
    return NO;
}

@end
