//
//  UITextField+Extended.m
//  Infusion Services Presentation
//
//  Created by InfAspire on 12/23/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "UITextField+Extended.h"
#import <objc/runtime.h>

//static char defaultHashKey;

@implementation UITextField (Extended)

/*- (UITextField*) nextTextField {
    return objc_getAssociatedObject(self, &defaultHashKey);
}

- (void) setNextTextField:(UITextField *)nextTextField {
    objc_setAssociatedObject(self, &defaultHashKey, nextTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}*

@end
