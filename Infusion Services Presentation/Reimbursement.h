//
//  Reimbursement.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/8/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Presentation;

@interface Reimbursement : NSManagedObject

@property (nonatomic, retain) NSString * geographicArea;
@property (nonatomic, retain) NSNumber * reimbursementFor96413;
@property (nonatomic, retain) NSNumber * reimbursementFor96415;
@property (nonatomic, retain) NSNumber * reimbursementFor96365;
@property (nonatomic, retain) Presentation *presentation;

@end
