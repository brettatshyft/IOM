//
//  GraphLoadQueue.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/6/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GraphLoadQueue;
@protocol GraphLoadQueueDelegate <NSObject>

- (void)graphLoadQueueHasFinished:(GraphLoadQueue*)graphLoadQueue;
- (void)graphLoadQueueCancelled:(GraphLoadQueue*)graphLoadQueue;

@end

@class GraphWebView;
@interface GraphLoadQueue : NSObject

@property (nonatomic, weak) id<GraphLoadQueueDelegate> delegate;

- (id)init;
- (void)addLoadRequestForGraphWebView:(GraphWebView*)graphView;
- (void)removeLoadRequestForGraphWebView:(GraphWebView*)graphView;
- (void)clearQueue;
- (void)startLoadingGraphs;
- (void)cancelProcessing;
- (void)loadNextGraph;

@end
