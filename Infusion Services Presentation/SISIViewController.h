//
//  SISIViewController.h
//  Infusion Services Presentation
//
//  Created by InfAspire on 24/01/2014.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Presentation;

@interface SISIViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *SISIType;
@property (nonatomic) int SISIValue;
@property (nonatomic, weak) Presentation* presentation;

-(void) updateView;
-(void) updateViewForSimponiStart:(NSInteger)start simponiEnd:(NSInteger)simponiEnd remicadeStart:(NSInteger)remicadeStart remicadeEnd:(NSInteger)remicadeEnd stelaraStart:(NSInteger)stelaraStart stelaraEnd:(NSInteger)stelaraEnd;

@end
