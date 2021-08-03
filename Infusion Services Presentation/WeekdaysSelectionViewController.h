//
//  WeekdaysSelectionViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/10/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Weekday){
    Monday = (1 << 0),
    Tuesday = (1 << 1),
    Wednesday = (1 << 2),
    Thursday = (1 << 3),
    Friday = (1 << 4),
    Saturday = (1 << 5),
    Sunday = (1 << 6)
};

@interface WeekdaysSelectionViewController : UITableViewController{
    
}

@property (nonatomic) NSNumber * __strong * weekdaysSelectedMask;

@end
