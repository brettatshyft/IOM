//
//  PayerMix.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Presentation;

@interface PayerMix : NSManagedObject

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * payer;
@property (nonatomic, retain) NSNumber * spp;
@property (nonatomic, retain) NSNumber * soc;
@property (nonatomic, retain) Presentation *presentation;

@end
