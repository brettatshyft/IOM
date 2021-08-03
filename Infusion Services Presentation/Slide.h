//
//  Slide.h
//  Infusion Services Presentation
//
//  Created by InfAspire on 1/17/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IOMSlideLink;

@interface Slide : NSObject

@property (nonatomic, strong) NSString* imageName;
@property (nonatomic, strong) NSString* chapterTitle;
@property (nonatomic, strong) NSArray* overlayIDs;
@property (nonatomic, strong) NSArray* presentationTypes;
@property (nonatomic, strong) NSArray<IOMSlideLink*>* slideLinks;
@property (nonatomic) int presentationSections;
@property (nonatomic) int SISI;

- (id)initWithValues:(NSString *)imageName chapterTitle:(NSString *)chapterTitle overlayIDs:(NSArray *)overlayIDs presentationTypes:(NSArray *)presentationTypes presentationSections:(int)presentationSections SISI:(int)SISI;
- (NSString *)description;


@end
