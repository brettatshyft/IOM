 //
//  IOMDataClient.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 12/15/17.
//  Copyright © 2017 Local Wisdom Inc. All rights reserved.
//

#import "IOMDataClient.h"
#import "NSString+IOMExtensions.h"
#import "IOMParsedAccount.h"

#define IOM_CLIENT_HOST @"ibizsoc.com"
#define IOM_CLIENT_SCHEME @"https"
#define IOM_CLIENT_API_PATH @"/upload/GetAccounts"
#define IOM_CLIENT_SUMM_ACCOUNTS @"/upload/GetAccountSum"
#define IOM_CLIENT_ID_QUERY_PARAM_KEY @"id"
#define IOM_CLIENT_ID2_QUERY_PARAM_KEY @"id2"
#define IOM_CLIENT_ID3_QUERY_PARAM_KEY @"id3"
#define IOM_CLIENT_ABS_QUERY_PARAM_KEY @"abs"
#define IOM_CLIENT_KEY_QUERY_PARAM_KEY @"key"

#define SECRET_KEY @"9K7JK7Ygj8PBspD3YloYOc06D124u08NS0AwJhH9xBvzi45W7f"

@implementation IOMDataClient

- (NSURLSessionDataTask*)getAccountsForJNJID:(NSString*)jnjID withABS:(NSString*)abs withCompletion:(void (^)(NSArray<NSString*>*, NSArray<NSString*>*))completion
{
    if (jnjID == nil || abs == nil) {
        completion(nil, nil);
        return nil;
    }

    NSString* md5String = [[SECRET_KEY stringByAppendingString:abs] MD5String];
    NSURLComponents* urlComponents = [NSURLComponents new];
    urlComponents.scheme = IOM_CLIENT_SCHEME;
    urlComponents.host = IOM_CLIENT_HOST;
    urlComponents.path = IOM_CLIENT_API_PATH;
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:IOM_CLIENT_ID_QUERY_PARAM_KEY value:jnjID],
                                 [NSURLQueryItem queryItemWithName:IOM_CLIENT_ABS_QUERY_PARAM_KEY value:abs],
                                 [NSURLQueryItem queryItemWithName:IOM_CLIENT_KEY_QUERY_PARAM_KEY value:md5String]];

    NSURL* url = [urlComponents URL];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(nil, nil);
            });
            return;
        }
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];

        NSArray<NSDictionary*>* accounts = [json objectForKey:@"Accounts"];
        NSMutableArray<NSString*>* accountsStrings = [NSMutableArray new];
        NSMutableArray<NSString*>* displayStrings = [NSMutableArray new];

        for (NSDictionary* dictionary in accounts) {
            IOMParsedAccount* account = [[IOMParsedAccount alloc] initWithDictionary:dictionary];
            if (account.jnjId != nil && account.displayname != nil) {
                [accountsStrings addObject:account.jnjId];
                [displayStrings addObject:account.displayname];
            }
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(accountsStrings, displayStrings);
        });
    }];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        [task resume];
    });

    return task;
}

////GetAccountSumm?id=123&id2=456&id3=789&key="[Hash of "123456789 + apikey"]
- (NSURLSessionDataTask*)getMonthlyDataForJNJID1:(NSString*)jnjID1
                                          jnjID2:(NSString*)jnjID2
                                          jnjID3:(NSString*)jnjID3
                                  withCompletion:(void (^)(IOMMonthlyData *))completion {
    NSURLComponents* urlComponents = [NSURLComponents new];
    urlComponents.scheme = IOM_CLIENT_SCHEME;
    urlComponents.host = IOM_CLIENT_HOST;
    urlComponents.path = IOM_CLIENT_SUMM_ACCOUNTS;

    NSMutableArray* queryItems = [@[] mutableCopy];
    NSMutableString* hash = [SECRET_KEY mutableCopy];
    
    if (jnjID1 != nil) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:IOM_CLIENT_ID_QUERY_PARAM_KEY value:jnjID1]];
        [hash appendString:jnjID1];
    }

    if (jnjID2 != nil) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:IOM_CLIENT_ID2_QUERY_PARAM_KEY value:jnjID2]];
        [hash appendString:jnjID2];
    }

    if (jnjID3 != nil) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:IOM_CLIENT_ID3_QUERY_PARAM_KEY value:jnjID3]];
        [hash appendString:jnjID3];
    }

    [queryItems addObject:[NSURLQueryItem queryItemWithName:IOM_CLIENT_KEY_QUERY_PARAM_KEY value:[hash MD5String]]];
    urlComponents.queryItems = queryItems;
    NSURL* url = [urlComponents URL];
    NSURLSession* session = [NSURLSession sharedSession];

    NSURLSessionDataTask* task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(nil);
            });
            return;
        }
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        IOMMonthlyData* monthlyData = [[IOMMonthlyData alloc] initWithDictionary:json];
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(monthlyData);
        });
    }];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        [task resume];
    });

    return task;
}

- (NSURLSessionDataTask*)getMonthlyDataForJNJID:(NSString*)jnjID withCompletion:(void (^)(IOMMonthlyData *))completion
{
    if (jnjID == nil) {
        completion(nil);
        return nil;
    }
    NSString* md5String = [[SECRET_KEY stringByAppendingString:jnjID] MD5String];
    NSString* urlString = [NSString stringWithFormat:@"https://ibizsoc.com/upload/GetMonthlyData?id=%@&key=%@", jnjID, md5String];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(nil);
            });
            return;
        }
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        IOMMonthlyData* monthlyData = [[IOMMonthlyData alloc] initWithDictionary:json];
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(monthlyData);
        });
    }];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        [task resume];
    });

    return task;
}

@end
