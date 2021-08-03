//
//  IOMDataClient.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 12/15/17.
//  Copyright © 2017 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOMMonthlyData.h"

@interface IOMDataClient : NSObject

- (NSURLSessionDataTask*)getAccountsForJNJID:(NSString*)jnjID
                                     withABS:(NSString*)abs
                              withCompletion:(void (^)(NSArray<NSString*>*, NSArray<NSString*>*))completion;

- (NSURLSessionDataTask*)getMonthlyDataForJNJID:(NSString*)jnjID
                                 withCompletion:(void (^)(IOMMonthlyData *))completion;

- (NSURLSessionDataTask*)getMonthlyDataForJNJID1:(NSString*)jnjID1
                                          jnjID2:(NSString*)jnjID2
                                          jnjID3:(NSString*)jnjID3
                                  withCompletion:(void (^)(IOMMonthlyData *))completion;

@end
