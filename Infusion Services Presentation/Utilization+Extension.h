//
//  Utilization+Extension.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/5/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "Utilization.h"

@interface Utilization (Extension)

- (int)totalPatients;
- (Utilization*)duplicateUtilization;

@end
