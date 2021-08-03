//
//  VialTrendFormViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFormViewController.h"

@interface VialTrendFormViewController : BaseFormViewController <UITextFieldDelegate, UIPopoverControllerDelegate>{
    
}

@property (nonatomic, copy) NSString* lastDataMonth;
@property (nonatomic) NSInteger valueLastDataMonth;
@property (nonatomic) NSInteger valueOneMonthBefore;
@property (nonatomic) NSInteger valueTwoMonthsBefore;
@property (nonatomic) NSInteger valueThreeMonthsBefore;
@property (nonatomic) NSInteger valueFourMonthsBefore;
@property (nonatomic) NSInteger valueFiveMonthsBefore;
@property (nonatomic) NSInteger valueSixMonthsBefore;
@property (nonatomic) NSInteger valueSevenMonthsBefore;
@property (nonatomic) NSInteger valueEightMonthsBefore;
@property (nonatomic) NSInteger valueNineMonthsBefore;
@property (nonatomic) NSInteger valueTenMonthsBefore;
@property (nonatomic) NSInteger valueElevenMonthsBefore;

@property (nonatomic) NSInteger valueLastDataMonthSim;
@property (nonatomic) NSInteger valueOneMonthBeforeSim;
@property (nonatomic) NSInteger valueTwoMonthsBeforeSim;
@property (nonatomic) NSInteger valueThreeMonthsBeforeSim;
@property (nonatomic) NSInteger valueFourMonthsBeforeSim;
@property (nonatomic) NSInteger valueFiveMonthsBeforeSim;
@property (nonatomic) NSInteger valueSixMonthsBeforeSim;
@property (nonatomic) NSInteger valueSevenMonthsBeforeSim;
@property (nonatomic) NSInteger valueEightMonthsBeforeSim;
@property (nonatomic) NSInteger valueNineMonthsBeforeSim;
@property (nonatomic) NSInteger valueTenMonthsBeforeSim;
@property (nonatomic) NSInteger valueElevenMonthsBeforeSim;

@property (nonatomic) NSInteger valueLastDataMonthStelara;
@property (nonatomic) NSInteger valueOneMonthBeforeStelara;
@property (nonatomic) NSInteger valueTwoMonthsBeforeStelara;
@property (nonatomic) NSInteger valueThreeMonthsBeforeStelara;
@property (nonatomic) NSInteger valueFourMonthsBeforeStelara;
@property (nonatomic) NSInteger valueFiveMonthsBeforeStelara;
@property (nonatomic) NSInteger valueSixMonthsBeforeStelara;
@property (nonatomic) NSInteger valueSevenMonthsBeforeStelara;
@property (nonatomic) NSInteger valueEightMonthsBeforeStelara;
@property (nonatomic) NSInteger valueNineMonthsBeforeStelara;
@property (nonatomic) NSInteger valueTenMonthsBeforeStelara;
@property (nonatomic) NSInteger valueElevenMonthsBeforeStelara;

@property (nonatomic) NSNumber* presentationType;

@end
