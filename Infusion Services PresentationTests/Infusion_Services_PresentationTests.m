//
//  Infusion_Services_PresentationTests.m
//  Infusion Services PresentationTests
//
//  Created by Paul Jones on 12/15/17.
//  Copyright © 2017 Local Wisdom Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IOMDataClient.h"
#import "IOMMonthlyData.h"

@interface Infusion_Services_PresentationTests : XCTestCase

@end

@implementation Infusion_Services_PresentationTests

- (void)testGetAccounts {
    IOMDataClient* client = [[IOMDataClient alloc] init];

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET"];
    [client getAccountsForJNJID:@"19896490" withABS:@"0000000" withCompletion:^(NSArray<NSString *> *one, NSArray<NSString *> *two) {
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:10];
}

- (void)testGetMonthlyData {
    IOMDataClient* client = [[IOMDataClient alloc] init];

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET"];
    [client getMonthlyDataForJNJID:@"19896490" withCompletion:^(IOMMonthlyData * monthlyData) {
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:30];
}

- (void)testGetMonthlyDataForMultipleIDs {
    IOMDataClient* client = [[IOMDataClient alloc] init];

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET"];
    // 8388538
    // 15846503, 15189639, 19896490
    [client getMonthlyDataForJNJID1:@"8216046" jnjID2:nil jnjID3:nil withCompletion:^(IOMMonthlyData * monthlyData) {
        [expectation fulfill];
    }];
    [self waitForExpectations:@[expectation] timeout:30];
}

@end
