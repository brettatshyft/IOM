//
//  IOMDataSyncManager.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 2/19/15.
//  Copyright (c) 2015 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOMSyncManager : NSObject

- (void)sendSyncIfRequired;
- (void)requestSync;

@end
