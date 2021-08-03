//
//  PresentationType.h
//  Infusion Services Presentation
//
//  Created by Paul Jones on 2/1/18.
//  Copyright © 2018 Local Wisdom Inc. All rights reserved.
//

#ifndef PresentationType_h
#define PresentationType_h

typedef NS_ENUM(NSInteger, PresentationType){
    PresentationTypeUnassigned = 0,
    PresentationTypeRAIOI = 1,
    PresentationTypeGIIOI = 2,
    PresentationTypeHOPD = 3,
    PresentationTypeMixedIOI = 4,
    PresentationTypeDermIOI = 5,
    PresentationTypeOther = 6
};

#endif /* PresentationType_h */
