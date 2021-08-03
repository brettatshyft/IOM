//
//  Slides.m
//  Infusion Services Presentation
//
//  Created by InfAspire on 1/17/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "Slide.h"

@interface Slide() {
}

@end


@implementation Slide

- (id)initWithValues:(NSString *)imageName chapterTitle:(NSString *)chapterTitle overlayIDs:(NSArray *)overlayIDs presentationTypes:(NSArray *)presentationTypes presentationSections:(int)presentationSections SISI:(int)SISI
{
    self = [super init];
    if (self) {
        self.imageName=[[NSString alloc] initWithString:imageName];
        self.chapterTitle=[[NSString alloc] initWithString:chapterTitle];
        self.overlayIDs=[[NSArray alloc] initWithArray:overlayIDs];
        self.presentationTypes=[[NSArray alloc] initWithArray:presentationTypes];
        self.presentationSections=(int)presentationSections;
        self.SISI=(int)SISI;
    }
    
    return self;
}

- (NSString *)description{
    NSString *result = [NSString stringWithFormat:@"%@ - %@ - %@ - %@ - %d - %d",[self.imageName description], [self.chapterTitle description], [self.overlayIDs description], [self.presentationTypes description], self.presentationSections, self.SISI];
    return result;
}

@end
