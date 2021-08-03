//
//  IOMBackupManager.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 12/17/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

typedef NS_ENUM(NSInteger, IOMBackupManagerState) {
    IOMBackupManagerStateNone,
    IOMBackupManagerStateBackup,
    IOMBackupManagerStateDownload,
    IOMBackupManagerStateRestore
};

@protocol IOMBackupManagerDelegate <NSObject>

- (void)backupDidStart;
- (void)backupDidEnd;
- (void)restoreWasSuccessful;
- (void)presentMailComposeViewController:(MFMailComposeViewController *)mcvc;

@end

@interface IOMBackupManager : NSObject<NSURLConnectionDelegate>

@property (nonatomic, retain) id<IOMBackupManagerDelegate> delegate;
@property (nonatomic, assign) IOMBackupManagerState state;

- (void)showBackupAlert;

@end
