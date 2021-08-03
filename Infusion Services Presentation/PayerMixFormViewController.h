//
//  PayerMixFormViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFormViewController.h"

@interface PayerMixFormViewController : BaseFormViewController <UITextFieldDelegate>{
    
}

@property (nonatomic, copy) NSString* payer1String;
@property (nonatomic, copy) NSString* payer2String;
@property (nonatomic, copy) NSString* payer3String;
@property (nonatomic, copy) NSString* payer4String;
@property (nonatomic, copy) NSString* payer5String;

@property (nonatomic) NSInteger percentOfRem1;
@property (nonatomic) NSInteger percentOfRem2;
@property (nonatomic) NSInteger percentOfRem3;
@property (nonatomic) NSInteger percentOfRem4;
@property (nonatomic) NSInteger percentOfRem5;

@property (nonatomic, copy) NSString* spp1String;
@property (nonatomic, copy) NSString* spp2String;
@property (nonatomic, copy) NSString* spp3String;
@property (nonatomic, copy) NSString* spp4String;
@property (nonatomic, copy) NSString* spp5String;

@property (nonatomic) BOOL spp1Selected;
@property (nonatomic) BOOL spp2Selected;
@property (nonatomic) BOOL spp3Selected;
@property (nonatomic) BOOL spp4Selected;
@property (nonatomic) BOOL spp5Selected;

@property (nonatomic) BOOL soc1Selected;
@property (nonatomic) BOOL soc2Selected;
@property (nonatomic) BOOL soc3Selected;
@property (nonatomic) BOOL soc4Selected;
@property (nonatomic) BOOL soc5Selected;

@end
