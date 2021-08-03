//
//  IOMDataSyncManager.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 2/19/15.
//  Copyright (c) 2015 Local Wisdom Inc. All rights reserved.
//

#import "IOMSyncManager.h"
#import "IOMMyInfoManager.h"
#import <Groot/Groot.h>
#import "AppDelegate.h"

static NSString * const kIOMSyncManagerSaveAllLastDateUserPreference = @"kIOMSyncManagerSaveAllLastDateUserPreference";
static NSString * const kIOMSyncManagerSaveAllDataUrl = @"https://www.ibizsoc.com/Sync/SaveAllData";

@interface IOMSyncManager () {
    NSMutableData * responseData;
    NSDictionary * responseJSON;
}

@end

@implementation IOMSyncManager

- (void)sendSyncIfRequired
{
    NSDate *lastExecutedDate = [[NSUserDefaults standardUserDefaults] objectForKey:kIOMSyncManagerSaveAllLastDateUserPreference];
    
    if (lastExecutedDate)
    {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:(NSHourCalendarUnit | NSSecondCalendarUnit)
                                                            fromDate:lastExecutedDate
                                                              toDate:[NSDate date]
                                                             options:0];
        
        BOOL atLeastOneWeekSinceLastSync = ([components hour] >= 168);
        if (atLeastOneWeekSinceLastSync)
        {
            [self requestSync];
        }
    }
    else
    {
        [self requestSync];
    }
}

- (NSString *)serializeCoreDataToJSON
{
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    NSPersistentStoreCoordinator *coordinator = [appDelegate persistentStoreCoordinator];
    [context setPersistentStoreCoordinator:coordinator];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Presentation"];
    NSError * error = nil;
    NSArray * presentations = [context executeFetchRequest:request error:&error];
    NSArray * ksonArray= [GRTJSONSerialization JSONArrayFromObjects:presentations];
    NSString * path = [[appDelegate applicationDocumentsDirectory].path
                       stringByAppendingPathComponent:@"db.json"];
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    [outputStream open];
    //TODO - UNComment
    [NSJSONSerialization writeJSONObject:ksonArray toStream:outputStream options:0 error:&error];
    [outputStream close];

    return path;
}

- (void)requestSync
{
    responseData = [[NSMutableData alloc] init];

    NSString * pathToJSONFile = [self serializeCoreDataToJSON];
    NSData *paramData = [NSData dataWithContentsOfFile:pathToJSONFile];

    NSString *urlString = kIOMSyncManagerSaveAllDataUrl;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];

    NSMutableData *body = [NSMutableData data];

    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"backup.zip\"\r\n", kIOMSyncManagerSaveAllArgumentFilename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:paramData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", kIOMSyncManagerSaveAllArgumentRDT] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[IOMMyInfoManager rdt] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", kIOMSyncManagerSaveAllArgumentWWID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[IOMMyInfoManager wwid] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", kIOMSyncManagerSaveAllArgumentEmail] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[IOMMyInfoManager email] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [request setHTTPBody:body];

    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [HTTPResponse statusCode];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
    
    return;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:nil];
    
    if (responseJSON && [[responseJSON objectForKey:@"Status"] isEqualToString:@"Success"])
    {
         [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kIOMSyncManagerSaveAllLastDateUserPreference];
    }
}

@end
