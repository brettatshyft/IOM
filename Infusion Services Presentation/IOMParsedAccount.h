//
//  IOMParsedAccount.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 1/22/18.
//  Copyright © 2018 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOMParsedAccount : NSObject

@property (nonatomic, retain) NSString * displayname;
@property (nonatomic, retain) NSString * jnjId;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
