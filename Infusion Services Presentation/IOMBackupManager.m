//
//  IOMBackupManager.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 12/17/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "IOMBackupManager.h"
#import <ZipArchive.h>
#import "AppDelegate.h"
#import "IOMMyInfoManager.h"
#import "UIAlertView+Block.h"
#import "NSUserDefaults+IOMMyInfoUserDefaults.h"

#define kDatabaseFileFullPath [[[(AppDelegate *)[[UIApplication sharedApplication] delegate] applicationDocumentsDirectory] URLByAppendingPathComponent:InfusionServicesPresentationDBFilename] absoluteString]
#define kDatabaseDirectoryFullPath [[(AppDelegate *)[[UIApplication sharedApplication] delegate] applicationDocumentsDirectory] absoluteString]
#define kDatabaseBackupZIPBaseFilename @"backup.zip"
#define kDatabaseBackupZIPFullFilename [NSTemporaryDirectory() stringByAppendingString:kDatabaseBackupZIPBaseFilename]

#define kIOMBackupKeyGUID @"Guid"
#define kIOMBackupKeyDate @"Date"
#define kIOMBackupKeyFile @"File"
#define kIOMBackupKeyStatus @"Status"
#define kIOMBackupKeyPass @"pass"

#define kIOMRecentBackupsUserDefault @"klmRecentBackups"

#define kIOMSaveFileURL @"https://www.ibizsoc.com/sync/savefile"
#define kIOMGetFileURL @"https://www.ibizsoc.com/sync/getfile"

@interface IOMBackupManager() {
    NSMutableData *_responseData;
    NSMutableArray *_recentBackupList;
    NSDictionary *_responseJSON;
    NSString *_currentPass;
}

@end

@implementation IOMBackupManager

#pragma mark -
#pragma mark - Public

- (id)init
{
    if (self = [super init]) {
        self.state = IOMBackupManagerStateNone;
    }
    
    return self;
}

- (void)showBackupAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Backup Presentations to Web" message:@"How would you like to backup your presentations?"
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@[@"Backup", @"Restore", @"Recent Backups"]]
     showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
         if (buttonIndex == 1) {
             [self showMakeBackupAlert];
         } else if (buttonIndex == 2) {
             [self showRestoreAlert];
         } else if (buttonIndex == 3) {
             [self showRecentBackups];
         }
     }];
}

#pragma mark -
#pragma mark - Private

- (void)showRestoreAlert
{
    UIAlertView * guidAlert = [[UIAlertView alloc] initWithTitle:@"Enter ID and PIN" message:@"Please enter your ID and PIN to restore your data."
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@[@"Restore"]];
    
    [guidAlert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [[guidAlert textFieldAtIndex:0] setPlaceholder:@"ID (ex. #goPfnWd)"];
    [[guidAlert textFieldAtIndex:1] setPlaceholder:@"PIN (WWID)"];
    
    [guidAlert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSString * guid = [[guidAlert textFieldAtIndex:0] text];
            NSString * pass = [[guidAlert textFieldAtIndex:1] text];
            
            [self requestRestoreWithGUID:guid password:pass error:nil];
            [self.delegate backupDidStart];
        }
    }];
}

- (void)showMakeBackupAlert
{
    UIAlertView * passwordAlert = [[UIAlertView alloc] initWithTitle:@"PIN Info" message: @"Your PIN to restore the backup will be your WWID."
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@[@"Backup"]];
    
    [passwordAlert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSString * pass = [NSUserDefaults iom_getMyInfoUserDefaultForType:IOMMyInfoDefaultsWWID];
            _currentPass = pass;
            [self requestBackupWithPassword:pass error:nil];
            [self.delegate backupDidStart];
        }
    }];
}

- (void)didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Sync Fail" message:[@"The sync failed with the following error: " stringByAppendingString:error.localizedDescription]
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:nil] show];
    
    [self.delegate backupDidEnd];
}

- (void)didSucceedForBackupWithGUID:(NSString *)guid
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentBackupList = [[NSMutableArray alloc] initWithArray: [defaults objectForKey:kIOMRecentBackupsUserDefault]];
    
    if ([recentBackupList count] >= 3) {
        [recentBackupList removeObjectAtIndex:0];
    }
    
    NSDictionary * backupDictionary = @{ kIOMBackupKeyGUID : guid,
                                         kIOMBackupKeyDate : [NSDate date],
                                         kIOMBackupKeyPass : _currentPass };
    
    [recentBackupList insertObject:backupDictionary atIndex:[recentBackupList count]];
    [defaults setObject:recentBackupList forKey:kIOMRecentBackupsUserDefault];
    [defaults synchronize];
    
    [[[UIAlertView alloc] initWithTitle:@"Backup Success"
                                message:[@"Retain this ID for your records to restore your device:\n\n" stringByAppendingString:guid]
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:@[@"Email backup info", @"Copy backup PIN (WWID)"]]
     showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
         if (buttonIndex == 1) {
             if ([MFMailComposeViewController canSendMail])
             {
                 MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];

                 [mail setToRecipients:@[[IOMMyInfoManager email]]];
                 [mail setSubject:@"SOC iBiz Backup Information"];
                 [mail setMessageBody:[NSString stringWithFormat:@"ID: %@\nPIN (WWID): %@", guid, _currentPass] isHTML:NO];

                 [self.delegate presentMailComposeViewController:mail];
             }
         } else if (buttonIndex == 2) {
             [UIPasteboard generalPasteboard].string = guid;
         }
    }];
    
    [self.delegate backupDidEnd];
}

- (void)didSucceedForRestore
{
    [[[UIAlertView alloc] initWithTitle:@"Restore Success" message:@"The restore was successful."
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:nil] show];
    [_delegate restoreWasSuccessful];
}

#pragma mark - Recent Backups

- (void)showRecentBackups
{
    _recentBackupList = [[NSMutableArray alloc] initWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:kIOMRecentBackupsUserDefault]];
    _recentBackupList = [[[_recentBackupList reverseObjectEnumerator] allObjects] mutableCopy];
    
    if ([_recentBackupList count] > 0) {
        UIAlertView * recentBackupsAlertView = [[UIAlertView alloc] initWithTitle:@"Recent Backups" message:@"Email yourself the backup information by tapping a selection below."
                                                                cancelButtonTitle:@"Cancel"
                                                                otherButtonTitles:nil];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/d/yyyy hh:mm a"];
        
        for (int i = 0; i < [_recentBackupList count]; i++) {
            NSString * dateString = [dateFormat stringFromDate:[[_recentBackupList objectAtIndex:i] objectForKey:kIOMBackupKeyDate]];
            [recentBackupsAlertView addButtonWithTitle:dateString];
        }
        
        [recentBackupsAlertView showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if ([_recentBackupList count] >= (buttonIndex - 1)) {
                NSDictionary * backupDictionary = [_recentBackupList objectAtIndex:(buttonIndex - 1)];
                NSString * eyedee = [backupDictionary objectForKey:kIOMBackupKeyGUID];
                NSString * pin = [backupDictionary objectForKey:kIOMBackupKeyPass];
                
                if ([MFMailComposeViewController canSendMail])
                {
                    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
                    [mail setToRecipients:@[[IOMMyInfoManager email]]];
                    [mail setSubject:@"SOC iBiz Backup Information"];
                    [mail setMessageBody:[NSString stringWithFormat:@"ID: %@\nPIN (WWID): %@", eyedee, pin] isHTML:NO];
                    
                    [self.delegate presentMailComposeViewController:mail];
                }
                else
                {
                    NSLog(@"This device cannot send email");
                }
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Recent Backups"
                                    message:@"No backups have been made yet."
                          cancelButtonTitle:@"Cancel"] show];
    }
}

#pragma mark - High Level Programattic API

- (void)requestBackupWithPassword:(NSString *)password error:(NSError **)theError
{
    _responseData = [[NSMutableData alloc] init];
    
    if (self.state == IOMBackupManagerStateNone) {
        self.state = IOMBackupManagerStateBackup;
        [self performBackupWithPassword:password withError:theError];
        NSData *paramData = [NSData dataWithContentsOfFile:kDatabaseBackupZIPFullFilename];
        
        NSString *urlString = kIOMSaveFileURL;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"backup.zip\"\r\n", kIOMBackupKeyFile] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:paramData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", kIOMSyncManagerSaveAllArgumentWWID] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[IOMMyInfoManager wwid] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    } else {
        NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : @"Tried to backup while backup or restore was occuring."};
        *theError = [[NSError alloc] initWithDomain:nil code:1 userInfo:errorDictionary];
    }
}

- (void)requestRestoreWithGUID:(NSString *)guid password:(NSString *)password error:(NSError **)theError
{
    if (self.state == IOMBackupManagerStateNone) {
        self.state = IOMBackupManagerStateRestore;
        _responseData = [[NSMutableData alloc] init];
        _currentPass = password;
        NSString *urlString = kIOMGetFileURL;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", kIOMBackupKeyGUID] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:guid] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    } else {
        NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : @"Tried to restore while backup or restore was occuring."};
        *theError = [[NSError alloc] initWithDomain:nil code:1 userInfo:errorDictionary];
    }
}

#pragma mark - Connection Delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [HTTPResponse statusCode];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
    
    return;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *myError = nil;
    
    switch (self.state) {
            
        case IOMBackupManagerStateDownload: {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_responseData writeToFile:kDatabaseBackupZIPFullFilename atomically:YES];
                
                if ([self performRestoreWithPassword:_currentPass error:nil]) {
                    [self didSucceedForRestore];
                } else {
                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    [details setValue:@"Invalid PIN" forKey:NSLocalizedDescriptionKey];
                    NSError * error = [[NSError alloc] initWithDomain:@"backup" code:614 userInfo:details];
                    [self didFailWithError:error];
                }
            });
            
            self.state = IOMBackupManagerStateNone;
            break;
        }
            
        case IOMBackupManagerStateBackup: {
            
            _responseJSON = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:&myError];
            [self didSucceedForBackupWithGUID:[_responseJSON valueForKey:kIOMBackupKeyGUID]];
            self.state = IOMBackupManagerStateNone;
            
            break;
        }
            
        case IOMBackupManagerStateRestore: {
            
            _responseJSON = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:&myError];
            NSString *url = [_responseJSON valueForKey:kIOMBackupKeyFile];
            NSString *status = [_responseJSON valueForKey:kIOMBackupKeyStatus];
            
            if ([[status lowercaseString] rangeOfString:@"fail"].location != NSNotFound) {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:status forKey:NSLocalizedDescriptionKey];
                myError = [[NSError alloc] initWithDomain:@"backup" code:614 userInfo:details];
                [self didFailWithError:myError];
                self.state = IOMBackupManagerStateNone;
            } else {
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:[NSURL URLWithString:url]];
                [request setHTTPMethod:@"GET"];
                _responseData = [[NSMutableData alloc] init];
                NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                [connection start];
                self.state = IOMBackupManagerStateDownload;
            }
            
            break;
        }
            
        default: {
            
            break;
        }
    }
}

#pragma mark - File Managment

- (NSString *)performBackupWithPassword:(NSString *)password withError:(NSError **)error
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *stores = [[appDelegate persistentStoreCoordinator] persistentStores];
    NSString *srcSQLFile;
    
    if ([stores count] >= 1) { // the only time it won't be will be when there's been an error
        NSPersistentStore *store = [stores objectAtIndex:0];
        srcSQLFile = store.URL.path;
    } else {
        srcSQLFile = kDatabaseFileFullPath;
    }
    
    NSString *newStoreTmpZIPFileString = kDatabaseBackupZIPFullFilename;
    NSString *dstSQLFile = InfusionServicesPresentationDBFilename;
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    ZipArchive * zipArchive = [[ZipArchive alloc] initWithFileManager:fileManager];
    
    NSError * localError;
    
    if ([fileManager fileExistsAtPath:newStoreTmpZIPFileString]) {
        [fileManager removeItemAtPath:newStoreTmpZIPFileString error:&localError];
    }
    
    BOOL success = NO;
    
    if ([fileManager fileExistsAtPath:srcSQLFile] && [zipArchive CreateZipFile2:newStoreTmpZIPFileString Password:password]) {
        success = [zipArchive addFileToZip:srcSQLFile newname:dstSQLFile];
        [zipArchive CloseZipFile2];
    }
    
    if (!success) {
        NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : @"File did not exist at path or ZIP backup could not be created."};
        *error = [[NSError alloc] initWithDomain:nil code:1 userInfo:errorDictionary];
    }
    
    return newStoreTmpZIPFileString;
}

- (BOOL)performRestoreWithPassword:(NSString *)password error:(NSError **)theError
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *stores = [[appDelegate persistentStoreCoordinator] persistentStores];
    NSURL *storeURL;
    
    if ([stores count] >= 1) { // the only time it won't be will be when there's been an error
        NSPersistentStore *store = [stores objectAtIndex:0];
        storeURL = [store URL];
        [[appDelegate persistentStoreCoordinator] removePersistentStore:store error:theError];
    }
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    ZipArchive * zipArchive = [[ZipArchive alloc] initWithFileManager:fileManager];
    
    BOOL success = YES;
    
    if ([zipArchive UnzipOpenFile:kDatabaseBackupZIPFullFilename Password:password]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        
        if ([zipArchive UnzipFileTo:documentsDir overWrite:YES]) {
            storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Infusion_Services_Presentation.sqlite"];
            appDelegate.persistentStoreCoordinator = NULL;
            appDelegate.managedObjectContext = NULL;
            appDelegate.managedObjectModel = NULL;
            [self.delegate backupDidEnd];
        }else{
            success = NO;
        }
    }else{
        success = NO;
    }
    
    if (!success) {
        [[appDelegate persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:theError];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NSManagedObjectContextDidSaveNotification object:nil];
    
    return success;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
